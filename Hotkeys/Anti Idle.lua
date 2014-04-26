init start
	-- local SCRIPT_VERSION = '1.0.0'

	local lastStand = $standtime
	local randTime = math.random(300000, 600000)
init end

auto(100)

if $standtime < lastStand then
	lastStand = $standtime
end

if $standtime - lastStand > randTime then
	local dirs = {'n', 'e', 's', 'w'}

	-- Makes sure it's random and not the same we're facing right now
	table.remove(dirs, table.find(dirs, $self.dir))
	turn(dirs[math.random(1, 3)])
	waitping()

	lastStand = $standtime
	randTime = math.random(300000, 600000)
end