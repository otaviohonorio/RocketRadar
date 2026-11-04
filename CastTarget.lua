-- RocketRadar | CastTarget.lua
-- Who an enemy cast is going to: the spell's icon to the RIGHT of that member's party frame, in the first slot of
-- the right side, with a ring in the cast's colour that fills with the cast (04/11/2026, the user's rule of the party
-- frame: "sem mexer no frame (...) os icones de cast (com a borda animada como se fosse cast)"; until 03/11 it was a
-- line all around the frame and the icon inside its top-right corner).
--
-- What the game tells. 12.0.1 cut `UnitIsSpellTarget(unit, target)` down to the player only (Blizzard_Deprecated,
-- Deprecated_12_0_1.lua: any other target returns false), so:
--   * the player: exact, `PlayerIsSpellTarget(caster)` (a secret boolean). Only casts that have a target count
--     (`UnitShouldDisplaySpellTargetName`, the same test the game's cast bar makes).
--   * a teammate: NOT POSSIBLE. Tried 02-03/11/2026 with the caster's current target
--     (`UnitIsUnit(caster.."target", member)`): in a delve, 938 reads of 938 never said "yes", also while the casts
--     went to the companion. Mobs cast at someone without turning to them; the cast's own target is exactly what
--     12.0.1 hid. Lesson L-047.
--   * EXPERIMENT (user, 03/11/2026: "vamos testar, só quero ver o quadro piscando"): the game lets an addon DRAW the
--     target's secret name (`UnitSpellTargetName`), not read it. Drawn text takes room, and room can be measured
--     without reading, by the geometry trick of the party cooldown sensor: the secret name is written (invisible)
--     at the cursor, a 1.5-unit probe sits where the text would end if it were as wide as a member's name (whose
--     width IS readable), and `IsMouseOver` with the top and bottom out of reach says whether the probe covers the
--     cursor = the two widths are equal. Two fonts (Friz and the chat font) must agree, so two different names of
--     the same width in one font do not light the wrong frame; members tied in both fonts are left out. The answer
--     is a secret boolean, folded by EvaluateColorValueFromBoolean into the frame's alpha. Unproven: the game may
--     hide the size of secret text. (The yellow dot that checked it on the player's own frame left on 04/11: nothing
--     of ours is drawn on the game's frame.)
-- Every answer may be a secret, so none is tested: each gate is a frame whose alpha comes from a boolean, nested
-- (target × important × can be interrupted, the same gates as the plate mark in Cards.lua). One overlay per
-- (caster, member): two mobs casting at the same member both show, one over the other.
-- (04/11) In the package, with the party icons it lives beside.
local ADDON, ns = ...

local CastTarget = {}
ns.CastTarget = CastTarget

local MEMBERS = { "player", "party1", "party2", "party3", "party4" }
local TICK = 0.1
local E = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean
local FONTS = { "GameFontNormal", "ChatFontNormal" }
local PROBE = 1.5       -- width of the probe: widths within PROBE/2 of each other count as equal
local rulers = {}       -- [caster] = { [member] = { ruler per font } }
local spareRulers = {}

local spare = {}
local live = {}         -- [caster] = { [member] = overlay }
local ticker

--------------------------------------------------------------------------------
-- Overlay: the cast's icon to the RIGHT of the frame (04/11: nothing of ours on the game's frame any more), in the
-- first slot of the right side (Debuffs.lua): the spell's icon, a ring in the cast's colour that FILLS with the cast
-- (a channel's empties), the time left in a corner. Two rings behind two gates: the interruptible's colour and the
-- grey of the one that cannot be interrupted; the answer is a secret boolean, folded into the gates' alpha.
--------------------------------------------------------------------------------
local function NewOverlay()
    local size = ns.Debuffs.SIZE
    local o = CreateFrame("Frame", nil, UIParent)
    o:SetFrameStrata("HIGH")
    o:SetSize(size, size)
    o.important = CreateFrame("Frame", nil, o)
    o.important:SetAllPoints()
    -- the animation's own frame, between the gates and the icon: its alpha is the pulse's, never a secret's
    o.motion = CreateFrame("Frame", nil, o.important)
    o.motion:SetAllPoints()
    o.motionAnim = ns.Pulse(o.motion)
    o.p = ns.Debuffs.Dress(o.motion, size, true)
    o.open = CreateFrame("Frame", nil, o.motion)      -- the cast can be interrupted: the cast's own colour
    o.open:SetAllPoints()
    o.openRing = ns.Debuffs.Ring(o.open)
    o.locked = CreateFrame("Frame", nil, o.motion)    -- it cannot: the game's grey
    o.locked:SetAllPoints()
    o.lockedRing = ns.Debuffs.Ring(o.locked)
    o.p.cd:SetFrameLevel(o.motion:GetFrameLevel() + 4)
    -- the time left on the cast (user, 03/11: "podia ter o tempo de cast em cima do icone"): the duration's remaining
    -- time is a secret on a plate, it goes straight into the text, never tested
    o.motion:SetScript("OnUpdate", function()
        local d = o.dur
        if not d then return end
        local ok, left = pcall(d.GetRemainingDuration, d)
        if ok then o.p.time:SetFormattedText("%.1f", left) end
        if d.IsActive then pcall(o.p.time.SetAlphaFromBoolean, o.p.time, d:IsActive(), 1, 0) end
    end)
    o.icon = { tex = o.p.icon, time = o.p.time }
    o:Hide()
    return o
end

---The rings of an overlay for one cast: the colour of each kind (keys "party.*", the game's art measured until the
---player picks one), filling with the cast ("fill"), full ("solid") or full and breathing ("pulse").
local function Draw(o, channel, duration)
    local anim = ns.db.partyAnim or "fill"
    o.openRing:SetVertexColor(ns.ColorOf(channel and "party.channel" or "party.cast"))
    o.lockedRing:SetVertexColor(ns.ColorOf("party.locked"))
    local cd = o.p.cd
    if anim == "fill" and duration ~= nil then
        -- the dark covers the time still to go: the ring fills; a channel's covers the time gone: it empties
        cd:SetReverse(channel and true or false)
        local ok = pcall(cd.SetCooldownFromDurationObject, cd, duration)
        if not ok then cd:Clear() end
    else
        cd:Clear()
    end
    ns.SetPulse(o.motionAnim, anim == "pulse")
end

local function Place(o, frame)
    o:ClearAllPoints()
    o:SetPoint("LEFT", frame, "RIGHT", ns.Debuffs.SIDE, 0)
end

--------------------------------------------------------------------------------
-- The width experiment: rulers and the check dot
--------------------------------------------------------------------------------
local function NewRuler(font)
    local r = CreateFrame("Frame", nil, UIParent)
    r:SetSize(1, 1)
    r:SetFrameStrata("BACKGROUND")
    r.text = r:CreateFontString(nil, "ARTWORK", font)
    r.text:SetTextColor(0, 0, 0, 0)
    r.text:SetWordWrap(false)
    r.text:SetPoint("LEFT", r, "LEFT", 0, 0)
    r.meter = r:CreateFontString(nil, "ARTWORK", font)
    r.meter:SetTextColor(0, 0, 0, 0)
    r.meter:SetPoint("LEFT", r, "LEFT", 0, 0)
    r.probe = CreateFrame("Frame", nil, r)
    r.probe:SetSize(PROBE, 1)
    r.font = font
    return r
end

local taken = { fresh = 0, reused = 0 }   -- per cast, for the diary line
local function TakeRuler(font)
    for i, r in ipairs(spareRulers) do
        if r.font == font then
            taken.reused = taken.reused + 1
            return table.remove(spareRulers, i)
        end
    end
    taken.fresh = taken.fresh + 1
    return NewRuler(font)
end

-- (03/11) ONE LINE PER CAST in the diary (development): the user saw a second cast at the companion leave her frame
-- unchanged while the first had marked it. The line says what the addon could see of each cast -- the answers that are
-- secrets are written as "secret", never read -- so the next test tells which suspect it was.
local function Diary(caster, what)
    if not ns.Log.enabled then return end
    ns.Log.Event(("target %s %s %s"):format(caster, what, date("%H:%M:%S")))
end

-- Plain width of a plain name in this ruler's font.
local function WidthOf(r, name)
    r.meter:SetText(name)
    local w = r.meter:GetUnboundedStringWidth()
    r.meter:SetText("")
    return w
end

-- The secret name, and the probe where it would end if it were `width` wide.
local function Arm(r, secretName, width)
    r.text:SetText(secretName)
    r.probe:ClearAllPoints()
    r.probe:SetPoint("LEFT", r.text, "RIGHT", -width - PROBE / 2, 0)
    r:Show()
end

-- Moves the ruler so its text starts at the cursor, then asks whether the probe covers the cursor.
local function Measure(r)
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    r:ClearAllPoints()
    r:SetPoint("LEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
    return r.probe:IsMouseOver(1e5, -1e5, 0, 0)
end

-- 1 when every font says "same width as this member's name", 0 otherwise (a secret number, never tested).
local function Match(caster, member)
    local set = rulers[caster] and rulers[caster][member]
    if not set then return 0 end
    local okR, value = pcall(function()
        local v = 1
        for i = #set, 1, -1 do v = E(Measure(set[i]), v, 0) end
        return v
    end)
    if ns.Log.enabled then
        ns.Log.Seen("target.width", not okR and "fail" or issecretvalue(value) and "secret" or tostring(value))
    end
    if not okR then
        ns.Log.Error("target:width", value)
        return 0
    end
    return value
end

-- (04/11) THE ALERT OF A CAST AT YOU (the preview: "Conjuração em você · Fogo d'Alma"): a line at the top of the
-- screen, the spell's icon and name, while an enemy casts at you. Only for you: the game tells whom a cast goes to only
-- for the player. Gated as the icons: at you (a secret boolean) × important × which kind (interruptible or not, a
-- secret), each kind on only when its alert is "On you" (the Debuffs and alerts tab). No sound: the game does not let a
-- secret start one.
local ALERT_Y = -130
local alerts, spareAlerts = {}, {}
local function NewAlert()
    local a = CreateFrame("Frame", nil, UIParent)
    a:SetFrameStrata("HIGH")
    a:SetSize(420, 28)
    a:SetPoint("TOP", UIParent, "TOP", 0, ALERT_Y)
    a.important = CreateFrame("Frame", nil, a)
    a.important:SetAllPoints()
    local function Kind()
        local k = CreateFrame("Frame", nil, a.important)
        k:SetAllPoints()
        k.icon = k:CreateTexture(nil, "ARTWORK")
        k.icon:SetSize(24, 24)
        k.icon:SetPoint("LEFT", k, "LEFT", 0, 0)
        k.label = k:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")   -- white: the game has no Highlight one
        k.label:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
        k.label:SetPoint("LEFT", k.icon, "RIGHT", 8, 0)
        k.label:SetText(ns.L["Cast at you"])
        k.spell = k:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
        k.spell:SetPoint("LEFT", k.label, "RIGHT", 8, 0)
        return k
    end
    a.open, a.locked = Kind(), Kind()
    a:Hide()
    return a
end

local function Release(caster)
    if alerts[caster] then
        alerts[caster]:Hide()
        spareAlerts[#spareAlerts + 1] = alerts[caster]
        alerts[caster] = nil
    end
    for _, o in pairs(live[caster] or {}) do
        o:Hide()
        ns.SetPulse(o.motionAnim, false)
        spare[#spare + 1] = o
    end
    live[caster] = nil
    for _, set in pairs(rulers[caster] or {}) do
        for _, ruler in ipairs(set) do
            ruler:Hide()
            spareRulers[#spareRulers + 1] = ruler
        end
    end
    rulers[caster] = nil
end

--------------------------------------------------------------------------------
-- Whether `member` is the target, as a boolean that may be a secret (never tested here)
--------------------------------------------------------------------------------
local function IsTarget(caster, member)
    if member == "player" then
        local ok, yes = pcall(PlayerIsSpellTarget, caster)
        if ok then
            if ns.Log.enabled then ns.Log.Seen("target.player.secret", issecretvalue(yes)) end
            return yes
        end
        if ns.Log.enabled then ns.Log.Seen("target.player", "fail") end
        return false
    end
    return false
end

-- Re-read the gates of every live overlay. The player: exact, plus the experiment's dot; a teammate: the experiment.
local function Gate(caster)
    if alerts[caster] and not (live[caster] and live[caster].player) then
        local ok, err = pcall(alerts[caster].SetAlphaFromBoolean, alerts[caster], IsTarget(caster, "player"), 1, 0)
        if not ok then ns.Log.Error("target:alert", err) end
    end
    for member, o in pairs(live[caster] or {}) do
        local ok, err
        if member == "player" then
            ok, err = pcall(o.SetAlphaFromBoolean, o, IsTarget(caster, member), 1, 0)
            if ok and alerts[caster] then ok, err = pcall(alerts[caster].SetAlphaFromBoolean, alerts[caster], IsTarget(caster, member), 1, 0) end
        else
            ok, err = pcall(o.SetAlpha, o, Match(caster, member))
        end
        if not ok then ns.Log.Error("target:gate", err) end
    end
end

-- Rulers for every member whose name is not tied with another member's in every font.
local function ArmRulers(caster)
    local okN, secretName = pcall(UnitSpellTargetName, caster)
    if not okN or not ns.Has(secretName) then
        Diary(caster, "no-name" .. (okN and "" or " (call failed)"))
        return
    end
    if ns.Log.enabled then ns.Log.Seen("target.name.secret", issecretvalue(secretName)) end
    local widths, keys = {}, {}
    for _, member in ipairs(MEMBERS) do
        local name = UnitExists(member) and UnitName(member)
        if name and not issecretvalue(name) then
            local set, key = {}, {}
            for i, font in ipairs(FONTS) do
                set[i] = TakeRuler(font)
                local w = WidthOf(set[i], name)
                set[i].width = w
                key[i] = ("%.1f"):format(w)
            end
            widths[member] = set
            key = table.concat(key, "/")
            keys[key] = (keys[key] or 0) + 1
            set.key = key
        end
    end
    local out = {}
    for member, set in pairs(widths) do
        if keys[set.key] > 1 then
            -- two members look alike in every font: neither can be told apart
            if ns.Log.enabled then ns.Log.Seen("target.width.tie", member) end
            for _, ruler in ipairs(set) do spareRulers[#spareRulers + 1] = ruler end
        else
            for _, ruler in ipairs(set) do Arm(ruler, secretName, ruler.width) end
            out[member] = set
        end
    end
    rulers[caster] = out
end

function CastTarget.Refresh()
    local any = false
    for caster in pairs(live) do
        if caster ~= "test" then
            Gate(caster)
            any = true
        end
    end
    if not any and ticker then
        ticker:Cancel()
        ticker = nil
    end
end

--------------------------------------------------------------------------------
-- A cast started, changed or ended on a plate
--------------------------------------------------------------------------------
local function Update(caster)
    Release(caster)
    local db = ns.db
    if not (db and db.kick) or not UnitCanAttack("player", caster) then return end
    local channel = false
    local _, text, texture, _, _, _, _, locked, spellID, castBarID = UnitCastingInfo(caster)
    if castBarID == nil then
        channel = true
        _, text, texture, _, _, _, locked, spellID, _, _, castBarID = UnitChannelInfo(caster)
    end
    if castBarID == nil then return end
    -- (04/11) each row of the table has its on/off: the cast (castMark), the channel (partyChannel), the
    -- uninterruptible (partyLocked); and each its alert
    local onFrame = (channel and db.partyChannel ~= false) or (not channel and db.castMark ~= false)
    local mode = ns.Alerts and ns.Alerts.Mode or function() return "off" end
    local alertOpen = mode(channel and "channel" or "cast") == "me"
    local alertLocked = mode("locked") == "me"
    if not onFrame and not alertOpen and not alertLocked then return end
    -- a cast without a target (an area spell) points at nobody
    local okT, targeted = pcall(UnitShouldDisplaySpellTargetName, caster)
    if ns.Log.enabled then ns.Log.Seen("target.has.secret", okT and issecretvalue(targeted)) end
    if not okT or (not issecretvalue(targeted) and not targeted) then
        Diary(caster, "no-target" .. (okT and "" or " (call failed)"))
        return
    end
    if not ns.Has(locked) then locked = false end
    local duration = channel and UnitChannelDuration(caster) or UnitCastingDuration(caster)
    local set = {}
    for _, member in ipairs(onFrame and MEMBERS or {}) do
        local frame = ns.Party and ns.Party.FrameFor(member, true)   -- the group frames only, never the portrait
        if frame and UnitExists(member) then
            local o = table.remove(spare) or NewOverlay()
            Place(o, frame)
            if db.kickFilter == "important" and ns.Has(spellID) then
                o.important:SetAlphaFromBoolean(C_Spell.IsSpellImportant(spellID), 1, 0)
            else
                o.important:SetAlpha(1)
            end
            Draw(o, channel, duration)
            o.open:SetAlphaFromBoolean(locked, 0, 1)
            if db.partyLocked == false then
                o.locked:SetAlpha(0)
            else
                o.locked:SetAlphaFromBoolean(locked, 1, 0)
            end
            o.icon.tex:SetTexture(texture)
            o.dur = duration
            o.icon.time:SetText("")
            -- a secret boolean through the scalar setter would be the same as a test: start hidden, gate below
            o:SetAlpha(0)
            o:Show()
            set[member] = o
        end
    end
    live[caster] = set
    if alertOpen or alertLocked then
        local a = table.remove(spareAlerts) or NewAlert()
        if db.kickFilter == "important" and ns.Has(spellID) then
            a.important:SetAlphaFromBoolean(C_Spell.IsSpellImportant(spellID), 1, 0)
        else
            a.important:SetAlpha(1)
        end
        for _, k in ipairs({ a.open, a.locked }) do
            k.icon:SetTexture(texture)
            k.spell:SetText(text)   -- the spell's name may be a secret: drawn, never read
        end
        if alertOpen then a.open:SetAlphaFromBoolean(locked, 0, 1) else a.open:SetAlpha(0) end
        if alertLocked then a.locked:SetAlphaFromBoolean(locked, 1, 0) else a.locked:SetAlpha(0) end
        a:SetAlpha(0)   -- gated below, by whom the cast goes to
        a:Show()
        alerts[caster] = a
    end
    taken.fresh, taken.reused = 0, 0
    ArmRulers(caster)
    do
        local measured = {}
        for member in pairs(rulers[caster] or {}) do measured[#measured + 1] = member end
        table.sort(measured)
        Diary(caster, ("cast locked=%s measured=%s fresh=%d reused=%d"):format(
            issecretvalue(locked) and "secret" or tostring(locked), table.concat(measured, ","), taken.fresh, taken.reused))
    end
    Gate(caster)
    if not ticker then ticker = C_Timer.NewTicker(TICK, CastTarget.Refresh) end
end

function CastTarget.Update(caster)
    local ok, err = pcall(Update, caster)
    if not ok then
        Release(caster)
        ns.Log.Error("target", err)
    end
end

local function OnCast(unit)
    if ns.IsPlateUnit(unit) then CastTarget.Update(unit) end
end

for _, event in ipairs({
    "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_INTERRUPTED",
    "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_CHANNEL_UPDATE",
    "UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_INTERRUPTIBLE", "UNIT_SPELLCAST_NOT_INTERRUPTIBLE",
}) do
    ns.On(event, OnCast)
end
ns.On("NAME_PLATE_UNIT_REMOVED", function(unit)
    if not issecretvalue(unit) then Release(unit) end
end)
-- A colour or an animation changed in the options: the casts on screen are drawn again.
table.insert(ns.lookListeners, function()
    for caster in pairs(live) do
        if caster ~= "test" then CastTarget.Update(caster) end
    end
end)
ns.On("UNIT_TARGET", function(unit)
    if ns.IsPlateUnit(unit) and live[unit] then Gate(unit) end
end)

---`/rr test`: the mark on your own frame for a few seconds, with a sample icon, to see it out of a fight.
function CastTarget.Test()
    local frame = ns.Party and ns.Party.FrameFor("player", true)
    if not frame then
        ns.Print(ns.L["The group frames are not on screen: the cast mark shows on them in a group."])
        return
    end
    Release("test")
    local o = table.remove(spare) or NewOverlay()
    Place(o, frame)
    o.important:SetAlpha(1)
    o.open:SetAlpha(1)
    o.locked:SetAlpha(0)
    o.icon.tex:SetTexture(C_Spell.GetSpellTexture(1766))
    o.dur = nil
    o.icon.time:SetText("1.5")
    Draw(o, false, nil)   -- a test has no cast to follow: the full ring, in the colour and animation chosen
    o:SetAlpha(1)
    o:Show()
    live.test = { player = o }
    C_Timer.After(6, function() if live.test and live.test.player == o then Release("test") end end)
end

function CastTarget.live() return live end
function CastTarget.alerts() return alerts end
