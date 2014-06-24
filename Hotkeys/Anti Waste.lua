init start
	-- local SCRIPT_VERSION = '1.0.0'

	local potName = 'mana potion'
	local minCount = 100

	-- DO NOT EDIT BELOW THIS LINE --

	-- NOTE: Because $trapped requires targeting to be enabled, this script also
	-- does.
init end

auto(100)
if itemcount(potName) < minCount and $trapped and $pattacker.id ~= 0 then
	xlog()
end