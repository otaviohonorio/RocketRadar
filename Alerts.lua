-- RocketRadar | Alerts.lua
-- (04/11/2026) ALERTS WITH TEXT AND SOUND, per type of debuff (the user, 03/11: "quero poder colocar avisos,
-- para cada icone com som e um aviso escrito (...) por padrão todos avisos são desabilitados"). Each type
-- (Magic, Curse, Poison, Disease, Bleed, and the boss's or role's debuff) has its alert: Off (the default), On you
-- only, or the Whole group; and its sound (a spoken word, or one of the game's sounds: Data/Sounds.lua).
--
-- THE TEXT. A line at the top of the screen per member who carries one: the debuff's icon, its type in its colour,
-- the spell's name and the member's name in the class colour. As on the party frames (Debuffs.lua), the ENGINE picks
-- the aura and shows, fills and hides the line: one CustomAuraContainerTemplate per member, two aura groups of one
-- line each (the debuff of a type turned on, and the boss's or role's), the lines laid out by the game's flow layout.
-- The containers are stacked one under the other, so a member without a debuff takes no room. The line stays while
-- the debuff lasts (the engine hides it when the aura goes), not for a fixed few seconds.
--
-- THE SOUND. The game plays a sound for an aura by EXACT spell only (C_UnitAuras.AddAuraSound: unit + spellID; no
-- type, no wildcard; documented in 12.1.5), so each type listens to the season's debuffs of that type the game's own
-- tables list (Data/AlertSpells.lua, tools/radar_alerts.py). A debuff missing from that list shows its line but
-- makes no sound; the boss's debuff has no list (the game gives it no type), so it has the text only. The sounds are
-- registered out of combat (the aura APIs refuse in secret time) and made again when the group or an option changes.
local ADDON, ns = ...
local L = ns.L

local Alerts = {}
ns.Alerts = Alerts

local UNITS = { "player", "party1", "party2", "party3", "party4" }
local LINE_W, LINE_H, ICON = 360, 26, 22
local TOP_Y = -160            -- under the game's own boss banner and objective text
local DISPEL, MOVE, BOSS = "RocketRadarAlert", "RocketRadarAlertMove", "RocketRadarAlertBoss"
-- "None": the boss's or role's debuff; "Move" (04/11): a root or a slow without a dispel type (Debuffs.lua, "Move")
Alerts.KINDS = { "Magic", "Curse", "Poison", "Disease", "Bleed", "Move", "None" }
local SOUND_KINDS = { "Magic", "Curse", "Poison", "Disease", "Bleed", "Move" }   -- the ones with a list of spells
Alerts.MODES = { "off", "me", "group" }

local holder
local records = {}            -- [unit] = { container, buttons = {} }
local soundIDs = {}
local pending = false

local function Secret()
    if not (C_Secrets and C_Secrets.ShouldAurasBeSecret) then return false end
    local ok, yes = pcall(C_Secrets.ShouldAurasBeSecret)
    return ok and yes == true
end

---The alert's mode of a kind: "off" (the default), "me" or "group".
function Alerts.Mode(kind)
    local m = type(ns.db.alerts) == "table" and ns.db.alerts[kind]
    if m == "me" or m == "group" then return m end
    return "off"
end

function Alerts.SetMode(kind, mode)
    ns.db.alerts = type(ns.db.alerts) == "table" and ns.db.alerts or {}
    ns.db.alerts[kind] = mode ~= "off" and mode or nil
    Alerts.Refresh()
end

---The sound of a kind: the player's choice, else the voice of its own type.
function Alerts.Sound(kind)
    local s = type(ns.db.alertSounds) == "table" and ns.db.alertSounds[kind]
    if s and ns.AlertSoundInfo(s) then return s end
    return ns.ALERT_SOUND_DEFAULT[kind]
end

function Alerts.SetSound(kind, key)
    ns.db.alertSounds = type(ns.db.alertSounds) == "table" and ns.db.alertSounds or {}
    ns.db.alertSounds[kind] = key
    Alerts.Refresh()
end

---Plays a sound of the catalogue now (the options' "listen" button), on the alerts' channel.
function Alerts.Listen(key)
    local info = ns.AlertSoundInfo(key)
    if not info then return end
    local channel = ns.db.alertChannel or "Master"
    if info.soundFileName then PlaySoundFile(info.soundFileName, channel) else PlaySoundFile(info.soundFileID, channel) end
end

local function Wanted(kind, unit)
    local m = Alerts.Mode(kind)
    return m == "group" or (m == "me" and unit == "player")
end

-- The type's name in the game's words (the Dungeon Journal's flags), in its colour: "Magic" -> "|cff0081ffMagia|r".
local NAMES = {
    Magic = "ENCOUNTER_JOURNAL_SECTION_FLAG7", Curse = "ENCOUNTER_JOURNAL_SECTION_FLAG8",
    Poison = "ENCOUNTER_JOURNAL_SECTION_FLAG9", Disease = "ENCOUNTER_JOURNAL_SECTION_FLAG10",
    Bleed = "ENCOUNTER_JOURNAL_SECTION_FLAG13",
}
function Alerts.KindName(kind)
    if kind == "None" then return L["Boss or role debuff"] end
    -- (04/11) a root or a slow without a dispel type: the game's own two words (the loss of control's, the options')
    if kind == "Move" then return (rawget(_G, "LOSS_OF_CONTROL_DISPLAY_ROOT") or "Rooted") .. " / " .. (rawget(_G, "SLOW") or "Slow") end
    return rawget(_G, NAMES[kind]) or kind
end

local function Hex(r, g, b)
    return ("%02x%02x%02x"):format(math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

local function TextMap()
    local map = {}
    for _, t in ipairs(ns.DISPEL_TYPES) do
        map[t] = ("|cff%s%s|r"):format(Hex(ns.ColorOf("dispel." .. t)), Alerts.KindName(t))
    end
    return map
end

local function Holder()
    if holder then return holder end
    holder = CreateFrame("Frame", nil, UIParent)
    holder:SetSize(LINE_W, 1)
    holder:SetPoint("TOP", UIParent, "TOP", 0, TOP_Y)
    holder:SetFrameStrata("HIGH")
    return holder
end

-- One line: the icon, then "<type> <spell>" and the member's name under the engine's control.
local function Dress(rec, unit, kind)
    return function(button)
        button:EnableMouse(false)
        if button.SetMouseMotionEnabled then button:SetMouseMotionEnabled(false) end
        local p = {}
        p.icon = button:CreateTexture(nil, "ARTWORK")
        p.icon:SetSize(ICON, ICON)
        p.icon:SetPoint("LEFT", button, "LEFT", 0, 0)
        ns.Party.Round(button, p.icon, ICON)
        p.kind = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
        p.kind:SetPoint("LEFT", p.icon, "RIGHT", 8, 0)
        -- (04/11) the game has no "GameFontHighlightLargeOutline" (the window broke on it): the gold one, made white
        p.spell = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
        p.spell:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
        p.spell:SetPoint("LEFT", p.kind, "RIGHT", 6, 0)
        p.who = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
        p.who:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
        p.who:SetPoint("LEFT", p.spell, "RIGHT", 6, 0)
        button.rr = p
        button.rr.what = kind   -- nil (a dispel type), "move" or "boss"
        rec.buttons[#rec.buttons + 1] = button
    end
end

local function Fill(rec, unit)
    local name = UnitName(unit)
    local _, class = UnitClass(unit)
    local cc = class and C_ClassColor.GetClassColor(class)
    local who = (type(name) == "string" and not issecretvalue(name)) and name or ""
    if cc and who ~= "" then who = cc:WrapTextInColorCode(who) end
    for _, b in ipairs(rec.buttons) do
        local p = b.rr
        p.who:SetText(who)
        pcall(b.SetIcon, b, p.icon)
        pcall(b.SetSpellName, b, p.spell)
        if p.what == "boss" or p.what == "move" then
            local k = p.what == "boss" and "None" or "Move"
            local r, g, bl = ns.ColorOf("dispel." .. k)
            p.kind:SetText(("|cff%s%s|r"):format(Hex(r, g, bl), Alerts.KindName(k)))
            pcall(b.ClearDispelTypeText, b)
        else
            pcall(b.SetDispelTypeText, b, p.kind, { showWhenHarmful = true, showWhenHelpful = false,
                customDispelTextMap = TextMap() })
        end
    end
end

local function Apply(unit)
    local rec = records[unit]
    if not rec then return end
    local c = rec.container
    local on = {}
    local any = false
    for _, t in ipairs(ns.DISPEL_TYPES) do
        if Wanted(t, unit) then
            on[t] = true
            any = true
        end
    end
    local here = UnitExists(unit) and (unit == "player" or IsInGroup())
    pcall(c.SetUnit, c, unit)
    pcall(c.SetAuraGroupFilterString, c, DISPEL, ns.Debuffs.MineFilter())
    pcall(c.SetAuraGroupCandidateFilters, c, DISPEL, { includeDispelTypes = on })
    pcall(c.SetAuraGroupEnabled, c, DISPEL, here and any)
    pcall(c.SetAuraGroupEnabled, c, MOVE, here and Wanted("Move", unit))
    -- the boss's line leaves a crowd control to the root/slow line while that one is on
    local bossFilter = (ns.db.dispelMode == "all" and "HARMFUL|!DISPELLABLE" or "HARMFUL|!RAID")
        .. (Wanted("Move", unit) and "|!CROWD_CONTROL" or "")
    pcall(c.SetAuraGroupFilterString, c, BOSS, bossFilter)
    pcall(c.SetAuraGroupEnabled, c, BOSS, here and Wanted("None", unit))
    Fill(rec, unit)
    pcall(c.UpdateAllAuras, c)
end

local function Build(unit, index)
    local ok, c = pcall(CreateFrame, "AuraContainer", nil, Holder(), "CustomAuraContainerTemplate")
    if not ok or not c then return ns.Log.Error("alerts:create", c) end
    pcall(c.EnableMouse, c, false)
    -- stacked: each container under the one before; an empty one is 0 high and takes no room
    if index == 1 then
        c:SetPoint("TOP", Holder(), "TOP", 0, 0)
    else
        c:SetPoint("TOP", records[UNITS[index - 1]].container, "BOTTOM", 0, 0)
    end
    local rec = { container = c, buttons = {} }
    records[unit] = rec
    local vertical = AnchorUtil and AnchorUtil.FlowLayoutAxis and AnchorUtil.FlowLayoutAxis.Vertical
    if vertical then pcall(c.SetFlowLayoutAxis, c, vertical) end
    local okG, err = pcall(function()
        local layout = { elementWidth = LINE_W, elementHeight = LINE_H }
        c:AddAuraGroup(DISPEL, ns.Debuffs.MineFilter(), { maxFrameCount = 1, candidateFilters = { includeDispelTypes = {} },
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff, initializeFrame = Dress(rec, unit, nil), layout = layout })
        c:AddAuraGroup(MOVE, ns.Debuffs.MOVE_FILTER, { maxFrameCount = 1,
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff, initializeFrame = Dress(rec, unit, "move"), layout = layout })
        c:AddAuraGroup(BOSS, ns.Debuffs.BossFilter(), { maxFrameCount = 1, candidateFilters = { isBossOrRoleAura = true },
            sortMethod = AuraContainerSortMethod.UnitFrameDebuff, initializeFrame = Dress(rec, unit, "boss"), layout = layout })
    end)
    if not okG then
        records[unit] = nil
        return ns.Log.Error("alerts:group", err)
    end
end

-- The sounds: every registration dropped and made again with the options in force.
local function Sounds()
    for _, id in ipairs(soundIDs) do pcall(C_UnitAuras.RemoveAuraSound, id) end
    wipe(soundIDs)
    local trigger = Enum.UnitAuraSoundTrigger and Enum.UnitAuraSoundTrigger.Added
    if trigger == nil or not (C_UnitAuras and C_UnitAuras.AddAuraSound) then return end
    local refused = 0
    for _, kind in ipairs(SOUND_KINDS) do
        local info = ns.AlertSoundInfo(Alerts.Sound(kind))
        for _, unit in ipairs(UNITS) do
            if info and Wanted(kind, unit) and UnitExists(unit) then
                for _, spell in ipairs(ns.ALERT_SPELLS and ns.ALERT_SPELLS[kind] or {}) do
                    local ok, id = pcall(C_UnitAuras.AddAuraSound, trigger, {
                        unitToken = unit, spellID = spell, soundFileName = info.soundFileName,
                        soundFileID = info.soundFileID, outputChannel = ns.db.alertChannel or "Master",
                        throttleSeconds = 2,
                    })
                    if ok and id then soundIDs[#soundIDs + 1] = id else refused = refused + 1 end
                end
            end
        end
    end
    ns.Log.Seen("alerts:sounds", ("%d %d"):format(#soundIDs, refused))
end

---Everything again with the options and the group of now (out of combat and out of secret time; else at the end).
function Alerts.Refresh()
    if Secret() or InCombatLockdown() then
        pending = true
        return
    end
    pending = false
    if not ns.Debuffs.Ready() then return end
    if not next(records) and not Alerts.AnyOn() then return end   -- nothing built while every alert is off
    for i, unit in ipairs(UNITS) do
        if not records[unit] then Build(unit, i) end
        Apply(unit)
    end
    Sounds()
end
table.insert(ns.lookListeners, Alerts.Refresh)

---Whether any alert is on (the window says so beside the table).
function Alerts.AnyOn()
    for _, k in ipairs(Alerts.KINDS) do
        if Alerts.Mode(k) ~= "off" then return true end
    end
    return false
end

ns.On("PLAYER_LOGIN", function() Alerts.Refresh() end)
ns.On("GROUP_ROSTER_UPDATE", function() Alerts.Refresh() end)
ns.On("PLAYER_REGEN_ENABLED", function() if pending then Alerts.Refresh() end end)

function Alerts.__records() return records end
function Alerts.__sounds() return soundIDs end
