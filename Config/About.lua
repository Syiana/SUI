--[[
    SUI 2.0 - Config/About.lua

    Credits and links.
]]

local _, ns = ...
local SUI = ns.SUI

local SUIConfig = LibStub("SUIConfig")

local team = {
    "|cfff72a53Syiana|r",
    "|cff2af7afRulez|r",
    "|cff2af7afBaine|r",
    "|cff2af7afPhoyk|r",
    "|cff2a91f7Obscurrium|r",
    "|cff2a91f7SuperTkle|r",
    "|cff2a91f7Proxy|r",
    "|cffe08000Marcelian|r",
    "|cffe08000Umren|r",
}

local specials = {
    "|cffFFF468Stacy|r",
    "|cffC69B6DCandy|r",
    "|cffFF7C0ASivax|r",
    "|cffC41E3AKyrea|r",
    "|cff00FF98Yjing|r",
    "|cff0070DDCaccie|r",
    "|cffFFFFFFHuf|r",
    "|cffAAD372Yazo|r",
    "|cff8788EEReko|r",
    "|cffC69B6DNano|r",
    "|cffC69B6DChili|r",
    "|cffAAD372Kasuxoxo|r",
    "|cffFF7C0AMystik|r",
    "|cffAAD372Louce|r",
    "|cffC69B6DBeiskaldi|r",
    "|cffC69B6DLimps|r",
    "|cff00FF98Tem|r",
    "|cffFF7C0AShimaya|r",
    "|cffA330C9Instababe|r",
    "|cffFFF468Citney|r",
    "|cffC41E3AEyu|r",
    "|cff3FC7EBJosefeVerdi|r",
    "|cffFFF468Trimaz67|r",
    "|cffF48CBABorugg|r",
    "|cffFF7C0AZonsy|r",
    "|cffF48CBALerthas|r",
    "|cff00FF98Tizi|r",
    "|cffF48CBAAyro|r",
    "|cffFFF468Avidance|r",
    "|cffF48CBAAviwings|r",
    "|cffFF7C0AXexexexexexe|r",
}

local supporter = {
    "|cffF48CBAAkna|r",
    "|cffFFF468Jojo|r",
    "|cffFFFFFFWoogo|r",
    "|cffFF7C0AOwldTV|r",
    "|cffFFF468Dartakiront|r",
    "|cffF48CBAOldsoul74|r",
    "|cffFFF468neaR_qt|r",
    "|cffC41E3ASamsabal|r",
    "|cffA330C9Breezyy999|r",
    "|cffFFFFFFj4yqtx|r",
    "|cffC41E3ASmolley|r",
    "|cff3FC7EBnyccQT|r",
    "|cffFF7C0AShimaya|r",
    "|cffFFFFFFKivancxo|r",
    "|cffC69B6DArestoniix|r",
    "|cff00FF98TrippyCat423|r",
    "|cffC69B6DGhargatuloth|r",
    "|cff3FC7EBRemgax|r",
    "|cff3FC7EBdream_witch2020|r",
    "|cff00FF98DustyPiink|r",
    "|cff00FF98Raknesso|r",
    "|cffFF7C0APHIL741|r",
    "|cffF48CBAKoreanhammer|r",
    "|cff00FF98Rulez|r",
    "|cffFF7C0ASonsi Gladiator|r",
    "|cffFF7C0AxHukk|r",
    "|cff3FC7EBLyonersalat|r",
    "|cff0070DDhindbarry|r",
    "|cffFFFFFFbenkenobi|r",
    "|cffFF7C0APuzzlebox|r",
    "|cffC69B6DTafsiri|r",
    "|cff3FC7EBthoserats|r",
    "|cffFFFFFFXentaria|r",
    "|cffAAD372Nxthunter|r",
    "|cffFF7C0ADrudrû|r",
    "|cffF48CBAKoffa|r",
    "|cffAAD372Fortunes|r",
    "|cffF48CBAUnstoppäble|r",
    "|cff0070DDRemi|r",
    "|cffFF7C0AKaizerdk|r",
    "|cffA330C9Venedri|r",
    "|cffC69B6DArsinal|r",
    "|cffFFFFFFTanly|r",
    "|cffF48CBANeonswift|r",
    "|cffA330C9Lylairi|r",
    "|cffF48CBACr0n0|r",
    "|cff33937FBiral|r",
    "|cffAAD372Petzilla|r",
    "|cffC41E3ABiven|r",
    "|cff00FF98Cigana|r",
    "|cffFF7C0ACongodandy|r",
    "|cffFFF468Wilmêr|r",
    "|cff0070DDElémentalz|r",
    "|cffC69B6DKinx|r",
    "|cffC41E3Ab|r",
    "|cffAAD372Nichlibou|r",
    "|cffFF7C0Asoundz|r",
    "|cff3FC7EBMageTea|r",
    "|cffFFF468sobeit|r",
    "|cffAAD372Shîvas|r",
    "|cffFF7C0AGobby|r",
    "|cffFF7C0AZaza|r",
    "|cff33937FHræsvelgr|r",
    "|cffFFFFFFTowl|r",
}

local function nameList(label, names, order)
    return {
        type = "scroll",
        label = label,
        height = 220,
        column = 4,
        order = order,
        scrollChild = function(self)
            local data = {}
            for i = 1, #names do
                data[i] = { text = names[i] }
            end
            SUIConfig:ObjectList(self.scrollChild, {}, "Label", function(_, fontString, item)
                fontString:SetText(item.text)
                SUIConfig:SetObjSize(fontString, 60, 20)
                fontString:SetPoint("RIGHT")
                fontString:SetPoint("LEFT")
                return fontString
            end, data)
        end,
    }
end

local function copyBox(label, text, order)
    return {
        type = "custom",
        label = label,
        column = 4,
        order = order,
        createFunction = function(frame)
            local box = SUIConfig:SimpleEditBox(frame, nil, 20, text)
            box:SetCursorPosition(0)
            box:SetScript("OnEditFocusGained", box.HighlightText)
            box:SetScript("OnMouseUp", function(self)
                self:SetFocus()
                self:HighlightText()
            end)
            box:SetScript("OnEscapePressed", function(self)
                self:ClearFocus()
                self:HighlightText(0, 0)
            end)
            box:SetScript("OnTextChanged", function(self)
                if self:GetText() ~= text then
                    self:SetText(text)
                end
            end)
            return box
        end,
    }
end

SUI.Config:RegisterLayout("About", {
    title = "FAQ",
    order = 1000,
    bind = false,
    rows = function()
        return {
            { header = { type = "header", label = "Credits" } },
            {
                team = nameList("Team", team, 1),
                specials = nameList("Specials", specials, 2),
                supporter = nameList("Supporter", supporter, 3),
            },
            { header = { type = "header", label = "Help" } },
            {
                discord = copyBox("Discord", "discord.gg/yBWkxxR", 1),
                twitch = copyBox("Twitch", "twitch.tv/syiana", 2),
            },
        }
    end,
})
