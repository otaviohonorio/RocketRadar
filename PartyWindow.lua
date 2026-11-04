-- RocketRadar | PartyWindow.lua
-- "Spells of the group": which spells each specialization shows beside the party frames. One class at a time (the
-- game's class list), one column per specialization, every spell with its icon (user, 25/10: an icon beside every
-- spell named) and a box; everything checked at first (user, 02/11: "lista por classe com tudo marcado"). An
-- unchecked box is kept in RocketRadarDB.partyOff, per specialization, and the icons are made again at once (out of
-- combat). In the package with the icons it configures (04/11).
local ADDON, ns = ...
local L = ns.L

local PW = {}
ns.PartyWindow = PW

local COL_W, COL_GAP, MARGIN = 200, 14, 20
local ROW_H, CHECK, ICON = 28, 26, 18
local TOP = 70          -- below the title bar and the class dropdown
local window, classIndex
local columns = {}


-- The specializations of every class, from the game (GetSpecializationInfoByID gives the class of a spec).
local function SpecsOf(classFile)
    local out = {}
    for spec in pairs(ns.PARTY_SPECS or {}) do
        local _, _, _, _, _, file = GetSpecializationInfoByID(spec)
        if file == classFile then out[#out + 1] = spec end
    end
    table.sort(out)
    return out
end

local function Classes()
    local out = {}
    for i = 1, GetNumClasses() do
        local name, file = GetClassInfo(i)
        if file and #SpecsOf(file) > 0 then out[#out + 1] = { name = name, file = file } end
    end
    return out
end

-- The spell as the icons show it (the talent that replaces it, for that specialization).
local function Face(id, spec)
    local sp = ns.PARTY_SPELLS[id]
    if sp and sp.show then
        if not sp.showSpecs then return sp.show end
        for _, s in ipairs(sp.showSpecs) do if s == spec then return sp.show end end
    end
    return id
end

local function Off()
    ns.db.partyOff = type(ns.db.partyOff) == "table" and ns.db.partyOff or {}
    return ns.db.partyOff
end

local function Row(col, i)
    local r = col.rows[i]
    if r then return r end
    r = CreateFrame("CheckButton", nil, col, "UICheckButtonTemplate")
    r:SetSize(CHECK, CHECK)
    r:SetPoint("TOPLEFT", col, "TOPLEFT", 0, -(30 + (i - 1) * ROW_H))
    r.icon = col:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(ICON, ICON)
    r.icon:SetPoint("LEFT", r, "RIGHT", 2, 0)
    r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    r.name = col:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.name:SetPoint("LEFT", r.icon, "RIGHT", 6, 0)
    r.name:SetWidth(COL_W - CHECK - 2 - ICON - 6)
    r.name:SetJustifyH("LEFT")
    r.name:SetWordWrap(true)
    r.name:SetMaxLines(2)
    r:SetScript("OnClick", function(self)
        Off()[self.key] = (not self:GetChecked()) or nil
        if ns.Party and ns.Party.Apply then ns.Party.Apply() end
    end)
    r:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(self.face)
        GameTooltip:Show()
    end)
    r:SetScript("OnLeave", GameTooltip_Hide)
    col.rows[i] = r
    return r
end

local function Column(i)
    local col = columns[i]
    if col then return col end
    col = CreateFrame("Frame", nil, window)
    col:SetSize(COL_W, 1)
    col:SetPoint("TOPLEFT", window, "TOPLEFT", MARGIN + (i - 1) * (COL_W + COL_GAP), -TOP)
    col.icon = col:CreateTexture(nil, "ARTWORK")
    col.icon:SetSize(22, 22)
    col.icon:SetPoint("TOPLEFT", col, "TOPLEFT", 2, 0)
    col.title = col:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    col.title:SetPoint("LEFT", col.icon, "RIGHT", 6, 0)
    col.title:SetWidth(COL_W - 30)
    col.title:SetJustifyH("LEFT")
    col.rows = {}
    columns[i] = col
    return col
end

function PW.Fill()
    if not window then return end
    local list = Classes()
    local class = list[classIndex] or list[1]
    if not class then return end
    local specs = SpecsOf(class.file)
    local off, tallest = Off(), 0
    for i, spec in ipairs(specs) do
        local col = Column(i)
        col:Show()
        local _, specName, _, specIcon = GetSpecializationInfoByID(spec)
        col.icon:SetTexture(specIcon)
        col.title:SetText(specName)
        local n = 0
        for _, entry in ipairs(ns.PARTY_SPECS[spec]) do
            n = n + 1
            local r = Row(col, n)
            local face = Face(entry[1], spec)
            r.key, r.face = ns.Party.OffKey(spec, entry[1]), face
            r:SetChecked(not off[r.key])
            r.icon:SetTexture(C_Spell.GetSpellTexture(face))
            r.name:SetText(C_Spell.GetSpellName(face) or tostring(face))
            r:Show()
            r.icon:Show()
            r.name:Show()
        end
        for k = n + 1, #col.rows do
            col.rows[k]:Hide()
            col.rows[k].icon:Hide()
            col.rows[k].name:Hide()
        end
        tallest = math.max(tallest, n)
    end
    for i = #specs + 1, #columns do columns[i]:Hide() end
    local width = MARGIN * 2 + #specs * COL_W + (#specs - 1) * COL_GAP
    window:SetSize(math.max(width, 460), TOP + 30 + tallest * ROW_H + 24 + ns.DONATE_ROW)
    window.classButton:GenerateMenu()
end

local function Build()
    local f = CreateFrame("Frame", "RocketRadarPartyWindow", UIParent, "ButtonFrameTemplate")
    ButtonFrameTemplate_HidePortrait(f)
    f:SetTitle(ns.TITLE .. " — " .. L["Spells of the group"])
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    tinsert(UISpecialFrames, "RocketRadarPartyWindow")
    f.Inset:ClearAllPoints()
    f.Inset:SetPoint("TOPLEFT", 4, -26)
    f.Inset:SetPoint("BOTTOMRIGHT", -6, ns.DONATE_ROW + 2)
    f.donate = ns.DonateFooter(f)
    ns.Style.Body(f, 1, f.Inset.Bg)   -- the body art of every Rocket window (Style.lua)

    local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", f, "TOPLEFT", MARGIN, -40)
    label:SetText(CLASS)
    local d = CreateFrame("DropdownButton", nil, f, "WowStyle1DropdownTemplate")
    d:SetPoint("LEFT", label, "RIGHT", 10, 0)
    d:SetWidth(200)
    d:SetupMenu(function(_, root)
        for i, c in ipairs(Classes()) do
            local color = C_ClassColor.GetClassColor(c.file)
            local text = color and color:WrapTextInColorCode(c.name) or c.name
            root:CreateRadio(text, function() return (classIndex or 1) == i end, function()
                classIndex = i
                PW.Fill()
            end)
        end
    end)
    f.classButton = d
    f:Hide()
    return f
end

function PW.Toggle()
    if not window then
        window = Build()
        -- open on the player's own class
        local _, mine = UnitClass("player")
        for i, c in ipairs(Classes()) do if c.file == mine then classIndex = i end end
    end
    if window:IsShown() then
        window:Hide()
    else
        PW.Fill()
        window:Show()
        window:Raise()
    end
end

function PW.__window() return window end
function PW.__columns() return columns end
function PW.SelectClass(i) classIndex = i PW.Fill() end
