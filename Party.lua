-- RocketRadar | Party.lua
-- Party defensives and bursts, as icons beside the Blizzard party frames: the icon lights while the
-- effect is up, and a dark veil shrinks while the spell recharges. Always on the LEFT of the frames (04/11/2026,
-- the user's rule of the party frame); in the package since 04/11 (the user confirmed the technique in a key, 02/11).
--
-- Which spells: one list per specialization (Data/Spells.lua, tools/radar_spells.py). A teammate whose
-- specialization is not known yet gets the list of the spec their role says (tank, healer); a damage
-- dealer waits for the inspection. Spells with no aura on the caster ("own") are shown only for the player.
--
-- The player's own icons use the game's exact recharge (C_Spell.GetSpellCooldownDuration into a Cooldown
-- frame: talents and charges included, numbers drawn by the game).
--
-- A teammate's icon (workspace skill wow-grupo-recargas): a hidden AuraContainer per (unit, auras). The
-- GAME does the matching; with the aura there, its one element is laid out WIDE pixels wide and the
-- container grows. IsMouseOver with the top and bottom pushed out of reach then answers "did it grow".
-- The answer is ALWAYS a secret for the addon (measured in keys, 02/11/2026: 400,000 reads, all secret),
-- so it never goes through an `if`. Everything is done by the engine:
--   * lit:    "any of the sensors lit" is folded with C_CurveUtil.EvaluateColorValueFromBoolean into a
--             secret number in [0, 1], which becomes the glow's alpha;
--   * edge:   the same fold picks "rose now" (lit and not lit before), storing a time code;
--   * veil:   a vertical StatusBar whose value is that stored code; its min/max move with the clock, so
--             its fill is the share of the recharge still to go.
-- Effects that sit on another member (Blessing of Protection, Pain Suppression...) are read on every
-- member: one sensor per (member, auras), shared by every icon that needs it.
-- The time code lives in [0, 1] in steps of 1/255: a slot covers 254 steps of `u` seconds from its
-- `epoch`. Two slots take turns every `cd` seconds, so a use is always stamped in a slot that can still
-- show its whole recharge.
-- ⚠ Blizzard sizes the container with a secret on purpose and pre-allocates frames "to make it
-- harder to observe the transition between zero/non-zero auras": a patch may close this.
local ADDON, ns = ...
local L = ns.L

local Party = {}
ns.Party = Party

local SPELLS, SPECS, ROLE_SPEC = ns.PARTY_SPELLS, ns.PARTY_SPECS, ns.PARTY_ROLE_SPEC
local UNITS = { "player", "party1", "party2", "party3", "party4" }
local TRACKED = {}
for _, u in ipairs(UNITS) do TRACKED[u] = true end
local WIDE = 50000
local GROUP = "cd"
local GAP = 1
-- Size, side, icons per row, the player's own row and the spells come from the options window (Window.lua, the
-- Group section; user, 03/11/2026: "ter a tela de configuração dele"). Defaults: what the icons were before.
local function Cfg()
    local db = ns.db or {}
    return {
        on = db.party ~= false,
        self = db.partySelf ~= false,
        size = tonumber(db.partySize) or 30,
        perRow = tonumber(db.partyPerRow) or 6,
        -- (04/11) always on the LEFT (the user's rule of the party frame: "fixar os defensivos e burst ao lado esquerdo
        -- do frame"); the right is the casts' and the debuffs' (CastTarget.lua, Debuffs.lua)
        side = "LEFT",
        off = type(db.partyOff) == "table" and db.partyOff or {},
    }
end
local SIZE = 30   -- the size cells are built at; Resize brings them to the chosen one
-- Left of the party frames while the user compares with the other addon, which sits on the right.
local VEIL = 0.7
local TICK = 0.2
-- Like an action button (Blizzard_ActionBar/Mainline/ActionButtonTemplate.xml), without its frame: the icon under
-- the round-cornered mask, the swipe black at 0.64 inset 3/45 of the button, no edge, no bling, the game's numbers.
-- The mask art is 64 px with only the middle 40 opaque (measured on the atlas, 02/11/2026): stretched to the icon
-- it shows 40/64 of it (26 px icons came out 16 px, "pequenos, espaçados"). It is drawn 64/40 of the icon and
-- centred, so its rounded edge falls on the icon's edge; the icon's own bevel is cut by the texcoord instead.
local MASK = "UI-HUD-ActionBar-IconFrame-Mask"
local MASK_SCALE = 64 / 40
local SWIPE = 0.64
local EDGE = 0.9     -- the hairline edge, near-black
local INSET = 1
local MEASURE = 256   -- scale of the hidden frame where a bar's fill height is read as a share (see Draw)

local E = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean
local T0 = math.floor(GetTime()) - 1
local function Now() return math.floor(GetTime() - T0) end

local host
local units = {}    -- [unit] = { unit, guid, class, spec, items = { t, ... } }
local zone = {}     -- [unit][signature] = sensor watching that member for those auras
local spare = { sensors = {}, cells = {} }
local ready, pending, queued, ticker
local meter, radial  -- radial: nil until the self-check ran, then true (clock swipe) or false (falling veil)
local stats = { reads = 0, secret = 0, errors = 0, items = 0, anchored = 0, exact = 0, exactFail = 0 }

local function Fault(where, err)
    stats.errors = stats.errors + 1
    ns.Log.Error(where, err)
end

local function Ready()
    if ready ~= nil then return ready end
    if C_AddOns and C_AddOns.LoadAddOn then pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer") end
    local ok, info = pcall(C_XMLUtil.GetTemplateInfo, "CustomAuraContainerTemplate")
    ready = (ok and info ~= nil and E ~= nil) and true or false
    ns.Log.Seen("party:template", ready)
    return ready
end

--------------------------------------------------------------------------------
-- Sensor
--------------------------------------------------------------------------------
local function Quiet(button)
    pcall(button.SetSize, button, 1, 1)
    pcall(button.SetAlpha, button, 0)
    pcall(button.EnableMouse, button, false)
end

local function NewSensor()
    local ok, c = pcall(CreateFrame, "AuraContainer", nil, host, "CustomAuraContainerTemplate")
    if not ok or not c then return Fault("party:create", c) end
    c:SetSize(1, 1)
    c:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -11, 0)  -- one pixel wide, left of the screen
    pcall(c.EnableMouse, c, false)
    local okG, err = pcall(c.AddAuraGroup, c, GROUP, "HELPFUL", {
        maxFrameCount = 1,
        candidateFilters = { includeSpellIDs = {} },
        initializeFrame = Quiet,
        layout = { elementWidth = WIDE, elementHeight = 1, elementSpacing = 0, lineSpacing = 0 },
    })
    if not okG then return Fault("party:group", err) end
    return c
end

local function Aim(c, unit, auras)
    local ids = {}
    for _, a in ipairs(auras or {}) do ids[a] = true end
    if not pcall(c.SetAuraGroupCandidateFilters, c, GROUP, { includeSpellIDs = ids }) then return false end
    pcall(c.SetUnit, c, unit or "player")
    pcall(c.SetEnabled, c, auras ~= nil)
    pcall(c.UpdateAllAuras, c)
    return true
end

local function TakeSensor(unit, auras)
    local c = table.remove(spare.sensors) or NewSensor()
    if c and Aim(c, unit, auras) then return c end
    if c then spare.sensors[#spare.sensors + 1] = c end
end

local function DropSensor(c)
    if not c then return end
    Aim(c, nil, nil)
    spare.sensors[#spare.sensors + 1] = c
end

--------------------------------------------------------------------------------
-- Cell: icon, glow, two veils (teammates), a Cooldown frame (the player)
--------------------------------------------------------------------------------
local function NewVeil(cell)
    local bar = CreateFrame("StatusBar", nil, cell)
    bar:SetAllPoints(cell.icon)
    bar:SetOrientation("VERTICAL")
    bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    bar:SetStatusBarColor(0, 0, 0, VEIL)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)
    bar:SetAlpha(0)
    return bar
end

-- A hidden bar one unit tall in a frame scaled by MEASURE: its fill texture's height IS the share filled,
-- read back as a (secret) number and handed to the radial texture, which accepts secrets.
local function NewMeasure()
    local bar = CreateFrame("StatusBar", nil, meter)
    bar:SetSize(1 / MEASURE, 1)
    bar:SetPoint("BOTTOMLEFT", meter, "BOTTOMLEFT", 0, 0)
    bar:SetOrientation("VERTICAL")
    bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    bar:SetStatusBarColor(0, 0, 0, 0)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)
    return bar
end

local function NewShade(cell)
    local shade = CreateFrame("Frame", nil, cell)
    shade:SetAllPoints()
    shade:SetFrameLevel(cell:GetFrameLevel() + 1)
    shade:SetAlpha(0)
    local dim = shade:CreateTexture(nil, "ARTWORK")
    dim:SetPoint("TOPLEFT", cell.icon, "TOPLEFT", INSET, -INSET)
    dim:SetPoint("BOTTOMRIGHT", cell.icon, "BOTTOMRIGHT", -INSET, INSET)
    dim:SetTexture("Interface\\Buttons\\WHITE8X8")
    dim:SetVertexColor(0, 0, 0, SWIPE)
    pcall(dim.SetRotation, dim, math.pi)
    pcall(dim.SetRadialProgressBarReverse, dim, true)
    pcall(dim.SetRadialProgressBarPercent, dim, 0)
    shade.dim = dim
    return shade
end

-- The look of every icon of the addon (party cooldowns, the cast mark's spell): the action button's rounded mask
-- and a hairline edge of one SCREEN pixel. The mask art is 64 px with the middle 40 opaque (lesson L-045), so it
-- is drawn 64/40 of the icon, centred; the size is set BEFORE the mask is attached.
function Party.Round(holder, icon, size)
    icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
    local mask = holder:CreateMaskTexture()
    mask:SetAtlas(MASK)
    mask:SetSize(size * MASK_SCALE, size * MASK_SCALE)
    mask:SetPoint("CENTER", icon, "CENTER", 0, 0)
    icon:AddMaskTexture(mask)
    -- A hairline edge (user, 02/11/2026: "uma leve, mínima bordinha"): one SCREEN pixel of near-black behind the
    -- icon, with the same rounded mask, so the icon stands out on a busy background at any UI scale.
    local okP, px = pcall(function() return PixelUtil.GetPixelToUIUnitFactor() / holder:GetEffectiveScale() end)
    px = (okP and type(px) == "number" and px > 0) and px or 1
    local edge = holder:CreateTexture(nil, "BACKGROUND")
    edge:SetColorTexture(0, 0, 0, EDGE)
    edge:SetPoint("TOPLEFT", icon, "TOPLEFT", -px, px)
    edge:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", px, -px)
    local edgeMask = holder:CreateMaskTexture()
    edgeMask:SetAtlas(MASK)
    edgeMask:SetSize((size + 2 * px) * MASK_SCALE, (size + 2 * px) * MASK_SCALE)
    edgeMask:SetPoint("CENTER", icon, "CENTER", 0, 0)
    edge:AddMaskTexture(edgeMask)
    holder.edge, holder.px, holder.mask, holder.edgeMask = edge, px, mask, edgeMask
end

local function NewCell()
    local cell = CreateFrame("Frame", nil, host)
    cell:SetSize(SIZE, SIZE)
    cell.icon = cell:CreateTexture(nil, "ARTWORK")
    cell.icon:SetAllPoints()
    cell.icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
    Party.Round(cell, cell.icon, SIZE)
    cell.veil = { NewVeil(cell), NewVeil(cell) }
    cell.shade = { NewShade(cell), NewShade(cell) }
    cell.meas = { NewMeasure(), NewMeasure() }
    cell.cd = CreateFrame("Cooldown", nil, cell, "CooldownFrameTemplate")
    cell.cd:SetPoint("TOPLEFT", cell.icon, "TOPLEFT", INSET, -INSET)
    cell.cd:SetPoint("BOTTOMRIGHT", cell.icon, "BOTTOMRIGHT", -INSET, INSET)
    cell.cd:SetSwipeColor(0, 0, 0, SWIPE)
    cell.cd:SetDrawEdge(false)
    cell.cd:SetDrawBling(false)
    cell.cd:SetHideCountdownNumbers(false)
    -- above the veils and the swipe (child frames draw over their parent's textures): lit while the effect is up
    local top = CreateFrame("Frame", nil, cell)
    top:SetAllPoints()
    top:SetFrameLevel(cell:GetFrameLevel() + 4)
    cell.glow = top:CreateTexture(nil, "OVERLAY")
    cell.glow:SetTexture("Interface\\Buttons\\CheckButtonHilight")
    cell.glow:SetBlendMode("ADD")
    cell.glow:SetAllPoints()
    cell.glow:SetAlpha(0)
    cell:SetScript("OnEnter", function(self)
        if not self.spell then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(self.spell)
        GameTooltip:Show()
    end)
    cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
    cell:SetMouseClickEnabled(false)
    return cell
end

local function ClearCell(cell)
    cell:Hide()
    cell.glow:SetAlpha(0)
    for k = 1, 2 do
        cell.veil[k]:SetAlpha(0)
        cell.shade[k]:SetAlpha(0)
    end
    pcall(cell.cd.Clear, cell.cd)
end

--------------------------------------------------------------------------------
-- Secret folding: "any of these lit" without looking at any of them
--------------------------------------------------------------------------------
-- a when any boolean in `list` is true, b otherwise (all secrets in, a secret out).
local function Pick(list, a, b)
    local r = b
    for i = 1, #list do r = E(list[i], a, r) end
    return r
end

--------------------------------------------------------------------------------
-- Time slots (teammates)
--------------------------------------------------------------------------------
local function Reset(t, n)
    t.u = math.max(1, math.ceil(t.cd / 254))
    t.slot = { { c = 0, v = 0, epoch = n }, { c = 0, v = 0, epoch = n } }
    t.cur, t.prev = 1, nil
end

local function Draw(t)
    local cell = t.cell
    local now = GetTime() - T0
    local span = t.cd / (255 * t.u)
    for k = 1, 2 do
        local sl, bar = t.slot[k], cell.veil[k]
        -- fill = (c - m) / span = remaining / cd, with the use at epoch + (255c - 1) u
        local m = (now - sl.epoch - t.cd + t.u) / (255 * t.u)
        local ok, err = pcall(function()
            if radial then
                local meas = cell.meas[k]
                meas:SetMinMaxValues(m, m + span)
                meas:SetValue(sl.c)
                cell.shade[k].dim:SetRadialProgressBarPercent(meas:GetStatusBarTexture():GetHeight())
                cell.shade[k]:SetAlpha(sl.v)
                bar:SetAlpha(0)
            else
                bar:SetMinMaxValues(m, m + span)
                bar:SetValue(sl.c)
                bar:SetAlpha(sl.v)
            end
        end)
        if not ok then Fault("party:draw", err) end
    end
end

local function Roll(t, n)
    if n - t.slot[t.cur].epoch < t.cd then return end
    t.cur = 3 - t.cur
    local sl = t.slot[t.cur]
    sl.c, sl.v, sl.epoch = 0, 0, n
end

local function Read(t, n)
    local lits = {}
    for i, s in ipairs(t.sensors) do
        local ok, lit = pcall(s.IsMouseOver, s, 1e5, -1e5, 0, 0)
        if not ok then return Fault("party:read", lit) end
        stats.reads = stats.reads + 1
        if issecretvalue(lit) then stats.secret = stats.secret + 1 end
        lits[i] = lit
    end
    local okG, errG = pcall(function() t.cell.glow:SetAlpha(Pick(lits, 1, 0)) end)
    if not okG then Fault("party:glow", errG) end
    if t.exact then return end
    Roll(t, n)
    local prev = t.prev
    t.prev = lits
    if prev == nil or #prev ~= #lits then return end  -- first look: an effect already up is not a use we saw
    local sl, other = t.slot[t.cur], t.slot[3 - t.cur]
    local stamp = math.min(254, math.max(1, math.floor((n - sl.epoch) / t.u) + 1)) / 255
    local okE, err = pcall(function()
        sl.c = Pick(lits, Pick(prev, sl.c, stamp), sl.c)
        sl.v = Pick(lits, Pick(prev, sl.v, 1), sl.v)
        other.v = Pick(lits, Pick(prev, other.v, 0), other.v)
    end)
    if not okE then Fault("party:edge", err) end
end

function Party.ReadAll()
    queued = false
    local n = Now()
    for _, u in ipairs(UNITS) do
        local rec = units[u]
        if rec then
            for _, t in ipairs(rec.items) do
                if #t.sensors > 0 then Read(t, n) end
                if not t.exact then Draw(t) end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The player's exact recharge
--------------------------------------------------------------------------------
local function Exact(t)
    local d
    if t.ch > 1 then
        local ok, got = pcall(C_Spell.GetSpellChargeDuration, t.id)
        if ok then d = got end
    end
    if not d then
        local ok, got = pcall(C_Spell.GetSpellCooldownDuration, t.id, true)
        if ok then d = got end
    end
    local ok = d and pcall(t.cell.cd.SetCooldownFromDurationObject, t.cell.cd, d, true)
    if ok then stats.exact = stats.exact + 1 else stats.exactFail = stats.exactFail + 1 end
end

function Party.ExactAll()
    local rec = units.player
    for _, t in ipairs(rec and rec.items or {}) do Exact(t) end
end

--------------------------------------------------------------------------------
-- Which spells, for whom
--------------------------------------------------------------------------------
-- The game keeps the specialization of the LAST inspected unit only: inspecting the next teammate (ours or
-- another addon's NotifyInspect) makes GetInspectSpecialization of the others return 0 again. What was learned
-- is kept per GUID, or the icons vanish and come back with every inspection (user, 02/11/2026).
local specByGUID = {}
local function SpecOf(unit, guid)
    if unit == "player" then
        local i = C_SpecializationInfo.GetSpecialization()
        return i and C_SpecializationInfo.GetSpecializationInfo(i) or nil, true
    end
    local ok, id = pcall(C_SpecializationInfo.GetInspectSpecialization, unit)
    if ok and not issecretvalue(id) and type(id) == "number" and id > 0 and guid then specByGUID[guid] = id end
    local known = guid and specByGUID[guid]
    if known then return known, true end
end

-- The spec to show: the real one, or the one the role says while the real one is not known.
local function ShownSpec(unit, class, guid)
    local spec, sure = SpecOf(unit, guid)
    if spec then return spec, sure end
    local ok, role = pcall(UnitGroupRolesAssigned, unit)
    if ok and type(role) == "string" and not issecretvalue(role) then
        local by = ROLE_SPEC[class]
        if by and by[role] then return by[role], false end
    end
end

local function Known(id)
    local ok, yes = pcall(C_SpellBook.IsSpellKnown, id)
    return ok and yes == true
end

-- The icon to show: the talent that replaces the spell (Sentinel for the Protection Paladin's Avenging Wrath).
local function Face(id, sp, spec, isPlayer)
    if isPlayer then
        local ok, ov = pcall(C_Spell.GetOverrideSpell, id)
        if ok and type(ov) == "number" and not issecretvalue(ov) and ov ~= id then return ov end
    end
    if sp.show then
        if not sp.showSpecs then return sp.show end
        for _, s in ipairs(sp.showSpecs) do if s == spec then return sp.show end end
    end
    return id
end

local function Signature(auras)
    local a = {}
    for i, x in ipairs(auras) do a[i] = x end
    table.sort(a)
    return table.concat(a, ",")
end

--------------------------------------------------------------------------------
-- Anchors: the Blizzard party frames (raid-style or classic), found by their unit attribute
--------------------------------------------------------------------------------
local function FrameFor(unit, groupOnly)
    -- CompactPartyFrame is made by the client's XML (Blizzard_CompactRaidFrames reads it as a global).
    local CompactPartyFrame = _G.CompactPartyFrame
    local hosts = {}
    if CompactPartyFrame and CompactPartyFrame:IsVisible() then hosts[#hosts + 1] = CompactPartyFrame end
    if PartyFrame and PartyFrame:IsVisible() then hosts[#hosts + 1] = PartyFrame end
    for _, h in ipairs(hosts) do
        for _, f in ipairs({ h:GetChildren() }) do
            if not f:IsForbidden() and f:IsVisible() and f.GetAttribute then
                local ok, u = pcall(f.GetAttribute, f, "unit")
                if ok and type(u) == "string" and not issecretvalue(u) and u:lower() == unit then return f end
            end
        end
    end
    if not groupOnly and unit == "player" and PlayerFrame and PlayerFrame:IsVisible() and not (CompactPartyFrame and CompactPartyFrame:IsVisible()) then
        return PlayerFrame
    end
end

-- A cell at another size: the cell, and both rounded masks in the art's proportion (lesson L-045).
function Party.Resize(cell, size)
    if cell.size == size then return end
    cell.size = size
    cell:SetSize(size, size)
    if cell.mask then cell.mask:SetSize(size * MASK_SCALE, size * MASK_SCALE) end
    if cell.edgeMask then
        local px = cell.px or 1
        cell.edgeMask:SetSize((size + 2 * px) * MASK_SCALE, (size + 2 * px) * MASK_SCALE)
    end
end

local function Place(rec)
    local f = FrameFor(rec.unit)
    -- The block of icons is centred on the frame's middle line (user, 02/11/2026: "sempre tente centralizar os
    -- icones na linha central dos frames dos jogadores"): one row sits on the line, two rows straddle it.
    local cfg = Cfg()
    local size, perRow = cfg.size, cfg.perRow
    local rows = math.ceil(#rec.items / perRow)
    local top = (rows * size + (rows - 1) * GAP) / 2
    for i, t in ipairs(rec.items) do
        local cell = t.cell
        cell:ClearAllPoints()
        Party.Resize(cell, size)
        if f then
            local row, col = math.floor((i - 1) / perRow), (i - 1) % perRow
            local x = 3 + col * (size + GAP)
            local y = top - row * (size + GAP) - size / 2   -- the cell's own middle, above (+) or below the line
            if cfg.side == "LEFT" then
                cell:SetPoint("RIGHT", f, "LEFT", -x, y)
            else
                cell:SetPoint("LEFT", f, "RIGHT", x, y)
            end
            cell:Show()
        else
            cell:Hide()
        end
    end
    if f then stats.anchored = stats.anchored + 1 end
end

--------------------------------------------------------------------------------
-- Build (out of combat only)
--------------------------------------------------------------------------------
local function Release(rec)
    for _, t in ipairs(rec.items) do
        DropSensor(t.own)
        ClearCell(t.cell)
        spare.cells[#spare.cells + 1] = t.cell
    end
    rec.items = {}
end

-- The key of a spell's box in the options (Window.lua's spell list): per specialization.
function Party.OffKey(spec, id) return spec .. ":" .. id end

local function Fill(rec, list, spec)
    local isPlayer = rec.unit == "player"
    local off = Cfg().off
    for _, entry in ipairs(list) do
        local id, cd, ch = entry[1], entry[2], entry[3]
        local sp = SPELLS[id]
        local wanted = sp and not (sp.own and not isPlayer) and not off[Party.OffKey(spec, id)]
        if wanted and isPlayer and sp.gate then wanted = Known(id) or (sp.show and Known(sp.show)) end
        if wanted then
            local cell = table.remove(spare.cells) or NewCell()
            local face = Face(id, sp, spec, isPlayer)
            local t = { id = id, cd = cd, ch = ch, cell = cell, exact = isPlayer, sensors = {},
                sig = sp.zone and Signature(sp.auras) or nil, others = sp.others, auras = sp.auras }
            -- the caster's own aura (a zone spell reads the caster through the shared zone sensors)
            if not sp.own and not sp.zone and not sp.others then t.own = TakeSensor(rec.unit, sp.auras) end
            cell.spell = face
            cell.icon:SetTexture(C_Spell.GetSpellTexture(face))
            Reset(t, Now())
            rec.items[#rec.items + 1] = t
        end
    end
end

-- One sensor per (member, auras) for the effects that land on someone else; every icon reads them all.
local function AimZones()
    local want = {}
    for _, u in ipairs(UNITS) do
        for _, t in ipairs(units[u] and units[u].items or {}) do
            if t.sig then want[t.sig] = t.auras end
        end
    end
    for _, u in ipairs(UNITS) do
        zone[u] = zone[u] or {}
        local here = UnitExists(u) and IsInGroup() and not IsInRaid()
        for sig, c in pairs(zone[u]) do
            if not want[sig] or not here then
                DropSensor(c)
                zone[u][sig] = nil
            end
        end
        if here then
            for sig, auras in pairs(want) do
                if not zone[u][sig] then zone[u][sig] = TakeSensor(u, auras) end
            end
        end
    end
    for _, u in ipairs(UNITS) do
        for _, t in ipairs(units[u] and units[u].items or {}) do
            local list = {}
            if t.own then list[1] = t.own end
            if t.sig then
                for _, v in ipairs(UNITS) do
                    local s = zone[v] and zone[v][t.sig]
                    if s and not (t.others and v == u) then list[#list + 1] = s end
                end
            end
            if #list ~= #t.sensors then t.prev = nil end
            t.sensors = list
        end
    end
end

-- Self-check of the clock swipe: a bar set to a KNOWN share must read back that share. If it does not (scale
-- clamped, layout not resolved, API missing), the icons keep the falling veil. The answer goes to the diary.
function Party.Probe()
    local probe = NewMeasure()
    local tex = probe:GetStatusBarTexture()
    if not (tex and tex.GetHeight and host.CreateTexture) then radial = false return end
    local test = host:CreateTexture()
    if not (test.SetRadialProgressBarPercent and test.SetRadialProgressBarReverse) then
        radial = false
        ns.Log.Seen("party:radial", "no-api")
        return
    end
    probe:SetValue(0.25)
    -- (04/11) every session of the diary read "off 0": the fill had no height yet at 0.5 s. Read again later (the
    -- layout may not be resolved), and write what each try saw, the bar's own height too, before giving up.
    local tries = { 0.5, 2, 5 }
    local function Try(i)
        C_Timer.After(tries[i] - (tries[i - 1] or 0), function()
            local ok, h = pcall(tex.GetHeight, tex)
            local okB, hb = pcall(probe.GetHeight, probe)
            radial = ok and type(h) == "number" and not issecretvalue(h) and math.abs(h - 0.25) < 0.02
            ns.Log.Seen("party:radial." .. i, (radial and "ok " or "off ") .. tostring(ok and (issecretvalue(h) and "secret" or h))
                .. " bar=" .. tostring(okB and hb) .. " shown=" .. tostring(probe:IsVisible()))
            if radial or i == #tries then
                ns.Log.Seen("party:radial", radial and "ok" or ("off " .. tostring(ok and (issecretvalue(h) and "secret" or h))))
                probe:Hide()
                Party.ReadAll()
            else
                Try(i + 1)
            end
        end)
    end
    Try(1)
end

function Party.Build()
    if InCombatLockdown() then
        pending = true
        return
    end
    if not Ready() then return end
    pending = false
    if not host then
        host = CreateFrame("Frame", nil, UIParent)
        host:SetAllPoints(UIParent)
        host:SetFrameStrata("MEDIUM")
        meter = CreateFrame("Frame", nil, UIParent)
        meter:SetSize(1, 1)
        meter:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
        pcall(meter.SetScale, meter, MEASURE)
        Party.Probe()
    end
    stats.items, stats.anchored = 0, 0
    local cfg = Cfg()
    local inGroup = IsInGroup() and not IsInRaid() and cfg.on
    local changed = {}
    for _, unit in ipairs(UNITS) do
        local rec = units[unit] or { unit = unit, items = {} }
        units[unit] = rec
        local _, class = UnitClass(unit)
        local guid = UnitExists(unit) and UnitGUID(unit) or nil
        local spec, sure
        if inGroup and guid and class then spec, sure = ShownSpec(unit, class, guid) end
        local list = spec and SPECS[spec] or nil
        if unit == "player" and not cfg.self then list = nil end
        if rec.guid ~= guid or rec.spec ~= spec or rec.class ~= class or not list then
            if #rec.items > 0 then ns.Log.Seen("party:rebuild", rec.guid ~= guid and "member" or "spec") end
            Release(rec)
            rec.guid, rec.spec, rec.class, rec.sure = guid, spec, class, sure
            if list then
                Fill(rec, list, spec)
                changed[#changed + 1] = ("%s %s %s%s n=%d"):format(unit, class, tostring(spec), sure and "" or "?", #rec.items)
            end
        end
        rec.sure = sure
        stats.items = stats.items + #rec.items
        Place(rec)
    end
    AimZones()
    Party.ExactAll()
    if #changed > 0 then ns.Log.Event("build " .. table.concat(changed, " | ") .. " " .. date("%H:%M:%S")) end
    if stats.items > 0 and not ticker then
        ticker = C_Timer.NewTicker(TICK, Party.ReadAll)
    elseif stats.items == 0 and ticker then
        ticker:Cancel()
        ticker = nil
    end
end

---An option changed in the window: every member's icons are made again (out of combat; in combat, after it).
function Party.Apply()
    for _, rec in pairs(units) do rec.guid = false end
    Party.Build()
end

--------------------------------------------------------------------------------
-- Specialization of teammates: inspect, one at a time, out of combat, until every one is known
--------------------------------------------------------------------------------
local inspecting, retry
local function InspectNext()
    if InCombatLockdown() or inspecting then return end
    for _, unit in ipairs(UNITS) do
        local rec = units[unit]
        if unit ~= "player" and rec and rec.guid and not rec.sure then
            if CanInspect(unit) then
                inspecting = unit
                NotifyInspect(unit)
                C_Timer.After(3, function()
                    if inspecting == unit then inspecting = nil end
                    InspectNext()
                end)
                return
            end
        end
    end
    -- someone out of reach: look again in a while
    for _, unit in ipairs(UNITS) do
        local rec = units[unit]
        if unit ~= "player" and rec and rec.guid and not rec.sure and not retry then
            retry = true
            C_Timer.After(5, function() retry = nil InspectNext() end)
            return
        end
    end
end

ns.On("INSPECT_READY", function()
    inspecting = nil
    if not InCombatLockdown() then Party.Build() end
    C_Timer.After(1, InspectNext)
end)

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------
ns.On("UNIT_AURA", function(unit)
    if queued or type(unit) ~= "string" or issecretvalue(unit) or not TRACKED[unit] then return end
    queued = true
    C_Timer.After(0.15, Party.ReadAll)  -- the container lays itself out on its next frame
end)

ns.On("SPELL_UPDATE_COOLDOWN", Party.ExactAll)
ns.On("SPELL_UPDATE_CHARGES", Party.ExactAll)

local function Rebuild()
    Party.Build()
    C_Timer.After(1, InspectNext)
end
ns.On("PLAYER_ENTERING_WORLD", Rebuild)
ns.On("GROUP_ROSTER_UPDATE", Rebuild)
ns.On("PLAYER_SPECIALIZATION_CHANGED", function(unit)
    -- a teammate changed specialization: forget what the inspection said and ask again
    if type(unit) == "string" and not issecretvalue(unit) and unit ~= "player" then
        local ok, guid = pcall(UnitGUID, unit)
        if ok and guid and not issecretvalue(guid) then specByGUID[guid] = nil end
    end
    Rebuild()
end)
ns.On("TRAIT_CONFIG_UPDATED", Rebuild)
ns.On("PLAYER_REGEN_ENABLED", function()
    if pending then Party.Build() end
    InspectNext()
end)
-- The raid-style party frames re-sort their members (EditModeSystemTemplates.lua calls RefreshMembers):
-- place the icons again after it, out of combat.
local compact = _G.CompactPartyFrame
if compact and compact.RefreshMembers then
    hooksecurefunc(compact, "RefreshMembers", function()
        if not InCombatLockdown() then C_Timer.After(0, Party.Build) end
    end)
end

--------------------------------------------------------------------------------
-- Ground truth for the diary (development): the icon's alpha cannot be read back (GetAlpha is
-- secret once the alpha came from a secret). A tracked cast that arrives readable (always for the
-- player) is written down, and -- only when asked with `/rr shots` -- a screenshot is taken a moment later to check
-- the icon afterwards. (03/11/2026) OFF BY DEFAULT: the user saw the game's "Screen captured" pop up out of nowhere;
-- the second shot (half the recharge) also skipped the cap and the gap.
--------------------------------------------------------------------------------
local SHOT_DELAY, SHOT_GAP, SHOT_MAX = 1.0, 5, 40
local shots, lastShot = 0, -100
local function Shot(tag)
    if not (ns.db and ns.db.devShots == true) then return end
    local now = GetTime()
    if shots >= SHOT_MAX or now - lastShot < SHOT_GAP then return end
    shots, lastShot = shots + 1, now
    C_Timer.After(SHOT_DELAY, function()
        -- the game's "Screen captured" (ActionStatus, Blizzard_ActionStatus) stays quiet for OUR shot only: it stops
        -- hearing the capture for a second; the player's own Print Screen still shows it (user, 03/11: "não tem como
        -- esconder isso?")
        local status = _G.ActionStatus
        local quiet = status and status.UnregisterEvent and status:IsEventRegistered("SCREENSHOT_SUCCEEDED")
        if quiet then status:UnregisterEvent("SCREENSHOT_SUCCEEDED") end
        local ok, err = pcall(Screenshot)
        if quiet then C_Timer.After(1, function() status:RegisterEvent("SCREENSHOT_SUCCEEDED") end) end
        ns.Log.Event(("shot %s ok=%s %s"):format(tag, tostring(ok), date("%H:%M:%S")))
        if not ok then ns.Log.Error("party:shot", err) end
    end)
end

ns.On("UNIT_SPELLCAST_SUCCEEDED", function(unit, _, spellID)
    if not ns.Log.enabled then return end
    if type(unit) ~= "string" or issecretvalue(unit) or not TRACKED[unit] then return end
    if issecretvalue(spellID) then
        ns.Log.Seen("party:cast", "secret")
        return
    end
    ns.Log.Seen("party:cast", "plain")
    local rec = units[unit]
    for _, t in ipairs(rec and rec.items or {}) do
        if t.id == spellID or t.cell.spell == spellID then
            local who = UnitName(unit)
            ns.Log.Event(("cast %s %s %d combat=%s %s"):format(unit, issecretvalue(who) and "?" or tostring(who),
                spellID, tostring(InCombatLockdown()), date("%H:%M:%S")))
            Shot(unit .. ":" .. spellID)
            -- a second shot when the recharge should be half gone, to check the veil
            C_Timer.After(math.max(0, math.min(t.cd / 2, 60) - SHOT_DELAY), function()
                Shot("half " .. unit .. ":" .. spellID)   -- the same switch, cap and gap as the first
            end)
            return
        end
    end
end)

function Party.Status()
    ns.Print(L["Group icons: %d (%d frames found). Reads %d, hidden %d; errors %d."]
        :format(stats.items, stats.anchored, stats.reads, stats.secret, stats.errors))
    if ready == false then ns.Print(L["The game did not offer the aura container: the sensor cannot work."]) end
end

Party.stats = stats
function Party.units() return units end
Party.FrameFor = FrameFor
function Party.radial() return radial end
function Party.gap() return GAP end
function Party.zones() return zone end
