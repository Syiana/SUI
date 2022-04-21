local Module = SUI:NewModule("UnitFrames.Links");

function Module:OnEnable()
  local db = SUI.db.profile.unitframes.links
  if (db) then
    -- Menu structure
    UnitPopupButtons["CL"] = {text = "Character Links", nested = 1}
    UnitPopupButtons["A"] = {text = "Armory", checkable = nil}
    UnitPopupButtons["MHP"] = {text = "Mythic Plus", checkable = nil}
    UnitPopupButtons["WL"] = {text = "Warcraft Logs", checkable = nil}
    UnitPopupButtons["RIO"] = {text = "Raider.IO", checkable = nil}
    UnitPopupButtons["XM"] = {text = "XunaMate", checkable = nil}
    UnitPopupButtons["CP"] = {text = "CheckPvP", checkable = nil}
    UnitPopupButtons["WP"] = {text = "WoWProgress", checkable = nil}
    table.insert(UnitPopupMenus["SELF"], #(UnitPopupMenus["SELF"]) - 1, "CL")
    table.insert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"]) - 1, "CL")
    table.insert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"]) - 1, "CL")
    table.insert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"]) - 1, "CL")
    table.insert(UnitPopupMenus["ARENAENEMY"], #(UnitPopupMenus["ARENAENEMY"]) - 1, "CL")
    table.insert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"]) - 1, "CL")
    table.insert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"]) - 1, "CL")
    table.insert(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"], #(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"]) - 1, "CL")
    table.insert(UnitPopupMenus["COMMUNITIES_WOW_MEMBER"], #(UnitPopupMenus["COMMUNITIES_WOW_MEMBER"]) - 1, "CL")
    table.insert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"]) - 1, "CL")
    table.insert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"]) - 1, "CL")
    table.insert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"]) - 1, "CL")
    table.insert(UnitPopupMenus["WORLD_STATE_SCORE"], #(UnitPopupMenus["WORLD_STATE_SCORE"]) - 1, "CL")
    UnitPopupMenus["CL"] = {"A", "XM", "CP", "MHP", "RIO", "WL", "WP"}

    -- Get current region
    local function getRegion()
      local regionLabel = {"us", "kr", "eu", "tw", "cn"}
      local regionId = GetCurrentRegion()
      return regionLabel[regionId]
    end

    -- Create the link
    local function buildLink(name, site)
      local char, server = string.match(name, "(.-)-(.*)")
      if not char then
        char = name
        server = GetRealmName()
      end
      server = FixRealmName(server)
      serverArmory = server
      serverArmory = string.gsub(serverArmory, "'", "")
      serverArmory = string.gsub(serverArmory, "’", "")
      serverMythicPlusHelper = server
      server = string.gsub(server, "(%l)(%u)", "%1-%2")
      server = string.gsub(server, " ", "-")
      serverWarcraftLogs = server
      server = string.gsub(server, "'", "-")
      server = string.gsub(server, "’", "-")
      serverWarcraftLogs = string.gsub(serverWarcraftLogs, "'", "")
      serverWarcraftLogs = string.gsub(serverWarcraftLogs, "’", "")
      if server == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|CFFFF6060Character Links|r: " .. "Out of range!")
      else
        local region = getRegion()
        local url = ""
        local role = UnitGroupRolesAssigned(char)
        if site == "armory" then
          if region == "eu" then
            url = "https://worldofwarcraft.com/en-gb/character/" .. serverArmory .. "/" .. char .. "/"
          else
            url = "https://worldofwarcraft.com/en-us/character/" .. serverArmory .. "/" .. char .. "/"
          end
        elseif site == "mythicplusshelper" then
          url = '{"region": "' .. region .. '"},\n'
          if IsInRaid() == true then
            url = url .. '{"groupType":"raid"},\n'
          else
            url = url .. '{"groupType":"dungeon"},\n'
          end
          url = url .. '{"character": "' .. char .. '",'
          url = url .. '"server": "' .. FixRealmName(serverMythicPlusHelper) .. '",'
          url = url .. '"playerType": "groupMember",'
          url = url .. '"role": "' .. role .. '"}\n'
        elseif site == "xunamate" then
          url = "https://xunamate.com/#/character/" .. region .. "/" .. server .. "/" .. char .. "/"
        elseif site == "checkpvp" then
          url = "https://check-pvp.fr/".. region .. "/" .. server .. "/" .. char .. "/"
        elseif site == "warcraftlogs" then
          url = "https://www.warcraftlogs.com/character/" .. region .. "/" .. serverWarcraftLogs .. "/" .. char .. "/"
        elseif site == "wowprogress" then
          url = "https://www.wowprogress.com/character/" .. region .. "/" .. server .. "/" .. char .. "/"
        elseif site == "raiderio" then
          url = "https://raider.io/characters/" .. region .. "/" .. server .. "/" .. char .. "/"
        end
        return url
      end
    end

    -- Display the link
    local function ShowUrl(name, site)
      if not name then
        return
      end
      local url = buildLink(name, site)
      if url then
        local edit_box = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(edit_box)
        if url then
          edit_box:Insert(url)
          edit_box:HighlightText()
        end
      end
    end

    -- Menu interaction
    local CURRENT_NAME, CURRENT_SERVER

    hooksecurefunc(
      "UnitPopup_ShowMenu",
      function(dropdownMenu, which, unit, name, userData)
        local server = nil
        if UIDROPDOWNMENU_MENU_LEVEL == 1 then
          if (unit) then
            name, server = UnitName(unit)
          elseif (name) then
            local n, s = strmatch(name, "^([^-]+)-(.*)")
            if (n) then
              name = n
              server = s
            end
          end
          CURRENT_NAME = name
          CURRENT_SERVER = server
        end
      end
    )

    hooksecurefunc(
      "UnitPopup_OnClick",
      function(self)
        local site
        local name, realm = UIDROPDOWNMENU_INIT_MENU.name, UIDROPDOWNMENU_INIT_MENU.server
        if name == CURRENT_NAME and not realm then
          realm = CURRENT_SERVER
        end
        if self.value == "A" then
          site = "armory"
        elseif self.value == "MHP" then
          site = "mythicplusshelper"
        elseif self.value == "XM" then
          site = "xunamate"
        elseif self.value == "CP" then
          site = "checkpvp"
        elseif self.value == "WL" then
          site = "warcraftlogs"
        elseif self.value == "WP" then
          site = "wowprogress"
        elseif self.value == "RIO" then
          site = "raiderio"
        else
          return
        end
        if realm then
          ShowUrl(name .. "-" .. realm, site)
        else
          ShowUrl(name, site)
        end
      end
    )

    -- LFG tool menu when searching for a group
    local LFG_LIST_SEARCH_ENTRY_MENU = {
      {
        text = nil,
        isTitle = true,
        notCheckable = true
      },
      {
        text = WHISPER_LEADER,
        func = function(_, name)
          ChatFrame_SendTell(name)
        end,
        notCheckable = true,
        arg1 = nil,
        disabled = nil,
        tooltipWhileDisabled = 1,
        tooltipOnButton = 1,
        tooltipTitle = nil,
        tooltipText = nil
      },
      {
        text = "Character Links",
        hasArrow = true,
        notCheckable = true,
        menuList = {
          {
            text = "Armory",
            func = function(_, name)
              ShowUrl(name, "armory")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil
          },
          {
            text = "XunaMate",
            func = function(_, name)
              ShowUrl(name, "xunamate")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "CheckPvP",
            func = function(_, name)
              ShowUrl(name, "checkpvp")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Mythic Plus",
            func = function(_, name)
              ShowUrl(name, "mythicplusshelper")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Raider.IO",
            func = function(_, name)
              ShowUrl(name, "raiderio")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Warcraft Logs",
            func = function(_, name)
              ShowUrl(name, "warcraftlogs")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "WoWProgress",
            func = function(_, name)
              ShowUrl(name, "wowprogress")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          }
        }
      },
      {
        text = LFG_LIST_REPORT_GROUP_FOR,
        hasArrow = true,
        notCheckable = true,
        menuList = {
          {
            text = LFG_LIST_BAD_NAME,
            func = function(_, id)
              C_LFGList.ReportSearchResult(id, "lfglistname")
            end,
            arg1 = nil,
            notCheckable = true
          },
          {
            text = LFG_LIST_BAD_DESCRIPTION,
            func = function(_, id)
              C_LFGList.ReportSearchResult(id, "lfglistcomment")
            end,
            arg1 = nil,
            notCheckable = true,
            disabled = nil
          },
          {
            text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,
            func = function(_, id)
              C_LFGList.ReportSearchResult(id, "lfglistvoicechat")
            end,
            arg1 = nil,
            notCheckable = true,
            disabled = nil
          },
          {
            text = LFG_LIST_BAD_LEADER_NAME,
            func = function(_, id)
              C_LFGList.ReportSearchResult(id, "badplayername")
            end,
            arg1 = nil,
            notCheckable = true,
            disabled = nil
          }
        }
      },
      {
        text = CANCEL,
        notCheckable = true
      }
    }

    function LFGListUtil_GetSearchEntryMenu(resultID)
      local results = C_LFGList.GetSearchResultInfo(resultID)
      if (not results) then
          return
      end
      local id = results.id
      local activityID = results.activityID
      local name = results.name
      local comment = results.comment
      local voiceChat = results.voiceChat
      local iLvl = results.iLvl
      local honorLevel = results.honorLevel
      local age = results.age
      local numBNetFriends = results.numBNetFriends
      local numCharFriends = results.numCharFriends
      local numGuildMates = results.numGuildMates
      local isDelisted = results.isDelisted
      local leaderName = results.leaderName
      local numMembers = results.numMembers

      local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
      LFG_LIST_SEARCH_ENTRY_MENU[1].text = name
      LFG_LIST_SEARCH_ENTRY_MENU[2].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[2].disabled = not leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].disabled = not leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[1].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[2].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[3].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[4].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[3].menuList[5].arg1 = leaderName
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[1].arg1 = resultID
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].arg1 = resultID
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[2].disabled = (comment == "")
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].arg1 = resultID
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[3].disabled = (voiceChat == "")
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].arg1 = resultID
      LFG_LIST_SEARCH_ENTRY_MENU[4].menuList[4].disabled = not leaderName
      return LFG_LIST_SEARCH_ENTRY_MENU
    end

    -- LFG tool menu when forming a group
    local LFG_LIST_APPLICANT_MEMBER_MENU = {
      {
        text = nil,
        isTitle = true,
        notCheckable = true
      },
      {
        text = WHISPER,
        func = function(_, name)
          ChatFrame_SendTell(name)
        end,
        notCheckable = true,
        arg1 = nil,
        disabled = nil
      },
      {
        text = "Character Links",
        hasArrow = true,
        notCheckable = true,
        menuList = {
          {
            text = "Armory",
            func = function(_, name)
              ShowUrl(name, "armory")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "XunaMate",
            func = function(_, name)
              ShowUrl(name, "xunamate")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "CheckPvP",
            func = function(_, name)
              ShowUrl(name, "checkpvp")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Mythic Plus",
            func = function(_, name)
              ShowUrl(name, "mythicplusshelper")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Raider.IO",
            func = function(_, name)
              ShowUrl(name, "raiderio")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "Warcraft Logs",
            func = function(_, name)
              ShowUrl(name, "warcraftlogs")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          },
          {
            text = "WoWProgress",
            func = function(_, name)
              ShowUrl(name, "wowprogress")
            end,
            notCheckable = true,
            arg1 = nil,
            disabled = nil,
          }
        }
      },
      {
        text = LFG_LIST_REPORT_FOR,
        hasArrow = true,
        notCheckable = true,
        menuList = {
          {
            text = LFG_LIST_BAD_PLAYER_NAME,
            notCheckable = true,
            func = function(_, id, memberIdx)
              C_LFGList.ReportApplicant(id, "badplayername", memberIdx)
            end,
            arg1 = nil,
            arg2 = nil
          },
          {
            text = LFG_LIST_BAD_DESCRIPTION,
            notCheckable = true,
            func = function(_, id)
              C_LFGList.ReportApplicant(id, "lfglistappcomment")
            end,
            arg1 = nil
          }
        }
      },
      {
        text = IGNORE_PLAYER,
        notCheckable = true,
        func = function(_, name, applicantID)
          AddIgnore(name)
          C_LFGList.DeclineApplicant(applicantID)
        end,
        arg1 = nil,
        arg2 = nil,
        disabled = nil
      },
      {
        text = CANCEL,
        notCheckable = true
      }
    }

    function LFGListUtil_GetApplicantMemberMenu(applicantID, memberIdx)
      local name, class, localizedClass, level, itemLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)

      LFG_LIST_APPLICANT_MEMBER_MENU[1].text = name or " "
      LFG_LIST_APPLICANT_MEMBER_MENU[2].arg1 = name
      LFG_LIST_APPLICANT_MEMBER_MENU[2].disabled = not name
      LFG_LIST_APPLICANT_MEMBER_MENU[3].arg1 = name
      LFG_LIST_APPLICANT_MEMBER_MENU[3].disabled = not name
      LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg1 = applicantID
      LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg2 = memberIdx
      LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].arg1 = applicantID
      LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].disabled = (comment == "")
      LFG_LIST_APPLICANT_MEMBER_MENU[5].arg1 = name
      LFG_LIST_APPLICANT_MEMBER_MENU[5].arg2 = applicantID
      LFG_LIST_APPLICANT_MEMBER_MENU[5].disabled = not name

      return LFG_LIST_APPLICANT_MEMBER_MENU
    end

    -- Server name fix
    function FixRealmName(server)
      if server == nil then
        return
      end
      server = string.gsub(server, "AeriePeak", "Aerie Peak")
      server = string.gsub(server, "AltarofStorms", "Altar of Storms")
      server = string.gsub(server, "AlteracMountains", "Alterac Mountains")
      server = string.gsub(server, "Area52", "Area 52")
      server = string.gsub(server, "ArgentDawn", "Argent Dawn")
      server = string.gsub(server, "BlackDragonflight", "Black Dragonflight")
      server = string.gsub(server, "BlackwaterRaiders", "Blackwater Raiders")
      server = string.gsub(server, "BlackwingLair", "Blackwing Lair")
      server = string.gsub(server, "Blade'sEdge", "Blade's Edge")
      server = string.gsub(server, "BleedingHollow", "Bleeding Hollow")
      server = string.gsub(server, "BloodFurnace", "Blood Furnace")
      server = string.gsub(server, "BootyBay", "Booty Bay")
      server = string.gsub(server, "BoreanTundra", "Borean Tundra")
      server = string.gsub(server, "BronzeDragonflight", "Bronze Dragonflight")
      server = string.gsub(server, "BurningBlade", "Burning Blade")
      server = string.gsub(server, "BurningLegion", "Burning Legion")
      server = string.gsub(server, "BurningSteppes", "Burning Steppes")
      server = string.gsub(server, "CenarionCircle", "Cenarion Circle")
      server = string.gsub(server, "ChamberofAspects", "Chamber of Aspects")
      server = string.gsub(server, "Chantséternels", "Chants éternels ")
      server = string.gsub(server, "ColinasPardas", "Colinas Pardas")
      server = string.gsub(server, "ConfrérieduThorium", "Confrérie du Thorium")
      server = string.gsub(server, "ConseildesOmbres", "Conseil des Ombres")
      server = string.gsub(server, "CultedelaRivenoire", "Culte de la Rive noire")
      server = string.gsub(server, "DarkIron", "Dark Iron")
      server = string.gsub(server, "DarkmoonFaire", "Darkmoon Faire")
      server = string.gsub(server, "DasKonsortium", "Das Konsortium")
      server = string.gsub(server, "DasSyndikat", "Das Syndikat")
      server = string.gsub(server, "DefiasBrotherhood", "Defias Brotherhood")
      server = string.gsub(server, "DemonSoul", "Demon Soul")
      server = string.gsub(server, "DerRatvonDalaran", "Der Rat von Dalaran")
      server = string.gsub(server, "DerabyssischeRat", "Der abyssische Rat")
      server = string.gsub(server, "DieArguswacht", "Die Arguswacht")
      server = string.gsub(server, "DieSilberneHand", "Die Silberne Hand")
      server = string.gsub(server, "DieTodeskrallen", "Die Todeskrallen")
      server = string.gsub(server, "DieewigeWacht", "Die ewige Wacht")
      server = string.gsub(server, "DunModr", "Dun Modr")
      server = string.gsub(server, "EarthenRing", "Earthen Ring")
      server = string.gsub(server, "EchoIsles", "Echo Isles")
      server = string.gsub(server, "EmeraldDream", "Emerald Dream")
      server = string.gsub(server, "FestungderStürme", "Festung der Stürme")
      server = string.gsub(server, "GrimBatol", "Grim Batol")
      server = string.gsub(server, "GrizzlyHills", "Grizzly Hills")
      server = string.gsub(server, "HowlingFjord", "Howling Fjord")
      server = string.gsub(server, "KhazModan", "Khaz Modan")
      server = string.gsub(server, "KirinTor", "Kirin Tor")
      server = string.gsub(server, "KulTiras", "Kul Tiras")
      server = string.gsub(server, "KultderVerdammten", "Kult der Verdammten")
      server = string.gsub(server, "LaCroisadeécarlate", "La Croisade écarlate")
      server = string.gsub(server, "LaughingSkull", "Laughing Skull")
      server = string.gsub(server, "LesClairvoyants", "Les Clairvoyants")
      server = string.gsub(server, "LesSentinelles", "Les Sentinelles")
      server = string.gsub(server, "LichKing", "Lich King")
      server = string.gsub(server, "Lightning'sBlade", "Lightning's Blade")
      server = string.gsub(server, "LosErrantes", "Los Errantes")
      server = string.gsub(server, "MarécagedeZangar", "Marécage de Zangar")
      server = string.gsub(server, "MoonGuard", "Moon Guard")
      server = string.gsub(server, "Pozzodell'Eternità", "Pozzo dell'Eternità")
      server = string.gsub(server, "ScarletCrusade", "Scarlet Crusade")
      server = string.gsub(server, "ScarshieldLegion", "Scarshield Legion")
      server = string.gsub(server, "ShadowCouncil", "Shadow Council")
      server = string.gsub(server, "ShatteredHalls", "Shattered Halls")
      server = string.gsub(server, "ShatteredHand", "Shattered Hand")
      server = string.gsub(server, "SilverHand", "Silver Hand")
      server = string.gsub(server, "SistersofElune", "Sisters of Elune")
      server = string.gsub(server, "SteamwheedleCartel", "Steamwheedle Cartel")
      server = string.gsub(server, "TarrenMill", "Tarren Mill")
      server = string.gsub(server, "Templenoir", "Temple noir")
      server = string.gsub(server, "TheForgottenCoast", "The Forgotten Coast")
      server = string.gsub(server, "TheMaelstrom", "The Maelstrom")
      server = string.gsub(server, "TheScryers", "The Scryers")
      server = string.gsub(server, "TheSha'tar", "The Sha'tar")
      server = string.gsub(server, "TheUnderbog", "The Underbog")
      server = string.gsub(server, "TheVentureCo", "The Venture Co")
      server = string.gsub(server, "ThoriumBrotherhood", "Thorium Brotherhood")
      server = string.gsub(server, "TolBarad", "Tol Barad")
      server = string.gsub(server, "Twilight'sHammer", "Twilight's Hammer")
      server = string.gsub(server, "TwistingNether", "Twisting Nether")
      server = string.gsub(server, "WyrmrestAccord", "Wyrmrest Accord")
      server = string.gsub(server, "ZirkeldesCenarius", "Zirkel des Cenarius")
      server = string.gsub(server, "Борейскаятундра", "Борейская тундра")
      server = string.gsub(server, "ВечнаяПесня", "Вечная Песня")
      server = string.gsub(server, "Корольлич", "Король-лич")
      server = string.gsub(server, "Пиратскаябухта", "Пиратская бухта")
      server = string.gsub(server, "Ревущийфьорд", "Ревущий фьорд")
      server = string.gsub(server, "СвежевательДуш", "Свежеватель Душ")
      server = string.gsub(server, "СтражСмерти", "Страж Смерти")
      server = string.gsub(server, "ТкачСмерти", "Ткач Смерти")
      server = string.gsub(server, "ЧерныйШрам", "Черный Шрам")
      server = string.gsub(server, "Ясеневыйлес", "Ясеневый лес")
      return server
    end
  end
end