init start
	-- local SCRIPT_VERSION = '1.0.0'

	local goldIds = {itemid('gold coin'), itemid('platinum coin')}
init end

auto(200, 300)

local cont, item
for i = 0, 15 do
	cont = getcontainer(i)

	if cont.isopen then
		for j = 0, cont.itemcount do
			item = cont.item[j]

			if item.count == 100 and table.find(goldIds, item.id) then
				useitem(item.id, i, j)
				waitping()
			end
		end
	end
end