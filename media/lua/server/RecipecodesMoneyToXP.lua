function TrainXP(items, result, char)
	local xpGain = 0
	
	for i=0, (items:size() - 1) do
		if items:get(i):getType() == "100XPTraining" then
			xpGain = 100
			break
		elseif items:get(i):getType() == "200XPTraining" then
			xpGain = 250
			break
		elseif items:get(i):getType() == "500XPTraining" then
			xpGain = 800
			break
		elseif items:get(i):getType() == "1000XPTraining" then
			xpGain = 2500
			break
		end
	end
	
	if result:getType() == "Axe" then
		char:getXp():AddXP(Perks.Axe, xpGain, false, false, true)
	elseif result:getType() == "Pistol" then
		char:getXp():AddXP(Perks.Aiming, xpGain, false, false, true)
	elseif result:getType() == "Hammer" then
		char:getXp():AddXP(Perks.Woodwork, xpGain, false, false, true)
	elseif result:getType() == "Cupcake" then
		char:getXp():AddXP(Perks.Cooking, xpGain, false, false, true)
	elseif result:getType() == "ElectronicsScrap" then
		char:getXp():AddXP(Perks.Electricity, xpGain, false, false, true)
	elseif result:getType() == "Rake" then
		char:getXp():AddXP(Perks.Farming, xpGain, false, false, true)
	elseif result:getType() == "Bandage" then
		char:getXp():AddXP(Perks.Doctor, xpGain, false, false, true)
	elseif result:getType() == "FishingRod" then
		char:getXp():AddXP(Perks.Fishing, xpGain, false, false, true)
	elseif result:getType() == "Hat_Sweatband" then
		char:getXp():AddXP(Perks.Fitness, xpGain, false, false, true)
	elseif result:getType() == "Twigs" then
		char:getXp():AddXP(Perks.PlantScavenging, xpGain, false, false, true)
	elseif result:getType() == "Shoes_RedTrainers" then
		char:getXp():AddXP(Perks.Lightfoot, xpGain, false, false, true)
	elseif result:getType() == "Katana" then
		char:getXp():AddXP(Perks.LongBlade, xpGain, false, false, true)
	elseif result:getType() == "BaseballBat" then
        char:getXp():AddXP(Perks.Blunt, xpGain, false, false, true)
	elseif result:getType() == "DuctTape" then
		char:getXp():AddXP(Perks.Maintenance, xpGain, false, false, true)
	elseif result:getType() == "Wrench" then
		char:getXp():AddXP(Perks.Mechanics, xpGain, false, false, true)
	elseif result:getType() == "BlowTorch" then
		char:getXp():AddXP(Perks.MetalWelding, xpGain, false, false, true)
	elseif result:getType() == "Shoes_ArmyBoots" then
		char:getXp():AddXP(Perks.Nimble, xpGain, false, false, true)
	elseif result:getType() == "9mmClip" then
		char:getXp():AddXP(Perks.Reloading, xpGain, false, false, true)
	elseif result:getType() == "HuntingKnife" then
		char:getXp():AddXP(Perks.SmallBlade, xpGain, false, false, true)
	elseif result:getType() == "Nightstick" then
		char:getXp():AddXP(Perks.SmallBlunt, xpGain, false, false, true)
	elseif result:getType() == "Hat_BalaclavaFull" then
		char:getXp():AddXP(Perks.Sneak, xpGain, false, false, true)
	elseif result:getType() == "WoodenLance" then
		char:getXp():AddXP(Perks.Spear, xpGain, false, false, true)
	elseif result:getType() == "Shoes_BlueTrainers" then
		char:getXp():AddXP(Perks.Sprinting, xpGain, false, false, true)
	elseif result:getType() == "DumbBell" then
		char:getXp():AddXP(Perks.Strength, xpGain, false, false, true)
	elseif result:getType() == "Thread" then
		char:getXp():AddXP(Perks.Tailoring, xpGain, false, false, true)
	elseif result:getType() == "TrapCage" then
		char:getXp():AddXP(Perks.Trapping, xpGain, false, false, true)
	end

end

function RecoverRubberBand(items, result, char)
	char:getInventory():AddItem("RubberBand")
end

function RecoverRubberBands(items, result, char)
	char:getInventory():AddItems("RubberBand", items:size() - 2)  -- subtracting stapler and staples
end

function Recipe.OnCreate.OpenMoneySuitcase(items, result, player)
	player:getInventory():AddItems("MoneyToXP.XPMoneyStack", 10)
end