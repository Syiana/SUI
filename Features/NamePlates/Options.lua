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
-- Most of the look only applies with the Custom style; those rows are hidden
-- while the Default style is selected, as are the options of a switch that is off.
local ARENA = { Mainline = true, Mists = true, TBC = true }
local RETAIL = { Mainline = true }
local CLASSIC = { Classic = true }

local function get(key)
    return SUI:Get("nameplates." .. key)
end

local function notCustom()
    return get("style") ~= "Custom"
end

-- Hidden while `key` is off (or, with custom = true, also while the style is Default).
local function off(key, custom)
    return function()
        return (custom and notCustom()) or not get(key)
    end
end

local function styleOptions()
    return { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } }
end

local function extend(el, extra)
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function check(key, label, tooltip, order, extra)
    return extend({ key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }, extra)
end

local function slider(key, label, min, max, step, order, tooltip, extra)
    return extend({ key = key, type = "slider", label = label, min = min, max = max, step = step, column = 4, order = order, tooltip = tooltip }, extra)
end

local function color(key, label, order, tooltip, hidden)
    return { key = key, type = "color", label = label, column = 4, order = order, tooltip = tooltip, hidden = hidden }
end

local function header(label, extra)
    return { header = extend({ type = "header", label = label }, extra) }
end

local CUSTOM = { hidden = notCustom }

SUI.Config:RegisterLayout("Nameplates", {
    group = "units",
    order = 30,
    category = "nameplates",
    rows = function()
        local textures = SUI.Media:Options("statusbar")
        local pbOff = function()
            return get("personalbar.style") ~= "Custom"
        end
        return {
            header("Style"),
            {
                style = { key = "style", type = "dropdown", label = "Style", options = styleOptions(), column = 4, order = 1, rebuild = true,
                          tooltip = "Custom enables the SUI look: texture, size, health text, colors, names and castbar." },
                texture = { key = "texture", type = "dropdown", label = "Texture", options = textures, column = 4, order = 2, hidden = notCustom,
                            tooltip = "Health bar texture of the nameplates." },
                height = slider("height", "Height", 1, 5, 0.1, 3, "Vertical scale of the nameplates.", CUSTOM),
            },
            {
                width = slider("width", "Width", 1, 5, 0.1, 1, "Horizontal scale of the nameplates.", CUSTOM),
            },
            header("Health", CUSTOM),
            {
                healthtext = check("healthtext", "Health Text", "Show the health percentage on the nameplate.", 1, { rebuild = true, hidden = notCustom }),
                colors = check("colors", "NPC Colors", "Color the health bars of the NPCs in the NPC color list.", 2, CUSTOM),
                threat = check("threat", "Threat Colors", "Color health bars by threat depending on your group role (tank or damage/healer).", 3, CUSTOM),
            },
            {
                decimals = { key = "decimals", type = "dropdown", label = "Health Text Decimals", column = 4, order = 1, hidden = off("healthtext", true),
                             tooltip = "Decimal places of the health percentage.",
                             options = { { value = 0, text = "0 (e.g. 99%)" }, { value = 1, text = "1 (e.g. 99.9%)" }, { value = 2, text = "2 (e.g. 99.99%)" } } },
                editor = { type = "button", text = "Edit NPC Colors", onClick = openEditor, column = 4, order = 2, hidden = notCustom },
            },
            {
                npctypes = check("npctypes.enabled", "NPC Type Colors", "Color bosses, minibosses and casters.", 1, { rebuild = true, hidden = notCustom }),
                instancesonly = check("npctypes.instancesonly", "Instances Only", "Only use NPC type colors in dungeons and raids.", 2,
                                      { hidden = off("npctypes.enabled", true) }),
            },
            {
                boss = color("npctypes.boss", "Boss", 1, "Health bar color of bosses.", off("npctypes.enabled", true)),
                miniboss = color("npctypes.miniboss", "Miniboss", 2, "Health bar color of minibosses.", off("npctypes.enabled", true)),
                caster = color("npctypes.caster", "Caster", 3, "Health bar color of casters.", off("npctypes.enabled", true)),
            },
            -- Arena numbers work with both styles, the rest needs Custom (and there is no arena on Vanilla).
            header("Names", { clients = ARENA }),
            header("Names", { clients = { Vanilla = true }, hidden = notCustom }),
            {
                color = check("color", "Class Color Names", "Show player names in their class color.", 1, CUSTOM),
                server = check("server", "Hide Server Name", "Hide the server name of players from other realms.", 2, CUSTOM),
                arenanumber = check("arenanumber", "Arena Numbers", "Show the arena number instead of the name on enemy arena players.", 3, { clients = ARENA }),
            },
            header("Castbar", CUSTOM),
            {
                casttime = check("casttime", "Cast Time", "Show the cast time below the cast icon.", 1, CUSTOM),
                castcolors = check("castbar.colors", "Interrupt Colors", "Color castbars while your interrupt is on cooldown or the cast cannot be interrupted.", 2,
                                   { rebuild = true, hidden = notCustom }),
            },
            {
                cooldown = color("castbar.cooldown", "Interrupt on Cooldown", 1, "Castbar color while your interrupt is on cooldown.", off("castbar.colors", true)),
                uninterruptible = color("castbar.uninterruptible", "Not Interruptible", 2, "Castbar color of casts that cannot be interrupted.", off("castbar.colors", true)),
            },
            header("Icons"),
            {
                totemicons = check("totemicons", "Totem Icons", "Show totem icons with their duration above totem nameplates.", 1),
            },
            {
                classicons = check("classicons.enabled", "Class Icons", "Show class icons (arena: specialization icons) on player nameplates.", 1, { rebuild = true }),
                pvponly = check("classicons.pvponly", "PvP Only", "Only show class icons in arenas and battlegrounds.", 2, { hidden = off("classicons.enabled") }),
                classsize = slider("classicons.size", "Class Icon Size", 12, 40, 1, 3, "Size of the class icons.", { hidden = off("classicons.enabled") }),
            },
            {
                healer = check("healer.enabled", "Healer Marker", "Mark healers (group roles and arena specializations).", 1, { rebuild = true }),
                healersize = slider("healer.size", "Healer Marker Size", 12, 40, 1, 2, "Size of the healer marker.", { hidden = off("healer.enabled") }),
            },
            {
                target = check("target.enabled", "Target Indicator", "Show arrows next to your target's nameplate.", 1, { rebuild = true }),
                targetcolor = color("target.color", "Arrow Color", 2, "Color of the target arrows.", off("target.enabled")),
                targetsize = slider("target.size", "Arrow Size", 8, 32, 1, 3, "Size of the target arrows.", { hidden = off("target.enabled") }),
            },
            {
                raidmarker = check("raidmarker.enabled", "Raid Marker", "Change the size and position of the raid marker.", 1, { rebuild = true }),
                anchor = { key = "raidmarker.anchor", type = "dropdown", label = "Raid Marker Position", column = 4, order = 2, hidden = off("raidmarker.enabled"),
                           tooltip = "Side of the health bar the raid marker sits on.",
                           options = { { value = "TOP", text = "Top" }, { value = "LEFT", text = "Left" }, { value = "RIGHT", text = "Right" } } },
                markersize = slider("raidmarker.size", "Raid Marker Size", 12, 48, 1, 3, "Size of the raid marker.", { hidden = off("raidmarker.enabled") }),
            },
            {
                markerx = slider("raidmarker.x", "Raid Marker X", -50, 50, 1, 1, "Horizontal offset of the raid marker.", { hidden = off("raidmarker.enabled") }),
                markery = slider("raidmarker.y", "Raid Marker Y", -50, 50, 1, 2, "Vertical offset of the raid marker.", { hidden = off("raidmarker.enabled") }),
            },
            -- Important auras are retail only; Hide Debuffs needs Custom.
            header("Auras", { clients = RETAIL }),
            header("Auras", { clients = CLASSIC, hidden = notCustom }),
            {
                auras = check("auras.enabled", "Important Auras", "Show crowd control and important buffs next to the health bar.", 1, { clients = RETAIL, rebuild = true }),
                cc = check("auras.cc", "Crowd Control", "Show crowd control on the unit left of the health bar.", 2, { clients = RETAIL, hidden = off("auras.enabled") }),
                important = check("auras.important", "Important Buffs", "Show important buffs of the unit right of the health bar.", 3,
                                  { clients = RETAIL, hidden = off("auras.enabled") }),
            },
            {
                aurasize = slider("auras.size", "Aura Size", 12, 40, 1, 1, "Size of the crowd control and important buff icons.",
                                  { clients = RETAIL, hidden = off("auras.enabled") }),
            },
            {
                debuffs = check("debuffs", "Hide Debuffs", "Hide the debuffs above the nameplates.", 1, CUSTOM),
            },
            header("Behavior", CUSTOM),
            {
                focusHighlight = check("focusHighlight", "Focus Highlight", "Give your focus target's nameplate a different texture.", 1, CUSTOM),
                stackingmode = check("stackingmode", "Smart Stacking", "Stack enemy nameplates instead of letting them overlap.", 2, CUSTOM),
            },
            header("CVars"),
            {
                cvars = check("cvars.enabled", "Nameplate CVars", "Let SUI manage the nameplate settings below (applied after combat).", 1, { rebuild = true }),
                friendlynpcs = check("cvars.friendlynpcs", "Friendly NPCs", "Show nameplates of friendly NPCs.", 2, { hidden = off("cvars.enabled") }),
                onlynames = check("cvars.onlynames", "Only Names (Friendly)", "Show only the name on friendly player nameplates.", 3,
                                  { clients = RETAIL, hidden = off("cvars.enabled") }),
                maxdistance = slider("cvars.maxdistance", "Max Distance", 20, 41, 1, 3, "Distance up to which nameplates are shown.",
                                     { clients = CLASSIC, hidden = off("cvars.enabled") }),
            },
            {
                offscreen = check("cvars.offscreen", "Offscreen Nameplates", "Keep nameplates at the screen edge for units outside the view.", 1,
                                  { clients = RETAIL, hidden = off("cvars.enabled") }),
            },
            header("Personal Resource Bar"),
            {
                pbstyle = { key = "personalbar.style", type = "dropdown", label = "Style", options = styleOptions(), column = 4, order = 1, rebuild = true,
                            tooltip = "Custom resizes and retextures the personal resource bar; switching back needs a reload." },
                pbtexture = { key = "personalbar.texture", type = "dropdown", label = "Texture", options = textures, column = 4, order = 2, hidden = pbOff,
                              tooltip = "Texture of the personal resource bar." },
                pbwidth = slider("personalbar.width", "Width", 50, 200, 1, 3, "Width of the personal resource bar.", { hidden = pbOff }),
            },
            {
                pbheight = slider("personalbar.height", "Health Height", 1, 35, 0.1, 1, "Height of the health bar.", { hidden = pbOff }),
                pbmana = slider("personalbar.manaheight", "Power Height", 1, 35, 0.1, 2, "Height of the power bar.", { hidden = pbOff }),
            },
        }
    end,
})
