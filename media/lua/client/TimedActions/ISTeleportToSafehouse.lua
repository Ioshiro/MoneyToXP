require "TimedActions/ISBaseTimedAction"

ISTeleportToSafehouse = ISBaseTimedAction:derive("ISTeleportToSafehouse");

function ISTeleportToSafehouse:isValid()
    return self.character:getHoursSurvived() < 6
end


function ISTeleportToSafehouse:update()
end

function ISTeleportToSafehouse:stop()
    self.character:setReading(false);
    ISBaseTimedAction.stop(self);
end

function ISTeleportToSafehouse:start()
    self:setAnimVariable("ReadType", "newspaper")
    self:setActionAnim(CharacterActionAnims.Read);
    self.character:setReading(true)
end

function ISTeleportToSafehouse:perform()
    self.character:setX(self.safehouse:getX());
    self.character:setY(self.safehouse:getY());
    self.character:setZ(0);
    print("teleporting to x:"..self.safehouse:getX()..",y:"..self.safehouse:getY())
    --self.character:setLx(self.safehouse:getX());
    --self.character:setLy(self.safehouse:getY());
    --self.character:setLz(0);
    self.character:getInventory():Remove(self.ticket)
    ISBaseTimedAction.perform(self);
end

function ISTeleportToSafehouse:new(character, ticket, safehouse)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 50;
    o.ticket = ticket;
    o.safehouse = safehouse;
    o.forceProgressBar = true
    return o
end