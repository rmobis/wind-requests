init start
	-- local SCRIPT_VERSION = '1.0.1'

	local minAmount = 30 -- Minimum amount to drop

	-- DO NOT EDIT BELOW THIS LINE --
	local randMinAmount = minAmount
init end

auto(1000, 3000)
dontlist()

if flasks() >= randMinAmount then
	if maround() ~= 0 then
		wait(500, 1000)
	else
		pausewalking(10000)

		for i = 283, 285 do
			if itemcount(i) > 0 then
				moveitems(i, 'ground')
				waitping()
			end
		end

		pausewalking(0)
	end

	randMinAmount = math.random(minAmount - 5, minAmount + 5)
end