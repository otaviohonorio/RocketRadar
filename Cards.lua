-- RocketRadar | Cards.lua
-- A mark ON the game's own health bar, in front of the whole pile.
--
-- The first version floated a card with icon and name above each plate. Fifteen mobs made it
-- unreadable, and over the cast bar it did not read well either (the user, 01/11). So nothing new
-- takes up room: the shape of the game's white target outline, in the cast's colour, fills up from
-- left to right as the cast goes on, as if it replaced the outline (the user, 02/11). The game's own
-- art could not do it: its line is under a pixel wide on screen, so the colour looked faded and the
-- rounded ends vanished. Textures/outline.tga (tools/gerar_contorno.py) is that shape, solid, with
-- a black edge so the colour stands out; it is drawn black, under the line.
-- The line itself is the game's own cast art (the user chose it, 02/11: "option B"), the same that
-- fills the cast bar, cut to the outline by Textures/outline_mask.tga. Nothing of the game's art is
-- shipped: the mask only cuts it. The art is laid three times so its height runs ACROSS the line,
-- as in the preview: over the top band, over the bottom band, and over the whole frame for the
-- rounded ends. All of them span the same width and run on the same timer, so they fill together.
--
-- WHY IT WORKS THIS WAY. In a key, whether a cast is important or can be interrupted is a secret,
-- and an addon cannot pass a secret to SetFrameStrata, SetFrameLevel, SetShown, SetPoint or
-- SetHeight (the game's API documentation, 12.1.5). So a plate cannot rise only when it matters.
-- It can, however, pass a secret to SetAlphaFromBoolean. Hence: the card ALWAYS sits above every
-- plate, and only its transparency depends on the cast. Frames one inside the other, each gated by
-- one secret: the mark is seen only when they let it through, and nobody read any of them.
-- The gates: the filter of the options, and whether the cast can be interrupted (one layer for each
-- answer, 03/11). Whether the player's own interrupt is ready or in range does not count (the user,
-- 02/11): the mark shows the cast itself.
-- It is parented to the plate and only anchored to the bar: Blizzard's frames stay untouched.
local ADDON, ns = ...
local L = ns.L

local STRATA = "HIGH"
local ART_OUTLINE = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\outline"
local ART_MASK = "Interface\\AddOns\\" .. ADDON .. "\\Textures\\outline_mask"
local ATLAS_CAST = "ui-castingbar-filling-standard"      -- the game's cast bar while it fills
local ATLAS_CHANNEL = "ui-castingbar-filling-channel"
local ATLAS_LOCKED = "ui-castingbar-uninterruptable"     -- the game's grey, for a cast that cannot be interrupted
-- Where the straight top line sits, as fractions of the frame's height (tools/gerar_contorno.py).
local BAND_TOP, BAND_BOTTOM = 0.1307, 0.2614


ns.Cards = {}
local cards = setmetatable({}, { __mode = "k" })  -- plate -> card; plates are reused by the game
local byUnit = {}

-- (03/11/2026) Two layers, one per kind of cast: the cast's colour when it can be interrupted, the game's grey when
-- it cannot (an option, off by default: the plate mark was made for the kick). Each layer has its own black edge
-- and three pieces of art; whether the cast can be interrupted is a secret, so each layer's alpha comes from it.
local function Layer(parent, card)
    local layer = CreateFrame("Frame", nil, parent)
    layer:SetAllPoints()
    local level = layer:GetFrameLevel()
    local function Bar(depth)
        local bar = CreateFrame("StatusBar", nil, layer)
        bar:SetFrameLevel(level + depth)
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        return bar
    end

    -- The black edge, under everything.
    local bar = Bar(1)
    bar:SetAllPoints()
    bar:SetStatusBarTexture(ART_OUTLINE)
    -- NEAREST keeps the edges hard: the default filter blurs a line this thin into the background.
    bar:GetStatusBarTexture():SetTexture(ART_OUTLINE, "CLAMP", "CLAMP", "NEAREST")
    bar:GetStatusBarTexture():SetVertexColor(0, 0, 0)
    layer.bar = bar

    -- The cast art: the rounded ends first, then the two straight lines over them.
    local ends, top, bottom = Bar(2), Bar(3), Bar(3)
    ends:SetAllPoints()
    layer.fills = { ends, top, bottom }
    for _, fill in ipairs(layer.fills) do
        local mask = fill:CreateMaskTexture()
        mask:SetTexture(ART_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE", "NEAREST")
        mask:SetAllPoints(card)
        fill.mask = mask
    end
    layer.top, layer.bottom = top, bottom
    return layer
end

local function Build(parent)
    local card = CreateFrame("Frame", nil, parent)

    -- Gate 2, inside gate 1 (the card): the transparency of the two multiplies.
    local gate = CreateFrame("Frame", nil, card)
    gate:SetAllPoints()
    card.gate = gate
    -- The animation's own frame: its alpha is the pulse's, never a secret's.
    local pulse = CreateFrame("Frame", nil, gate)
    pulse:SetAllPoints()
    card.motion, card.motionAnim = pulse, ns.Pulse(pulse)
    card.open = Layer(pulse, card)
    card.locked = Layer(pulse, card)
    return card
end

---Lays the two straight pieces over the top and bottom line. Sizes are plain numbers, never secret.
local function Layout(card, height)
    height = height or card:GetHeight()
    if not height or height <= 0 then return end
    local y, band = BAND_TOP * height, (BAND_BOTTOM - BAND_TOP) * height
    for _, layer in ipairs({ card.open, card.locked }) do
        layer.top:ClearAllPoints()
        layer.top:SetPoint("TOPLEFT", card, "TOPLEFT", 0, -y)
        layer.top:SetPoint("TOPRIGHT", card, "TOPRIGHT", 0, -y)
        layer.top:SetHeight(band)
        layer.bottom:ClearAllPoints()
        layer.bottom:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 0, y)
        layer.bottom:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", 0, y)
        layer.bottom:SetHeight(band)
    end
end

---The game's cast art on every piece of the line, in the colour of `key` (ns.Paint). Setting a texture may hand
---back a new texture object, and a mask belongs to the object: it is put on again whenever the object changed.
local function SetArt(layer, atlas, key)
    for _, fill in ipairs(layer.fills) do
        if layer.atlas ~= atlas then fill:SetStatusBarTexture(atlas) end
        local tex = fill:GetStatusBarTexture()
        if fill.masked ~= tex then
            tex:AddMaskTexture(fill.mask)
            fill.masked = tex
        end
        ns.Paint(tex, key)
    end
    layer.atlas = atlas
end

local function SetTimer(layer, duration, direction)
    layer.bar:SetTimerDuration(duration, Enum.StatusBarInterpolation.Immediate, direction)
    for _, fill in ipairs(layer.fills) do
        fill:SetTimerDuration(duration, Enum.StatusBarInterpolation.Immediate, direction)
    end
end

local function SetFull(layer)
    layer.bar:SetValue(1)
    for _, fill in ipairs(layer.fills) do fill:SetValue(1) end
end

---(03/11) The documentation has no way to stop a bar's timer (SimpleStatusBarAPI: SetTimerDuration, no clear), and
---it does not say that SetValue stops it. So a card that ran a timer gets new layers before it is drawn full.
local function Fresh(card)
    if not card.timed then return end
    for _, layer in ipairs({ card.open, card.locked }) do layer:Hide() end
    card.open, card.locked = Layer(card.motion, card), Layer(card.motion, card)
    card.timed = false
    Layout(card)
end

local function HealthBarOf(plate)
    local unitFrame = plate.UnitFrame
    local holder = unitFrame and unitFrame.HealthBarsContainer
    return holder and holder.healthBar
end

local function CardOf(plate, healthBar)
    local card = cards[plate]
    if not card then
        card = Build(plate)
        -- Always above every plate. Fixed, because no secret may decide it.
        card:SetFrameStrata(STRATA)
        card:SetScript("OnSizeChanged", function(self, _, height) Layout(self, height) end)
        card:Hide()
        cards[plate] = card
    end
    -- The game reuses unit frames between plates, so the anchor is set again every time.
    card:ClearAllPoints()
    card:SetAllPoints(healthBar.selectedBorder or healthBar)
    Layout(card)
    return card
end

local function Hide(unit)
    local card = byUnit[unit]
    if card then
        card:Hide()
        ns.SetPulse(card.motionAnim, false)
        byUnit[unit] = nil
    end
end

---Draws a card for a cast: the art and colour of each layer, the timer or a full line, the pulse.
local function Draw(card, channel, duration)
    local anim = ns.db.plateAnim or "fill"
    local timed = anim == "fill" and duration ~= nil
    if not timed then Fresh(card) end
    SetArt(card.open, channel and ATLAS_CHANNEL or ATLAS_CAST, channel and "plate.channel" or "plate.cast")
    SetArt(card.locked, ATLAS_LOCKED, "plate.locked")
    for _, layer in ipairs({ card.open, card.locked }) do
        if timed then
            SetTimer(layer, duration,
                channel and Enum.StatusBarTimerDirection.RemainingTime or Enum.StatusBarTimerDirection.ElapsedTime)
        else
            SetFull(layer)
        end
    end
    if timed then card.timed = true end
    ns.SetPulse(card.motionAnim, anim == "pulse")
end

local function Update(unit)
    local db = ns.db
    if not db.kick or not UnitCanAttack("player", unit) then return Hide(unit) end
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or plate:IsForbidden() then return Hide(unit) end

    -- `castBarID` is the one field documented as never secret: it says whether there is a cast.
    local channel = false
    local _, text, _, _, _, _, _, locked, spellID, castBarID = UnitCastingInfo(unit)
    if castBarID == nil then
        channel = true
        _, text, _, _, _, _, locked, spellID, _, _, castBarID = UnitChannelInfo(unit)
    end
    if castBarID == nil then return Hide(unit) end

    local healthBar = HealthBarOf(plate)
    if not healthBar then
        ns.Log.Seen("health.bar.missing", true)
        return Hide(unit)
    end
    local card = CardOf(plate, healthBar)
    byUnit[unit] = card

    if not ns.Has(locked) then locked = false end

    if db.kickFilter == "important" and ns.Has(spellID) then
        card:SetAlphaFromBoolean(C_Spell.IsSpellImportant(spellID), 1, 0)
    else
        card:SetAlpha(1)
    end
    card.gate:SetAlpha(1)

    local duration = channel and UnitChannelDuration(unit) or UnitCastingDuration(unit)
    Draw(card, channel, duration)
    -- After Draw: it may have made new layers.
    card.open:SetAlphaFromBoolean(locked, 0, 1)
    if db.plateLocked then
        card.locked:SetAlphaFromBoolean(locked, 1, 0)
    else
        card.locked:SetAlpha(0)
    end
    card:Show()

    if ns.Log.enabled then
        ns.Log.Seen("cast.locked.secret", issecretvalue(locked))
        ns.Log.Seen("cast.spell.secret", issecretvalue(spellID))
        ns.Log.Seen("cast.text.secret", issecretvalue(text))
    end
end

---A bad value must never stop the event: one mark less, not a frozen addon.
function ns.Cards.Update(unit)
    local ok, err = pcall(Update, unit)
    if not ok then
        Hide(unit)
        ns.Log.Error("cards", err)
    end
end

local function OnCast(unit)
    if ns.IsPlateUnit(unit) then ns.Cards.Update(unit) end
end

for _, event in ipairs({
    "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_INTERRUPTED",
    "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_CHANNEL_UPDATE",
    "UNIT_SPELLCAST_DELAYED", "UNIT_SPELLCAST_INTERRUPTIBLE", "UNIT_SPELLCAST_NOT_INTERRUPTIBLE",
}) do
    ns.On(event, OnCast)
end

ns.On("NAME_PLATE_UNIT_ADDED", OnCast)
ns.On("NAME_PLATE_UNIT_REMOVED", function(unit)
    if not issecretvalue(unit) then Hide(unit) end
end)

-- A colour or an animation changed in the options: the marks on screen are drawn again.
table.insert(ns.lookListeners, function()
    for unit in pairs(byUnit) do ns.Cards.Update(unit) end
end)

-- Development only: what the game says it drew, so "nothing shows" gets an answer from the diary.
local function Measure(name, call)
    local ok, a, b = pcall(call)
    if not ok then return name .. "=error" end
    if issecretvalue(a) or issecretvalue(b) then return name .. "=secret" end
    return name .. "=" .. tostring(a) .. (b ~= nil and "/" .. tostring(b) or "")
end

local function Report(card, healthBar, plate)
    local bar = card.open.bar
    local line = table.concat({
        Measure("barSize", function() return healthBar:GetSize() end),
        Measure("barSeen", function() return healthBar:IsVisible() end),
        Measure("cardSize", function() return card:GetSize() end),
        Measure("cardSeen", function() return card:IsVisible() end),
        Measure("alpha", function() return card:GetEffectiveAlpha(), bar:GetEffectiveAlpha() end),
        Measure("layer", function() return card:GetFrameStrata(), card:GetFrameLevel() end),
        Measure("plateLayer", function() return plate:GetFrameStrata(), plate:GetFrameLevel() end),
        Measure("lineLayer", function() return bar:GetFrameStrata(), bar:GetFrameLevel() end),
        Measure("lineSize", function() return bar:GetSize() end),
        Measure("fill", function() return card.open.top:GetStatusBarTexture():GetAtlas() end),
        Measure("topSize", function() return card.open.top:GetSize() end),
        Measure("masks", function() return card.open.top:GetStatusBarTexture():GetNumMaskTextures() end),
    }, " ")
    ns.Print(line)
    ns.Log.Seen("test.report", line)
end

---Shows the mark on the current target for a few seconds, to see it in place outside a fight: the cast's colour, in
---the animation chosen (a full line for "fill": a test has no cast to follow).
function ns.Cards.Test()
    local plate = C_NamePlate.GetNamePlateForUnit("target")
    if not plate or plate:IsForbidden() then
        ns.Print(L["Target an enemy with a visible nameplate first."])
        return
    end
    local healthBar = HealthBarOf(plate)
    if not healthBar then return end
    local card = CardOf(plate, healthBar)
    card:SetAlpha(1)
    card.gate:SetAlpha(1)
    Draw(card, false, nil)
    card.open:SetAlpha(1)
    card.locked:SetAlpha(0)
    card:Show()
    if ns.Log.enabled then Report(card, healthBar, plate) end
    C_Timer.After(6, function()
        for _, live in pairs(byUnit) do
            if live == card then return end   -- a real cast took the mark meanwhile
        end
        card:Hide()
        ns.SetPulse(card.motionAnim, false)
    end)
end
