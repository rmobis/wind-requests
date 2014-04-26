init start
	-- local SCRIPT_VERSION = '1.1.0'

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
		args = args:explode(';')
		table.map(args, string.trim)

		if comm then
			if not comm.leaderOnly or m.isleader then
				comm.action(table.unpack(args))
			end
		end
	end
init end