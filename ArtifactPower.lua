local _, e = ...

local DUNGEON_TABLE = {}
local WEEKLY_AP = {}

--[[
RUSSIAN
Upper Kara   Верхний Каражан
Lower Kara   Нижний Каражан
]]
DUNGEON_TABLE[197] = {}
--DUNGEON_TABLE[197]['enUS']
--DUNGEON_TABLE[197]['ptBR']
--DUNGEON_TABLE[197]['deDE']
--DUNGEON_TABLE[197]['frFR']
--DUNGEON_TABLE[197]['esMX']
--DUNGEON_TABLE[197]['ruRU']

DUNGEON_TABLE[197]['name'] = 'Eye of Azshara'
DUNGEON_TABLE[198] = {}
DUNGEON_TABLE[198]['name'] = 'Darkheart Thicket'
DUNGEON_TABLE[199] = {}
DUNGEON_TABLE[199]['name'] = 'Black Rook Hold'
DUNGEON_TABLE[200] = {}
DUNGEON_TABLE[200]['name'] = 'Halls of Valor'
DUNGEON_TABLE[206] = {}
DUNGEON_TABLE[206]['name'] = 'Neltharion\'s Lair'
DUNGEON_TABLE[207] = {}
DUNGEON_TABLE[207]['name'] = 'Vault of the Wardens'
DUNGEON_TABLE[208] = {}
DUNGEON_TABLE[208]['name'] = 'Maw of Souls'
DUNGEON_TABLE[209] = {}
DUNGEON_TABLE[209]['name'] = 'The Arcway'
DUNGEON_TABLE[210] = {}
DUNGEON_TABLE[210]['name'] = 'Court of Stars'
DUNGEON_TABLE[227] = {}
DUNGEON_TABLE[227]['name'] = 'Return to Karazhan: Lower'
DUNGEON_TABLE[233] = {}
DUNGEON_TABLE[233]['name'] = 'Cathedral of Eternal Night'
DUNGEON_TABLE[234] = {}
DUNGEON_TABLE[234]['name'] = 'Return to Karazhan: Upper'
DUNGEON_TABLE[239] = {}
DUNGEON_TABLE[239]['name'] = 'Seat of the Triumvirate'

--[[
Times
	-1440
	> 1440
	< 2700
	>2700
 Tier 1 Lvl 2 -3
 	-Maw 175
 	-Other 300
 	-HoV, Arc 375

 Tier 2 Lvl 4-6
 	- 290
 	- 475
 	- 600

 Tier 3 Lvl 7-9
 	-325
 	-540
 	-675

 Tier 4 10-14
 	-465
 	-775
 	-1000

 Tier 5 lvl 15+
 	-725
 	-1200
 	-1500
]]

function e.BuildMapTable()
	for map in pairs(DUNGEON_TABLE) do
		local name, mapID, runTime = C_ChallengeMode.GetMapInfo(map)
		local a, b, c = runTime, runTime * .8, runTime * .6
		DUNGEON_TABLE[map]['name'] = name
		DUNGEON_TABLE[map]['chestTimes'] = {}
		DUNGEON_TABLE[map].chestTimes[1] = a
		DUNGEON_TABLE[map].chestTimes[2] = b
		DUNGEON_TABLE[map].chestTimes[3] = c
		DUNGEON_TABLE[map]['apTier'] = {}
		if runTime == 1440 then
			DUNGEON_TABLE[map].apTier[1] = 175	-- 2-3
			DUNGEON_TABLE[map].apTier[2] = 290	-- 4-6
			DUNGEON_TABLE[map].apTier[3] = 325	-- 7-9
			DUNGEON_TABLE[map].apTier[4] = 465	-- 10-14
			DUNGEON_TABLE[map].apTier[5] = 725	-- 15-19
			DUNGEON_TABLE[map].apTier[6] = 1025	-- 20-25
			DUNGEON_TABLE[map].apBonus   = 50	-- 10+
		elseif runTime > 1440 and runTime < 2700 then
			DUNGEON_TABLE[map].apTier[1] = 300
			DUNGEON_TABLE[map].apTier[2] = 475
			DUNGEON_TABLE[map].apTier[3] = 540
			DUNGEON_TABLE[map].apTier[4] = 775
			DUNGEON_TABLE[map].apTier[5] = 1200
			DUNGEON_TABLE[map].apTier[6] = 1700
			DUNGEON_TABLE[map].apBonus   = 100
		elseif runTime == 2700 then
			DUNGEON_TABLE[map].apTier[1] = 375
			DUNGEON_TABLE[map].apTier[2] = 600
			DUNGEON_TABLE[map].apTier[3] = 675
			DUNGEON_TABLE[map].apTier[4] = 1000
			DUNGEON_TABLE[map].apTier[5] = 1500
			DUNGEON_TABLE[map].apTier[6] = 2125
			DUNGEON_TABLE[map].apBonus   = 125
		end
	end
end


function e.GetMapName(mapID)
	return DUNGEON_TABLE[tonumber(mapID)]['name']
end

local function GetMapTime(mapID, chestCount)
	return DUNGEON_TABLE[mapID].chestTimes[chestCount]
end

local function GetKeyTier(keyLevel)
	if keyLevel < 4 then return 1 end
	if keyLevel > 3 then
		if keyLevel < 7 then
			return 2
		elseif keyLevel < 10 then
			return 3
		elseif keyLevel < 15 then
			return 4
		elseif keyLevel < 20 then
			return 5
		else
			return 6
		end
	end
end

local function GetKeyBonusTokens(keyLevel)
	if keyLevel < 10 then
		return 0
	elseif keyLevel < 15 then
		return (keyLevel % 10)
	elseif keyLevel < 20 then
		return (keyLevel % 15)
	else
		return (keyLevel % 20)
	end
end

local function GetMapAP(mapID, keyLevel)
	return DUNGEON_TABLE[tonumber(mapID)]['apTier'][GetKeyTier(tonumber(keyLevel))]
end

local function GetMapBonusAP(mapID)
	return DUNGEON_TABLE[tonumber(mapID)].apBonus
end

WEEKLY_AP[2] = 1250
WEEKLY_AP[3] = 1250
WEEKLY_AP[4] = 1925
WEEKLY_AP[5] = 1925
WEEKLY_AP[6] = 1925
WEEKLY_AP[7] = 2150
WEEKLY_AP[8] = 2150
WEEKLY_AP[9] = 2150
WEEKLY_AP[10] = 3125
WEEKLY_AP[11] = 3525
WEEKLY_AP[12] = 3925
WEEKLY_AP[13] = 4325
WEEKLY_AP[14] = 4725
WEEKLY_AP[15] = 5000
WEEKLY_AP[16] = 5400
WEEKLY_AP[17] = 5800
WEEKLY_AP[18] = 6200
WEEKLY_AP[19] = 6600
WEEKLY_AP[20] = 7000
WEEKLY_AP[21] = 7400
WEEKLY_AP[22] = 7800
-- Here be dragons!
WEEKLY_AP[23] = 8200
WEEKLY_AP[24] = 8600
WEEKLY_AP[25] = 9000
WEEKLY_AP[26] = 9400
WEEKLY_AP[27] = 9800
WEEKLY_AP[28] = 10200
WEEKLY_AP[29] = 10600
WEEKLY_AP[30] = 11000

function e.GetWeeklyAP(keyLevel)
	if keyLevel == 0 then return 0 end
	return WEEKLY_AP[keyLevel] or WEEKLY_AP[#WEEKLY_AP]
end

function e.MapApText(mapID, keyLevel)

	local amount = GetMapAP(mapID, keyLevel) * e.GetAKBonus()
	local bonusAmount = (GetMapBonusAP(mapID) * GetKeyBonusTokens(keyLevel)) * e.GetAKBonus()
	return e.ConvertToSI(amount + bonusAmount) .. ' AP'

end
