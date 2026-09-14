--[[
    SUI 2.0 - Features/NamePlates/Options.lua

    The Nameplates tab and the NPC colour editor window (add by NPC id via
    LibNPCInfo, change colour, delete, search). The editor writes the list
    through SUI:Set, so running features pick up changes immediately.
]]

local _, ns = ...
local SUI = ns.SUI

local tinsert, tremove = table.insert, table.remove

-- NPC colour editor -------------------------------------------------------------------
local editor

local function npcList()
    return SUI.db.profile.nameplates.npccolors
end

local function commit()
    SUI:Set("nameplates.npccolors", npcList())
    editor.search:GetScript("OnTextChanged")(editor.search)
end

local function addNPC(value)
    local id = tonumber(value)
    if not id then
        return
    end
    LibStub("LibNPCInfo").GetNPCInfoByID(id, function(npc)
        if not npc.name then
            return
        end
        local list = npcList()
        for i = 1, #list do
            if list[i].id == id then
                SUI:Print(("'%s' (ID: %d) already exists."):format(npc.name, id))
                return
            end
        end
        tinsert(list, { id = id, name = npc.name, color = { r = 0, g = 0.55, b = 1, a = 1 } })
        SUI:Print(("'%s' (ID: %d) has been added."):format(npc.name, id))
        commit()
    end, function()
        SUI:Print(("NPC with ID '%d' does not exist."):format(id))
    end)
end

local function buildEditor()
    local SUIConfig = LibStub("SUIConfig")
    local window = SUIConfig:Window(UIParent, 500, 385, "NPC Colors")
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")

    local columns = {
        { name = "NPC Name", width = 200, align = "LEFT", index = "name", format = "string" },
        { name = "NPC ID", width = 75, align = "LEFT", index = "id", format = "number" },
        {
            name = "Color", width = 75, align = "LEFT", index = "color", format = "color",
            events = {
                OnClick = function(_, _, _, row)
                    local c = row.color
                    SUIConfig:ColorPickerFrame(c.r, c.g, c.b, c.a, function(picker)
                        row.color = picker:GetColor()
                        commit()
                    end, function() end)
                end,
            },
        },
        {
            name = "Delete", width = 75, align = "LEFT", index = "delete", format = "delete",
            events = {
                OnClick = function(_, _, _, row)
                    local list = npcList()
                    for i = #list, 1, -1 do
                        if list[i] == row then
                            tremove(list, i)
                        end
                    end
                    SUI:Print(("'%s' (ID: %d) has been removed."):format(row.name, row.id))
                    commit()
                end,
            },
        },
    }
    local grid = SUIConfig:ScrollTable(window, columns, 14, 14)
    SUIConfig:GlueTop(grid, window, 0, -60)

    local search = SUIConfig:SearchEditBox(window, 458, 24, "Search")
    SUIConfig:GlueBelow(search, window, 0, 100, "CENTER")
    search:HookScript("OnTextChanged", function(box)
        local text = (box:GetText() or ""):lower()
        local list = npcList()
        if text == "" then
            grid:SetData(list)
            return
        end
        local results = {}
        for i = 1, #list do
            if list[i].name:lower():find(text, 1, true) then
                results[#results + 1] = list[i]
            end
        end
        grid:SetData(results)
    end)

    local input = SUIConfig:NumericBox(window, 150, 24)
    SUIConfig:GlueBelow(input, window, 0, 40, "CENTER")
    local function submit()
        addNPC(input:GetText())
        input:SetText("")
    end
    input.button:HookScript("OnClick", submit)
    input:HookScript("OnEnterPressed", submit)

    local label = SUIConfig:Header(window, "Add NPC by ID", 12)
    SUIConfig:GlueBelow(label, window, 0, 55, "CENTER")

    window.search = search
    grid:SetData(npcList())
    return window
end

local function openEditor()
    editor = editor or buildEditor()
    editor.search:SetText("")
    editor.search:GetScript("OnTextChanged")(editor.search)
    editor:SetAlpha(1)
    editor:Show()
end

-- Layout ------------------------------------------------------------------------------
local ARENA = { Mainline = true, Mists = true, TBC = true }
local RETAIL = { Mainline = true }
local CLASSIC = { Classic = true }

local function styleOptions()
    return { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } }
end

local function check(key, label, tooltip, order, clients)
    return { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order, clients = clients }
end

local function slider(key, label, min, max, step, order, clients)
    return { key = key, type = "slider", label = label, min = min, max = max, step = step, column = 4, order = order, clients = clients }
end

local function color(key, label, order)
    return { key = key, type = "color", label = label, column = 4, order = order }
end

local function header(label, clients)
    return { header = { type = "header", label = label, clients = clients } }
end

SUI.Config:RegisterLayout("Nameplates", {
    order = 30,
    category = "nameplates",
    rows = function()
        local textures = SUI.Media:Options("statusbar")
        return {
            header("Nameplates"),
            {
                style = { key = "style", type = "dropdown", label = "Style", options = styleOptions(), column = 4, order = 1,
                          tooltip = "Custom enables the SUI look (texture, texts, castbar, colours, size)" },
                texture = { key = "texture", type = "dropdown", label = "Texture", options = textures, column = 4, order = 2 },
                decimals = { key = "decimals", type = "dropdown", label = "Health Text Decimals", column = 4, order = 3,
                             options = { { value = 0, text = "0 (e.g. 99%)" }, { value = 1, text = "1 (e.g. 99.9%)" }, { value = 2, text = "2 (e.g. 99.99%)" } } },
            },
            {
                height = slider("height", "Height", 1, 5, 0.1, 1),
                width = slider("width", "Width", 1, 5, 0.1, 2),
            },
            header("Options"),
            {
                healthtext = check("healthtext", "Health Text", "Shows the health percentage in the nameplate", 1),
                color = check("color", "Classcolor Playernames", "Show Playernames in their class color", 2),
                server = check("server", "Hide Servername", "Hide servernames entirely on nameplates", 3),
            },
            {
                arenanumber = check("arenanumber", "Arena Nameplate", "Shows Arena number over Nameplate", 1, ARENA),
                totemicons = check("totemicons", "Totem Icons", "Shows Totem icons on Nameplate", 2),
                casttime = check("casttime", "Cast Time", "Show cast time below the cast icon", 3),
            },
            {
                focusHighlight = check("focusHighlight", "Focus Highlight", "Highlight Focus Target (different Texture)", 1),
                debuffs = check("debuffs", "Hide Debuffs", "Hides your own debuffs above of the nameplates", 2),
                stackingmode = check("stackingmode", "Smart Stacking Mode", "Enabled = Smart Stacking Mode / Disabled = Overlapping Nameplates", 3),
            },
            header("Castbar"),
            {
                castcolors = check("castbar.colors", "Interrupt Colors", "Color castbars while your interrupt is on cooldown or the cast cannot be interrupted", 1),
                cooldown = color("castbar.cooldown", "Interrupt on Cooldown", 2),
                uninterruptible = color("castbar.uninterruptible", "Not Interruptible", 3),
            },
            header("Mythic+ Options"),
            {
                colors = check("colors", "NPC Colors", "Enable/Disable NPC Colors for important NPCs", 1),
                threat = check("threat", "Threat Colors", "Color health bars by threat depending on your group role (tank or damage/healer)", 2),
                editor = { type = "button", text = "Change NPC Colors", onClick = openEditor, column = 4, order = 3 },
            },
            {
                npctypes = check("npctypes.enabled", "NPC Type Colors", "Color bosses, minibosses and casters", 1),
                instancesonly = check("npctypes.instancesonly", "Instances Only", "Only use NPC type colors in dungeons and raids", 2),
            },
            {
                boss = color("npctypes.boss", "Boss", 1),
                miniboss = color("npctypes.miniboss", "Miniboss", 2),
                caster = color("npctypes.caster", "Caster", 3),
            },
            header("Icons"),
            {
                classicons = check("classicons.enabled", "Class Icons", "Show class icons (arena: specialization icons) on player nameplates", 1),
                pvponly = check("classicons.pvponly", "PvP Only", "Only show class icons in arenas and battlegrounds", 2),
                classsize = slider("classicons.size", "Class Icon Size", 12, 40, 1, 3),
            },
            {
                healer = check("healer.enabled", "Healer Marker", "Mark healers (group roles and arena specializations)", 1),
                healersize = slider("healer.size", "Healer Marker Size", 12, 40, 1, 2),
            },
            {
                target = check("target.enabled", "Target Indicator", "Show arrows next to your target's nameplate", 1),
                targetcolor = color("target.color", "Arrow Color", 2),
                targetsize = slider("target.size", "Arrow Size", 8, 32, 1, 3),
            },
            {
                raidmarker = check("raidmarker.enabled", "Raid Marker", "Change size and position of the raid marker", 1),
                anchor = { key = "raidmarker.anchor", type = "dropdown", label = "Raid Marker Position", column = 4, order = 2,
                           options = { { value = "TOP", text = "Top" }, { value = "LEFT", text = "Left" }, { value = "RIGHT", text = "Right" } } },
                markersize = slider("raidmarker.size", "Raid Marker Size", 12, 48, 1, 3),
            },
            {
                markerx = slider("raidmarker.x", "Raid Marker X", -50, 50, 1, 1),
                markery = slider("raidmarker.y", "Raid Marker Y", -50, 50, 1, 2),
            },
            header("Auras", RETAIL),
            {
                auras = check("auras.enabled", "Important Auras", "Show crowd control and important buffs next to the health bar", 1, RETAIL),
                cc = check("auras.cc", "Crowd Control", "Crowd control on the unit, left of the health bar", 2, RETAIL),
                important = check("auras.important", "Important Buffs", "Important buffs of the unit, right of the health bar", 3, RETAIL),
            },
            {
                aurasize = slider("auras.size", "Aura Size", 12, 40, 1, 1, RETAIL),
            },
            header("CVars"),
            {
                cvars = check("cvars.enabled", "Nameplate CVars", "Let SUI manage the settings below (applied after combat)", 1),
                friendlynpcs = check("cvars.friendlynpcs", "Friendly NPCs", "Show nameplates of friendly NPCs", 2),
                onlynames = check("cvars.onlynames", "Only Names (Friendly)", "Show only the name on friendly player nameplates", 3, RETAIL),
            },
            {
                offscreen = check("cvars.offscreen", "Offscreen Nameplates", "Keep nameplates at the screen edge for units outside the view", 1, RETAIL),
                maxdistance = slider("cvars.maxdistance", "Max Distance", 20, 41, 1, 1, CLASSIC),
            },
            header("Personal Resource Bar"),
            {
                pbstyle = { key = "personalbar.style", type = "dropdown", label = "Style", options = styleOptions(), column = 4, order = 1 },
                pbtexture = { key = "personalbar.texture", type = "dropdown", label = "Texture", options = textures, column = 4, order = 2 },
            },
            {
                pbwidth = slider("personalbar.width", "Personal Nameplate Width", 50, 200, 1, 1),
                pbheight = slider("personalbar.height", "Personal Height", 1, 35, 0.1, 2),
                pbmana = slider("personalbar.manaheight", "Mana Height", 1, 35, 0.1, 3),
            },
        }
    end,
})
