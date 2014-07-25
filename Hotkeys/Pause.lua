init start
	-- local SCRIPT_VERSION = '1.0.1'

	-- What settings should be paused/unpaused
	local settingsToggable = {
		Cavebot = true,
		Looting = true,
		Targeting = true,
		SpellHealer = false,
		PotionHealer = false,
		ConditionHealer = false,
		ManaTrainer = false
	}

	-- DO NOT EDIT BELOW THIS LINE --
init end

local curState = false
for k, v in pairs(settingsToggable) do
	curState = curState or (v and tobool(get(k .. '/Enabled')))
end

local newState = toyesno(not curState)
for k, v in pairs(settingsToggable) do
	if v then
		set(k .. '/Enabled', newState)
	end
end

-- Prevents multiple subsequent activations
wait(500)
