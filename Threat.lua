-- RocketRadar | Threat.lua
-- Who holds each mob, on every plate, not only the moment it changes.
--
-- The game's documentation (SecretWhenUnitThreatStateRestricted, 12.1.5): queries where one unit is
-- the player, their pet or an ally and the other a nameplate "are generally not secret". So here,
-- unlike the cast, plain code can decide. "Generally" is not "always": a secret answer leaves the
-- plate without a marker instead of guessing, and the log counts it.
--
-- UnitThreatSituation: 0/1 another unit holds the mob, 2 the unit holds it but is not the highest
-- on the list (about to lose it), 3 it holds it securely.
--
-- (22/11/2026) The percentage beside the shield (the user approved the preview "PREVIA Rocket Radar - ameaca antes de
-- puxar"): UnitDetailedThreatSituation's third value, scaledPercentage, is how much of the threat needed to take the
-- mob a unit has (100 = the mob turns to it; the game already counts the distance, the 110%/130% rule). Its values are
-- "generally not secret" between the player or an ally and a mob that is not a boss
-- (SecretWhenUnitThreatValuesRestricted, 12.1.5 and the Forever); on a boss they are, and the number is left out.
-- UnitThreatPercentageOfLead is not used: neither the game's documentation nor the wiki says what it returns.
local ADDON, ns = ...
local L = ns.L

ns.Threat = {}

-- Damage and healers: the shield turns yellow from threatWarn and blinks from threatStrong. The tank: orange when the
-- closest player is within threatLead of taking the mob. All three are the player's (the Threat tab); these, the default.
local WARN, STRONG, LEAD = 70, 90, 20

local tokens = setmetatable({}, { __mode = "k" })
local shown = {}
local units = {}          -- the plates on screen, kept by the add and remove events
local pending = false

local function TokenOf(plate)
    local token = tokens[plate]
    if token then return token end
    token = CreateFrame("Frame", nil, plate)
    token:SetSize(22, 22)
    token:SetFrameStrata("BACKGROUND")   -- over the plates (WORLD), under the windows (L-072, Cards.lua)
    token:SetPoint("RIGHT", plate, "LEFT", -2, 0)
    token.icon = token:CreateTexture(nil, "ARTWORK")
    token.icon:SetAllPoints()
    token.icon:SetAtlas("ui-lfg-roleicon-tank-micro-groupfinder")
    token.icon:SetDesaturated(true)
    token.name = token:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
    token.name:SetPoint("RIGHT", token, "LEFT", -2, 0)
    token.pulse = token:CreateAnimationGroup()
    token.pulse:SetLooping("BOUNCE")
    local fade = token.pulse:CreateAnimation("Alpha")
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0.3)
    fade:SetDuration(0.35)
    -- about to take the mob: a slower blink than the loose mob's
    token.slow = token:CreateAnimationGroup()
    token.slow:SetLooping("BOUNCE")
    local slow = token.slow:CreateAnimation("Alpha")
    slow:SetFromAlpha(1)
    slow:SetToAlpha(0.45)
    slow:SetDuration(0.8)
    tokens[plate] = token
    return token
end

---The ally who holds `unit`, or nil. Stops at the first one: only one unit holds a mob.
local function Holder(unit)
    local prefix = IsInRaid() and "raid" or "party"
    local last = GetNumGroupMembers()
    if prefix == "party" then last = last - 1 end
    for i = 1, last do
        local ally = prefix .. i
        local status = UnitThreatSituation(ally, unit)
        if not issecretvalue(status) and status and status >= 2 then return ally end
    end
    if UnitExists("pet") then
        local status = UnitThreatSituation("pet", unit)
        if not issecretvalue(status) and status and status >= 2 then return "pet" end
    end
end

---"boss", "trash" or "?" (the answer unreadable), for the log only.
local function Kind(unit)
    local ok, boss = pcall(UnitIsBossMob, unit)
    if not ok or issecretvalue(boss) then return "?" end
    return boss and "boss" or "trash"
end

---How much of the threat needed to take `unit` that `who` has (0-100), or nil when the game does not say (no threat
---yet). The third value is true when the number is secret: it can be written (`Secret`), never compared.
---(24/11) The Forever's log: 8059 reads in instances, every one secret, the trash included (the documentation's
---"generally not secret" does not hold there); the same is expected in the retail's instances.
local function Percent(who, unit)
    local tanking, _, scaled = UnitDetailedThreatSituation(who, unit)
    -- (23/11) a test showed no number and the diary had no line at all: "the game said nothing" is counted too
    if scaled == nil then return ns.Log.Seen("threat.pct.none", who == "player" and "player" or "ally") end
    local secret = issecretvalue(scaled)
    ns.Log.Seen("threat.pct.secret", secret and Kind(unit) or false)
    if secret then return scaled, nil, true end
    return scaled, tanking
end

---A secret percentage as text, rounded by the game without reading it (C_StringUtil, both clients:
---SecretArguments AllowedWhenTainted), or nil when it can't.
local function Secret(value)
    if not (C_StringUtil and C_StringUtil.RoundToNearestString) then return nil end
    local ok, text = pcall(C_StringUtil.RoundToNearestString, value)
    return ok and text or nil
end

---The highest percentage among the group's other members who are not tanks (a second tank close is the plan), or nil.
local function NextPercent(unit)
    local prefix = IsInRaid() and "raid" or "party"
    local last = GetNumGroupMembers()
    if prefix == "party" then last = last - 1 end
    local best
    for i = 1, last do
        local ally = prefix .. i
        -- the one holding the mob (the player themself, in a raid's list) is not "the next"
        if UnitGroupRolesAssigned(ally) ~= "TANK" then
            local pct, tanking, hidden = Percent(ally, unit)
            if pct and not hidden and not issecretvalue(tanking) and tanking ~= true and (not best or pct > best) then best = pct end
        end
    end
    return best
end

---Name of `ally` in its class colour.
local function HolderName(ally)
    local name = UnitName(ally)
    if issecretvalue(name) then return name end
    local _, class = UnitClass(ally)
    local color = class and not issecretvalue(class) and C_ClassColor.GetClassColor(class)
    return color and color:WrapTextInColorCode(name) or name
end

local function Hide(unit)
    local token = shown[unit]
    if token then
        token.pulse:Stop()
        token.slow:Stop()
        token:Hide()
        shown[unit] = nil
    end
end

---`label`: the name of who took the mob (class colour; kept by the names option) or, `number` true, a percentage or
---"You" (kept by the percentage option), in the state's colour. `blink`: "fast" (loose) / "slow" (about to take it).
local function Show(unit, plate, state, label, number, blink, dim)
    local token = TokenOf(plate)
    shown[unit] = token
    local r, g, b = ns.ColorOf("threat." .. state)   -- (04/11) the player's colour, else the game's
    token.icon:SetVertexColor(r, g, b)
    token.icon:SetAlpha(dim and 0.45 or 1)
    local on
    if number then on = ns.db.threatPercent ~= false else on = ns.db.threatNames end
    if on and number and issecretvalue(label) then
        token.name:SetFormattedText("%s%%", label)   -- a secret percentage: the game writes it (AllowedWhenTainted)
    else
        token.name:SetText(on and label or "")
    end
    token.name:SetTextColor(r, g, b)
    if blink == "fast" then
        token.slow:Stop()
        if not token.pulse:IsPlaying() then token.pulse:Play() end
    elseif blink == "slow" then
        token.pulse:Stop()
        if not token.slow:IsPlaying() then token.slow:Play() end
    else
        token.pulse:Stop()
        token.slow:Stop()
    end
    token:Show()
end

local function Pct(v) return string.format("%d%%", math.floor(v + 0.5)) end

---Updates one plate.
local function Update(unit)
    if not UnitCanAttack("player", unit) or not UnitAffectingCombat(unit) then return Hide(unit) end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or plate:IsForbidden() then return Hide(unit) end

    local status = UnitThreatSituation("player", unit)
    if issecretvalue(status) then
        ns.Log.Seen("threat.player.secret", true)
        return Hide(unit)
    end
    ns.Log.Seen("threat.player.secret", false)

    if ns.IsTank() then
        if status == 3 or status == 2 then
            -- The lead: how far the closest player (not a tank) is from taking the mob. Alone, or on a boss, no number.
            local nextPct = IsInGroup() and NextPercent(unit)
            local lead = nextPct and math.max(0, 100 - nextPct)
            local state = (status == 2 or (lead and lead < (tonumber(ns.db.threatLead) or LEAD))) and "risk" or "safe"
            return Show(unit, plate, state, lead and ("+" .. Pct(lead)), true)
        end
        -- Alone there is nobody to lose the mob to: a pet holding it is fine.
        if not IsInGroup() then return Hide(unit) end
        local holder = Holder(unit)
        if not holder then return Hide(unit) end
        local name = HolderName(holder)
        -- Another tank holding the mob is the plan, not a problem.
        if UnitGroupRolesAssigned(holder) == "TANK" then
            return Show(unit, plate, "tank", name)
        end
        return Show(unit, plate, "lost", name, nil, "fast")
    end

    -- Damage or healer: alone a mob on the player is simply the fight, not a warning (the user saw a red shield on
    -- every rare, 02/11). In a group: red when it turned to the player, yellow while close to it.
    if not IsInGroup() then return Hide(unit) end
    if status and status >= 2 then
        return Show(unit, plate, "lost", YOU, true, "fast")
    end
    local pct, _, hidden = Percent("player", unit)
    if hidden then
        -- (24/11, the user's choice) A secret number can't be held against 70/90: it shows only when the game itself
        -- says the player passed the tank's threat and is about to take the mob (state 1), yellow and blinking.
        ns.Log.Seen("threat.pct.hidden.status", status)
        if status == 1 then return Show(unit, plate, "warn", Secret(pct) or "", true, "slow") end
        return Hide(unit)
    end
    if ns.db.threatPercent == false then pct = nil end
    local warn = tonumber(ns.db.threatWarn) or WARN
    if pct and pct >= warn then
        local strong = pct >= (tonumber(ns.db.threatStrong) or STRONG)
        return Show(unit, plate, "warn", Pct(pct), true, strong and "slow" or nil, not strong)
    end
    Hide(unit)
end

local function Safely(unit)
    local ok, err = pcall(Update, unit)
    if not ok then
        Hide(unit)
        ns.Log.Error("threat", err)
    end
end

-- The line in the middle of the screen with how many mobs were on the tank, at risk and loose was
-- removed: the user did not want it (02/11). The markers on the plates say the same, where it happens.
function ns.Threat.Refresh()
    local on = ns.db and ns.db.threat
    for unit in pairs(units) do
        if on then Safely(unit) else Hide(unit) end
    end
end

-- A pull fires these events by the dozen, one per mob: one pass answers all of them.
local function Flush()
    pending = false
    ns.Threat.Refresh()
end

local function Queue()
    if ns.db and not pending then
        pending = true
        C_Timer.After(0.1, Flush)
    end
end

local function OnThreat(unit)
    if ns.IsPlateUnit(unit) then Queue() end
end

ns.On("UNIT_THREAT_LIST_UPDATE", OnThreat)
ns.On("UNIT_THREAT_SITUATION_UPDATE", OnThreat)
ns.On("NAME_PLATE_UNIT_ADDED", function(unit)
    if ns.IsPlateUnit(unit) then
        units[unit] = true
        Queue()
    end
end)
ns.On("NAME_PLATE_UNIT_REMOVED", function(unit)
    if not issecretvalue(unit) then
        units[unit] = nil
        Hide(unit)
    end
end)
ns.On("PLAYER_SPECIALIZATION_CHANGED", Queue)

-- After a /reload the plates are already there and no add event comes.
ns.On("PLAYER_ENTERING_WORLD", function()
    wipe(units)
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) then units[unit] = true end
    end
    Queue()
end)

table.insert(ns.ticks, ns.Threat.Refresh)
