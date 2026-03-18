local Layout = SUI:NewModule('Config.Layout.FAQ')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Components
    local SUIConfig = LibStub('SUIConfig')

    -- Imports
    local User = SUI:GetModule("Data.User")

    -- Layout
    local function createCopyBox(value)
        return {
            type = 'custom',
            label = value.label,
            column = 4,
            createFunction = function(frame)
                local editBox = SUIConfig:SimpleEditBox(frame, nil, 20, value.text)
                editBox:SetCursorPosition(0)
                editBox:SetScript('OnEditFocusGained', function(self)
                    self:HighlightText()
                end)
                editBox:SetScript('OnMouseUp', function(self)
                    self:SetFocus()
                    self:HighlightText()
                end)
                editBox:SetScript('OnEscapePressed', function(self)
                    self:ClearFocus()
                    self:HighlightText(0, 0)
                end)
                editBox:SetScript('OnTextChanged', function(self)
                    if self:GetText() ~= value.text then
                        self:SetText(value.text)
                    end
                end)
                return editBox
            end
        }
    end

    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Credits'
                }
            },
            {
                team = {
                    type = 'scroll',
                    label = 'Team',
                    scrollChild = function(self)
                        local items = {};
                        local function update(parent, label, data)
                            label.data = data;
                            label:SetText(data.text);
                            SUIConfig:SetObjSize(label, 60, 20);
                            label:SetPoint('RIGHT');
                            label:SetPoint('LEFT');
                            return label;
                        end

                        SUIConfig:ObjectList(self.scrollChild, items, 'Label', update, User.team);
                    end,
                    height = 220,
                    column = 4,
                    order = 1
                },
                special = {
                    type = 'scroll',
                    label = 'Specials',
                    scrollChild = function(self)
                        local items = {};
                        local function update(parent, label, data)
                            label.data = data;
                            label:SetText(data.text);
                            SUIConfig:SetObjSize(label, 60, 20);
                            label:SetPoint('RIGHT');
                            label:SetPoint('LEFT');
                            return label;
                        end

                        SUIConfig:ObjectList(self.scrollChild, items, 'Label', update, User.specials);
                    end,
                    height = 220,
                    column = 4,
                    order = 2
                },
                supporter = {
                    type = 'scroll',
                    label = 'Supporter',
                    scrollChild = function(self)
                        local items = {};
                        local function update(parent, label, data)
                            label.data = data;
                            label:SetText(data.text);
                            SUIConfig:SetObjSize(label, 60, 20);
                            label:SetPoint('RIGHT');
                            label:SetPoint('LEFT');
                            return label;
                        end

                        SUIConfig:ObjectList(self.scrollChild, items, 'Label', update, User.supporter);
                    end,
                    height = 220,
                    column = 4,
                    order = 3
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Help'
                }
            },
            {
                discord = createCopyBox({
                    label = 'Discord',
                    text = 'discord.gg/yBWkxxR'
                }),
                twitch = createCopyBox({
                    label = 'Twitch',
                    text = 'twitch.tv/syiana'
                })
            }
        },
    }
end
