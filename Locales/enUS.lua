-- RocketRadar | Locales/enUS.lua
-- The localization base, as in every Rocket addon: this file ALWAYS loads, in any client language. The key is the
-- English text, so a language without a file (or a key without a translation) shows the English. The language's own
-- file loads after this one (ptBR.lua, deDE.lua...) and overrides what it translates. The game's own words (the debuff
-- types, their letters, "General", "Party", "Colour"...) are read straight from the game's globals in the code, in the
-- player's language.
local ADDON, ns = ...

ns.L = ns.L or setmetatable({}, { __index = function(_, key) return key end })
