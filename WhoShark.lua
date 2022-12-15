-- AddOn specific variables
local nameStamp = "\124cff00ccffWhoShark\124r"

-- Saved variables local references
local WhoShark_playerNames = {}
local WhoShark_playerNamesCount = 0

-- Event handlers
local eventFrame = CreateFrame("frame", "eventFrame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:RegisterEvent("WHO_LIST_UPDATE")

FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")

-- Functions
-- Function: Event handler for the
function eventFrame:OnEvent(event)
   if event == "PLAYER_LOGIN" then
      if not WhoShark_CNT then
         WhoShark_CNT = 0
      end

      if not WhoShark_NAMES then
         WhoShark_NAMES = {}
      end

      WhoShark_playerNames = WhoShark_NAMES
      WhoShark_playerNamesCount = WhoShark_CNT

      print(nameStamp .. ": WhoShark is started!")
   elseif event == "PLAYER_LOGOUT" then
      -- Save local variables to the saved variables table
      WhoShark_SAVEDVAR1["playerNames"] = WhoShark_playerNames
      WhoShark_SAVEDVAR1["playerNamesCount"] = WhoShark_playerNamesCount
      FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
      print(nameStamp .. ": WhoShark is ready for shutdown!")
   elseif event == "WHO_LIST_UPDATE" then
      print(nameStamp .. ": WhoShark is updating player list!")
      _, totalCount = C_FriendList.GetNumWhoResults()

      for res = 1, totalCount, 1 do
         player = C_FriendList.GetWhoInfo(res)
         
         -- check if player is already in the list
         for idx = 1, WhoShark_playerNamesCount, 1 do
            if WhoShark_playerNames[idx] == player.fullName then
               -- player is already in the list
               break
            end
         end

         table.insert(WhoShark_playerNames, WhoShark_playerNamesCount, player.fullName)
         -- WhoShark_playerNames[WhoShark_playerNamesCount] = player.fullName
         WhoShark_playerNamesCount = WhoShark_playerNamesCount + 1
      end

      WhoShark_NAMES = WhoShark_playerNames
      WhoShark_CNT = WhoShark_playerNamesCount
   end
end

eventFrame:SetScript("OnEvent", eventFrame.OnEvent)
