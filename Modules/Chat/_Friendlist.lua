local Friendlist = SUI:NewModule("Chat.Friendlist");

function Friendlist:OnEnable()
  local db = SUI.db.profile.chat.friendlist
  if (db) then
    function FriendColor_ClassColor(class)
      local localClass;
      --print("class before switch = " .. class)
      
      if(class == "DRUID") then
        class = "Druid"
      end
      if(class == "HUNTER") then
        class = "Hunter"
      end
      if(class == "MAGE") then
        class = "Mage"
      end
      if(class == "PALADIN") then
        class = "Paladin"
      end
      if(class == "PRIEST") then
        class = "Priest"
      end
      if(class == "ROGUE") then
        class = "Rogue"
      end
      if(class == "WARLOCK") then
        class = "Warlock"
      end
      if(class == "WARRIOR") then
        class = "Warrior"
      end
    
      --print("class after switch " .. class)
      
      if GetLocale() ~= "enUS" then
        for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then localClass = k end end
        --print("k female = " .. k)
      else
        for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then localClass = k end end
        --print(print("k male = " .. k))
      end
      
      local classColor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[localClass];
      if class == "Shaman" then
            classColor.r = 0.00
            classColor.g = 0.44
            classColor.b = 0.87
        end
      return classColor; -- check nil
    end
    
    function FriendColor_BNetFriend(i, friendOffset, numOnline)
      --print("friendOffsetBnet = " .. friendOffset)
      local bnetIDAccount, accountName, battleTag, isBattleTagPresence, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR, isReferAFriend, canSummonFriend = BNGetFriendInfo(i);
      
      if isOnline == false then
        return;
      end
      
      if client ~= BNET_CLIENT_WOW then
        return;
      end
      
      local hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, toonID, bnetIDAccount, isGameAFK, isGameBusy = BNGetGameAccountInfo(bnetIDGameAccount);
      
      local classc = FriendColor_ClassColor(class);
      if not classc then
        return;
      end
      
      local index = i-friendOffset+numOnline;
      
      local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(index).."Name"];
      if nameString then
        nameString:SetText(accountName.." ("..characterName..", L"..level..")");
        nameString:SetTextColor(classc.r, classc.g, classc.b);
      end
      
      if CanCooperateWithGameAccount(toonID) ~= true then
        local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(index).."Info"];
        if nameString then
          nameString:SetText(zoneName.." ("..realmName..")");
        end
      end
    end
    
    function FriendColor_Friend(i, friendOffset)
      --print("friendOffset = " .. friendOffSet)
      local friendInfo = C_FriendList.GetFriendInfoByIndex(i);
        
      if friendInfo.connected == false then
        return;
      end
      
      local classc = FriendColor_ClassColor(friendInfo.className);
      if not classc then
        return;
      end
      
      local index = i-friendOffset;
      
      local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(index).."Name"];
      if nameString and friendInfo.name then
        nameString:SetText(friendInfo.name..", L"..friendInfo.level);
        nameString:SetTextColor(classc.r, classc.g, classc.b);
      end
    end
    
    function GuildColor_Class(i, numGuildOnline)
      --print("GuildColor_Class i = " .. i)
      local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i)
      --print(name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID)	
    
      --print("The class from guild info is ***** " .. class)
      local classc = FriendColor_ClassColor(class);
      --print("classc = " .. classc)
      if not classc then
        return;
      end	
      
      index = i + numGuildOnline
      --print("guild i = " .. i .. " / numGuildOnline = " .. numGuildOnline)
      
      local nameString = _G["GuildFrameButton"..(i).."Name"];
      if nameString and name then
        nameString:SetTextColor(classc.r, classc.g, classc.b);
      end
      
      local classString = _G["GuildFrameButton"..(i).."Class"];
      if classString and name then
        classString:SetTextColor(classc.r, classc.g, classc.b);
      end
    end
    
    function GuildColor_Class()
      local playerzone = GetRealZoneText()
        local off = FauxScrollFrame_GetOffset(GuildListScrollFrame)
      --print("Inside GuildColor_ClassBlah()")
      --print("playerzone = " .. playerzone)
      --print("FauxScrollFrame_GetOffset(GuildListScrollFrame) = " .. off)
      --print("GUILDMEMBERS_TO_DISPLAY = " .. GUILDMEMBERS_TO_DISPLAY)
        for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
          local name, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(off + i)
        --print(name, level, class, zone, online)
          --class = L["class"][class]
        
    
          if name then
        --print("name = " .. name);
            if class then
          --print("class = " .. class);
              local classc = FriendColor_ClassColor(class);
              if online then
          --print(name .. " is online");
          --print("*****************");
                --_G["GuildFrameButton"..i.."Class"]:SetTextColor(color.r,color.g,color.b,1)
          _G['GuildFrameGuildStatusButton'..i..'Name']:SetTextColor(classc.r, classc.g, classc.b);
          local onlineString = _G['GuildFrameGuildStatusButton'..i..'Online'];
          if onlineString then
            if onlineString:GetText() == 'Online' then
              onlineString:SetTextColor(.5, 1, 1, 1)
            end
            if onlineString:GetText() == '<AFK>' then
              onlineString:SetTextColor(1, 1, .4)
            end
          end
          -- Online
          -- Rank
          local nameString = _G["GuildFrameButton"..(i).."Name"];
          if nameString and name then
            nameString:SetTextColor(classc.r, classc.g, classc.b);
          end
          
          local classString = _G["GuildFrameButton"..(i).."Class"];
          if classString and name then
            classString:SetTextColor(classc.r, classc.g, classc.b);
          end
              else
          _G['GuildFrameGuildStatusButton'..i..'Name']:SetTextColor(classc.r, classc.g, classc.b, .5);
          local nameString = _G["GuildFrameButton"..(i).."Name"];
          if nameString and name then
            nameString:SetTextColor(classc.r, classc.g, classc.b, .5);
          end
          
          local classString = _G["GuildFrameButton"..(i).."Class"];
          if classString and name then
            classString:SetTextColor(classc.r, classc.g, classc.b, .5);
          end
              end
            end
    
            if level then--[[
              local color = GetDifficultyColor(level)
              if online then
                _G["GuildFrameButton"..i.."Level"]:SetTextColor(color.r + .2, color.g + .2, color.b + .2, 1)
              else
                _G["GuildFrameButton"..i.."Level"]:SetTextColor(color.r + .2, color.g + .2, color.b + .2, .5)
              end]]
            end
    
            if zone and zone == playerzone then
              if online then
                _G["GuildFrameButton"..i.."Zone"]:SetTextColor(.5, 1, 1, 1)
              else
                _G["GuildFrameButton"..i.."Zone"]:SetTextColor(.5, 1, 1, .5)
              end
            end
        
    
          end
        end
    
    end
    
    function FriendColor_GetFriendOffset()
      local friendOffset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
      if not friendOffset then
        friendOffset = 0;
      end
      if friendOffset < 0 then
        friendOffset = 0;
      end
      
      return friendOffset;
    end
    
    function WhoColor_Class()
      for i = 1, _G.WHOS_TO_DISPLAY do
        _G["WhoFrameButton"..i.."Variable"]:SetTextColor(1, 1, 1)
      end
      
      do
        --print("inside WhoColorY");
        local button, level, name, class
        local whoIndex
        local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
        local columnTable
        
        for i = 1, _G.WHOS_TO_DISPLAY do
          whoIndex = whoOffset + i
          button = _G['WhoFrameButton'..i]	
          level = _G['WhoFrameButton'..i..'Level']
          name = _G['WhoFrameButton'..i..'Name']
          class = _G['WhoFrameButton'..i..'Class']
          variableText = _G["WhoFrameButton"..i.."Variable"]
    
          
          local info = C_FriendList.GetWhoInfo(whoIndex)
          if info then
            guild = info.fullGuildName
            name = info.fullName
            class = info.classStr
            zone = info.area
            race = info.raceStr
            local classc = FriendColor_ClassColor(class);
    
            local nameString = _G['WhoFrameButton'..i..'Name']
            nameString:SetTextColor(classc.r, classc.g, classc.b);
            
            local selectedID = UIDropDownMenu_GetSelectedID(WhoFrameDropDown)
            if selectedID == 1 then
              --print("selectedID = 1 | Zone")
              local playerzone = GetRealZoneText()
              if zone and zone == playerzone then _G["WhoFrameButton"..i.."Variable"]:SetTextColor(.5, 1, 1, 1) end
            elseif selectedID == 2 then
              --print("selectedID = 2 | Guild")
              local playerGuild = GetGuildInfo("player")
              if guild and guild == playerGuild then _G["WhoFrameButton"..i.."Variable"]:SetTextColor(.5, 1, 1, 1) end
            else --selectedID == 3 then
              --print("selectedID = 3 | Race")
              local playerRace = UnitRace("player")					
              if race and race == playerRace then _G["WhoFrameButton"..i.."Variable"]:SetTextColor(.5, 1, 1, 1) end
            end		
          end
        end
      end
    end
    
    function FriendColor_Hook_FriendsList_Update()
      --print("Triggering Guild List Update")	
      local friendOffset = FriendColor_GetFriendOffset();
      --print("friendOffset = " .. friendOffset)
      --print("guildOffSet = " .. guildOffset)
      local numBNetTotal, numBNetOnline = BNGetNumFriends();
    
      -- Online WoW friends
      local numFriends = C_FriendList.GetNumFriends() or 0;
      local numOnline = C_FriendList.GetNumOnlineFriends() or 0;
      
      --added by forest
      local off = FauxScrollFrame_GetOffset(GuildListScrollFrame)
      local playerzone = GetRealZoneText()
      --print ("playerzone = " .. playerzone)
      --print(GUILDMEMBERS_TO_DISPLAY)
      --print("off = " .. off)
      local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers();
      
      local numWhos, totalNumWhos = C_FriendList.GetNumWhoResults(); -- totalNumWhos doesnt appear to actually be used in this method?
      --print("numWhos = " .. numWhos);
      
      --DEFAULT_CHAT_FRAME:AddMessage(numOnline);poo
      
      if numOnline > 0 then
        for i=1, numOnline, 1 do
          FriendColor_Friend(i, friendOffset);
        end
      end
        
      -- Online Battlenet friends
      if numBNetOnline > 0 then
        --local BNetOffset = numBNetOnline;
        for i=1, 1+numBNetOnline, 1 do
          FriendColor_BNetFriend(i, friendOffset, numOnline);
        end
      end
      
      -- added by forest
      --print("numOnlineGuildMembers = " .. numOnlineGuildMembers)
      if numOnlineGuildMembers > 0 then
        for i=1, numOnlineGuildMembers, 1 do
          GuildColor_Class()
        end
      end
      
      -- added by forest
      if numWhos ~= nil then -- HonorSpy addon installed by some players uses a lot of '/who' time to look for player updates and this causes the '/who' run by GuildColors to often return nil.
        if numWhos > 0 then
          for i=1, numWhos, 1 do
            WhoColor_Class() -- commenting out for the time being. this method needs to be fixed
          end
        end
      end
    
    end;
    
    hooksecurefunc("FriendsList_Update", FriendColor_Hook_FriendsList_Update);
    hooksecurefunc("HybridScrollFrame_Update", FriendColor_Hook_FriendsList_Update);
    hooksecurefunc("GuildStatus_Update", FriendColor_Hook_FriendsList_Update);
    hooksecurefunc("WhoList_Update", FriendColor_Hook_FriendsList_Update);    
  end
end