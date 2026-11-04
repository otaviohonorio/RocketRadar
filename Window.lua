-- RocketRadar | Window.lua
-- The options window, in the Rocket design system (Style.lua; 03/11/2026): the game's Options panel layout -- a
-- gold section title over the game's divider, the option's name on the left, its control in a column on the right
-- -- over the body art the user chose. Its height follows the content.
-- (03/11/2026) Three columns, one per place: the general options, the enemy plates and the party frames. The user
-- asked for an on/off, an animation and a colour per kind of mark, on the plate and on the party frame, and for the
-- dispel line; one column would be over 1200 high, taller than the screen at the default scale (wow-ui-design:
-- columns rather than tabs when the options are few enough to be seen at once).
local ADDON, ns = ...
local L = ns.L
local S = ns.Style

local X0 = 22                -- the left margin
local WIDTH = 980            -- (04/11) the widest tab: the debuffs' table, as in the preview
local FULL_W = WIDTH - X0 * 2 - 10
local COL_W = 420            -- the two columns of the General and Party tabs
local COL2 = X0 + COL_W + 24
local NAME = 200             -- from a column's left to its controls (the longest name in ptBR, 178, measured 03/11 with frizqt__.ttf)
local CW = 170               -- the controls' width
-- (04/11) the content starts under the round portrait with the logo, in the top-left corner of every main window of the
-- family (the user: "nossos addons tem o icone na janela principal com o icone redondo no canto superior esquerdo, tem
-- que por em todos"); the portrait reaches about 58 down
local TOP = -62

local window

local function Left() return { x = X0, col = X0 + NAME, width = COL_W } end
local function Right() return { x = COL2, col = COL2 + NAME, width = COL_W } end

local function Section(f, c, y, text) return (S.Section(f, c.x, y, c.width, text)) end

local function Check(f, c, y, key, label, tip, after, default)
    return (S.Check(f, c.x, y, c.col, label, tip,
        function()
            if ns.db[key] == nil then return default end
            return ns.db[key]
        end,
        function(v)
            ns.db[key] = v
            if after then after() end
        end))
end

local function Choice(f, c, y, key, label, tip, values, after)
    return (S.Dropdown(f, c.x, y, c.col, CW, label, tip, values,
        function() return ns.db[key] end,
        function(v)
            ns.db[key] = v
            if after then after() end
        end))
end

local function Slider(f, c, y, key, label, tip, min, max, step, default, after)
    return (S.Slider(f, c.x, y, c.col, CW, label, tip, min, max, step, "%d",
        function() return tonumber(ns.db[key]) or default end,
        function(v)
            ns.db[key] = v
            if after then after() end
        end))
end

-- A colour (ns.ColorOf / ns.SetColor): the game's until one is chosen.
local function Color(f, c, y, key, label, text, dx, stay, noLabel)
    return (S.Color(f, c.x, y, c.col, not noLabel and label or nil, {
            title = label,
            text = text,
            click = L["Click: choose a colour"],
            reset = L["Right click: the game's colour"],
        },
        function() return ns.ColorOf(key) end,
        function(r, g, b) ns.SetColor(key, r, g, b) end,
        dx, stay))
end

local function Look() ns.OnLookChanged() end

-- The animations of a cast mark: fill with the cast (the timer of the game's cast bar), full, or full and pulsing.
local CAST_ANIMS = {
    { value = "fill", text = L["Filling"] },
    { value = "solid", text = L["Full"] },
    { value = "pulse", text = L["Pulsing"] },
}
local CAST_ANIM_TIP = L["Filling: the line fills as the cast goes on, like the game's cast bar. Full: the whole line at once. Pulsing: the whole line, breathing."]

-- The three colours of a cast mark, one row each: interruptible cast, channel, cannot be interrupted.
local function CastColors(f, c, y, prefix)
    y = Color(f, c, y, prefix .. ".cast", L["Cast colour"],
        L["A cast that can be interrupted. At first, the game's cast bar art itself."])
    y = Color(f, c, y, prefix .. ".channel", L["Channel colour"],
        L["A channel that can be interrupted. At first, the game's channel art."])
    y = Color(f, c, y, prefix .. ".locked", L["Uninterruptible colour"],
        L["A cast that cannot be interrupted. At first, the game's grey for it."])
    return y
end

-- The game's own option, kept in the game's variable, never in ours (and never changed in combat).
local function Stacking(f, c, y)
    local y2, box = S.Check(f, c.x, y, c.col, L["Spread enemy plates (game option)"],
        L["The game's own setting. Plates push each other apart, so two bars rarely cover one another."],
        function() return C_CVar.GetCVarBitfield("nameplateStackingTypes", Enum.NamePlateStackType.Enemy) end,
        function(v)
            if InCombatLockdown() then
                ns.Print(L["This option cannot change in combat."])
                return
            end
            C_CVar.SetCVarBitfield("nameplateStackingTypes", Enum.NamePlateStackType.Enemy, v)
        end)
    box:HookScript("OnClick", function(self)
        if InCombatLockdown() then self:SetChecked(not self:GetChecked()) end
    end)
    return y2
end

-- (04/11/2026) THREE TABS, FAITHFUL TO THE PREVIEW (the user: "dá para reduzir a janela de configuração e usar abas
-- para reorganizar melhor" and "vai ter mais espaço para ser mais fiel aos mockups com mais explicações para o jogador
-- entender como funciona cada coisa"; the preview mockup/PREVIA Rocket Radar - geral (portugues).png):
--   General             the profile and the threat (left), the enemy plates (right)
--   Party               the left of the party frame (right of the tab: the right of the frame)
--   Debuffs and alerts  the preview's table: on, an example icon, the letters, the type, what it is, who removes it,
--                       the colour, the alert and the sound, cast rows included
-- Under every section, a note in the secondary colour says how the thing works.

-- A note: secondary text (LIGHTGRAY on the white object, the identity's rule), wrapped to the column; returns the next y.
local function Note(f, x, y, width, text)
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint("TOPLEFT", f, "TOPLEFT", x + S.INDENT, y - 2)
    t:SetWidth(width - S.INDENT)
    t:SetJustifyH("LEFT")
    t:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    t:SetText(text)
    -- the drawn height; before the game has drawn it, an estimate by the length (12 per line, ~5.6 points per letter)
    local h = tonumber(t.GetStringHeight and t:GetStringHeight()) or 0
    local guess = math.ceil(#text * 5.6 / (width - S.INDENT)) * 12
    return y - 2 - math.max(h, guess) - 10, t
end

-- (04/11) the example at the top of a tab (Examples.lua): its height, or 0 while the party's files are not loaded
local function Example(f, which)
    if not (ns.Examples and ns.Debuffs and ns.Party and ns.Alerts) then return TOP end
    return TOP - ns.Examples[which](f, X0, TOP, FULL_W)
end

-- (04/11) ONE TAB PER FEATURE, each with its example on top (the user: "a janela agora ficou muito comprida (...)
-- para cada feature uma aba nova, placa e threats, com o exemplo acima como ficou em todas as abas"). The notes are
-- short: the example shows what the words used to tell.

-- Tab "General": the whole addon at a glance, and the profile.
local function GeneralTab(f)
    local refresh = function() ns.Threat.Refresh() end
    local top = Example(f, "General")
    local c = Left()
    local y = Section(f, c, top, L["Profile"])
    -- (04/11) the game's tutorial "?" beside the choice, explaining each one (the user: "no jogar como, pode ter um
    -- icone de ? que explica cada um dos itens, tank, dano e healer")
    local help = CreateFrame("Button", nil, f)
    help:SetSize(22, 22)
    help:SetPoint("TOPLEFT", f, "TOPLEFT", c.col + CW + 6, y - 2)
    help:SetNormalTexture(137083)       -- interface/tutorialframe/tutorialframe-questionmark (wago.tools)
    help:SetHighlightTexture(137083, "ADD")
    help:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip_SetTitle(GameTooltip, L["Play as"])
        GameTooltip_AddHighlightLine(GameTooltip, L["Automatic"])
        GameTooltip_AddNormalLine(GameTooltip, L["Follows your specialization: a tank specialization plays as tank, any other as damage or healer."], true)
        GameTooltip_AddBlankLineToTooltip(GameTooltip)
        GameTooltip_AddHighlightLine(GameTooltip, L["Tank"])
        GameTooltip_AddNormalLine(GameTooltip, L["The shield beside every enemy plate says who holds it: green, safe with you; orange, about to be lost; red and blinking, loose, with the name of who took it; white, with the other tank."], true)
        GameTooltip_AddBlankLineToTooltip(GameTooltip)
        GameTooltip_AddHighlightLine(GameTooltip, L["Damage or healer"])
        GameTooltip_AddNormalLine(GameTooltip, L["The shield shows only when an enemy turns to you (in a group): red, so you step back or use a defensive."], true)
        GameTooltip:Show()
    end)
    help:SetScript("OnLeave", GameTooltip_Hide)
    f.profileHelp = help
    y = Choice(f, c, y, "profile", L["Play as"],
        L["Automatic follows your specialization: a tank spec uses the tank markers."], {
            { value = "auto", text = L["Automatic"] },
            { value = "dps", text = L["Damage or healer"] },
            { value = "tank", text = L["Tank"] },
        }, refresh)
    y = Check(f, c, y, "minimapButton", L["Minimap button"],
        L["The button opens this window with a click. Its tooltip shows who the markers are drawn for."],
        function() if ns.MinimapButton then ns.MinimapButton.SetHidden(not ns.db.minimapButton) end end)
    local r = Right()
    Note(f, r.x, Section(f, r, top, L["The tabs"]) + 4, r.width,
        L["Each tab shows one part, with its example on top: the enemy plates, the threat, the party frame, the debuffs and the alerts."])
    return y
end

-- Tab "Plates": the mark on the enemy plates.
local function PlatesTab(f)
    local top = Example(f, "Plates")
    local c = Left()
    local y = Section(f, c, top, rawget(_G, "UNIT_NAMEPLATES_SHOW_ENEMIES") or L["Enemy plates"])
    y = Check(f, c, y, "kick", L["Mark whoever is casting"],
        L["On every cast that can be interrupted. The outline of the health bar takes the cast's colour and fills up with it, in front of the other plates."], Look)
    y = Choice(f, c, y, "kickFilter", L["Which casts"],
        L["Important: only what the game itself marks as important. In a key the addon cannot read the spell, so it cannot have a list of its own."], {
            { value = "all", text = L["All"] },
            { value = "important", text = L["Important only"] },
        }, Look)
    y = Check(f, c, y, "plateLocked", L["Also the uninterruptible"],
        L["A cast that cannot be interrupted is marked too, in its own colour. Off: only what can be interrupted."], Look)
    y = Choice(f, c, y, "plateAnim", L["Animation"], CAST_ANIM_TIP, CAST_ANIMS, Look)
    local r = Right()
    local y2 = Section(f, r, top, rawget(_G, "COLOR") or L["Colour"])
    y2 = CastColors(f, r, y2, "plate")
    y2 = Stacking(f, r, y2)
    y2 = S.Button(f, r.col, y2, CW, L["Test on my target"],
        L["Shows the mark on the health bar of your current target for a few seconds."],
        function() ns.Cards.Test() end)
    return Note(f, X0, math.min(y, y2), FULL_W, L["Using another nameplate addon? Turn off \"Mark whoever is casting\": the Radar then touches no plate."])
end

-- Tab "Threat": the shield beside each plate.
local function ThreatTab(f)
    local refresh = function() ns.Threat.Refresh() end
    local top = Example(f, "Threat")
    local c = Left()
    local y = Section(f, c, top, L["Threat"])
    y = Check(f, c, y, "threat", L["Show who holds each mob"],
        L["Tank: green is yours and safe, orange is yours about to be lost, red is loose, white is with another tank. Damage and healers: red when a mob turned to you."],
        refresh)
    y = Check(f, c, y, "threatNames", L["Name who holds the mob"],
        L["Beside the marker of a mob you do not hold, in the class colour."], refresh)
    -- (04/11) the colour of each state (the user: "na ameaça, se virar aba, pode ter a paleta de cores para editar a
    -- cor dos estagios"); the game's colours at first, a right click goes back to them
    local r = Right()
    local y2 = Section(f, r, top, rawget(_G, "COLOR") or L["Colour"])
    for _, st in ipairs({ { "safe", L["Safe with you"] }, { "risk", L["About to be lost"] },
                          { "lost", L["Loose (or turned to you)"] }, { "tank", L["With the other tank"] } }) do
        y2 = Color(f, r, y2, "threat." .. st[1], st[2], L["The shield's colour in this state. At first, the game's own."])
    end
    return math.min(y, y2)
end

-- Tab "Party": the left of the game's party frame, and its right.
local function PartyTab(f)
    local apply = function() if ns.Party and ns.Party.Apply then ns.Party.Apply() end end
    local top = Example(f, "Party")
    local c = Left()
    local y = top
    y = Section(f, c, y, L["Party frame: left"])
    y = Check(f, c, y, "party", L["Defensives and bursts"],
        L["Beside each party frame, the major defensives and the burst of each member: lit while active, dark while recharging."], apply)
    y = Check(f, c, y, "partySelf", L["Show mine too"],
        L["Your own icons beside your frame, with the game's exact recharge."], apply)
    y = Slider(f, c, y, "partySize", L["Icon size"], L["How large the icons are."], 20, 40, 2, 30, apply)
    y = Slider(f, c, y, "partyPerRow", L["Icons per row"],
        L["After this many, a new row starts; the block stays centred on the frame."], 3, 10, 1, 6, apply)
    y = S.Button(f, c.col, y, CW, L["Choose the spells"],
        L["Which spells each specialization shows. Everything is checked at first."],
        function() if ns.PartyWindow then ns.PartyWindow.Toggle() end end)
    y = Note(f, c.x, y, c.width, L["Yours use the game's exact recharge. A teammate who deals damage shows up after the inspection, out of combat; a tank and a healer, at once."])
    local y1 = y

    c = Right()
    y = top
    y = Section(f, c, y, L["Party frame: right"])
    y = Choice(f, c, y, "partyAnim", L["Cast animation"], CAST_ANIM_TIP, CAST_ANIMS, Look)
    y = Check(f, c, y, "debuffs", L["Debuffs that come off"],
        L["After the cast, each debuff that can be removed: its own icon, a border in its type's colour that empties with the time left, and in its corners the type's symbol and letters, the time and the stacks. The game itself reads the debuff: it works in a fight and in a key."], Look, true)
    y = Choice(f, c, y, "dispelMode", L["Which debuffs"],
        L["What I can remove: only the types your specialization removes. All: every debuff that has a type, whoever can remove it."], {
            { value = "mine", text = L["What I can remove"] },
            { value = "all", text = L["All"] },
        }, Look)
    y = Note(f, c.x, y, c.width, L["Nothing goes on the game's frame. The cast is exact for you; for the others it is still a test. Types and colours: the \"Debuffs\" tab; warnings: the \"Alerts\" tab."])
    return math.min(y1, y)
end

-- (04/11) THE SAME PURPOSE, THE SAME TEXT, THE SHORTEST (the user: "o texto de quem tira do cast não interrompivel e de
-- chefe poderiam ser iguais, é o mesmo proposito (...) no que é o mais curto possível"): "What to do" is "interrupt"
-- for the casts that can be, "defensive and heal" for what cannot be stopped (the uninterruptible cast, the boss's
-- debuff), "remove" for a debuff with a type.
-- (04/11) TWO TABS, NOT ONE TABLE (the user: "acho melhor separar as penalidades de avisos, essa tela ficou muito
-- poluida"): "Debuffs" says what shows beside the party frame and how (on, example, letters, type, what it is, who
-- removes it, colour); "Alerts" says what warns you at the top of the screen and with which sound.
-- Columns measured with frizqt__.ttf against the longest ptBR text of each, plus 20%: the game draws wider than the
-- measure ("Efeito de maldição", the game's ENCOUNTER_JOURNAL_SECTION_FLAG8, 107, came out cut in a 106 column: the
-- user's print, 04/11). Type 129 of 150; what it is 150 of 176 ("de chefe ou de mecânica"); what to do 100 of 144.
-- Every header has air before the next one: "Ligado" 34 in 46, "Ícone" 27 in 44, "Sigla" 25 in 42.
local P = { on = 0, icon = 46, letters = 90, type = 132, what = 300, who = 482, color = 632, info = 672 }
local A = { icon = 0, type = 34, alert = 196, sound = 322, listen = 462 }
local ALERT_W, SOUND_W = 116, 132
local CAST_KINDS = { cast = true, channel = true, locked = true }

local function Header(f, x, y, dx, text)
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint("BOTTOMLEFT", f, "TOPLEFT", x + dx, y - 16)
    t:SetTextColor(LIGHTGRAY_FONT_COLOR:GetRGB())
    t:SetText(text)
    return t
end

local function Tip(owner, title, text)
    owner:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip_SetTitle(GameTooltip, title)
        if text then GameTooltip_AddNormalLine(GameTooltip, text, true) end
        GameTooltip:Show()
    end)
    owner:SetScript("OnLeave", GameTooltip_Hide)
end

local function Cell(f, x, y, dx, width, font, text)
    local t = f:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    t:SetPoint("LEFT", f, "TOPLEFT", x + dx, y - 13)
    if width then t:SetWidth(width) end
    t:SetJustifyH("LEFT")
    t:SetWordWrap(false)
    t:SetText(text or "")
    return t
end

-- Each row: its kind, the on/off it uses, the colour, the example icon and the texts.
local MOVE_SAMPLE = 1235405   -- Espetossado (Covil de Nalorakk), a slow of the season without a type: the row's icon
local function Rows()
    local rows = {
        { kind = "cast", on = "castMark", color = "party.cast", name = L["Cast"], what = L["an enemy casting"],
          who = L["interrupt"], atlas = "ui-castingbar-filling-standard" },
        { kind = "channel", on = "partyChannel", color = "party.channel", name = L["Channel"], what = L["an enemy channelling"],
          who = L["interrupt"], atlas = "ui-castingbar-filling-channel" },
        { kind = "locked", on = "partyLocked", color = "party.locked", name = L["Uninterruptible"], what = L["cannot be interrupted"],
          who = L["defensive and heal"], atlas = "ui-castingbar-uninterruptable" },
    }
    for _, t in ipairs(ns.DISPEL_TYPES) do
        local spells = ns.ALERT_SPELLS and ns.ALERT_SPELLS[t]
        rows[#rows + 1] = { kind = t, dispel = true, color = "dispel." .. t, name = ns.Alerts.KindName(t),
            letters = rawget(_G, ns.Debuffs.LETTERS[t]) or "", symbol = ns.Debuffs.SYMBOL[t],
            spell = spells and spells[1] }
    end
    -- (04/11) a root or a slow without a dispel type, in light blue (Debuffs.lua, group "Move"); not in the Alerts tab
    rows[#rows + 1] = { kind = "Move", move = true, on = "moveDebuffs", color = "dispel.Move", name = ns.Alerts.KindName("Move"),
        what = L["no dispel type"], who = L["free it"], spell = MOVE_SAMPLE }
    rows[#rows + 1] = { kind = "None", on = "bossDebuffs", color = "dispel.None", name = ns.Alerts.KindName("None"),
        what = L["from a boss or a mechanic"], who = L["defensive and heal"],
        symbol = ns.Debuffs.SKULL }
    return rows
end

local samples = {}   -- what follows the options on both tabs (refreshed on every change)

local function RowOn(row)
    if row.dispel then return not (type(ns.db.dispelOff) == "table" and ns.db.dispelOff[row.kind]) end
    return ns.db[row.on] ~= false
end

local function SetRowOn(row, v)
    if row.dispel then
        ns.db.dispelOff = type(ns.db.dispelOff) == "table" and ns.db.dispelOff or {}
        ns.db.dispelOff[row.kind] = (not v) or nil
    else
        ns.db[row.on] = v
    end
end

local function AlertModes(row)
    local m = { { value = "off", text = L["Off"] }, { value = "me", text = L["On you"] } }
    if not CAST_KINDS[row.kind] then m[3] = { value = "group", text = L["Whole group"] } end
    return m
end

-- The example icon of a row: the icon as it shows, its ring in the colour in use.
local function RowExample(f, x, y, dx, row)
    local holder = CreateFrame("Frame", nil, f)
    holder:SetSize(24, 24)
    holder:SetPoint("LEFT", f, "TOPLEFT", x + dx, y - 13)
    local icon = holder:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    if row.atlas then icon:SetAtlas(row.atlas)
    elseif row.spell then icon:SetTexture(C_Spell.GetSpellTexture(row.spell))
    else icon:SetAtlas(row.symbol) end
    local ring = ns.Debuffs.Ring(holder)
    ring:SetVertexColor(ns.ColorOf(row.color))
    samples[#samples + 1] = { ring = ring, key = row.color }
end

-- (04/11) WHO CAN REMOVE IT: the game's "i" at the end of each debuff row (the user: "no final de cada linha, poderia
-- ter um icone que passando o mouse em cima mostra quais classes podem remover o efeito"). The list is the game's own
-- (Data/Dispellers.lua, tools/radar_dispellers.py: every class spell with a friendly dispel of the type); the tooltip
-- names each class (its colour and icon), and each spell with its icon and, when only some specializations have it,
-- which. The names are the game's, in the client's language.
local HELP_ICON = 616343   -- interface/common/help-i (the game's help plates' "i"; file id from wago.tools)

local function ClassName(file)
    local names = rawget(_G, "LOCALIZED_CLASS_NAMES_MALE")
    return names and names[file] or file
end

-- the class icons of the group finder, by class file (tools/ver_atlas.py --check reads every name)
local CLASS_ATLAS = {
    DEATHKNIGHT = "groupfinder-icon-class-color-deathknight",
    DEMONHUNTER = "groupfinder-icon-class-color-demonhunter",
    DRUID = "groupfinder-icon-class-color-druid",
    EVOKER = "groupfinder-icon-class-color-evoker",
    HUNTER = "groupfinder-icon-class-color-hunter",
    MAGE = "groupfinder-icon-class-color-mage",
    MONK = "groupfinder-icon-class-color-monk",
    PALADIN = "groupfinder-icon-class-color-paladin",
    PRIEST = "groupfinder-icon-class-color-priest",
    ROGUE = "groupfinder-icon-class-color-rogue",
    SHAMAN = "groupfinder-icon-class-color-shaman",
    WARLOCK = "groupfinder-icon-class-color-warlock",
    WARRIOR = "groupfinder-icon-class-color-warrior",
}

local function WhoRemoves(list)
    local order, byClass = {}, {}
    for _, e in ipairs(list) do
        local cls, spell, specs = e[1], e[2], e[3]
        if not byClass[cls] then
            byClass[cls] = {}
            order[#order + 1] = cls
        end
        local name = C_Spell.GetSpellName(spell) or tostring(spell)
        local tex = C_Spell.GetSpellTexture(spell)
        local text = (tex and ("|T%s:14:14:0:0|t "):format(tex) or "") .. name
        if specs and #specs > 0 then
            local sn = {}
            for _, id in ipairs(specs) do
                local _, specName = GetSpecializationInfoByID(id)
                sn[#sn + 1] = specName or tostring(id)
            end
            text = text .. " (" .. table.concat(sn, ", ") .. ")"
        end
        local seen = false
        for _, t in ipairs(byClass[cls]) do if t == text then seen = true end end
        if not seen then table.insert(byClass[cls], text) end
    end
    table.sort(order, function(a, b) return ClassName(a) < ClassName(b) end)
    return order, byClass
end

local function WhoTip(owner, row)
    owner:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip_SetTitle(GameTooltip, row.name)
        if row.kind == "None" then
            GameTooltip_AddNormalLine(GameTooltip, L["No class removes it: a boss's or a mechanic's debuff. Defensive and heal."], true)
        elseif row.move then
            -- (04/11) no dispel takes it off: who frees a teammate, then who frees only themselves (Data/Dispellers.lua)
            for _, ally in ipairs({ true, false }) do
                local list = {}
                for _, e in ipairs(ns.MOVE_REMOVERS or {}) do
                    if e[4] == ally then list[#list + 1] = e end
                end
                local order, byClass = WhoRemoves(list)
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
                GameTooltip_AddNormalLine(GameTooltip, ally and L["Frees a teammate:"] or L["Frees only themselves:"], true)
                for _, cls in ipairs(order) do
                    local cc = C_ClassColor.GetClassColor(cls)
                    local icon = (CreateAtlasMarkup and CLASS_ATLAS[cls]) and CreateAtlasMarkup(CLASS_ATLAS[cls], 14, 14) or ""
                    local name = cc and cc:WrapTextInColorCode(ClassName(cls)) or ClassName(cls)
                    GameTooltip_AddHighlightLine(GameTooltip, icon .. " " .. name .. ": " .. table.concat(byClass[cls], ", "), true)
                end
            end
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            GameTooltip_AddNormalLine(GameTooltip, L["Without the talent, the class does not have the spell. The icon uses the game's crowd control filter: a stun or a fear without a type can show in it too."], true)
        else
            local order, byClass = WhoRemoves(ns.DISPELLERS and ns.DISPELLERS[row.kind] or {})
            if #order == 0 then GameTooltip_AddNormalLine(GameTooltip, L["No class spell in the game's tables removes it."], true) end
            for _, cls in ipairs(order) do
                local cc = C_ClassColor.GetClassColor(cls)
                local icon = (CreateAtlasMarkup and CLASS_ATLAS[cls]) and CreateAtlasMarkup(CLASS_ATLAS[cls], 14, 14) or ""
                local name = cc and cc:WrapTextInColorCode(ClassName(cls)) or ClassName(cls)
                GameTooltip_AddHighlightLine(GameTooltip, icon .. " " .. name, true)
                for _, t in ipairs(byClass[cls]) do GameTooltip_AddNormalLine(GameTooltip, "    " .. t, true) end
            end
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            GameTooltip_AddNormalLine(GameTooltip, L["Without the specialization or the talent, the class does not have the spell."], true)
        end
        GameTooltip:Show()
    end)
    owner:SetScript("OnLeave", GameTooltip_Hide)
end

-- A row of the "Debuffs" tab.
local function DebuffRow(f, x, y, row)
    local boss = row.kind == "None"
    local on = CreateFrame("CheckButton", nil, f, "MinimalCheckboxTemplate")
    on:SetSize(30, 29)
    on:SetPoint("TOPLEFT", f, "TOPLEFT", x + P.on, y + 1)
    on:SetChecked(RowOn(row))
    on:SetScript("OnClick", function(self) SetRowOn(row, self:GetChecked() and true or false) Look() end)
    Tip(on, row.name, L["Whether it shows beside the party frame."])
    samples[#samples + 1] = { check = on, row = row }
    RowExample(f, x, y, P.icon, row)
    if row.symbol and not row.letters then
        local sk = f:CreateTexture(nil, "ARTWORK")
        sk:SetSize(16, 16)
        sk:SetPoint("LEFT", f, "TOPLEFT", x + P.letters, y - 13)
        sk:SetAtlas(row.symbol)
    else
        local lt = Cell(f, x, y, P.letters, 30, "GameFontHighlight", row.letters or "")
        if row.dispel then lt:SetTextColor(ns.ColorOf(row.color)) end
    end
    local name = Cell(f, x, y, P.type, P.what - P.type - 6, "GameFontHighlight", row.name)
    if row.move then
        -- the game's two words: in German and Russian they pass the column on one line (measured 04/11: 214 and 186 of
        -- 162), so this one breaks after the "/" into two
        name:SetWordWrap(true)
        name:SetMaxLines(2)
    end
    local what = Cell(f, x, y, P.what, P.who - P.what - 6, nil, row.what)
    local who = Cell(f, x, y, P.who, P.color - P.who - 6, nil, row.who)
    if row.dispel then samples[#samples + 1] = { what = what, who = who, row = row } end
    Color(f, { x = x, col = x + P.color }, y, row.color, row.name,
        boss and L["The border's colour for it. At first, the game's red for a debuff without a type."]
        or row.move and L["The border's colour for it. At first, a light blue: the game has no colour for it."]
        or row.dispel and L["The border's colour for this type. At first, the game's own colour for it."]
        or L["The border's colour for it. At first, the colour of the game's own cast bar art."], 0, true, true)
    if row.dispel or boss or row.move then
        local info = CreateFrame("Button", nil, f)
        info:SetSize(20, 20)
        info:SetPoint("LEFT", f, "TOPLEFT", x + P.info, y - 13)
        info:SetNormalTexture(HELP_ICON)
        info:SetHighlightTexture(HELP_ICON, "ADD")
        info.row = row
        WhoTip(info, row)
    end
    return y - S.ROW
end

-- A row of the "Alerts" tab.
local function AlertRow(f, x, y, row)
    local boss = row.kind == "None"
    RowExample(f, x, y, A.icon, row)
    Cell(f, x, y, A.type, A.alert - A.type - 6, "GameFontHighlight", row.name)
    local alert = CreateFrame("DropdownButton", nil, f, "WowStyle1DropdownTemplate")
    alert:SetPoint("TOPLEFT", f, "TOPLEFT", x + A.alert, y)
    alert:SetWidth(ALERT_W)
    alert:SetupMenu(function(_, root)
        for _, v in ipairs(AlertModes(row)) do
            root:CreateRadio(v.text, function() return ns.Alerts.Mode(row.kind) == v.value end,
                function() ns.Alerts.SetMode(row.kind, v.value) end)
        end
    end)
    Tip(alert, L["Alert"], CAST_KINDS[row.kind]
        and L["A line at the top of the screen while an enemy casts at you: the spell's icon and name. Only on you: the game tells whom a cast goes to only for you."]
        or L["A line at the top of the screen while the debuff lasts: its icon, its type, the spell and who has it, in the class colour. On you: only when it is on you."])
    samples[#samples + 1] = { alert = alert }
    if CAST_KINDS[row.kind] or boss then
        local none = Cell(f, x, y, A.sound + 4, SOUND_W + 30, nil, CAST_KINDS[row.kind] and L["— (the game does not allow it)"] or L["— (no list of spells)"])
        local hit = CreateFrame("Frame", nil, f)
        hit:SetAllPoints(none)
        Tip(hit, rawget(_G, "SOUND") or L["Sound"], CAST_KINDS[row.kind]
            and L["The game does not let an addon play a sound for a cast at you: what is secret in a fight cannot start a sound."]
            or L["The game plays an alert's sound only for exact spells, and a boss's debuff has no type to list them by: this alert is the text only."])
        return y - S.ROW
    end
    local sound = CreateFrame("DropdownButton", nil, f, "WowStyle1DropdownTemplate")
    sound:SetPoint("TOPLEFT", f, "TOPLEFT", x + A.sound, y)
    sound:SetWidth(SOUND_W)
    sound:SetupMenu(function(_, root)
        if root.SetScrollMode then root:SetScrollMode(360) end
        for _, s in ipairs(ns.ALERT_SOUNDS) do
            root:CreateRadio(s.label, function() return ns.Alerts.Sound(row.kind) == s.key end,
                function() ns.Alerts.SetSound(row.kind, s.key) ns.Alerts.Listen(s.key) end)
        end
    end)
    Tip(sound, rawget(_G, "SOUND") or L["Sound"], L["Played when the debuff lands, on the alert's members. The game plays it only for the season's debuffs of this type that the game's tables list: one missing from them shows its line without the sound."])
    local listen = CreateFrame("Button", nil, f)
    listen:SetSize(24, 24)
    listen:SetPoint("TOPLEFT", f, "TOPLEFT", x + A.listen, y - 1)
    listen:SetNormalAtlas("voicechat-icon-speaker")
    listen:SetHighlightAtlas("voicechat-icon-speaker", "ADD")
    listen:SetScript("OnClick", function() ns.Alerts.Listen(ns.Alerts.Sound(row.kind)) end)
    Tip(listen, L["Listen"])
    return y - S.ROW
end

-- What follows the options: the rings' colours, the boxes, and the "what it is / who removes it" of each type by mode.
local function RefreshSamples()
    local all = ns.db.dispelMode == "all"
    for _, s in ipairs(samples) do
        if s.ring then s.ring:SetVertexColor(ns.ColorOf(s.key)) end
        if s.check then s.check:SetChecked(RowOn(s.row)) end
        if s.what then
            -- the type is in the column before: not repeated here (wow-ui-design, no text cut)
            s.what:SetText(all and L["can be removed"] or L["you can remove it"])
            s.who:SetText(L["remove"])
        end
        if s.alert and s.alert.GenerateMenu then s.alert:GenerateMenu() end
    end
end
table.insert(ns.lookListeners, RefreshSamples)

local CHANNELS = {
    { value = "Master", text = rawget(_G, "MASTER_VOLUME") or "Master" },
    { value = "SFX", text = rawget(_G, "FX_VOLUME") or "SFX" },
    { value = "Dialog", text = rawget(_G, "DIALOG_VOLUME") or "Dialog" },
}

-- Tab "Debuffs": what shows beside the party frame, and how.
local function DebuffsTab(f)
    if not (ns.Alerts and ns.Debuffs) then return TOP end
    local x = X0
    local y = Section(f, { x = x, width = FULL_W }, Example(f, "Debuffs"), L["Beside the party frame"])
    local all = CreateFrame("CheckButton", nil, f, "MinimalCheckboxTemplate")
    all:SetSize(30, 29)
    all:SetPoint("TOPLEFT", f, "TOPLEFT", x + P.on, y + 1)
    all:SetChecked(true)
    Cell(f, x, y, P.on + 34, 140, "GameFontHighlight", L["Turn all on"])
    all:SetScript("OnClick", function(self)
        local v = self:GetChecked() and true or false
        for _, row in ipairs(Rows()) do SetRowOn(row, v) end
        Look()
    end)
    Tip(all, L["Turn all on"], L["Every row of the table, shown or not beside the party frame."])
    y = y - S.ROW - 6
    Header(f, x, y, P.on, L["On"])
    Header(f, x, y, P.icon, L["Icon"])
    Header(f, x, y, P.letters, L["Letters"])
    Header(f, x, y, P.type, rawget(_G, "TYPE") or L["Type"])
    Header(f, x, y, P.what, L["What it is"])
    Header(f, x, y, P.who, L["What to do"])
    Header(f, x, y, P.color - 4, rawget(_G, "COLOR") or L["Colour"])
    y = y - 18
    for _, row in ipairs(Rows()) do y = DebuffRow(f, x, y, row) end
    RefreshSamples()   -- "what it is" and "who removes it" of each type, by the mode in force (they were blank until a change)
    y = Note(f, x, y - 4, FULL_W, L["Colour: a click picks one, a right click goes back to the game's. The symbol and the letters are the game's own."])
    return y
end

-- Tab "Alerts": what warns you at the top of the screen, and the sound.
local function AlertsTab(f)
    if not (ns.Alerts and ns.Debuffs) then return TOP end
    local x = X0
    local y = Section(f, { x = x, width = FULL_W }, Example(f, "Alerts"), L["Alerts on the screen"])
    Cell(f, x, y, 0, A.alert - 6, "GameFontHighlight", L["Alerts: all"])
    Choice(f, { x = x, col = x + A.alert }, y, "__alertsAll", "", L["Sets the alert of every row at once. The casts take \"On you\" (the game tells whom a cast goes to only for you)."], {
        { value = "off", text = L["Off"] }, { value = "me", text = L["On you"] }, { value = "group", text = L["Whole group"] },
    }, function()
        local v = ns.db.__alertsAll
        ns.db.__alertsAll = nil
        for _, row in ipairs(Rows()) do
            if not row.move then ns.Alerts.SetMode(row.kind, (CAST_KINDS[row.kind] and v == "group") and "me" or v) end
        end
        Look()
    end)
    y = y - S.ROW
    Cell(f, x, y, 0, A.alert - 6, "GameFontHighlight", L["Sound channel"])
    Choice(f, { x = x, col = x + A.alert }, y, "alertChannel", "", L["The game's volume the alerts' sounds follow."], CHANNELS,
        function() ns.Alerts.Refresh() end)
    y = y - S.ROW - 6
    Header(f, x, y, A.type, rawget(_G, "TYPE") or L["Type"])
    Header(f, x, y, A.alert, L["Alert"])
    Header(f, x, y, A.sound, rawget(_G, "SOUND") or L["Sound"])
    y = y - 18
    for _, row in ipairs(Rows()) do
        if not row.move then y = AlertRow(f, x, y, row) end   -- the root/slow has no alert (yet): its sound needs a list
    end
    RefreshSamples()
    y = Note(f, x, y - 4, FULL_W, L["The line stays while the debuff lasts. The sound plays only for the season's debuffs the game's tables list. Every alert starts off."])
    return y
end

local function Build()
    local f = CreateFrame("Frame", "RocketRadarWindow", UIParent, "ButtonFrameTemplate")
    f:SetTitle(ns.TITLE)
    if f.SetPortraitToAsset then f:SetPortraitToAsset(ns.LOGO) end   -- the family's round portrait (Rocket Mount, Swap)
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    tinsert(UISpecialFrames, "RocketRadarWindow")

    -- the tabs: one page each, the window as tall as the tallest page
    local tabs = {
        { "general", rawget(_G, "GENERAL") or L["General"], GeneralTab },
        { "plates", L["Plates"], PlatesTab },
        { "threat", L["Threat"], ThreatTab },
        { "party", rawget(_G, "PARTY") or L["Party"], PartyTab },
        { "debuffs", L["Debuffs"], DebuffsTab },
        { "alerts", L["Alerts"], AlertsTab },
    }
    f.pages, f.tabs, f.heights = {}, {}, {}
    local y = 0
    for i, t in ipairs(tabs) do
        local page = CreateFrame("Frame", nil, f)
        page:SetAllPoints(f)
        local yi = t[3](page)
        f.pages[t[1]], f.heights[i] = page, -yi
        y = math.min(y, yi)
        local b = CreateFrame("Button", "RocketRadarWindowTab" .. i, f, "PanelTabButtonTemplate")
        b:SetID(i)
        b:SetText(t[2])
        b:SetScript("OnClick", function() ns.SetWindowTab(t[1]) end)
        if i == 1 then
            b:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 11, 2)
        else
            b:SetPoint("TOPLEFT", f.tabs[i - 1], "TOPRIGHT", 3, 0)
        end
        if PanelTemplates_TabResize then PanelTemplates_TabResize(b, 0) end
        f.tabs[i], b.key = b, t[1]
    end
    if PanelTemplates_SetNumTabs then PanelTemplates_SetNumTabs(f, #f.tabs) end

    f.donate = ns.DonateFooter(f)
    f:SetSize(WIDTH, -y + 8 + ns.DONATE_ROW + 8)
    f.Inset:ClearAllPoints()
    f.Inset:SetPoint("TOPLEFT", 4, -60)
    f.Inset:SetPoint("BOTTOMRIGHT", -6, ns.DONATE_ROW + 2)
    S.Body(f, 1, f.Inset.Bg)
    f:Hide()
    window = f
    ns.SetWindowTab(ns.db.windowTab or "general")
    return f
end

---Shows one tab of the window (the last one opened comes back next time).
function ns.SetWindowTab(key)
    if not window then return end
    if not window.pages[key] then key = "general" end
    for k, page in pairs(window.pages) do page:SetShown(k == key) end
    for i, b in ipairs(window.tabs) do
        if b.key == key and PanelTemplates_SetTab then PanelTemplates_SetTab(window, i) end
    end
    window.tab = key
    ns.db.windowTab = key
end

function ns.ToggleWindow()
    window = window or Build()
    window:SetShown(not window:IsShown())
end

function ns.Window()
    return window
end
