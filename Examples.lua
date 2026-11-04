-- RocketRadar | Examples.lua
-- (04/11/2026) THE EXAMPLES AT THE TOP OF EACH TAB of the options window. The user: "no mockup, tem os exemplos das
-- telas, poderia ter uma geral principal o geral, onde tem aquele print mais completo e nas outras de forma mais
-- especifica da um deles, exemplos sempre ajudam melhor a entender como funciona"; he chose them at the top of each tab
-- (preview mockup/PREVIA Rocket Radar - exemplos em cada aba.png).
-- Built LIVE with the game's own pieces (the party frame's health art, the nameplate's bar, the role icon, real spell
-- icons) and ours (the plate's outline, the ring, the corners): no picture of the game is shipped (the rule of the
-- workspace: Blizzard art copied into the package is not allowed). The names of the teammates are made up; the spells,
-- classes, types and their letters are the game's.
local ADDON, ns = ...
local L = ns.L

local Ex = {}
ns.Examples = Ex

local OUTLINE = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\outline"
local SMALL = 26              -- the icons beside the example party frame
local FRAME_W, FRAME_H = 120, 40

local function Text(parent, font, text, r, g, b)
    local t = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    t:SetText(text or "")
    if r then t:SetTextColor(r, g, b) end
    return t
end

local function Spell(id) return C_Spell.GetSpellTexture(id) end

-- The example box: the game's dark list inset behind it, the word "Example" in its corner.
function Ex.Box(parent, x, y, w, h)
    local box = CreateFrame("Frame", nil, parent, "InsetFrameTemplate3")
    box:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    box:SetSize(w, h)
    local tag = Text(box, "GameFontNormalSmall", L["Example"])
    tag:SetPoint("TOPRIGHT", box, "TOPRIGHT", -8, -6)
    return box
end

-- One icon of the right side, as it shows: the spell's icon, the ring in a colour, the corners written by hand here
-- (in the game the engine writes them).
local function RightIcon(parent, size, spell, color, symbol, letters, time, stacks, fill)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(size, size)
    local p = ns.Debuffs.Dress(f, size)
    p.icon:SetTexture(Spell(spell))
    p.ring:SetVertexColor(unpack(color))
    if symbol then p.symbol:SetAtlas(symbol) end
    p.letters:SetText(letters or "")
    if letters and color then p.letters:SetTextColor(unpack(color)) end
    p.time:SetText(time or "")
    p.stacks:SetText(stacks or "")
    -- (04/11) THE SAME SWIPE AS IN THE FIGHT, STOPPED. A hand-made dark band cut the ring with a step at its corner (the
    -- user's print: "um defeito na borda, precisamos ter cuidado para esse tipo de defeito"): the ring's own cooldown
    -- (Debuffs.Dress, the swipe shaped as the ring) set to a point of its time and paused. A cast fills (the dark covers
    -- the time still to come); a debuff empties (the dark covers the time gone).
    Ex.Freeze(p.cd, fill or 0.3, fill == nil)
    p.time:ClearAllPoints()
    if not letters and not symbol then
        p.time:SetFontObject("GameFontNormalLargeOutline")   -- the game has no Highlight one: made white
        p.time:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
        p.time:SetPoint("CENTER", f, "CENTER")
    else
        p.time:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 2, 2)
    end
    return f
end

---A cooldown stopped at `done` of its time (0 to 1): `reverse` darkens the part gone (an aura), else the part to come.
function Ex.Freeze(cd, done, reverse)
    local D = 100
    cd:SetReverse(reverse and true or false)
    cd:SetCooldown(GetTime() - done * D, D)
    if cd.Pause then cd:Pause() end
end

local function TypeColor(kind) return { ns.ColorOf("dispel." .. kind) } end
-- a debuff of the season of that type (Data/AlertSpells.lua, the game's tables); the boss's uses a Bleed's look
local function FirstSpell(kind)
    local list = ns.ALERT_SPELLS and (ns.ALERT_SPELLS[kind] or ns.ALERT_SPELLS.Bleed)
    if not list then return nil end
    -- (04/11) the one with the shortest name in the player's language: the examples' cast bars and alert lines have a
    -- fixed room, and a long name came out cut ("Arremessar Ma...", the user's print)
    local best, bestLen
    for _, id in ipairs(list) do
        local name = C_Spell.GetSpellName(id)
        local n = type(name) == "string" and #name or nil
        if n and n > 0 and (not bestLen or n < bestLen) then best, bestLen = id, n end
    end
    return best or list[1]
end

-- One member of the example party: the game's health art in the class colour, the name, the left icons (lit or dark
-- with the sweep) and the right ones.
local function Member(parent, x, y, class, name, spec, lit, right)
    local cc = C_ClassColor.GetClassColor(class)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    frame:SetSize(FRAME_W, FRAME_H)
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetAtlas("raidframe-hp-bg-white")
    bg:SetVertexColor(0.1, 0.1, 0.1)
    local hp = frame:CreateTexture(nil, "ARTWORK")
    hp:SetPoint("TOPLEFT")
    hp:SetPoint("BOTTOMLEFT")
    hp:SetWidth(FRAME_W * 0.85)
    hp:SetAtlas("RaidFrame-Hp-Fill")
    if cc then hp:SetVertexColor(cc:GetRGB()) end
    local n = Text(frame, "GameFontHighlightSmall", name)
    n:SetPoint("CENTER", frame, "CENTER", 0, 0)
    -- the left: the specialization's defensives and bursts, the first ones lit, one recharging
    local list = ns.PARTY_SPECS and ns.PARTY_SPECS[spec] or {}
    local count = math.min(#list, 5)
    for i = 1, count do
        local id = list[i][1]
        local icon = CreateFrame("Frame", nil, parent)
        icon:SetSize(SMALL, SMALL)
        icon:SetPoint("RIGHT", frame, "LEFT", -3 - (count - i) * (SMALL + 1), 0)
        local t = icon:CreateTexture(nil, "ARTWORK")
        t:SetAllPoints()
        t:SetTexture(Spell(id))
        ns.Party.Round(icon, t, SMALL)
        if i == lit then
            local glow = icon:CreateTexture(nil, "OVERLAY")
            glow:SetTexture("Interface\\Buttons\\CheckButtonHilight")
            glow:SetBlendMode("ADD")
            glow:SetAllPoints()
        elseif i == count then
            -- recharging: the game's cooldown, as on your own icons (Party.lua: CooldownFrameTemplate, 1 in), stopped
            local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
            cd:SetPoint("TOPLEFT", t, "TOPLEFT", 1, -1)
            cd:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", -1, 1)
            cd:SetSwipeColor(0, 0, 0, 0.64)
            cd:SetDrawEdge(false)
            cd:SetDrawBling(false)
            cd:SetHideCountdownNumbers(true)
            Ex.Freeze(cd, 0.4, false)
        end
    end
    -- the right: the cast's place (kept even when empty, as in the game), then what I remove, then the boss's
    -- the size of the game: 34 (at 30 the letters "Mag" covered the type's symbol: the user's print)
    local size = ns.Debuffs.SIZE
    local function Put(r, at)
        local ic = RightIcon(parent, size, r.spell, r.color, r.symbol, r.letters, r.time, r.stacks, r.fill)
        ic:SetPoint("LEFT", frame, "RIGHT", at, 0)
    end
    right = right or {}
    if right.cast then Put(right.cast, ns.Debuffs.SIDE) end
    local rx = ns.Debuffs.SIDE + size + ns.Debuffs.GROUP_GAP
    for _, r in ipairs(right.mine or {}) do Put(r, rx) rx = rx + size + 2 end
    if right.mine and #right.mine > 0 then rx = rx + ns.Debuffs.GROUP_GAP - 2 end
    for _, r in ipairs(right.boss or {}) do Put(r, rx) rx = rx + size + 2 end
    return frame
end

local function Party(parent, x, y, rows)
    local you = UnitName("player")
    if type(you) ~= "string" or issecretvalue(you) then you = "Eldriss" end
    local cast = { spell = FirstSpell("Magic"), color = { ns.ColorOf("party.cast") }, time = "1.2", fill = 0.6 }
    -- (04/11) Lumina has one too: the empty place of the cast looked like a missing icon (the user's print)
    local channel = { spell = FirstSpell("Bleed"), color = { ns.ColorOf("party.channel") }, time = "2.6", fill = 0.35 }
    local function Debuff(kind, time, stacks)
        return { spell = FirstSpell(kind), color = TypeColor(kind), symbol = ns.Debuffs.SYMBOL[kind],
            letters = rawget(_G, ns.Debuffs.LETTERS[kind]) or "", time = time, stacks = stacks }
    end
    local boss = { spell = FirstSpell("Bleed"), color = TypeColor("None"), symbol = ns.Debuffs.SKULL, time = "12", stacks = "2" }
    local members = {
        { "WARRIOR", "Thoren", 73, 1, { cast = cast, boss = { boss } } },
        { "PRIEST", "Lumina", 257, 2, { cast = channel, mine = { Debuff("Magic", "14"), Debuff("Curse", "6") } } },
        { "MAGE", you, 63, 0, { cast = cast, mine = { Debuff("Poison", "9", "3") } } },
    }
    local h = 0
    for i = 1, rows do
        local m = members[i]
        Member(parent, x, y - (i - 1) * (FRAME_H + 4), m[1], m[2], m[3], m[4], m[5])
        h = i * (FRAME_H + 4)
    end
    return h
end

-- An alert line as it shows at the top of the screen.
local function AlertLine(parent, x, y, spell, kindText, spellName, who, small)
    local font, size, step = "GameFontNormalLargeOutline", 20, 26
    if small then font, size, step = "GameFontNormalOutline", 16, 20 end
    local icon = parent:CreateTexture(nil, "ARTWORK")
    icon:SetSize(size, size)
    icon:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    icon:SetTexture(Spell(spell))
    local k = Text(parent, font, kindText)
    k:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    local s = Text(parent, font, spellName, HIGHLIGHT_FONT_COLOR:GetRGB())
    s:SetPoint("LEFT", k, "RIGHT", 5, 0)
    if who then
        local w = Text(parent, font, who, HIGHLIGHT_FONT_COLOR:GetRGB())
        w:SetPoint("LEFT", s, "RIGHT", 5, 0)
    end
    return step
end

local function Hex(c) return ("%02x%02x%02x"):format(math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5), math.floor(c[3] * 255 + 0.5)) end

local function Alerts(parent, x, y, small)
    local h = 0
    h = h + AlertLine(parent, x, y - h, FirstSpell("Magic"), L["Cast at you"], C_Spell.GetSpellName(FirstSpell("Magic")) or "", nil, small)
    local cls = C_ClassColor.GetClassColor("PRIEST")
    for _, kind in ipairs({ "Magic", "Poison" }) do
        local name = ns.Alerts.KindName(kind)
        local who = cls and cls:WrapTextInColorCode("Lumina") or "Lumina"
        h = h + AlertLine(parent, x, y - h, FirstSpell(kind), ("|cff%s%s|r"):format(Hex(TypeColor(kind)), name),
            C_Spell.GetSpellName(FirstSpell(kind)) or "", who, small)
    end
    return h
end

-- An enemy plate: the game's bar and background, our outline in a cast's colour; the threat shield beside it.
-- The game's cast bar under the health (NamePlateCastingBarTemplate, Blizzard_NamePlates: background, the art filling,
-- the spark, the icon, the spell's name and the target's on the right; the shield when it cannot be interrupted). The
-- Radar does not draw it: it is the game's, shown here so the example looks like the plate (the user, 04/11: "tá
-- faltando a barra em baixo da vida de cast, só tem a borda").
local function CastBar(bar, cast)
    local cb = CreateFrame("Frame", nil, bar)
    cb:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -2)
    cb:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, -2)
    cb:SetHeight(10)
    local bg = cb:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetAtlas("ui-castingbar-background")
    local fill = cb:CreateTexture(nil, "ARTWORK")
    fill:SetPoint("TOPLEFT")
    fill:SetPoint("BOTTOMLEFT")
    fill:SetWidth(150 * cast.fill)
    fill:SetAtlas(cast.atlas)
    local spark = cb:CreateTexture(nil, "OVERLAY")
    spark:SetAtlas("ui-castingbar-pip")
    spark:SetBlendMode("ADD")
    spark:SetSize(4, 12)
    spark:SetPoint("CENTER", fill, "RIGHT", 0, 0)
    local icon = cb:CreateTexture(nil, "OVERLAY", nil, 1)
    icon:SetSize(12, 12)
    icon:SetPoint("RIGHT", cb, "LEFT", -1, 0)
    if cast.locked then icon:SetAtlas("nameplates-InterruptShield") else icon:SetTexture(Spell(cast.spell)) end
    local text = Text(cb, "SystemFont_NamePlateCastBar", C_Spell.GetSpellName(cast.spell) or "")
    text:SetPoint("LEFT", cb, "LEFT", 3, 0)
    text:SetPoint("RIGHT", cb, "CENTER", 20, 0)
    text:SetJustifyH("LEFT")
    text:SetWordWrap(false)
    local target = Text(cb, "SystemFont_NamePlateCastBar", cast.target or "")
    target:SetPoint("RIGHT", cb, "RIGHT", -3, 0)
    return cb
end

local function Plate(parent, x, y, name, castKey, threat, cast, holder)
    local bar = CreateFrame("Frame", nil, parent)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 12)
    bar:SetSize(150, 12)
    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetAtlas("nameplates-bar-background-white")
    bg:SetVertexColor(0.15, 0.15, 0.15)
    local hp = bar:CreateTexture(nil, "ARTWORK")
    hp:SetPoint("TOPLEFT")
    hp:SetPoint("BOTTOMLEFT")
    hp:SetWidth(150 * 0.8)
    hp:SetAtlas("nameplates-bar-fill")
    hp:SetVertexColor(0.8, 0.1, 0.1)
    local n = Text(parent, "GameFontHighlightSmall", name)
    n:SetPoint("BOTTOM", bar, "TOP", 0, 1)
    if castKey then
        local o = bar:CreateTexture(nil, "OVERLAY")
        o:SetTexture(OUTLINE)
        o:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
        o:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
        o:SetVertexColor(ns.ColorOf(castKey))
    end
    if cast then CastBar(bar, cast) end
    if threat then
        local s = bar:CreateTexture(nil, "OVERLAY")
        s:SetSize(18, 18)
        s:SetPoint("RIGHT", bar, "LEFT", -4, 0)
        s:SetAtlas("ui-lfg-roleicon-tank-micro-groupfinder")
        s:SetDesaturated(true)
        s:SetVertexColor(ns.ColorOf("threat." .. threat))
        if holder then
            local hn = Text(parent, "GameFontHighlightSmallOutline", holder)
            hn:SetPoint("RIGHT", s, "LEFT", -2, 0)
        end
    end
    return bar
end

local function Caption(parent, anchor, text)
    local t = Text(parent, "GameFontHighlightSmall", text)
    t:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    t:SetPoint("LEFT", anchor, "RIGHT", 10, 0)
    t:SetJustifyH("LEFT")
    return t
end

-- Tab General: the complete example. Returns the height used.
function Ex.General(parent, x, y, w)
    -- (04/11) THE LAYOUT OF THE PREVIEW (the user, with the crop of mockup/PREVIA Rocket Radar - geral (portugues).png in
    -- the root: "achei que iria ficar bem semelhante (...) não precisa mostrar 5 jogadores, pode ser 3 e o aviso
    -- abaixo"): on the left the plates and the threat, each told; on the right the party frame with three players and,
    -- under it, the alerts. Captions measured with frizqt__.ttf plus 20%: 306 at most, from 196 to 502.
    -- (04/11) the threat's rows 36 apart: at 30 the plate's name touched the row above (the user's print)
    local h = 436
    local box = Ex.Box(parent, x, y, w, h)
    local magic, bleed = FirstSpell("Magic"), FirstSpell("Bleed")
    local title = Text(box, "GameFontNormal", rawget(_G, "UNIT_NAMEPLATES_SHOW_ENEMIES") or L["Enemy plates"])
    title:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -10)
    local p1 = Plate(box, 40, -34, L["Casting"], "plate.cast", nil,
        { atlas = "ui-castingbar-filling-standard", spell = magic, target = "Lumina", fill = 0.6 })
    Caption(box, p1, L["casting: the outline fills in the cast's colour"])
    local p2 = Plate(box, 40, -80, L["Channelling"], "plate.channel", nil,
        { atlas = "ui-castingbar-filling-channel", spell = bleed, target = "Thoren", fill = 0.4 })
    Caption(box, p2, L["channelling: the game's green art, emptying"])
    local p3 = Plate(box, 40, -126, L["Uninterruptible"], "plate.locked", nil,
        { atlas = "ui-castingbar-uninterruptable", spell = magic, target = "Eldriss", fill = 0.7, locked = true })
    Caption(box, p3, L["uninterruptible: the game's grey (an option)"])
    local p4 = Plate(box, 40, -172, L["Not casting"], nil, nil)
    Caption(box, p4, L["not casting: the game's plate, nothing of ours"])
    -- the threat
    local t1 = Text(box, "GameFontNormal", L["Threat"] .. " — " .. L["Playing a tank"])
    t1:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -208)
    local dk = C_ClassColor.GetClassColor("DEATHKNIGHT")
    local morgrath = dk and dk:WrapTextInColorCode("Morgrath") or "Morgrath"
    local rows = {
        { "safe", nil, L["green: safe with you"] },
        { "risk", nil, L["orange: with you, about to be lost"] },
        { "lost", morgrath, L["red and blinking: loose, with who took it"] },
        { "tank", "Thoren", L["white: with the other tank"] },
    }
    for i, r in ipairs(rows) do
        local p = Plate(box, 90, -192 - i * 36, L["Mob"], nil, r[1], nil, r[2])
        Caption(box, p, r[3])
    end
    local t2 = Text(box, "GameFontNormal", L["Playing damage or healer (in a group)"])
    t2:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -370)
    local pd = Plate(box, 90, -396, L["Mob"], nil, "lost")   -- 12 between the title and the plate's name
    Caption(box, pd, L["red: the mob turned to you"])
    -- the party frame (right), three players
    local px = 530
    local t3 = Text(box, "GameFontNormal", L["Party frame"])
    t3:SetPoint("TOPLEFT", box, "TOPLEFT", px, -10)
    Party(box, px + 140, -32, 3)
    local legend = Text(box, "GameFontHighlightSmall", L["Left: defensives and bursts (lit = on; dark with a sweep = recharging). Right: the cast coming | what you remove | the boss's."])
    legend:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    legend:SetPoint("TOPLEFT", box, "TOPLEFT", px, -170)
    legend:SetWidth(w - px - 14)
    legend:SetJustifyH("LEFT")
    -- the alerts, under the party frame
    local t4 = Text(box, "GameFontNormal", L["Alerts on the screen"])
    t4:SetPoint("TOPLEFT", box, "TOPLEFT", px, -214)
    Alerts(box, px + 8, -236, true)
    return h + 10
end

-- Tab Plates: the four plates, each told.
function Ex.Plates(parent, x, y, w)
    local h = 214
    local box = Ex.Box(parent, x, y, w, h)
    local magic, bleed = FirstSpell("Magic"), FirstSpell("Bleed")
    local p1 = Plate(box, 40, -16, L["Casting"], "plate.cast", nil,
        { atlas = "ui-castingbar-filling-standard", spell = magic, target = "Lumina", fill = 0.6 })
    Caption(box, p1, L["casting: the outline fills in the cast's colour, in front of the other plates"])
    local p2 = Plate(box, 40, -62, L["Channelling"], "plate.channel", nil,
        { atlas = "ui-castingbar-filling-channel", spell = bleed, target = "Thoren", fill = 0.4 })
    Caption(box, p2, L["channelling: the game's green art, emptying"])
    local p3 = Plate(box, 40, -108, L["Uninterruptible"], "plate.locked", nil,
        { atlas = "ui-castingbar-uninterruptable", spell = magic, target = "Eldriss", fill = 0.7, locked = true })
    Caption(box, p3, L["cannot be interrupted: the game's grey (an option, off at first)"])
    local p4 = Plate(box, 40, -154, L["Not casting"], nil, nil)
    Caption(box, p4, L["not casting: the game's plate, nothing of ours"])
    local note = Text(box, "GameFontHighlightSmall", L["The cast bar under the health is the game's own: the Radar only adds the outline."])
    note:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    note:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 12, 8)
    return h + 10
end

-- Tab Threat: the shield beside each plate, for a tank and for damage or healer, in the colours in use.
function Ex.Threat(parent, x, y, w)
    -- (04/11) a plate takes 24 (its name above, its bar): 40 between rows leaves air between one bar and the next
    -- name (at 30 they touched: the user, "na aba de ameaça o texto tbm tá um pouco colado")
    local ROW = 40
    local h = 254
    local box = Ex.Box(parent, x, y, w, h)
    local t1 = Text(box, "GameFontNormal", L["Playing a tank"])
    t1:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -10)
    local dk = C_ClassColor.GetClassColor("DEATHKNIGHT")
    local morgrath = dk and dk:WrapTextInColorCode("Morgrath") or "Morgrath"
    local rows = {
        { "safe", nil, L["green: the mob is with you and safe"] },
        { "risk", nil, L["orange: with you, about to be lost"] },
        { "lost", morgrath, L["red and blinking: loose, with the name of who took it"] },
        { "tank", "Thoren", L["white: with the other tank"] },
    }
    for i, r in ipairs(rows) do
        local p = Plate(box, 130, -30 - (i - 1) * ROW, L["Mob"], nil, r[1], nil, r[2])
        Caption(box, p, r[3])
    end
    local t2 = Text(box, "GameFontNormal", L["Playing damage or healer (in a group)"])
    t2:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -188)
    local p = Plate(box, 130, -216, L["Mob"], nil, "lost")   -- 12 between the title and the plate's name
    Caption(box, p, L["red: the mob turned to you"])
    return h + 10
end

-- Tab Party: the party frame alone, bigger, with what each side is.
function Ex.Party(parent, x, y, w)
    local h = 180
    local box = Ex.Box(parent, x, y, w, h)
    Party(box, 200, -14, 3)
    local a = Text(box, "GameFontHighlightSmall", L["Left: defensives and bursts (lit = on; dark with a sweep = recharging)."])
    a:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 12, 24)
    a:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    local b = Text(box, "GameFontHighlightSmall", L["Right: the cast coming | what you remove | the boss's or the role's."])
    b:SetPoint("BOTTOMLEFT", box, "BOTTOMLEFT", 12, 8)
    b:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    return h + 10
end

-- Tab Debuffs: one icon up close, its four corners told, and the cast's icon filling.
function Ex.Debuffs(parent, x, y, w)
    local h = 130
    local box = Ex.Box(parent, x, y, w, h)
    local big = RightIcon(box, 64, FirstSpell("Bleed"), TypeColor("Bleed"), ns.Debuffs.SYMBOL.Bleed,
        rawget(_G, "DEBUFF_SYMBOL_BLEED") or "Sg", "14", "3")
    big:SetPoint("TOPLEFT", box, "TOPLEFT", 190, -32)
    local function Label(text, point, rel, dx, dy, justify)
        local t = Text(box, "GameFontHighlightSmall", text)
        t:SetPoint(point, big, rel, dx, dy)
        t:SetJustifyH(justify)
        return t
    end
    Label(L["the type's symbol (the game's)"], "RIGHT", "TOPLEFT", -8, -8, "RIGHT")
    Label(L["the stacks (above 1)"], "RIGHT", "BOTTOMLEFT", -8, 8, "RIGHT")
    Label(L["the type's letters (the game's)"], "LEFT", "TOPRIGHT", 8, -8, "LEFT")
    Label(L["the border: the type's colour, emptying"], "LEFT", "RIGHT", 8, 0, "LEFT")
    Label(L["the time left"], "LEFT", "BOTTOMRIGHT", 8, 8, "LEFT")
    local cast = RightIcon(box, 64, FirstSpell("Magic"), { ns.ColorOf("party.cast") }, nil, nil, "1.2", nil, 0.6)
    cast:SetPoint("TOPLEFT", box, "TOPLEFT", math.floor(w * 0.68), -32)
    local c = Text(box, "GameFontHighlightSmall", L["The cast: the border fills, the time in the middle."])
    c:SetPoint("TOP", cast, "BOTTOM", 0, -6)
    return h + 10
end

-- Tab Alerts: the lines as they show at the top of the screen.
function Ex.Alerts(parent, x, y, w)
    local h = 100
    local box = Ex.Box(parent, x, y, w, h)
    Alerts(box, math.floor(w * 0.25), -16)
    return h + 10
end
