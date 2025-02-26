require "ISUI/ISInventoryPaneContextMenu"
require "ISUI/ISToolTip"
require "TimedActions/ISBaseTimedAction"

local function onDroga(player, perk, droga)
    if not instanceof(droga[1], "InventoryItem") then
        droga = droga[1].items[1];
    else
        droga = droga[1]
    end
    droga:getModData().perk = perk
    ISInventoryPaneContextMenu.onEatItems({ droga }, 1, player)
end

local function OnFillInventoryObjectContextMenu(playerIndex, context, items)
    local player = getSpecificPlayer(playerIndex)
    local item;
    if not player then return end
    if not instanceof(items[1], "InventoryItem") then
        item = items[1].items[1];
    else
        item = items[1]
    end
    if not item then return end
    if not item:getFullType() then return end

    -- if the clicked item is not MoneyToXP.Droga+number then return
    if not item:getFullType():match("^MoneyToXP%.Droga%d+$") then return end

    local option = context:getOptionFromName(getText("ContextMenu_Eat"))
    if option then
        option.name = "Drogati"
        option.target = nil
        option.onSelect = nil
        option.param1 = nil
        option.param2 = nil
    else
        option = context:addOption("Drogati", player, nil, nil, nil)
    end

    if player:getMoodles():getMoodleLevel(MoodleType.FoodEaten) >= 3 and player:getNutrition():getCalories() >= 1000 then
        local tooltip = ISInventoryPaneContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("Tooltip_CantEatMore");
        option.toolTip = tooltip;
    else
        local subMenuSkills = ISContextMenu:getNew(context);
        context:addSubMenu(option, subMenuSkills);
        subMenuSkills:addOption("ContextMenu_Train_Axe", playerIndex, onDroga, Perks.Axe, items)
        subMenuSkills:addOption("ContextMenu_Train_Aim", playerIndex, onDroga, Perks.Aiming, items)
        subMenuSkills:addOption("ContextMenu_Train_Carpentry", playerIndex, onDroga, Perks.Woodwork, items)
        subMenuSkills:addOption("ContextMenu_Train_Cooking", playerIndex, onDroga, Perks.Cooking, items)
        subMenuSkills:addOption("ContextMenu_Train_Electrical", playerIndex, onDroga, Perks.Electricity, items)
        subMenuSkills:addOption("ContextMenu_Train_Farming", playerIndex, onDroga, Perks.Farming, items)
        subMenuSkills:addOption("ContextMenu_Train_First_Aid", playerIndex, onDroga, Perks.Doctor, items)
        subMenuSkills:addOption("ContextMenu_Train_Fishing", playerIndex, onDroga, Perks.Fishing, items)
        subMenuSkills:addOption("ContextMenu_Train_Fitness", playerIndex, onDroga, Perks.Fitness, items)
        subMenuSkills:addOption("ContextMenu_Train_Foraging", playerIndex, onDroga, Perks.PlantScavenging, items)
        subMenuSkills:addOption("ContextMenu_Train_Lightfoot", playerIndex, onDroga, Perks.Lightfoot, items)
        subMenuSkills:addOption("ContextMenu_Train_Long_Blade", playerIndex, onDroga, Perks.LongBlade, items)
        subMenuSkills:addOption("ContextMenu_Train_Maintenance", playerIndex, onDroga, Perks.Maintenance, items)
        subMenuSkills:addOption("ContextMenu_Train_Mechanics", playerIndex, onDroga, Perks.Mechanics, items)
        subMenuSkills:addOption("ContextMenu_Train_Metalworking", playerIndex, onDroga, Perks.MetalWelding, items)
        subMenuSkills:addOption("ContextMenu_Train_Nimble", playerIndex, onDroga, Perks.Nimble, items)
        subMenuSkills:addOption("ContextMenu_Train_Reloading", playerIndex, onDroga, Perks.Reloading, items)
        subMenuSkills:addOption("ContextMenu_Train_Short_Blade", playerIndex, onDroga, Perks.SmallBlade, items)
        subMenuSkills:addOption("ContextMenu_Train_Short_Blunt", playerIndex, onDroga, Perks.SmallBlunt, items)
        subMenuSkills:addOption("ContextMenu_Train_Long_Blunt", playerIndex, onDroga, Perks.Blunt, items)
        subMenuSkills:addOption("ContextMenu_Train_Sneak", playerIndex, onDroga, Perks.Sneak, items)
        subMenuSkills:addOption("ContextMenu_Train_Spear", playerIndex, onDroga, Perks.Spear, items)
        subMenuSkills:addOption("ContextMenu_Train_Sprinting", playerIndex, onDroga, Perks.Sprinting, items)
        subMenuSkills:addOption("ContextMenu_Train_Strength", playerIndex, onDroga, Perks.Strength, items)
        subMenuSkills:addOption("ContextMenu_Train_Trapping", playerIndex, onDroga, Perks.Trapping, items)
        subMenuSkills:addOption("ContextMenu_Train_Tailoring", playerIndex, onDroga, Perks.Tailoring, items)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(OnFillInventoryObjectContextMenu)


ISEatFoodAction = ISBaseTimedAction:derive("ISEatFoodAction");

function ISEatFoodAction:isValidStart()
    return self.character:getMoodles():getMoodleLevel(MoodleType.FoodEaten) < 3 or
    self.character:getNutrition():getCalories() < 1000
end

function ISEatFoodAction:isValid()
    if self.item:getRequireInHandOrInventory() then
        if not self:getRequiredItem() then
            return false
        end
    end
    return self.character:getInventory():contains(self.item);
end

function ISEatFoodAction:update()
    self.item:setJobDelta(self:getJobDelta());
    if self.eatSound ~= "" and self.eatAudio ~= 0 and not self.character:getEmitter():isPlaying(self.eatAudio) then
        self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
        --        self.eatAudio = getSoundManager():PlayWorldSoundWav( self.eatSound, self.character:getCurrentSquare(), 0.5, 2, 0.5, true);
    end
end

function ISEatFoodAction:start()
    if self.eatSound ~= '' then
        self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
        --		self.eatAudio = getSoundManager():PlayWorldSoundWav( self.eatSound, self.character:getCurrentSquare(), 0.5, 2, 0.5, true);
    end
    if self.item:getCustomMenuOption() then
        self.item:setJobType(self.item:getCustomMenuOption())
    else
        self.item:setJobType(getText("ContextMenu_Eat"));
    end
    self.item:setJobDelta(0.0);

    local secondItem = nil;
    if self.item:getEatType() and self.item:getEatType() ~= "" then
        -- for can or 2handed, add a fork or a spoon if we have them otherwise we'll use default eat action
        -- use 2handforced if you don't want this to happen (like eating a burger..)
        if self.item:getEatType() == "can" or self.item:getEatType() == "candrink" or self.item:getEatType() == "2hand" or self.item:getEatType() == "plate" or self.item:getEatType() == "2handbowl" then
            local playerInv = self.character:getInventory()
            local spoon = playerInv:getFirstTag("Spoon") or playerInv:getFirstType("Base.Spoon");
            local fork = playerInv:getFirstTag("Fork") or playerInv:getFirstType("Base.Fork");

            if self.item:getEatType() == "2handbowl" and spoon then
                self:setAnimVariable("FoodType", "2handbowl");
                secondItem = spoon;
            elseif self.item:getEatType() == "2handbowl" then
                self:setAnimVariable("FoodType", "drink");
            else
                secondItem = spoon or fork;
                if secondItem then
                    if self.item:getEatType() == "plate" then
                        self:setAnimVariable("FoodType", "plate");
                    else
                        self:setAnimVariable("FoodType", "can");
                    end
                elseif self.item:getEatType() == "2hand" then
                    self:setAnimVariable("FoodType", "2hand");
                elseif self.item:getEatType() == "plate" then
                    self:setAnimVariable("FoodType", "plate");
                elseif self.item:getEatType() == "candrink" then
                    self:setAnimVariable("FoodType", "drink");
                end
            end
        else
            self:setAnimVariable("FoodType", self.item:getEatType());
        end
    end
    self:setOverrideHandModels(secondItem, self.item);
    if self.item:getEatType() == "Pot" then
        self:setOverrideHandModels(self.item, nil);
    end
    if self.item:getCustomMenuOption() == getText("ContextMenu_Drink") and self.item:getEatType() ~= "2handbowl" then
        self:setActionAnim(CharacterActionAnims.Drink);
    else
        self:setActionAnim(CharacterActionAnims.Eat);
    end
    self.character:reportEvent("EventEating");
end

function ISEatFoodAction:stop()
    print("STOP")
    print(tostring(self.item:getHungChange()))
    print(tostring(self.item:getBaseHunger()))
    ISBaseTimedAction.stop(self);
    if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
    self.item:setJobDelta(0.0);
    local applyEat = true;
    if self.item and self.item:getFullType() == "Base.Cigarettes" then
        applyEat = false; -- dont apply cigarette effects when action cancelled.
    end
    local hungerChange = math.abs(self.item:getHungerChange() * 100)
    if (hungerChange or self.item:getBaseHunger()) and hungerChange <= 1 then
        applyEat = false; -- dont consume 1 hunger food items when action cancelled.
    end
    if applyEat and self.character:getInventory():contains(self.item) then
        self:eat(self.item, self:getJobDelta());
    end
end

function ISEatFoodAction:perform()
    if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
    if self.item:getHungChange() ~= 0 then
        -- This is now a looping sound, don't play it here
        --        self.character:getEmitter():playSound("Swallowing");
    end
    self.item:getContainer():setDrawDirty(true);
    self.item:setJobDelta(0.0);
    self.character:Eat(self.item, self.percentage);
    if self.item:getModData().perk then
        local xpGain = 0
        local drogaType = self.item:getFullType()
        if drogaType == "MoneyToXP.Droga1" then
            xpGain = 75
        elseif drogaType == "MoneyToXP.Droga2" then
            xpGain = 225
        elseif drogaType == "MoneyToXP.Droga3" then
            xpGain = 1275
        elseif drogaType == "MoneyToXP.Droga4" then
            xpGain = 5775
        elseif drogaType == "MoneyToXP.Droga5" then
            xpGain = 19125
        end
        self.character:getXp():AddXP(self.item:getModData().perk, xpGain, false, false, true)
    end
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISEatFoodAction:getRequiredItem()
    if not self.item:getRequireInHandOrInventory() then
        return
    end
    local types = self.item:getRequireInHandOrInventory()
    for i = 1, types:size() do
        local fullType = moduleDotType(self.item:getModule(), types:get(i - 1))
        local item2 = self.character:getInventory():getFirstType(fullType)
        if item2 then
            return item2
        end
    end
    return nil
end

function ISEatFoodAction:eat(food, percentage)
    -- calcul the percentage ate
    if percentage > 0.95 then
        percentage = 1.0;
    end
    percentage = self.percentage * percentage;
    self.character:Eat(self.item, percentage);
end

function ISEatFoodAction:new(character, item, percentage)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.item = item;
    o.stopOnWalk = false;
    o.stopOnRun = true;
    o.percentage = percentage;
    if not o.percentage then
        o.percentage = 1;
    end

    o.maxTime = math.abs(item:getBaseHunger() * 150 * o.percentage) * 8;

    if o.maxTime > math.abs(item:getHungerChange() * 150 * 8) then
        o.maxTime = math.abs(item:getHungerChange() * 150 * 8);
    end

    local hungerConsumed = math.abs(item:getBaseHunger() * o.percentage * 100);
    local eatingLoop = 1;
    if hungerConsumed >= 30 then
        eatingLoop = 2;
    end
    if hungerConsumed >= 80 then
        eatingLoop = 3;
    end

    local timerForOne = 232;
    if o.item:getCustomMenuOption() == getText("ContextMenu_Drink") then
        hungerConsumed = math.abs(item:getThirstChange() * o.percentage * 100);
        timerForOne = 171;
        if hungerConsumed >= 3 then
            eatingLoop = 2;
        end
        if hungerConsumed >= 6 then
            eatingLoop = 3;
        end
    end

    o.maxTime = timerForOne * eatingLoop;

    -- Cigarettes don't reduce hunger
    if hungerConsumed == 0 then o.maxTime = 460 end
    if item:getEatType() == "popcan" then
        o.maxTime = 160;
    end

    o.eatSound = item:getCustomEatSound() or "Eating";
    o.eatAudio = 0

    --	local w = item:getActualWeight();
    --    if w > 3 then w = 3; end;
    --
    --    o.maxTime = o.maxTime * w;

    o.ignoreHandsWounds = true;
    return o
end
