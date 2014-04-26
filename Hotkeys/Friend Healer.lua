init start
	-- local SCRIPT_VERSION = '1.0.0'

	-- Friends to heal
	local friends = {
		'Cachero',
		'Bubble'
	}

	local healHPPC = 100 -- Minimum HPPC to heal
	local minHPPC = 30 -- Minimum HPPC you should have to heal
	local minMPPC = 30 -- Minimum MPPC you should have to heal

	-- DO NOT EDIT BELOW THIS LINE --

	table.lower(friends)
init end

auto(100)

if $hppc >= minHPPC and $mppc >= minMPPC then
	foreach creature m 'pt' do
		if m.hppc < healHPPC and table.find(friends, m.name:lower()) then
			cast('exura sio "' .. m.name:lower())
			waitping()
			return
		end
	end
end