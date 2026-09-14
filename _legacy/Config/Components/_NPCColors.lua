local NPCColors = SUI:NewModule('Config.Components.NPCColors');

local function buildWindow()
    -- Load Libs
    local SUIConfig = LibStub('SUIConfig')
    local npcInfo = LibStub('LibNPCInfo')

    -- Set Layout
    SUIConfig.config = {
        font = {
            family    = STANDARD_TEXT_FONT,
            size      = 12,
            titleSize = 16,
            effect    = 'NONE',
            strata    = 'OVERLAY',
            color     = {
                normal   = { r = 1, g = 1, b = 1, a = 1 },
                disabled = { r = 1, g = 1, b = 1, a = 1 },
                header   = { r = 1, g = 0.9, b = 0, a = 1 },
            }
        },
        backdrop = {
            texture        = [[Interface\Buttons\WHITE8X8]],
            highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
            panel          = { r = 0.065, g = 0.065, b = 0.065, a = 0.95 },
            slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
            checkbox       = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
            dropdown       = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
            button         = { r = 0.055, g = 0.055, b = 0.055, a = 1 },
            buttonDisabled = { r = 0, g = 0.55, b = 1, a = 0.5 },
            border         = { r = 0.01, g = 0.01, b = 0.01, a = 1 },
            borderDisabled = { r = 0, g = 0.50, b = 1, a = 1 },
        },
        progressBar = {
            color = { r = 1, g = 0.9, b = 0, a = 0.5 },
        },
        highlight = {
            color = { r = 0, g = 0.55, b = 1, a = 0.5 },
            blank = { r = 0, g = 0, b = 0 }
        },
        dialog = {
            width  = 400,
            height = 100,
            button = {
                width  = 100,
                height = 20,
                margin = 5
            }
        },
        tooltip = {
            padding = 10
        }
    }

    -- Read Data
    local data = SUI.db.profile.nameplates.npccolors

    -- Create Window
    local window = SUIConfig:Window(UIParent, 500, 385, 'NPC Colors')
    window:SetPoint('CENTER')
    window:SetFrameStrata('DIALOG');

    -- Table Columns
    local cols = {
        {
            name   = 'NPC Name',
            width  = 200,
            align  = 'LEFT',
            index  = 'name',
            format = 'string'
        },
        {
            name   = 'NPC ID',
            width  = 75,
            align  = 'LEFT',
            index  = 'id',
            format = 'string'
        },
        {
            name   = 'Color',
            width  = 75,
            align  = 'LEFT',
            index  = 'color',
            format = 'color',
            events = {
                OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                    SUIConfig:ColorPickerFrame(
                        rowData.color.r,
                        rowData.color.g,
                        rowData.color.b,
                        rowData.color.a,
                        function(cpf)
                            rowData.color = cpf:GetColor()
                            table:SetData(data)
                            SUI_NPCColors[rowData.id] = cpf:GetColor()
                        end,
                        function() end,
                        nil,
                        function() end
                    );
                end
            }
        },
        {
            name = 'Delete',
            width = 75,
            align = 'LEFT',
            index = 'delete',
            format = 'delete',
            events = {
                OnClick = function(self, cellFrame, rowFrame, rowData, columnData, rowIndex)
                    -- Remove entry
                    table.remove(data, rowIndex)
                    self:SetData(data)
                    SUI_NPCColors[rowData.id] = nil

                    -- Print feedback to the user
                    print('|cffea00ffS|r|cff00a2ffUI|r: \'' ..
                        rowData.name .. '\' (ID: ' .. rowData.id .. ') has been removed.')
                end
            }
        }
    }

    -- Create Table
    local dataTable = SUIConfig:ScrollTable(window, cols, 14, 14)
    dataTable:EnableSelection(true);
    SUIConfig:GlueTop(dataTable, window, 0, -60)

    -- Set Table Data
    dataTable:SetData(data)

    -- Search Box
    local searchBox = SUIConfig:SearchEditBox(window, 458, 24, 'Search')
    SUIConfig:GlueBelow(searchBox, window, 0, 100, 'CENTER')

    searchBox:HookScript("OnTextChanged", function(self)
        -- Initiate Results table
        local results = {}

        -- Set Search text into variable
        local text = string.lower(self:GetText())

        if text ~= '' then
            for _, k in ipairs(data) do
                if string.lower(k.name):find(text) then
                    table.insert(results, k)
                end
            end

            dataTable:SetData(results)
        else
            dataTable:SetData(data)
        end
    end)

    -- Add NPC function
    local function addNPC(value)
        local npcID = tonumber(value) -- convert to number as it's necessary

        npcInfo.GetNPCInfoByID(
            npcID,
            function(npc)
                if npc.name then
                    local values = {
                        id = npcID,
                        name = npc.name,
                        color = { r = 0, g = 0.55, b = 1, a = 1 }
                    }

                    -- Check if an entry already exists
                    for _, k in pairs(data) do
                        if k.id == npc.id then
                            -- Print feedback to the user and return
                            print('|cffea00ffS|r|cff00a2ffUI|r: \'' ..
                                npc.name .. '\' (ID: ' .. npc.id .. ') already exists.')

                            return
                        end
                    end

                    -- Insert into table and print feedback to the user
                    table.insert(data, values)
                    SUI_NPCColors[npc.id] = { r = 0, g = 0.55, b = 1, a = 1 }
                    print('|cffea00ffS|r|cff00a2ffUI|r: \'' .. npc.name .. '\' (ID: ' .. npc.id .. ') has been added.')

                    dataTable:SetData(data)
                end
            end,
            function()
                print('|cffea00ffS|r|cff00a2ffUI|r: NPC with ID \'' .. npcID .. '\' does not exist.')
            end
        )
    end

    -- Create Input Field
    local input = SUIConfig:NumericBox(window, 150, 24, nil, function() end)
    SUIConfig:GlueBelow(input, window, 0, 40, 'CENTER')

    input.button:HookScript("OnClick", function(self)
        -- Add NPC
        addNPC(self.editBox:GetText())

        -- Clear Input Field
        self.editBox:SetValue('')
    end)

    input:HookScript("OnEnterPressed", function(self)
        -- Add NPC
        addNPC(self:GetText())

        -- Clear Input Field
        self:SetValue('')
    end)

    -- Input Field Label
    local inputLabel = SUIConfig:Header(window, 'Add NPC by ID', 12)
    SUIConfig:GlueBelow(inputLabel, window, 0, 55, 'CENTER')
end

NPCColors.Show = function(self)
    buildWindow()
end
