local _, e = ...

if not AstralAffixes then 
	AstralAffixes = {}
	AstralAffixes[1] = 0
	AstralAffixes[2] = 0
	AstralAffixes[3] = 0
end

local GRAY = 'ff9d9d9d'
local PURPLE = 'ffa335ee'

local function Weekly10()
	e.GetBestClear()
	if AstralCharacters[e.CharacterID()].level >= 10 then
		SendAddonMessage('AstralKeys', 'updateWeekly 1')
	end
	e.UpdateCharacterFrames()
end

local function InitData()
	if UnitLevel('player') ~= 110 then return end
	e.GetBestClear()
	e.SetCharacterID()
	e.UpdateGuildList()
	e.FindKeyStone(true, false, true)
	e.BuildMapTable()
	SendAddonMessage('AstralKeys', 'request', 'GUILD')

	e.UnregisterEvent('CHALLENGE_MODE_MAPS_UPDATE')
	e.RegisterEvent('CHALLENGE_MODE_MAPS_UPDATE', Weekly10)
end
e.RegisterEvent('CHALLENGE_MODE_MAPS_UPDATE', InitData)

--[[
e.RegisterEvent('CHALLENGE_MODE_MAPS_UPDATE', function()
	if UnitLevel('player') ~= 110 then return end
	e.GetBestClear()
 	if not init then
		e.SetCharacterID()
 		e.UpdateGuildList()
 		e.FindKeyStone(true, false)
 		e.BuildMapTable()
 		SendAddonMessage('AstralKeys', 'request', 'GUILD')
 		init = true
 	end

 	if AstralKeys[e.PlayerID()]['weeklyCache'] == 0 then
		if AstralCharacters[e.CharacterID()].level >= 10 then
			SendAddonMessage('AstralKeys', 'updateWeekly 1')
			e.UpdateCharacterFrames()
		end
	end
 end)]]

function e.CreateKeyLink(index)
	local s = '|cffa335ee'
	local mapID, keyLevel, a1, a2, a3 = AstralKeys[index].map, AstralKeys[index].level, AstralKeys[index].a1, AstralKeys[index].a2, AstralKeys[index].a3

	--s = s .. PURPLE

	s = s .. '|Hkeystone:' .. mapID .. ':' .. keyLevel .. ':' .. a1 .. ':' .. a2 .. ':' .. a3 .. '|h[Keystone: ' .. e.GetMapName(mapID) .. ']|h|r'
	s = s:gsub('\124\124', '\124')

	return s, keyLevel
end

e.RegisterEvent('CHALLENGE_MODE_COMPLETED', function()
	C_Timer.After(3, function() e.FindKeyStone(true, true) end)
end)

local function CompletedWeekly()
	if not e.CharacterID() then return 0 end
	if AstralCharacters[e.CharacterID()]['level'] then
	 if AstralCharacters[e.CharacterID()].level >= 15 then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

function e.SetAffix(affixNumber, affixID)
	AstralAffixes[affixNumber] = affixID
end

function e.GetAffix(affixNumber)
	return AstralAffixes[affixNumber]
end

function e.FindKeyStone(sendUpdate, anounceKey)
	local mapID, keyLevel, a1, a2, a3, s, itemID, delink, link
	local s = ''

	for bag = 0, NUM_BAG_SLOTS + 1 do
		for slot = 1, GetContainerNumSlots(bag) do
			itemID = GetContainerItemID(bag, slot)
			if (itemID and itemID == 138019) then
				link = GetContainerItemLink(bag, slot)
				mapID, keyLevel, a1, a2, a3 = e.ParseLink(link)
				s = 'updateV4 ' .. e.PlayerName() .. ':' .. e.PlayerClass() .. ':' .. e.PlayerRealm() ..':' .. mapID .. ':' .. keyLevel  .. ':' .. a1 .. ':' .. a2 .. ':' .. a3 .. ':' .. CompletedWeekly()
				--s = 'updateV4 CHARACTERSAZ:DEMONHUNTER:Bleeding Hollow:201:22:1:13:13:10:16:1'				
			end
		end
	end

	if not link then
		if not e.IsEventRegistered('CHAT_MSG_LOOT') then
			e.RegisterEvent('CHAT_MSG_LOOT', function(...)
				local msg = ...
				local sender = select(5, ...)
				if not sender == e.PlayerName() then return end

				if string.lower(msg):find('keystone') then
					e.RegisterEvent('BAG_UPDATE', function()
						e.FindKeyStone(true, true)
						e.UnregisterEvent('BAG_UPDATE')
						e.UnregisterEvent('CHAT_MSG_LOOT')
						end)
				end
			end)
		end
	end

	local oldMap, oldLevel = e.GetUnitKeyByID(e.PlayerID())
	if tonumber(oldMap) == tonumber(mapID) and tonumber(oldLevel) == tonumber(keyLevel) then return end

	if link and e.IsEventRegistered('BAG_UPDATE') then
		e.UnregisterEvent('BAG_UPDATE')
	end

	if sendUpdate  and s ~= '' then
		if IsInGuild() then
			SendAddonMessage('AstralKeys', s, 'GUILD')
		else
			local foundPlayer = false
			for i = 1, #AstralKeys do
				if AstralKeys[i].name == e.PlayerName() then
					foundPlayer = true
					if AstralKeys[i].level < tonumber(keyLevel) then
						AstralKeys[i].map = tonumber(mapID)
						AstralKeys[i].level = tonumber(keyLevel)
						AstralKeys[i].a1 = tonumber(a1)
						AstralKeys[i].a2 = tonumber(a2)
						AstralKeys[i].a3 = tonumber(a3)
					end
				end
			end

			if not foundPlayer then
				AstralKeys[#AstralKeys + 1] = {
				['name'] = e.PlayerName(),
				['class'] = e.PlayerClass(),
				['realm'] = e.PlayerRealm(),
				['map'] = tonumber(mapID),
				['level'] = tonumber(keyLevel),
				['a1'] = tonumber(a1),
				['a2'] = tonumber(a2),
				['a3'] = tonumber(a3),
				}
<<<<<<< HEAD
				e.SetUnitID(e.PlayerName(), e.PlayerRealm(), #AstralKeys)
=======
				e.SetUnitID(e.PlayerName() .. '-' ..  e.PlayerRealm(), #AstralKeys)
>>>>>>> refs/remotes/origin/master
			end
		end
	end
	if anounceKey then
		e.AnnounceNewKey(link, keyLevel)
	end
end

<<<<<<< HEAD
local function CreateKeyText(mapID, level)
	return level .. ' ' .. C_ChallengeMode.GetMapInfo(mapID)
=======
local function CreateKeyText(mapID, level, usable)
	if not usable then
		return level .. ' ' .. C_ChallengeMode.GetMapInfo(mapID)
	else
		if tonumber(usable) == 0 then
			return WrapTextInColorCode(level .. ' ' .. C_ChallengeMode.GetMapInfo(mapID), 'ff9d9d9d')
		else
			return level .. ' ' .. C_ChallengeMode.GetMapInfo(mapID)
		end
	end
>>>>>>> refs/remotes/origin/master
end

-- Parses item link to get mapID, key level, affix1, affix2, affix3
-- @param link Item Link for keystone
-- return mapID, keyLevel, affix1, affix2, affix3 Integer values

function e.ParseLink(link)
	if not link:find('keystone') then return end -- Not a keystone link, don't do anything
	local delink = link:gsub('\124', '\124\124')
	local mapID, keyLevel, affix1, affix2, affix3 = delink:match(':(%d+):(%d+):(%d+):(%d+):(%d+)')
	return mapID, keyLevel, affix1, affix2, affix3
end

function e.GetUnitKeyByID(id)
	if not id or (id < 1 ) then return end

	return AstralKeys[id]['map'], AstralKeys[id]['level']
end

function e.GetCharacterKey(unit)
	if not unit then return '' end

	for i = 1, #AstralKeys do
		if AstralKeys[i].name == unit then
			return CreateKeyText(AstralKeys[i].map, AstralKeys[i].level)
		end
	end

	return WrapTextInColorCode('No key found.', 'ff9d9d9d')

end

function e.GetBestKey(id)
	return AstralCharacters[id].level
end

function e.GetBestMap(unit)

	for i = 1, #AstralCharacters do
		if AstralCharacters[i].name == unit then
			if AstralCharacters[i].map ~= 0 then
				return e.GetMapName(AstralCharacters[i].map)
			end
		end
	end
	
	return 'No mythic+ ran this week.'
end

--Returns map ID and keystone level run for current week

function e.GetBestClear()
	if UnitLevel('player') ~= 110 then return end
	local bestLevel = 0
	local bestMap = 0
	for _, v in pairs(C_ChallengeMode.GetMapTable()) do
		local _, _, weeklyBestLevel = C_ChallengeMode.GetMapPlayerStats(v)
		if weeklyBestLevel then
			if weeklyBestLevel > bestLevel then
				bestLevel = weeklyBestLevel
				bestMap = v
			end
		end
	end

	if #AstralCharacters == 0 then
		table.insert(AstralCharacters, {name = e.PlayerName(), class = e.PlayerClass(), realm = e.PlayerRealm(), map = bestMap, level = bestLevel, knowledge = e.GetAKBonus(e.ParseAKLevel())})
	end

	local index = -1
	for i = 1, #AstralCharacters do
		if AstralCharacters[i]['name'] == e.PlayerName() and AstralCharacters[i].realm == e.PlayerRealm() then
			AstralCharacters[i].map = bestMap
			AstralCharacters[i].level = bestLevel
			index = i
		end
	end

	if index == -1 then
		table.insert(AstralCharacters, {name = e.PlayerName(), class = e.PlayerClass(), realm = e.PlayerRealm(), map = bestMap, level = bestLevel, knowledge = e.GetAKBonus(e.ParseAKLevel())})
	end
end