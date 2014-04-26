init start
	-- local SCRIPT_VERSION = '1.0.0'

	-- Creatures counted; empty array means any creature
	local creatures    = {'Serpent Spawn', 'Hydra'}

	-- Minimum amount of creatures to change heal rule
	local minCreatures = 1

	-- The full path to the heal rule to be changed
	local rulePath     = 'SpellHealer/Rules/NewHealRule'

	-- The value for when there are less creatures on screen then what was set
	-- up on `minCreatures` variable. NOTE: This is a range; eg: {50, 55} means
	-- '50 to 55'.
	local defaultValue = {50, 55}

	-- The value for when there are at least the same amount of creatures on
	--screen then what was set up on `minCreatures` variable. NOTE: This is a
	-- range; eg: {90, 95} means '90 to 95'.
	local safeValue    = {90, 95}

	-- DO NOT EDIT BELOW THIS LINE --
	table.lower(creatures)
	rulePath = string.finish(rulePath, '/ConditionValue')

init end

auto(100)
local value = tern(maround(creatures) < minCreatures, defaultValue, safeValue)
set(rulePath, ('%d x %d'):format(value[1], value[2]))