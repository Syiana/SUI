local Layout = SUI:NewModule('Config.Layout.Chat')

function Layout:OnEnable()
    local db = SUI.db
    local ChatModule = SUI:GetModule("SUI.Modules.Chat", true)

    local function updateStyleSetting(_, value)
        db.profile.chat.style = value
        if ChatModule and ChatModule:IsEnabled() then
            ChatModule:Disable()
            ChatModule:Enable()
        end
    end

    local function updateEditPosition(_, value)
        db.profile.chat.top = value == "top"
        if ChatModule and ChatModule.UpdateSharedEditBoxPosition then
            ChatModule:UpdateSharedEditBoxPosition()
        end
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateEditBoxPosition then
            ChatModule.Style:UpdateEditBoxPosition()
        end
    end

    local function updateEditAlpha()
        if ChatModule and ChatModule.UpdateSharedEditBoxAlpha then
            ChatModule:UpdateSharedEditBoxAlpha()
        end
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateEditBoxAlpha then
            ChatModule.Style:UpdateEditBoxAlpha()
        end
    end

    local function updateChatAlpha()
        if ChatModule and ChatModule.UpdateSharedChatBackgroundAlpha then
            ChatModule:UpdateSharedChatBackgroundAlpha()
        end
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateChatBackgroundAlpha then
            ChatModule.Style:UpdateChatBackgroundAlpha()
        end
    end

    local function updateEditFont()
        if ChatModule and ChatModule.UpdateSharedEditBoxFont then
            ChatModule:UpdateSharedEditBoxFont()
        end
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateEditBoxFont then
            ChatModule.Style:UpdateEditBoxFont()
        end
    end

    local function updateChatFont()
        if ChatModule and ChatModule.UpdateSharedMessageFonts then
            ChatModule:UpdateSharedMessageFonts()
        end

        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateMessageFonts then
            ChatModule.Style:UpdateMessageFonts()
        end
    end

    local function updateScrollButtons()
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateAllScrollButtons then
            ChatModule.Style:UpdateAllScrollButtons()
        end
    end

    local function updateDockFading()
        if ChatModule and ChatModule.Style and ChatModule.Style.UpdateTabAndButtonFading then
            ChatModule.Style:UpdateTabAndButtonFading(db.profile.chat.settings.dock.fade.enabled)
        end
    end

    local function updateQuickJoinIcon()
        local module = SUI:GetModule("Chat.Quickjoin", true)
        if not module then
            return
        end

        if not module:IsEnabled() then
            module:Enable()
        elseif module.OnEnable then
            module:OnEnable()
        end
    end

    local function updateTooltips()
        if ChatModule and ChatModule.EnableSharedTooltips then
            ChatModule:EnableSharedTooltips()
        end
    end

    local function toggleFeature(moduleName, enabled)
        if not ChatModule then
            return
        end

        local module = SUI:GetModule(moduleName, true)
        if not module then
            return
        end

        if enabled then
            if not module:IsEnabled() then
                module:Enable()
            end
        else
            if module:IsEnabled() then
                module:Disable()
            end
        end
    end

    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.chat,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Chat'
                }
            },
            {
                style = {
                    key = 'style',
                    label = 'Style',
                    type = 'dropdown',
                    options = {
                        { value = 'Default', text = 'Default' },
                        { value = 'Custom', text = 'Custom' },
                        { value = 'Modern', text = 'Modern' }
                    },
                    column = 4,
                    order = 1,
                    onChange = updateStyleSetting
                },
                tooltips = {
                    key = 'settings.tooltips',
                    type = 'checkbox',
                    label = 'Mouseover Tooltips',
                    tooltip = 'Show hyperlink tooltips on mouseover in custom chat',
                    column = 4,
                    order = 2,
                    onChange = updateTooltips
                },
                friendlist = {
                    key = 'friendlist',
                    type = 'checkbox',
                    label = 'Class Friendlist',
                    tooltip = 'Show character names in class color in the friend list',
                    column = 4,
                    order = 3
                }
            },
            {
                quickjoin = {
                    key = 'quickjoin',
                    type = 'checkbox',
                    label = 'Friendlist Icon Mouseover',
                    tooltip = 'Show the friendlist icon only on mouseover',
                    column = 4,
                    order = 1,
                    onChange = updateQuickJoinIcon
                },
                link = {
                    key = 'link',
                    type = 'checkbox',
                    label = 'Link Copy',
                    tooltip = 'Make links clickable to copy them',
                    column = 4,
                    order = 2,
                    onChange = function(_, value)
                        toggleFeature("Chat.Url", value)
                    end
                },
                copy = {
                    key = 'copy',
                    type = 'checkbox',
                    label = 'Copy Button',
                    tooltip = 'Show the copy chat-history button',
                    column = 4,
                    order = 3,
                    onChange = function(_, value)
                        toggleFeature("Chat.Copy", value)
                    end
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Modern Chat'
                }
            },
            {
                editposition = {
                    key = 'settings.edit.position',
                    label = 'Input Position',
                    type = 'dropdown',
                    options = {
                        { value = 'top', text = 'Top' },
                        { value = 'bottom', text = 'Bottom' }
                    },
                    column = 4,
                    order = 1,
                    onChange = updateEditPosition
                },
                editoffset = {
                    key = 'settings.edit.offset',
                    type = 'slider',
                    label = 'Input Offset',
                    min = 0,
                    max = 64,
                    column = 4,
                    order = 2,
                    onChange = updateEditPosition
                },
                editalpha = {
                    key = 'settings.edit.alpha',
                    type = 'slider',
                    label = 'Input Background Alpha',
                    min = 0,
                    max = 1,
                    precision = 1,
                    column = 4,
                    order = 3,
                    onChange = updateEditAlpha
                }
            },
            {
                editfontsize = {
                    key = 'settings.edit.font.size',
                    type = 'slider',
                    label = 'Input Font Size',
                    min = 10,
                    max = 20,
                    column = 4,
                    order = 1,
                    onChange = updateEditFont
                },
                editfontoutline = {
                    key = 'settings.edit.font.outline',
                    type = 'checkbox',
                    label = 'Input Font Outline',
                    column = 4,
                    order = 2,
                    onChange = updateEditFont
                },
                editfontshadow = {
                    key = 'settings.edit.font.shadow',
                    type = 'checkbox',
                    label = 'Input Font Shadow',
                    column = 4,
                    order = 3,
                    onChange = updateEditFont
                }
            },
            {
                chatalpha = {
                    key = 'settings.chat.alpha',
                    type = 'slider',
                    label = 'Chat Background Alpha',
                    min = 0,
                    max = 1,
                    precision = 1,
                    column = 4,
                    order = 1,
                    onChange = updateChatAlpha
                },
                chatfontsize = {
                    key = 'settings.chat.font.size',
                    type = 'slider',
                    label = 'Chat Font Size',
                    min = 10,
                    max = 20,
                    column = 4,
                    order = 2,
                    onChange = updateChatFont
                },
                scrollbuttons = {
                    key = 'settings.buttons.up_and_down',
                    type = 'checkbox',
                    label = 'Scroll Buttons',
                    tooltip = 'Show custom scroll buttons in custom chat',
                    column = 4,
                    order = 3,
                    onChange = updateScrollButtons
                }
            },
            {
                chatfontoutline = {
                    key = 'settings.chat.font.outline',
                    type = 'checkbox',
                    label = 'Chat Font Outline',
                    column = 4,
                    order = 1,
                    onChange = updateChatFont
                },
                chatfontshadow = {
                    key = 'settings.chat.font.shadow',
                    type = 'checkbox',
                    label = 'Chat Font Shadow',
                    column = 4,
                    order = 2,
                    onChange = updateChatFont
                },
                messagefade = {
                    key = 'settings.fade.enabled',
                    type = 'checkbox',
                    label = 'Message Fading',
                    column = 4,
                    order = 3,
                    onChange = function() end
                }
            },
            {
                fadeoutdelay = {
                    key = 'settings.fade.out_delay',
                    type = 'slider',
                    label = 'Fade Out Delay',
                    min = 10,
                    max = 240,
                    column = 4,
                    order = 1,
                    onChange = function() end
                },
                dockfade = {
                    key = 'settings.dock.fade.enabled',
                    type = 'checkbox',
                    label = 'Tabs and Buttons Fading',
                    column = 4,
                    order = 2,
                    onChange = updateDockFading
                },
                dockalpha = {
                    key = 'settings.dock.alpha',
                    type = 'slider',
                    label = 'Dock Alpha',
                    min = 0,
                    max = 1,
                    precision = 1,
                    column = 4,
                    order = 3,
                    onChange = function() end
                }
            }
        },
    }
end
