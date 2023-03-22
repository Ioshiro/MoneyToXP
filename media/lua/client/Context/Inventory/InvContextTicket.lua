ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextTicket()
    local self 					= ISMenuElement.new();
    self.invMenu			    = ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu( _item )
        if _item:getType() == "SafehouseTicket" then
            if _item:getContainer() ~= self.invMenu.inventory then
                return;
			end
            local player = getPlayer()
			local subOption= self.invMenu.context:addOption(getText("ContextMenu_Teleport"), player, self.teleportToSafehouse);
            if player:getHoursSurvived() > 6 or not SafeHouse.hasSafehouse(player) then
                subOption.notAvailable = true
            end
        end
    end

    function self.teleportToSafehouse( _p)
		local safehouse = SafeHouse.hasSafehouse(_p)
        local ticket = self.invMenu.inventory:getItemFromType("MoneyToXP.SafehouseTicket")
		if ticket == nil then return end
        if safehouse == nil then return end
        local x,y, z = safehouse:getX(), safehouse:getY(), 0
        _p:setX(tonumber(x));
        _p:setY(tonumber(y));
        _p:setZ(tonumber(z));
        _p:setLx(tonumber(x));
        _p:setLy(tonumber(y));
        _p:setLz(tonumber(z));
        _p:getInventory():Remove(ticket)
	end
	return self;
end
