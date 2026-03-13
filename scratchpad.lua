--[[
My LUA acratchpad
]]

local scopeCheck = "scratchpad.lua"


function MultiTool:CreateDefaultTextAreas()
	self:debugMsg("CreateDefaultTextAreas(...)")
	
	local logFrame = CreateFrame("Frame", "MultToolLog", UIParent, "BasicFrameTemplateWithInset")
	--local logFrame = CreateFrame("ScrollFrame", "MultiToolLoggingFrame", UIParent, "UIPanelScrollFrameTemplate")
	logFrame:SetSize(500, 350)
	logFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	logFrame.TitleBg:SetHeight(30)
	logFrame.title = logFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	logFrame.title:SetPoint("TOPLEFT", logFrame.TitleBg, "TOPLEFT", 5, -3)
	logFrame.title:SetText("MultiTool Log")
	logFrame:Hide()
	
	logFrame:EnableMouse(true)
	logFrame:SetMovable(true)
	logFrame:RegisterForDrag("LeftButton")
	logFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	logFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	
	logFrame:SetScript("OnShow", function()
	        PlaySound(808)
	end)
	
	logFrame:SetScript("OnHide", function()
	        PlaySound(808)
	end)

	
--	local panel = CreateFrame("Frame")
--	panel.name = "MyAddOn"
--	--InterfaceOptions_AddCategory(panel)
	
	-- Create the scrolling parent frame and size it to fit inside the texture
	local scrollFrame = CreateFrame("ScrollFrame", nil, logFrame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 3, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)
	
	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local scrollChild = CreateFrame("Frame")
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(logFrame:GetWidth()-18)
	scrollChild:SetHeight(1)
	
	---- Add widgets to the scrolling child frame as desired
	--local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	--title:SetPoint("TOP")
	--title:SetText("MyAddOn")
	--
	--local footer = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
	--footer:SetPoint("TOP", 0, -5000)
	--footer:SetText("This is 5000 below the top, so the scrollChild automatically expanded.")
	--
	
	local logTextArea = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
	logTextArea:SetPoint("TOP", 0)
	logTextArea:SetText("Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. It is typically a corrupted version of De finibus bonorum et malorum, a 1st-century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin. The first two words are the truncation of dolorem ipsum. More at WikipediaSuscipit numquam doloribus qui voluptate consequatur quod. Voluptatem dolorem qui ex nam. Vel eaque dolor et sit maiores temporibus corrupti voluptatibus. Quia voluptates in dicta dolor dolorem. Temporibus et quibusdam sunt expedita nesciunt qui expedita. Nemo consequatur facilis et temporibus odit sunt. Vel nostrum corporis omnis corrupti tempore esse. Distinctio sapiente eaque ab dolores laborum. Praesentium aut voluptatem vero ullam ut aut. Voluptatem sunt in est. Explicabo voluptatibus facilis animi voluptatem. Aut recusandae quod deleniti quae unde quia quod sunt. Eligendi quo deleniti excepturi pariatur alias quibusdam et. Accusantium non aperiam excepturi accusamus nesciunt velit. Ullam reprehenderit dicta dolorum consequatur magnam. Consequuntur voluptatibus numquam voluptas tenetur. Id harum sint sed qui quod praesentium. Pariatur aperiam quasi accusamus et sed a fugiat. Adipisci et ipsum expedita. Enim praesentium ut placeat animi blanditiis voluptatum eos. In quasi architecto nisi dolores perspiciatis quibusdam magnam. Voluptatem nam ratione tempore praesentium necessitatibus. Vel nisi dolorem molestiae eum ad necessitatibus voluptatem omnis. Similique est corrupti accusamus labore eum saepe unde.")

	logFrame:Show()
end


--function InitTrig_Create_TextAreaTemplates takes nothing returns nothing
--    call BlzLoadTOCFile( "war3mapImported\\Templates.toc" )
--    call TimerStart(CreateTimer(), 0.0, false, function CreateDefaultTextAreas)
--endfunction


function MultiTool:MoreTest()
	
	local scrollFrame = CreateFrame("ScrollFrame", "MultiTollScroll", logFrame, "UIPanelScrollFrameTemplate")
	--scrollFrame:SetPoint("TOPLEFT", logFrame, "TOPLEFT", 16, -36)
	--scrollFrame:SetPoint("BOTTOMRIGHT", logFrame, "TOPRIGHT", -24, 8)
	
	
	local logTextArea = CreateFrame("EditBox", "MultiToolText", scrollFrame)
	logTextArea:SetTextColor(0.5, 0.5, 0.5, 1)
	logTextArea:SetAutoFocus(false)
	logTextArea:SetMultiLine(true)
	logTextArea:SetFontObject(GameFontHighlightSmall)
	logTextArea:SetMaxLetters(99999)
	logTextArea:EnableMouse(true)
	logTextArea:SetScript("OnEscapePressed", logTextArea.ClearFocus)
	logTextArea:SetWidth(500)
	
	scrollFrame:SetScrollChild(logTextArea)
	
	logTextArea:SetText("orem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. It is typically a corrupted version of De finibus bonorum et malorum, a 1st-century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin. The first two words are the truncation of dolorem ipsum. More at WikipediaSuscipit numquam doloribus qui voluptate consequatur quod. Voluptatem dolorem qui ex nam. Vel eaque dolor et sit maiores temporibus corrupti voluptatibus. Quia voluptates in dicta dolor dolorem. Temporibus et quibusdam sunt expedita nesciunt qui expedita. Nemo consequatur facilis et temporibus odit sunt. Vel nostrum corporis omnis corrupti tempore esse. Distinctio sapiente eaque ab dolores laborum. Praesentium aut voluptatem vero ullam ut aut. Voluptatem sunt in est. Explicabo voluptatibus facilis animi voluptatem. Aut recusandae quod deleniti quae unde quia quod sunt. Eligendi quo deleniti excepturi pariatur alias quibusdam et. Accusantium non aperiam excepturi accusamus nesciunt velit. Ullam reprehenderit dicta dolorum consequatur magnam. Consequuntur voluptatibus numquam voluptas tenetur. Id harum sint sed qui quod praesentium. Pariatur aperiam quasi accusamus et sed a fugiat. Adipisci et ipsum expedita. Enim praesentium ut placeat animi blanditiis voluptatum eos. In quasi architecto nisi dolores perspiciatis quibusdam magnam. Voluptatem nam ratione tempore praesentium necessitatibus. Vel nisi dolorem molestiae eum ad necessitatibus voluptatem omnis. Similique est corrupti accusamus labore eum saepe unde.")
end


function MultiTool:FnordTest()
	self:debugMsg("FnordTest(...)")
	self:debugMsg("IsFriend? ", "info")
	local fname = "charname-server"
	
	local numBNetTotal, numBNetOnline, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()
	self:debugMsg("GetNumFriends(...)")
	self:debugMsg("  numBNetTotal: " .. tostring(numBNetTotal), "debug")
	self:debugMsg("  numBNetOnline: " .. tostring(numBNetOnline), "debug")
	self:debugMsg("  numBNetFavorite: " .. tostring(numBNetFavorite), "debug")
	self:debugMsg("  numBNetFavoriteOnline: " .. tostring(numBNetFavoriteOnline), "debug")

	--for i = 1, BNGetNumFriends() do
	for i = 1, 1 do
		local acct = C_BattleNet.GetFriendAccountInfo(i)
		self:debugMsg("  bnetAccountID:" .. tostring(acct.bnetAccountID), "debug")
		self:debugMsg("  accountName:" .. tostring(acct.accountName), "debug")
		self:debugMsg("  battleTag:" .. tostring(acct.battleTag), "debug")
		self:debugMsg("  isFriend:" .. tostring(acct.isFriend), "debug")
		self:debugMsg("  lastOnlineTime:" .. tostring(acct.lastOnlineTime), "debug")
		self:debugMsg("  isAFK:" .. tostring(acct.isAFK), "debug")
		self:debugMsg("  isDND:" .. tostring(acct.isDND), "debug")
		self:debugMsg("  isFavorite:" .. tostring(acct.isFavorite), "debug")
		self:debugMsg("  appearOffline:" .. tostring(acct.appearOffline), "debug")
		self:debugMsg("  customMessage:" .. tostring(acct.customMessage), "debug")
		self:debugMsg("  customMessageTime:" .. tostring(acct.customMessageTime), "debug")
		self:debugMsg("  rafLinkType:" .. tostring(acct.rafLinkType), "debug")
		self:debugMsg("  note:" .. tostring(acct.note), "debug")

		local numGameAccts = C_BattleNet.GetFriendNumGameAccounts(i) 
		self:debugMsg("#### numGameAccts:" .. tostring(numGameAccts), "debug")

		for j = 0, numGameAccts do
			self:debugMsg("BNetGameAccountInfo ...", "debug")
			local BNetGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(i, j)
			--local BNetGameAccountInfo = BNetAccountInfo.
			if (BNetGameAccountInfo == nil) then
				self:debugMsg("BNetGameAccountInfo is nil ...", "debug")
			else
				self:debugMsg("  gameAccountID:" .. tostring(BNetGameAccountInfo.gameAccountID), "debug")
				self:debugMsg("  clientProgram:" .. tostring(BNetGameAccountInfo.clientProgram), "debug")
				self:debugMsg("  isOnline:" .. tostring(BNetGameAccountInfo.isOnline), "debug")
				self:debugMsg("  isGameBusy:" .. tostring(BNetGameAccountInfo.isGameBusy), "debug")
				self:debugMsg("  characterName:" .. tostring(BNetGameAccountInfo.characterName), "debug")
				self:debugMsg("  isGameAFK:" .. tostring(BNetGameAccountInfo.isGameAFK), "debug")
				self:debugMsg("  wowProjectID:" .. tostring(BNetGameAccountInfo.wowProjectID), "debug")
				self:debugMsg("  characterName:" .. tostring(BNetGameAccountInfo.characterName), "debug")
				self:debugMsg("  realmName:" .. tostring(BNetGameAccountInfo.realmName), "debug")
				self:debugMsg("  realmDisplayName:" .. tostring(BNetGameAccountInfo.realmDisplayName), "debug")
				self:debugMsg("  realmID:" .. tostring(BNetGameAccountInfo.realmID), "debug")
				self:debugMsg("  characterName:" .. tostring(BNetGameAccountInfo.characterName), "debug")
			end
		end
	end
end