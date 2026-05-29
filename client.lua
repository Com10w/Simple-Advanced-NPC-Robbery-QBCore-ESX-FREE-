local QBCore = nil
local ESX = nil

-- Initialize Framework
if Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

local robbedPeds = {} 
local currentTarget = nil 
local isRobbing = false 

-- Universal Notification System
local function Notify(msg, type)
    if Config.Framework == 'qb' then
        QBCore.Functions.Notify(msg, type)
    elseif Config.Framework == 'esx' then
        ESX.ShowNotification(msg)
    end
end

-- Function to draw 3D text
local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function CanRobWithWeapon()
    local playerPed = PlayerPedId()
    local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
    return Config.AllowedWeapons[weaponHash]
end

local function AlertPolice()
    if math.random(1, 100) <= Config.PoliceAlertChance then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        if GetResourceState('ps-dispatch') == 'started' then
            exports['ps-dispatch']:SuspiciousActivity()
        elseif GetResourceState('qb-dispatch') == 'started' then
            TriggerServerEvent('qb-dispatch:911call', coords, "Armed Robbery")
        elseif GetResourceState('cd_dispatch') == 'started' then
            TriggerServerEvent('cd_dispatch:GetPlayerPos', 'suspicious_activity')
        else
            TriggerServerEvent('police:server:policeAlert', 'Armed Robbery Alert')
        end
    end
end

-- Universal Progress Bar and Robbery Logic
local function StartRobbing(entity)
    if isRobbing then return end 
    
    isRobbing = true
    local playerPed = PlayerPedId()
    AlertPolice()

    ClearPedTasks(entity) 
    TaskTurnPedToFaceEntity(entity, playerPed, -1)
    Wait(300) 

    local animDict = "random@mugging3"
    local animName = "handsup_standing_base"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end
    TaskPlayAnim(entity, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Handle Progress Bar depending on Framework
    if Config.Framework == 'qb' then
        QBCore.Functions.Progressbar("robbing_npc", "Emptying pockets...", Config.RobberyTime, false, true, {
            disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false, 
        }, {}, {}, {}, function() -- Success
            if not IsEntityDead(entity) then
                SetBlockingOfNonTemporaryEvents(entity, false)
                ClearPedTasks(entity)
                TaskReactAndFleePed(entity, playerPed)
                TriggerServerEvent('custom-npc-robbery:server:giveMoney')
                robbedPeds[entity] = true 
            else
                Notify("The person died, robbery canceled.", "error")
            end
            isRobbing = false
            currentTarget = nil
        end, function() -- Cancel
            SetBlockingOfNonTemporaryEvents(entity, false)
            ClearPedTasks(entity)
            TaskReactAndFleePed(entity, playerPed) 
            Notify("Robbery canceled.", "error")
            isRobbing = false
            currentTarget = nil
        end)
    elseif Config.Framework == 'esx' then
        -- ESX does not have a native progress bar. 
        -- We simulate it securely with a timer and notification.
        Notify("Emptying pockets...", "info")
        Wait(Config.RobberyTime)
        
        if not IsEntityDead(entity) then
            SetBlockingOfNonTemporaryEvents(entity, false)
            ClearPedTasks(entity)
            TaskReactAndFleePed(entity, playerPed)
            TriggerServerEvent('custom-npc-robbery:server:giveMoney')
            robbedPeds[entity] = true 
        else
            Notify("The person died, robbery canceled.", "error")
        end
        isRobbing = false
        currentTarget = nil
    end
end

local function IntimidatePed(entity)
    local playerPed = PlayerPedId()
    if isRobbing then return end

    RequestAnimDict("random@mugging3")
    while not HasAnimDictLoaded("random@mugging3") do Wait(10) end

    SetBlockingOfNonTemporaryEvents(entity, true)
    
    if not IsEntityPlayingAnim(entity, "random@mugging3", "handsup_standing_base", 3) then
        ClearPedTasksImmediately(entity) 
        TaskTurnPedToFaceEntity(entity, playerPed, -1) 
        TaskPlayAnim(entity, "random@mugging3", "handsup_standing_base", 8.0, -8.0, -1, 49, 0, 0, 0, 0)
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local isArmed = IsPedArmed(playerPed, 4) or IsPedArmed(playerPed, 1)

        if isArmed then
            local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            
            if not aiming and currentTarget then
                local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(currentTarget))
                if dist < 5.0 and not IsEntityDead(currentTarget) then
                    entity = currentTarget
                else
                    if not isRobbing then
                        SetBlockingOfNonTemporaryEvents(currentTarget, false)
                        TaskReactAndFleePed(currentTarget, playerPed)
                        currentTarget = nil
                    end
                end
            end

            if entity and IsEntityAPed(entity) and not IsPedAPlayer(entity) and not IsPedInAnyVehicle(entity) and not IsEntityDead(entity) then
                if CanRobWithWeapon() then
                    local coords = GetEntityCoords(entity)
                    local dist = #(GetEntityCoords(playerPed) - coords)
                    
                    if dist < 5.0 then 
                        sleep = 0
                        
                        if not robbedPeds[entity] then
                            currentTarget = entity
                            IntimidatePed(entity)
                            
                            if not isRobbing then
                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "[E] Rob")
                                if IsControlJustPressed(0, 38) then 
                                    StartRobbing(entity)
                                end
                            end
                        else
                            if not isRobbing then
                                DrawText3D(coords.x, coords.y, coords.z + 1.0, "~r~Pockets Empty")
                                SetBlockingOfNonTemporaryEvents(entity, false)
                                TaskReactAndFleePed(entity, playerPed)
                            end
                        end
                    end
                end
            end
        else
            if currentTarget and not isRobbing then
                SetBlockingOfNonTemporaryEvents(currentTarget, false)
                TaskReactAndFleePed(currentTarget, playerPed)
                currentTarget = nil
            end
        end
        Wait(sleep)
    end
end)