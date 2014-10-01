init start
	-- local SCRIPT_VERSION = '1.1.2'

	local commands = {
		sd = {
			leaderOnly = true,
			action     = function(id)
				useoncreature(3155, getcreaturebyid(id))
				waitping()
			end
		}
	}

	function navmessages(m)
		local comm, args = m.message:match('(.-):(.+)')
		comm = commands[comm]

		if comm then
			args = args:explode(';')
			table.map(args, function(arg) return string.trim(arg) end)
	
			if m.isleader or not comm.leaderOnly then
				comm.action(table.unpack(args))
			end
		end
	end
init end
