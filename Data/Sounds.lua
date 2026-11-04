-- RocketRadar | Data/Sounds.lua
-- (03/11/2026) The sounds of the alerts (the user: "pode incluir todas essas opções ai"): a spoken word per type, in
-- English only (the user: "o som pode ser só em inglês"; for the boss, "Debuff": "no caso do chefe seria penalidade"),
-- and sounds of the game itself, by file id. The engine plays them (C_UnitAuras.AddAuraSound takes a soundFileName or a
-- soundFileID and stops it after five seconds).
-- The voices are files of this addon (Sounds/voice-*.ogg), made with the Windows voice "Zira" (en-US). ⚠ Before the
-- first release: check that the licence of that voice allows shipping its audio (HANDOFF); otherwise replace them.
-- The game's sounds were found by path in the game's file list (wago.tools) and heard by the user (the sons/ folder).
local ADDON, ns = ...

-- (04/11) the names in the player's language: this file loads after Locales/ (the .toc), and each name is written
-- out in full (L with the English text) so tests/locales.lua sees every one of them
local L = ns.L

local VOICE = "Interface\\AddOns\\" .. ADDON .. "\\Sounds\\voice-%s.ogg"

-- `label` is the English text (the key of the translation); `file` is a path, `id` a file of the game.
ns.ALERT_SOUNDS = {
    { key = "voice-dispel", label = L["Voice: \"Dispel\""], file = VOICE:format("dispel") },
    { key = "voice-magic", label = L["Voice: \"Magic\""], file = VOICE:format("magic") },
    { key = "voice-curse", label = L["Voice: \"Curse\""], file = VOICE:format("curse") },
    { key = "voice-poison", label = L["Voice: \"Poison\""], file = VOICE:format("poison") },
    { key = "voice-disease", label = L["Voice: \"Disease\""], file = VOICE:format("disease") },
    { key = "voice-bleed", label = L["Voice: \"Bleed\""], file = VOICE:format("bleed") },
    { key = "voice-debuff", label = L["Voice: \"Debuff\""], file = VOICE:format("debuff") },
    -- general alerts of the game
    { key = "raidwarning", label = L["Raid warning"], id = 567397 },
    { key = "raidbosswarning", label = L["Boss warning"], id = 567394 },
    { key = "readycheck", label = L["Ready check"], id = 567478 },
    { key = "alarm1", label = L["Alarm clock 1"], id = 567436 },
    { key = "alarm2", label = L["Alarm clock 2"], id = 567399 },
    { key = "alarm3", label = L["Alarm clock 3"], id = 567458 },
    { key = "toast", label = L["Battle.net toast"], id = 567402 },
    -- by theme (the game's spell sounds; named by what they sound like, not by a spell)
    { key = "magic1", label = L["Magic: dispel"], id = 568392 },
    { key = "magic2", label = L["Magic: arcane burst"], id = 568678 },
    { key = "magic3", label = L["Magic: arcane charge"], id = 568054 },
    { key = "magic4", label = L["Magic: arcane cast"], id = 5520037 },
    { key = "curse1", label = L["Curse 1"], id = 569079 },
    { key = "curse2", label = L["Curse 2"], id = 567957 },
    { key = "curse3", label = L["Curse: shadow 1"], id = 1488047 },
    { key = "curse4", label = L["Curse: shadow 2"], id = 1488071 },
    { key = "poison1", label = L["Poison 1"], id = 569632 },
    { key = "poison2", label = L["Poison 2"], id = 568950 },
    { key = "poison3", label = L["Poison: spores 1"], id = 569259 },
    { key = "poison4", label = L["Poison: spores 2"], id = 568437 },
    { key = "disease1", label = L["Disease 1"], id = 568208 },
    { key = "disease2", label = L["Disease: plague 1"], id = 568441 },
    { key = "disease3", label = L["Disease: plague 2"], id = 568485 },
    { key = "bleed1", label = L["Bleed 1"], id = 839695 },
    { key = "bleed2", label = L["Bleed 2"], id = 839699 },
    { key = "bleed3", label = L["Bleed 3"], id = 569730 },
    { key = "bleed4", label = L["Bleed 4"], id = 568877 },
    { key = "bossdefeated", label = L["Boss defeated"], id = 1125303 },
    { key = "countdown", label = L["Countdown end"], id = 567438 },
}

-- When an alert is turned on, the sound it starts with: the voice of its own type.
ns.ALERT_SOUND_DEFAULT = {
    Magic = "voice-magic", Curse = "voice-curse", Poison = "voice-poison", Disease = "voice-disease",
    Bleed = "voice-bleed", None = "voice-debuff", Move = "voice-debuff",
}

---The sound fields for C_UnitAuras.AddAuraSound (soundFileName or soundFileID) of a key; nil if unknown.
function ns.AlertSoundInfo(key)
    for _, s in ipairs(ns.ALERT_SOUNDS) do
        if s.key == key then
            if s.file then return { soundFileName = s.file } end
            return { soundFileID = s.id }
        end
    end
end
