local _, e = ...

local unitList = {}
local guildList = {}
local playerID -- Store's player's for quicker access to self data

-- Puts all guild member's into a table for checking if unit in same guild

local function UpdateGuildList()
	wipe(guildList)
	local name
	for i = 1, GetNumGuildMembers() do
		name = GetGuildRosterInfo(i)
		if not name then return end
		guildList[name] = true
	end
end

-- Checks to see if a unit is in the player's guild
-- @param unit Unit name and server
function e.UnitInGuild(unit)
	return guildList[unit] or false
end

-- Sets a number to a unit for quicker access to table
-- @param unit  Unit name and server
-- @param unitID integer value
function e.SetUnitID(unit, unitID)
	unitList[unit] = unitID
end

-- Retrieves ID number for associated unit
-- @param unit Unit name and server
function e.UnitID(unit)
	return unitList[unit] or false
end

-- Set player's unitID
function e.SetPlayerUnitID()
	playerID = e.UnitID(string.format('%s-%s', e.PlayerName(), e.PlayerRealm()))
end

-- Retrieves player's id number
-- @return int ID number for player in character table
function e.PlayerID()
	return playerID
end


-- Clears unit list
function e.WipeUnitList()
	wipe(unitList)
end

-- Retrieves unit's realm from unit string
-- @param id int for unit
function e.UnitRealm(id)
	return AstralKeys[id][1]:sub(AstralKeys[id][1]:find('-') + 1)
end

-- Returns Character name with server name removed
-- @param id int ID number for unit
-- @return Unit name with server name removed
function e.UnitName(index)
	return Ambiguate(AstralKeys[index][1], 'GUILD')
end

--Gets unit class from saved variables
-- @param id int ID number for the unit
function e.UnitClass(id)
	return AstralKeys[id][2]
end

AstralEvents:Register('GUILD_ROSTER_UPDATE', UpdateGuildList, 'guildUpdate')