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
local ADDON, ns = ...
local L = ns.L

ns.Threat = {}

local STATE = {
    safe = GREEN_FONT_COLOR,
    risk = ORANGE_FONT_COLOR,
    lost = RED_FONT_COLOR,
    tank = HIGHLIGHT_FONT_COLOR,
}

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
        token:Hide()
        shown[unit] = nil
    end
end

local function Show(unit, plate, state, name)
    local token = TokenOf(plate)
    shown[unit] = token
    token.icon:SetVertexColor(ns.ColorOf("threat." .. state))   -- (04/11) the player's colour, else the game's (STATE)
    token.name:SetText(ns.db.threatNames and name or "")
    if state == "lost" then
        if not token.pulse:IsPlaying() then token.pulse:Play() end
    else
        token.pulse:Stop()
    end
    token:Show()
end

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
        if status == 3 then
            return Show(unit, plate, "safe")
        elseif status == 2 then
            return Show(unit, plate, "risk")
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
        return Show(unit, plate, "lost", name)
    end

    -- Damage or healer: the marker appears only when the mob turned to the player. Alone that is
    -- simply the fight, not a warning: the user saw a red shield on every rare (02/11).
    if status and status >= 2 and IsInGroup() then
        Show(unit, plate, "lost")
    else
        Hide(unit)
    end
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
