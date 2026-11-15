-- RocketRadar | Commands.lua
local ADDON, ns = ...

SLASH_ROCKETRADAR1 = "/rr"

SlashCmdList["ROCKETRADAR"] = function(msg)
    msg = (msg or ""):lower()
    if msg:match("^%s*test") then
        ns.Cards.Test()
        if ns.CastTarget then ns.CastTarget.Test() end  -- the cast's icon to the right of your party frame
    elseif msg:match("^%s*party") and ns.Party then
        ns.Party.Status()
    else
        ns.ToggleWindow()
    end
end
