init start
	-- local SCRIPT_VERSION = '1.1.0'

	local filename = 'Loot - ' .. $name .. '.txt'
	local hideEmpty = false

	-- DO NOT EDIT BELOW THIS LINE --
init end

auto(1000)

local handler = nil
foreach newmessage m do
	if m.type == MSG_INFO then
		local _, loot = m.content:match(REGEX_LOOT)

		if loot and (not hideEmpty or loot ~= 'nothing') then
			if handler == nil then
				handler = io.open(filename, 'a+')
			end

			handler:write(os.date('%H:%M') .. ' ' .. m.content .. '\n')
		end
	end
end

if handler ~= nil then
	handler:close()
end