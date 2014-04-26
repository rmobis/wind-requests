init start
	-- local SCRIPT_VERSION = '1.0.1'

	local charList = {
		{'account1', 'password1', 'char1', 'skill1'},
		{'account2', 'password2', 'char2', 'skill2'},
		{'account3', 'password3', 'char3', 'skill3'},
		{'account4', 'password4', 'char4', 'skill4'},
		{'account5', 'password5', 'char5', 'skill5'},
		{'account6', 'password6', 'char6', 'skill6'},
		{'account7', 'password7', 'char7', 'skill7'}
	}

	-- DO NOT EDIT BELOW THIS LINE --
	local skills = {'sword', 'axe', 'club', 'distance', 'magic'}
	local randTime = math.random(-110, 10)
	for i, v in ipairs(charList) do
		table.insert(charList[i], $botdb:getvalue('offtrainlast', v[3]) or 0)
		table.insert(charList[i], $botdb:getvalue('offtraintime', v[3]) or 0)
	end
init end

auto(10000, 30000)
for _, v in ipairs(charList) do
	if (os.time() - v[5]) / 60 > v[6] + (12 * 60) + randTime then
		randTime = math.random(-110, 10)

		connect(v[1], v[2], v[3])
		waitping()
		v[5] = os.time()
		v[6] = $offlinetraining
		$botdb:setvalue('offtrainlast', v[3], v[5])
		$botdb:setvalue('offtraintime', v[3], v[6])
		if $offlinetraining > 10 then
			local id = 16197 + table.find(skills, v[4])
			reachgrounditem(id)
			wait(200, 500)
			useitem(id, 'ground')
		else
			logout()
		end

		wait(1000, 1500)
		press('[ESC]')
		wait(1000, 1500)
	end
end