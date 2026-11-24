-- RocketRadar | Threat.lua
-- Who holds each mob, on every plate, not only the moment it changes.
--
-- The game's documentation (SecretWhenUnitThreatStateRestricted, 12.1.5): queries where one unit is
-- the player, their pet or an ally and the other a nameplate "are generally not secret". So here,
-- unlike the cast, plain code can decide. "Generally" is not "always": a secret answer leaves the
-- plate without a marker instead of guessing, and the log counts it.
--
-- UnitThreatSituation (warcraft.wiki.gg, API_UnitThreatSituation): 0 under 100% of the threat needed to take the mob;
-- 1 over 100% but not yet its target (the game's yellow); 2 its target, but someone else is over 100% (orange: about to
-- lose it); 3 its target and nobody else over 100% (holds it securely).
--
-- (24/11/2026) No percentage: inside instances the game hid the number in all 8059 reads of the Forever's log, trash
-- included, so a number and thresholds over it (0.5.0, never published) could not work. The user: "não faz sentido
-- mostrar o percentual, só temos que deixar bem claro quando o aggro tá com o tanque, quando ele tá perdendo o aggro e
-- quando outra pessoa aggrou antes ou ganhou o aggro do tank". Only the state, which the game gives in the open.
local ADDON, ns = ...
local L = ns.L

ns.Threat = {}

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
        -- (24/11) only the player's own read is proven open in instances (the log, M+ and raid included); a teammate's
        -- is not yet: the names on the plates depend on it, so the log counts it too
        ns.Log.Seen("threat.ally.secret", issecretvalue(status))
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
        token.slow:Stop()
        token:Hide()
        shown[unit] = nil
    end
end

---`label`: who took the mob (class colour, or "You"), kept by the names option, in the state's colour.
---`blink`: "fast" (loose) / "slow" (about to be taken).
local function Show(unit, plate, state, label, blink)
    local token = TokenOf(plate)
    shown[unit] = token
    local r, g, b = ns.ColorOf("threat." .. state)   -- (04/11) the player's colour, else the game's
    token.icon:SetVertexColor(r, g, b)
    token.name:SetText(ns.db.threatNames and label or "")
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
            return Show(unit, plate, "risk", nil, "slow")   -- someone passed the tank's threat: losing it
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
        return Show(unit, plate, "lost", name, "fast")
    end

    -- Damage or healer (24/11, the user's choice "only the dangers"): a mob with the tank shows nothing. Alone a mob on
    -- the player is simply the fight, not a warning (the user saw a red shield on every rare, 02/11).
    if not IsInGroup() then return Hide(unit) end
    if status and status >= 2 then return Show(unit, plate, "lost", YOU, "fast") end         -- it turned to the player
    if status == 1 then return Show(unit, plate, "warn", nil, "slow") end          -- the player passed the tank's threat
    local holder = Holder(unit)
    if holder and UnitGroupRolesAssigned(holder) ~= "TANK" then
        return Show(unit, plate, "lost", HolderName(holder), "fast")               -- another player took it
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
