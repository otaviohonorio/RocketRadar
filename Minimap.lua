-- RocketRadar | Minimap.lua
-- The minimap button that opens the options window, drawn like the other Rocket addons' buttons (RocketLab and
-- RocketMeter Minimap.lua: the game's ring at 50, its dark disc at 24, the icon at 18, all centred) with the addon's
-- own logo (Textures/Minimap.png, the radar and the rocket). The position is kept as an angle and the radius follows
-- the minimap's size, so it survives an enlarged minimap. The options window has the box that hides it.
local ADDON, ns = ...
local L = ns.L

local MinimapButton = {}
ns.MinimapButton = MinimapButton

local RIM = 5
local DEFAULT_ANGLE = 250       -- the other Rocket buttons start at 200, 210 and 235
local ICON = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\Minimap.png"
local button

local function Radius() return Minimap:GetWidth() / 2 + RIM end

local function UpdatePosition()
    local angle = math.rad(ns.db.minimap.angle or DEFAULT_ANGLE)
    local radius = Radius()
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

local function OnDragUpdate()
    local mx, my = Minimap:GetCenter()
    local scale = Minimap:GetEffectiveScale()
    local px, py = GetCursorPosition()
    px, py = px / scale, py / scale
    ns.db.minimap.angle = math.deg(math.atan2(py - my, px - mx)) % 360
    UpdatePosition()
end

-- The state line of the tooltip: who the markers are drawn for.
local function ProfileText()
    local p = ns.db.profile
    if p == "tank" then return L["Tank"] end
    if p == "dps" then return L["Damage or healer"] end
    return L["Automatic"]
end

function MinimapButton.Create()
    if button then return button end
    button = CreateFrame("Button", ADDON .. "MinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("AnyUp")
    button:RegisterForDrag("LeftButton")
    button:SetMovable(true)

    local disc = button:CreateTexture(nil, "BACKGROUND")
    disc:SetSize(24, 24)
    disc:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    disc:SetPoint("CENTER", button, "CENTER")

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("CENTER", button, "CENTER")
    icon:SetTexture(ICON)
    icon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
    button.icon = icon

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(50, 50)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    button:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", OnDragUpdate) end)
    button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    button:SetScript("OnClick", function() ns.ToggleWindow() end)
    button:SetScript("OnEnter", function(self)
        -- The minimap tooltip of every Rocket addon (13/10, the visual identity): the title; the state, white; a
        -- blank line; one green line per action, the verb in the infinitive. No "drag to move".
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip_SetTitle(GameTooltip, ns.TITLE)
        GameTooltip_AddHighlightLine(GameTooltip, L["Play as"] .. ": " .. ProfileText())
        GameTooltip_AddBlankLineToTooltip(GameTooltip)
        GameTooltip_AddInstructionLine(GameTooltip, L["Click: open the options"])
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", GameTooltip_Hide)

    Minimap:HookScript("OnSizeChanged", UpdatePosition)
    UpdatePosition()
    button:SetShown(ns.db.minimapButton ~= false)
    return button
end

---The box of the options window.
function MinimapButton.SetHidden(hide)
    ns.db.minimapButton = not hide
    if button then button:SetShown(not hide) end
end

ns.On("PLAYER_LOGIN", MinimapButton.Create)
