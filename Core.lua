-- RocketRadar | Core.lua
-- Adds to the game's nameplates; never replaces, recolours or moves them. The health bar stays
-- exactly as the player set it in the game's options (the user: "não gostaria de mudar as cores
-- default como a vida vermelha").
local ADDON, ns = ...

ns.TITLE = "|cffff6a00Rocket|r Radar"
ns.NAME = "Rocket Radar"
ns.LOGO = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\Logo.png"   -- the portrait of the main window

-- The key is the English text, so a missing translation still reads.
ns.L = setmetatable({}, { __index = function(_, k) return k end })

ns.defaults = {
    profile = "auto",        -- auto (by the specialization's role) / dps / tank
    kick = true,
    kickFilter = "all",  -- all / important
    threat = true,
    threatNames = true,
    -- the group (Party.lua, CastTarget.lua): the options window's Group section
    party = true,
    partySelf = true,
    partySize = 30,
    partyPerRow = 6,
    castMark = true,
    minimapButton = true,
    -- (03/11/2026) every mark has its on/off, its animation and a colour per kind (the user: "opções de liga e
    -- desliga, para o cast na barra da placa, cast no frame da party e as outras features, e ter uma palheta de cor
    -- para cada item, cast, channeling, animações, tanto para a placa, quanto para frame party")
    plateLocked = false,      -- the plate mark also for a cast that cannot be interrupted (grey); off: as before
    partyLocked = true,       -- the party frame mark for it (the user asked for it on 03/11, for the healer)
    partyChannel = true,      -- (04/11) the channel's own row in the table (Debuffs and alerts tab)
    plateAnim = "fill",       -- fill (with the cast) / solid / pulse
    partyAnim = "fill",
    -- (04/11/2026) the right of the party frame (Debuffs.lua): the debuffs that come off, then the boss's or role's
    debuffs = true,
    dispelMode = "mine",      -- mine (what I can remove) / all (every debuff that has a dispel type)
    bossDebuffs = true,
    moveDebuffs = true,       -- (04/11) a root or a slow without a dispel type, in light blue (Debuffs.lua, MOVE)
    alertChannel = "Master",  -- the alerts' sounds (Alerts.lua); alerts = { [kind] = "me"/"group" }: every one off at first
    -- dispelOff = { [type] = true }: types turned off; colors = { [key] = { r, g, b } }: nil = the game's colour
}

--------------------------------------------------------------------------------
-- Colours: the game's by default, the player's when chosen (Window.lua). One place paints every piece.
--------------------------------------------------------------------------------
-- The game's cast art, measured (average of the opaque pixels of each atlas, tools/ver_atlas.py, 03/11/2026): what
-- the swatch shows while no colour is chosen. The art itself is drawn untouched then.
ns.GAME_COLOR = {
    cast = { 0.86, 0.73, 0.21 },      -- ui-castingbar-filling-standard
    channel = { 0.42, 0.70, 0.14 },   -- ui-castingbar-filling-channel
    locked = { 0.62, 0.58, 0.51 },    -- ui-castingbar-uninterruptable
    -- (04/11) a root or a slow without a dispel type: the game has no colour for it; the user asked for "um azul em tom
    -- mais claro", lighter than the game's Magic blue (DEBUFF_TYPE_MAGIC_COLOR, 0.2 0.6 1.0)
    Move = { 0.55, 0.85, 1.0 },
}
-- (04/11) the threat shield's colour of each state, a colour object of the game (the Threat tab lets each one change)
ns.THREAT_DEFAULT = { safe = "GREEN_FONT_COLOR", risk = "ORANGE_FONT_COLOR", lost = "RED_FONT_COLOR", tank = "HIGHLIGHT_FONT_COLOR" }
-- The dispel types, in the order the game lists them (AuraUtil, DEBUFF_DISPLAY_INFO).
ns.DISPEL_TYPES = { "Magic", "Curse", "Disease", "Poison", "Bleed" }

---The colour chosen for `key` ("plate.cast", "party.locked", "dispel.Magic", ...), or nil = the game's.
function ns.ChosenColor(key)
    local c = ns.db and type(ns.db.colors) == "table" and ns.db.colors[key]
    if type(c) == "table" and type(c[1]) == "number" then return c end
    return nil
end

---The colour in use for `key`, as r, g, b: the chosen one, else the game's (the art measured, or the dispel colour).
function ns.ColorOf(key)
    local c = ns.ChosenColor(key)
    if c then return c[1], c[2], c[3] end
    local kind = key:match("^%a+%.(%a+)$")
    local dispelColor = kind and rawget(_G, "DEBUFF_TYPE_" .. kind:upper() .. "_COLOR")
    if key:find("^dispel%.") and dispelColor then return dispelColor:GetRGB() end
    -- (04/11) the threat shield's states, in the game's colours (GREEN_/ORANGE_/RED_/HIGHLIGHT_FONT_COLOR)
    local threatColor = key:find("^threat%.") and ns.THREAT_DEFAULT[kind] and rawget(_G, ns.THREAT_DEFAULT[kind])
    if threatColor then return threatColor:GetRGB() end   -- "dispel.None": the boss's red
    local g = ns.GAME_COLOR[kind] or ns.GAME_COLOR.cast
    return g[1], g[2], g[3]
end

---Keeps a colour (`r` nil: back to the game's) and tells the marks to draw again.
function ns.SetColor(key, r, g, b)
    ns.db.colors = type(ns.db.colors) == "table" and ns.db.colors or {}
    ns.db.colors[key] = r and { r, g, b } or nil
    if ns.OnLookChanged then ns.OnLookChanged() end
end

---Paints a texture with the game's art in the colour of `key`: untouched while the game's is in use; else the art
---loses its own colour and takes the chosen one (it keeps its shading).
function ns.Paint(texture, key)
    if not texture then return end
    local c = ns.ChosenColor(key)
    if c then
        texture:SetDesaturated(true)
        texture:SetVertexColor(c[1], c[2], c[3])
    else
        texture:SetDesaturated(false)
        texture:SetVertexColor(1, 1, 1)
    end
end

---The pulse of the "pulse" animation: a gentle breathing of the frame's alpha, the same for every mark.
function ns.Pulse(frame)
    local g = frame:CreateAnimationGroup()
    g:SetLooping("BOUNCE")
    local a = g:CreateAnimation("Alpha")
    a:SetFromAlpha(1)
    a:SetToAlpha(0.35)
    a:SetDuration(0.6)
    a:SetSmoothing("IN_OUT")
    return g
end

---Plays or stops a pulse by the animation chosen.
function ns.SetPulse(group, on)
    if not group then return end
    if on then
        if not group:IsPlaying() then group:Play() end
    else
        group:Stop()
    end
end

-- Who draws again when a colour or an animation changes (each module adds itself).
ns.lookListeners = {}
function ns.OnLookChanged()
    for _, fn in ipairs(ns.lookListeners) do pcall(fn) end
end

-- The stand-in for the player: every call answers nothing. `Log.lua`, development only, swaps it.
ns.Log = setmetatable({ enabled = false }, {
    __index = function() return function() end end,
})

function ns.Print(...)
    print(ns.TITLE .. ":", ...)
end

---True for anything that is there, a secret included: a secret must not be tested for truth.
function ns.Has(v)
    return issecretvalue(v) or v ~= nil
end

---Whether an event is about a nameplate. The token is checked first: it could be a secret.
function ns.IsPlateUnit(unit)
    return type(unit) == "string" and not issecretvalue(unit) and unit:sub(1, 9) == "nameplate"
end

function ns.IsTank()
    local p = ns.db and ns.db.profile
    if p == "tank" then return true end
    if p == "dps" then return false end
    local spec = C_SpecializationInfo.GetSpecialization()
    return spec ~= nil and GetSpecializationRole(spec) == "TANK"
end

--------------------------------------------------------------------------------
-- Events: every module listens through `ns.On`. Nothing here polls out of combat.
--------------------------------------------------------------------------------
local listeners = {}
local frame = CreateFrame("Frame")

function ns.On(event, fn)
    if not listeners[event] then
        listeners[event] = {}
        frame:RegisterEvent(event)
    end
    table.insert(listeners[event], fn)
end

frame:SetScript("OnEvent", function(_, event, ...)
    local list = listeners[event]
    for i = 1, #list do
        list[i](...)
    end
end)

-- Only in combat, and only for what events do not announce: a cooldown coming back and a threat
-- change the game did not report.
local ticker
ns.ticks = {}

local function Tick()
    for i = 1, #ns.ticks do
        ns.ticks[i]()
    end
end

ns.On("PLAYER_REGEN_DISABLED", function()
    if not ticker then ticker = C_Timer.NewTicker(0.25, Tick) end
end)

ns.On("PLAYER_REGEN_ENABLED", function()
    if ticker then
        ticker:Cancel()
        ticker = nil
    end
    Tick()
end)

ns.On("ADDON_LOADED", function(addon)
    if addon ~= ADDON then return end
    RocketRadarDB = RocketRadarDB or {}
    for k, v in pairs(ns.defaults) do
        if RocketRadarDB[k] == nil then RocketRadarDB[k] = v end
    end
    ns.db = RocketRadarDB
    ns.db.minimap = type(ns.db.minimap) == "table" and ns.db.minimap or {}   -- the button's angle (Minimap.lua)
    if ns.Log.Start then ns.Log.Start() end
end)

function RocketRadar_OnCompartmentClick()
    ns.ToggleWindow()
end
