Tickets = {}

local function OnPlayerUpdate(player)
	if player and player:isAlive() then
		local ticket = getGameTime():getModData().ticket
		if ticket == nil then ticket = {} end
		if Tickets[player:getSteamID()] == 1 then 
			player:getInventory():AddItem("MoneyToXP.SafehouseTicket")
			ticket[player:getSteamID()] = 0
			getGameTime():getModData().ticket = ticket
			Tickets = ticket	
		end
		Events.OnPlayerUpdate.Remove(OnPlayerUpdate)
	end
end

local function OnPlayerDeath(player)
	local inv = player:getInventory()
	local item = inv:getItemFromType("MoneyToXP.SafehouseTicket")
	if item then 
		inv:RemoveOneOf("MoneyToXP.SafehouseTicket")
		local ticket = getGameTime():getModData().ticket
		if ticket == nil then ticket = {} end
		ticket[player:getSteamID()] = 1
		getGameTime():getModData().ticket = ticket
		Tickets = ticket
		--sendServerCommand("MTX", "AddTicket", player)
		Events.OnPlayerUpdate.Add(OnPlayerUpdate)
		--print(" ticket : ".. ticket[player:getSteamID()])
	end
end

local function OnServerCommand(module, command, arguments)
	if module == "MTX" then
		if command == "AddTicket" then
            local ticket = getGameTime():getModData().ticket
			if ticket == nil then ticket = {} end
			ticket[player:getSteamID()] = 1
			getGameTime():getModData().ticket = ticket
			Tickets = ticket
        end
	end
end



Events.OnServerCommand.Add(OnServerCommand)

Events.OnPlayerDeath.Add(OnPlayerDeath)