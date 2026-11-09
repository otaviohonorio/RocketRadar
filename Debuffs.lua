-- RocketRadar | Debuffs.lua
-- (04/11/2026) THE RIGHT OF THE PARTY FRAME. The user's rule (03/11, memory radar-regra-do-quadro): "sem mexer no frame,
-- vamos fixar os defensivos e burst ao lado esquerdo do frame e os icones de cast (com a borda animada como se fosse
-- cast) de dispell, curse, veneno, sangramento e etc (somente o que pode ser removido) e cada um com seu icone e borda
-- com a cor". Nothing of ours is drawn ON the game's frame any more (the line around it, Dispel.lua, is gone); to its
-- right, three groups with a gap between them (preview mockup/PREVIA Rocket Radar - geral (portugues).png):
--
--   [the cast coming at the member]  [what I can remove]  [root or slow]  [the boss's or the role's debuff]
--    CastTarget.lua, the first slot   group "Mine"          group "Move"     group "Boss"
--
-- (04/11) "Move": a root or a slow WITHOUT a dispel type (the user: "as que não aparecem como dispel mas dá para
-- remover, aparecer o ícone (...) num azul em tom mais claro"). No dispel takes it off; a few class spells free a
-- teammate from it (Data/Dispellers.lua, MOVE_REMOVERS, read from the game's text). The engine cannot filter a
-- teammate's debuff by mechanic or by spell (Blizzard_AuraContainerUtil.lua: CanApplyIdentityCandidateFilters), so
-- the group uses the game's CROWD_CONTROL filter ("HARMFUL|CROWD_CONTROL|!DISPELLABLE"), which follows the game's own
-- list (C_Spell.IsSpellCrowdControl). NOT YET MEASURED that this list holds the season's roots and slows (TESTES.md);
-- it also holds stuns and fears, which the same icon then shows.
--
-- Every icon is 34 points, its block centred on the frame's middle line (memory icones-centrados-no-quadro), with:
--   * the spell's own icon (the user: "usa esses icones e sempre com o tempo");
--   * a ring 4 points thick in the type's colour (the game's DEBUFF_TYPE_*_COLOR, or the player's choice), the part
--     of the time already gone darkened over it, so the ring EMPTIES with the time left;
--   * four corners: the type's symbol of the game (top left; the boss's skull), the type's letters of the game
--     (DEBUFF_SYMBOL_*: Mag, Mal, Vn, Do, Sg in ptBR; top right), the time left (bottom left), the stacks (bottom right).
--
-- HOW, WITHOUT READING ANY AURA (the debuffs of a teammate are secrets in a fight). One CustomAuraContainerTemplate
-- per party frame of the game (Blizzard_AuraContainer, 12.1.5), with two aura GROUPS laid out by the game's flow layout.
-- The ENGINE picks the auras (filter + candidate filters), shows and hides each button, and fills every piece we hand
-- it: the icon (SetIcon), the ring's colour (AddDispelTypeTexture, PreserveAsset + customDispelColorMap), the symbol
-- (AddDispelTypeTexture, CustomAsset + customDispelAssetMap), the letters (SetDispelTypeText + customDispelTextMap),
-- the darkening (SetDurationCooldown), the time (SetDurationText) and the stacks (SetApplicationCount). All checked
-- against wow-ui-source live (Blizzard_CustomAuraButton.lua, Blizzard_CustomAuraContainer.lua, AuraContainerUtil
-- documentation; 12.1.5.70783). The game marks no "deals damage" debuff: the boss's or role's debuff
-- (`isBossOrRoleAura`, the ones the game draws 1.5x) stands for it, in the game's red for a debuff without a type
-- (DEBUFF_TYPE_NONE_COLOR, #cc0000), told apart from the Bleed's by the skull (decision of the user, 04/11).
--
-- The aura buttons deny tainted access while auras are secret: everything is built and changed only while they are
-- not (C_Secrets.ShouldAurasBeSecret), and a change asked for in a fight waits for its end.
local ADDON, ns = ...

local Debuffs = {}
ns.Debuffs = Debuffs

Debuffs.SIZE = 34             -- the icons on the right (the left ones are 30: 'Mag' needs the room, 03/11)
Debuffs.SIDE = 4              -- from the frame's right edge to the first icon (the cast's slot)
Debuffs.GROUP_GAP = 8         -- between two groups
local GAP = 2                 -- between two icons of a group
local CORNER = 12             -- the type's symbol in the top-left corner
local RING = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\IconRing.png"
local DARK = 0.65             -- the part of the ring whose time is gone: the colour at 35%
local MINE, MOVE, BOSS = "RocketRadarMine", "RocketRadarMove", "RocketRadarBoss"
local MAX_MINE, MAX_MOVE, MAX_BOSS = 3, 2, 2

-- The game's symbol of each type (raid frames' own icons, atlas checked with tools/ver_atlas.py).
Debuffs.SYMBOL = {
    Magic = "RaidFrame-Icon-DebuffMagic", Curse = "RaidFrame-Icon-DebuffCurse", Disease = "RaidFrame-Icon-DebuffDisease",
    Poison = "RaidFrame-Icon-DebuffPoison", Bleed = "RaidFrame-Icon-DebuffBleed",
}
Debuffs.SKULL = "BossBanner-SkullCircle"
-- The game's letters for each type (the colour-blind mode's), in the player's language.
Debuffs.LETTERS = {
    Magic = "DEBUFF_SYMBOL_MAGIC", Curse = "DEBUFF_SYMBOL_CURSE", Disease = "DEBUFF_SYMBOL_DISEASE",
    Poison = "DEBUFF_SYMBOL_POISON", Bleed = "DEBUFF_SYMBOL_BLEED",
}

local records = {}            -- [party frame] = { container, unit, buttons = {} }
local pending = false
local ready

local function Secret()
    if not (C_Secrets and C_Secrets.ShouldAurasBeSecret) then return false end
    local ok, yes = pcall(C_Secrets.ShouldAurasBeSecret)
    return ok and yes == true
end

-- (05/11) every call to the engine goes through Try: a refused one is written in the diary with its error (until
-- now these pcalls threw the error away, and "nothing shows" had no cause to read)
local function Try(where, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then ns.Log.Error("debuffs:" .. where, err) end
    return ok
end

local function Ready()
    if ready ~= nil then return ready end
    if C_AddOns and C_AddOns.LoadAddOn then pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer") end
    local ok, info = pcall(C_XMLUtil.GetTemplateInfo, "CustomAuraContainerTemplate")
    ready = (ok and info ~= nil and Enum and Enum.CustomAuraButtonDispelTypeTextureStyle ~= nil) and true or false
    ns.Log.Seen("debuffs:template", ready)
    return ready
end

Debuffs.Ready = Ready

---Whether the player knows a spell that removes some dispel type (Data/Dispellers.lua; talents too).
function Debuffs.CanDispel()
    for _, list in pairs(ns.DISPELLERS or {}) do
        for _, e in ipairs(list) do
            local ok, known = pcall(C_SpellBook.IsSpellKnown, e[2])
            if ok and known == true then return true end
        end
    end
    return false
end

---"all" or "mine". (04/11) "What I can remove" for a player who removes NOTHING (a Death Knight, a Warrior...) showed
---an empty right side in a whole key (the user: "o lado direito não funcionou, não mostrou nada"): for them it is "all".
function Debuffs.Mode()
    if ns.db.dispelMode == "all" or not Debuffs.CanDispel() then return "all" end
    return "mine"
end

---"HARMFUL|RAID": what the player can remove; "HARMFUL|DISPELLABLE": every debuff that has a dispel type.
function Debuffs.MineFilter()
    return Debuffs.Mode() == "all" and "HARMFUL|DISPELLABLE" or "HARMFUL|RAID"
end

---The boss's or role's debuff that the first group does not already show (nor the root/slow group, while it is on).
function Debuffs.BossFilter()
    local f = Debuffs.Mode() == "all" and "HARMFUL|!DISPELLABLE" or "HARMFUL|!RAID"
    if Debuffs.MoveOn() then f = f .. "|!CROWD_CONTROL" end
    return f
end

Debuffs.MOVE_FILTER = "HARMFUL|CROWD_CONTROL|!DISPELLABLE"

---Whether the player knows a spell (or talent) that frees a teammate from a root or a slow (Data/Dispellers.lua).
function Debuffs.CanFree()
    for _, e in ipairs(ns.MOVE_REMOVERS or {}) do
        if e[4] then
            local ok, known = pcall(C_SpellBook.IsSpellKnown, e[2])   -- talents too (SpellBookDocumentation, 12.1.5)
            if ok and known == true then return true end
        end
    end
    return false
end

---The root/slow group: on, and in "What I can remove" only for who can free a teammate.
function Debuffs.MoveOn()
    if ns.db.debuffs == false or ns.db.moveDebuffs == false then return false end
    return Debuffs.Mode() == "all" or Debuffs.CanFree()
end

local function TypesOn()
    local off = type(ns.db.dispelOff) == "table" and ns.db.dispelOff or {}
    local on, all = {}, true
    for _, t in ipairs(ns.DISPEL_TYPES) do
        if off[t] then all = false else on[t] = true end
    end
    return on, all
end

local function MineCandidates()
    local on, all = TypesOn()
    if all then return {} end
    return { includeDispelTypes = on }
end

local function ColorMap()
    local map = {}
    for _, t in ipairs(ns.DISPEL_TYPES) do
        local r, g, b = ns.ColorOf("dispel." .. t)
        map[t] = CreateColor(r, g, b, 1)
    end
    return map
end

local function LetterMap()
    local map = {}
    for t, g in pairs(Debuffs.LETTERS) do map[t] = rawget(_G, g) or t:sub(1, 2) end
    return map
end

local function SymbolMap()
    local map = {}
    for t, atlas in pairs(Debuffs.SYMBOL) do map[t] = { asset = atlas } end
    return map
end

---A ring around an icon of `parent`'s size, white until tinted.
function Debuffs.Ring(parent)
    local ring = parent:CreateTexture(nil, "OVERLAY", nil, 1)
    ring:SetAllPoints()
    ring:SetTexture(RING)
    return ring
end

---The pieces of one icon, on an aura button of ours or on the cast's own icon (CastTarget.lua uses it too): the
---rounded icon, the ring, the darkening swipe, and the four corners' strings and textures.
---`noRing`: the caller draws its own rings (the cast's two: interruptible and not, each behind its own gate).
function Debuffs.Dress(button, size, noRing)
    size = size or Debuffs.SIZE
    local p = { holder = button }
    p.icon = button:CreateTexture(nil, "ARTWORK")
    p.icon:SetAllPoints()
    ns.Party.Round(button, p.icon, size)
    if not noRing then p.ring = Debuffs.Ring(button) end
    -- above the ring: the swipe darkens only the ring's shape (its texture is the ring)
    p.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
    p.cd:SetAllPoints()
    p.cd:SetSwipeTexture(RING)
    p.cd:SetSwipeColor(0, 0, 0, DARK)
    p.cd:SetDrawEdge(false)
    p.cd:SetDrawBling(false)
    p.cd:SetHideCountdownNumbers(true)
    -- the corners live above the swipe
    local top = CreateFrame("Frame", nil, button)
    top:SetAllPoints()
    top:SetFrameLevel(button:GetFrameLevel() + 6)
    p.top = top
    p.symbol = top:CreateTexture(nil, "OVERLAY", nil, 2)
    p.symbol:SetSize(CORNER, CORNER)
    p.symbol:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    p.letters = top:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Small_Outline")
    p.letters:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
    p.time = top:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
    p.time:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 2, 2)
    p.stacks = top:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    p.stacks:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    return p
end

---Hands the pieces of an aura button to the engine. `kind`: "boss" (the skull and the game's red, without type),
---"move" (light blue, no symbol nor letters: the game has none for it), else the dispel type's own pieces.
local function Register(button, kind)
    local p = button.rr
    local style = Enum.CustomAuraButtonDispelTypeTextureStyle
    -- (05/11) the game's CustomAuraButtonTemplate has NO size (Blizzard_CustomAuraButton.xml): without this every
    -- button the engine showed was 0x0, and the right side never showed a thing (diary: sz=0x0 on all 30)
    button:SetSize(Debuffs.SIZE, Debuffs.SIZE)
    pcall(button.ClearDispelTypeTextures, button)
    button:SetIcon(p.icon)
    button:SetDurationCooldown(p.cd)
    button:SetDurationText(p.time)
    button:SetApplicationCount(p.stacks)
    if kind == "boss" or kind == "move" then
        local r, g, b = ns.ColorOf(kind == "boss" and "dispel.None" or "dispel.Move")
        p.ring:SetVertexColor(r, g, b)
        if kind == "boss" then
            p.symbol:SetAtlas(Debuffs.SKULL)
            p.symbol:Show()
        else
            p.symbol:Hide()
        end
        p.letters:SetText("")
        pcall(button.ClearDispelTypeText, button)
    else
        button:AddDispelTypeTexture(p.ring, { style = style.PreserveAsset, showWhenHarmful = true,
            showWhenHelpful = false, customDispelColorMap = ColorMap() })
        button:AddDispelTypeTexture(p.symbol, { style = style.CustomAsset, showWhenHarmful = true,
            showWhenHelpful = false, customDispelAssetMap = SymbolMap() })
        button:SetDispelTypeText(p.letters, { showWhenHarmful = true, showWhenHelpful = false,
            customDispelTextMap = LetterMap() })
    end
end

local function Initialize(rec, kind)
    return function(button)
        button:EnableMouse(false)
        if button.SetMouseMotionEnabled then button:SetMouseMotionEnabled(false) end
        Try("size", button.SetSize, button, Debuffs.SIZE, Debuffs.SIZE)
        button.rr = Debuffs.Dress(button, Debuffs.SIZE)
        button.rr.kind = kind
        -- the dark covers the time already gone and grows with it: the ring empties (the game's buffs do the same)
        button.rr.cd:SetReverse(true)
        rec.buttons[#rec.buttons + 1] = button
        local ok, err = pcall(Register, button, kind)
        if not ok then ns.Log.Error("debuffs:register", err) end
    end
end

local function Layout(index, first)
    return {
        elementWidth = Debuffs.SIZE, elementHeight = Debuffs.SIZE, elementSpacing = GAP,
        groupSpacing = first and 0 or Debuffs.GROUP_GAP, layoutIndex = index,
    }
end

---Where the container sits: to the right of the frame, after the cast's slot, its middle on the frame's middle.
-- (05/11, the user's choice) the debuffs touch the frame, with no hole: the cast's icon comes AFTER the last debuff
-- (CastTarget.lua anchors it to this container's right end; the engine sizes the container to its icons, a secret
-- width the anchor follows without us reading it). Before, the first slot was always the cast's, empty most of the time.
local function Place(rec, owner)
    local c = rec.container
    c:ClearAllPoints()
    c:SetPoint("LEFT", owner, "RIGHT", Debuffs.SIDE, 0)
end

---Where the cast's icon goes for a party frame: after our debuffs when the right side is on, else the frame itself.
---Returns the frame to anchor to and the gap.
function Debuffs.CastAnchor(frame)
    local rec = records[frame]
    if rec and ns.db.debuffs ~= false then return rec.container, Debuffs.SIDE end
    return frame, Debuffs.SIDE
end

local function Apply(rec)
    local c = rec.container
    local on = ns.db.debuffs ~= false
    Try("filter.mine", c.SetAuraGroupFilterString, c, MINE, Debuffs.MineFilter())
    Try("cand.mine", c.SetAuraGroupCandidateFilters, c, MINE, MineCandidates())
    Try("on.mine", c.SetAuraGroupEnabled, c, MINE, on)
    Try("on.move", c.SetAuraGroupEnabled, c, MOVE, Debuffs.MoveOn())
    Try("filter.boss", c.SetAuraGroupFilterString, c, BOSS, Debuffs.BossFilter())
    Try("on.boss", c.SetAuraGroupEnabled, c, BOSS, on and ns.db.bossDebuffs ~= false)
    for _, b in ipairs(rec.buttons) do
        local ok, err = pcall(Register, b, b.rr.kind)
        if not ok then ns.Log.Error("debuffs:register", err) end
    end
    Try("show", c.Show, c)
    Try("enabled", c.SetEnabled, c, on)
    Try("update", c.UpdateAllAuras, c)
    ns.Log.Seen("debuffs:apply", ("on=%s mine=%s move=%s boss=%s"):format(tostring(on), Debuffs.MineFilter(),
        tostring(Debuffs.MoveOn()), Debuffs.BossFilter()))
end

local function Attach(owner, unit)
    if not owner or rawget(owner, "isNamePlate") or type(unit) ~= "string" or issecretvalue(unit) then return end
    if not (unit == "player" or unit:find("^party%d")) then return end
    local rec = records[owner]
    if rec then
        if rec.unit ~= unit then
            rec.unit = unit
            pcall(rec.container.SetUnit, rec.container, unit)
        end
        return
    end
    if Secret() or InCombatLockdown() then
        pending = true
        -- (04/11) a key showed nothing on the right: the diary must say whether the build was held back, and why
        ns.Log.Seen("debuffs:attach", Secret() and "wait-secret" or "wait-combat")
        return
    end
    if not Ready() then return ns.Log.Seen("debuffs:attach", "no-template") end
    local ok, c = pcall(CreateFrame, "AuraContainer", nil, owner, "CustomAuraContainerTemplate")
    if not ok or not c then return ns.Log.Error("debuffs:create", c) end
    c:SetSize(1, Debuffs.SIZE)
    c:SetFrameLevel(owner:GetFrameLevel() + 10)
    pcall(c.EnableMouse, c, false)
    rec = { container = c, unit = unit, buttons = {} }
    records[owner] = rec
    Place(rec, owner)
    Try("unit", c.SetUnit, c, unit)
    local okA, err = pcall(function()
        c:AddAuraGroup(MINE, Debuffs.MineFilter(), {
            maxFrameCount = MAX_MINE, candidateFilters = MineCandidates(),
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff,
            initializeFrame = Initialize(rec, nil), layout = Layout(1, true),
        })
        c:AddAuraGroup(MOVE, Debuffs.MOVE_FILTER, {
            maxFrameCount = MAX_MOVE,
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff,
            initializeFrame = Initialize(rec, "move"), layout = Layout(2, false),
        })
        c:AddAuraGroup(BOSS, Debuffs.BossFilter(), {
            maxFrameCount = MAX_BOSS, candidateFilters = { isBossOrRoleAura = true },
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff,
            initializeFrame = Initialize(rec, "boss"), layout = Layout(3, false),
        })
    end)
    if not okA then
        records[owner] = nil
        return ns.Log.Error("debuffs:group", err)
    end
    ns.Log.Seen("debuffs:attach", "made")
    Apply(rec)
end

local function UnitOf(frame)
    local u = frame and (rawget(frame, "unit") or (frame.GetAttribute and frame:GetAttribute("unit")))
    if type(u) == "string" and not issecretvalue(u) then return u end
end

---Every party frame of the game on screen (the raid's are left alone: a 5-player tool): the raid-style ones
---(CompactPartyFrame) and, since 04/11, the classic ones (PartyFrame, the Edit Mode's default: "Use Raid-Style Party
---Frames" off), the same two the left side (Party.lua, FrameFor) has always used.
function Debuffs.Scan()
    local n, host = 0, "none"
    local party = rawget(_G, "CompactPartyFrame")
    local members = party and rawget(party, "memberUnitFrames")
    if type(members) == "table" and party:IsVisible() then
        host = "compact"
        for _, f in ipairs(members) do
            local u = UnitOf(f)
            if u then n = n + 1 end
            Attach(f, u)
        end
    end
    local classic = rawget(_G, "PartyFrame")
    if classic and classic:IsVisible() then
        host = host == "none" and "classic" or host .. "+classic"
        for _, f in ipairs({ classic:GetChildren() }) do
            if not f:IsForbidden() and f.GetAttribute then
                local ok, u = pcall(f.GetAttribute, f, "unit")
                if ok and type(u) == "string" and not issecretvalue(u) then
                    n = n + 1
                    Attach(f, u:lower())
                end
            end
        end
    end
    ns.Log.Seen("debuffs:host", host .. " " .. n)
end

---The options changed: every record takes them now, or at the end of the fight.
function Debuffs.Refresh()
    if Secret() or InCombatLockdown() then
        pending = true
        return
    end
    pending = false
    for _, rec in pairs(records) do Apply(rec) end
    if ns.db.debuffs ~= false then Debuffs.Scan() end
end
table.insert(ns.lookListeners, Debuffs.Refresh)

local hooked = false
local function Hook()
    if hooked or type(rawget(_G, "CompactUnitFrame_SetUnit")) ~= "function" then return end
    hooksecurefunc("CompactUnitFrame_SetUnit", function(frame, unit)
        if ns.db and ns.db.debuffs ~= false then Attach(frame, unit) end
    end)
    hooked = true
end

ns.On("PLAYER_LOGIN", function()
    Hook()
    if ns.db.debuffs ~= false then Debuffs.Scan() end
end)
ns.On("GROUP_ROSTER_UPDATE", function()
    if ns.db.debuffs ~= false then Debuffs.Scan() end
end)
ns.On("PLAYER_REGEN_ENABLED", function()
    if pending then Debuffs.Refresh() end
end)
-- the auras may stay secret past the fight's end (a key): try again when the zone changes and when a key ends
ns.On("ZONE_CHANGED_NEW_AREA", function() if pending then Debuffs.Refresh() end end)
ns.On("CHALLENGE_MODE_COMPLETED", function() if pending then Debuffs.Refresh() end end)
-- a talent or a specialization that frees a teammate from a root or a slow comes or goes: the root/slow group follows
ns.On("TRAIT_CONFIG_UPDATED", function() Debuffs.Refresh() end)
ns.On("PLAYER_SPECIALIZATION_CHANGED", function(unit) if unit == "player" then Debuffs.Refresh() end end)
-- the spells known come in after the login (and change with a talent): what the player removes is read again then
ns.On("SPELLS_CHANGED", function() if ns.db then Debuffs.Refresh() end end)

function Debuffs.Count()
    local n = 0
    for _ in pairs(records) do n = n + 1 end
    return n
end
function Debuffs.__records() return records end
