local QBCore = nil
local ESX = nil

-- Initialize Framework
if Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

RegisterNetEvent('custom-npc-robbery:server:giveMoney', function()
    local src = source
    local amount = math.random(Config.MinMoney, Config.MaxMoney)
    local itemChance = math.random(1, 100)
    local itemName = "stolenphone" 

    if Config.Framework == 'qb' then
        -- QBCore Logic
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end 
        
        Player.Functions.AddMoney('cash', amount, "npc-robbery")
        
        if itemChance <= 25 then
            if Player.Functions.AddItem(itemName, 1) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "add")
                TriggerClientEvent('QBCore:Notify', src, "You snatched a hidden item from them!", "success")
            end
        end
        TriggerClientEvent('QBCore:Notify', src, "You found $"..amount.." in their pockets!", "success")

    elseif Config.Framework == 'esx' then
        -- ESX Logic
        local Player = ESX.GetPlayerFromId(src)
        if not Player then return end
        
        Player.addMoney(amount)

        if itemChance <= 25 then
            Player.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', src, "You snatched a hidden item from them!")
        end
        TriggerClientEvent('esx:showNotification', src, "You found $"..amount.." in their pockets!")
    end
end)