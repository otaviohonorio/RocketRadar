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
    elseif msg:match("^%s*shots") and ns.Log.enabled then  -- development only: the automatic screenshots of the party icons
        ns.db.devShots = not ns.db.devShots
        ns.Print(ns.db.devShots and ns.L["Automatic screenshots: on."] or ns.L["Automatic screenshots: off."])
    else
        ns.ToggleWindow()
    end
end
