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
			local option = self.invMenu.context:addOption(getText("ContextMenu_Teleport"), player, nil, nil, nil);
            if player:getHoursSurvived() > 6 or not SafeHouse.hasSafehouse(player) then
                option.notAvailable = true
                return;
            end
            
            local safehouseOwnerFound = false
            local playerUsername = player:getUsername()
            local subMenuSafes = ISContextMenu:getNew(self.invMenu.context);
            self.invMenu.context:addSubMenu(option, subMenuSafes);
            for i=0,SafeHouse.getSafehouseList():size()-1 do
                local safehouse = SafeHouse.getSafehouseList():get(i);
                if safehouse:getOwner() == playerUsername then
                    subMenuSafes:addOption(safehouse:getTitle(), player, self.teleportToSafehouse, safehouse);
                    safehouseOwnerFound = true
                end
            end
            if not safehouseOwnerFound then
                option.notAvailable = true
            end
        end
    end

    function self.teleportToSafehouse( _p, _s)
        local ticket = self.invMenu.inventory:getItemFromType("MoneyToXP.SafehouseTicket")
		if ticket == nil then return end
        if _s == nil then return end
        local x,y, z = _s:getX(), _s:getY(), 0
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
