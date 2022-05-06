Show = false
PlayerData = {}
isLoggedIn = false
inVehicle = false
playerPed = 0
lastpauseMenuState = 0

QBCore = nil
Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    DisplayRadar(false)
end)

local bigMap = false
local onMap = false

local minimap = nil


Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        inVehicle = IsPedInAnyVehicle(playerPed, false) and not IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `wheelchair`)
        SendNUIMessage({
            action = 'tick',
            show = IsPauseMenuActive(),
            health = (GetEntityHealth(playerPed)-100),
            armor = GetPedArmour(playerPed),
            stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            oxy = IsPedSwimmingUnderWater(playerPed) and GetPlayerUnderwaterTimeRemaining(PlayerId()) or 100,
        })

        Citizen.Wait(200)
    end
end)

function UIStuff()
    Citizen.CreateThread(function()
        minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(200)
        SetRadarBigmapEnabled(false, false)

        while Show do
            Citizen.Wait(500)
            local pauseMenuState = GetPauseMenuState()
            if pauseMenuState ~= lastpauseMenuState then
                lastpauseMenuState = pauseMenuState
                removeHealthBar()
            end

            if inVehicle and not onMap then
                SetPedConfigFlag(playerPed, 35, false)
                onMap = true
                if not bigMap then DisplayRadar(true) end
                removeHealthBar()
            elseif not inVehicle and onMap then
                onMap = false
                if not bigMap then DisplayRadar(false) end
                removeHealthBar()
            end
            
        end
    end)
end

function removeHealthBar()
    BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(3)
    EndScaleformMovieMethod()
end

RegisterNetEvent('tgiann-hud:big-map')
AddEventHandler('tgiann-hud:big-map', function(bool)
    if Show then
        if bool then
            if not inVehicle then
                bigMap = true
                DisplayRadar(true)
            end
            SendNUIMessage({action = 'hideui'})
            SetBigmapActive(true, false)
        else
            if not inVehicle then
                bigMap = false
                DisplayRadar(false)
            end
            SendNUIMessage({action = 'showui'})
            SetBigmapActive(false,false)
        end
        Citizen.Wait(50)
        removeHealthBar()
    end
end)

RegisterNetEvent('SaltyChat_SetVoiceRange_client')
AddEventHandler('SaltyChat_SetVoiceRange_client', function(seviye)
    if seviye == 2 then
        SendNUIMessage({action = 'ses-0'})
    elseif seviye == 6 then
        SendNUIMessage({action = 'ses-1'})
    elseif seviye == 18 then
        SendNUIMessage({action = 'ses-2'})
    end
end)

local normalKonusmaAktif = false
RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(status)
    if status and not normalKonusmaAktif then
        normalKonusmaAktif = true
        SendNUIMessage({action = 'ses-aktif'})
    elseif not status and normalKonusmaAktif then
        normalKonusmaAktif = false
        SendNUIMessage({action = 'ses-pasif'})
    end
end)

RegisterNetEvent('tgiann-hud:UpdateStatus')
AddEventHandler('tgiann-hud:UpdateStatus', function(Status)
    SendNUIMessage({
        action = "updateStatus",
        st = Status,
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({action = 'showui'})
    UIStuff()
    isLoggedIn = true
    Show = true
    Citizen.Wait(10000)
    QBCore.Functions.Notify("/hud Yazarak Hud'u İstediğin Gibi Ayarlayabilirsin!", "primary", 15000)
end)

RegisterNetEvent('tgiann-hud:ui')
AddEventHandler('tgiann-hud:ui', function(open)
    if open then 
        UIStuff()
        Show = true
        SendNUIMessage({action = 'showui'})
    else
        Show = false
        SendNUIMessage({action = 'hideui'})
        Citizen.Wait(500)
        DisplayRadar(false)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    SendNUIMessage({action = 'hideui'})
    isLoggedIn = false
    Show = false
end)

RegisterNetEvent('tgiann-hud:open-hud')
AddEventHandler('tgiann-hud:open-hud', function()
    if not Show then
        PlayerData = QBCore.Functions.GetPlayerData()
        TriggerEvent("tgian-hud:load-data")
        SendNUIMessage({action = 'showui'})
        UIStuff()
        isLoggedIn = true
        Show = true
    end
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'showMenu'})
end)

RegisterNUICallback('close-ayar-menu', function()
    SetNuiFocus(false, false)
end)

local disSes = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsDisabledControlJustPressed(0, 166) then
            disSes = not disSes
            TriggerServerEvent("ls-radio:set-disses", disSes)
            SendNUIMessage({action = 'disSes', disSes = disSes})
        end
    end
end)

RegisterNUICallback('set-emotechat', function(data)
    TriggerEvent("3dme-chat", data.status)
end)

RegisterNUICallback('fh4speed', function(data)
    TriggerEvent("fh4speed:hud", data.status)
end)

RegisterNetEvent('tgiann-hud:parasut')
AddEventHandler('tgiann-hud:parasut', function()
    local playerPed = PlayerPedId()
	GiveWeaponToPed(playerPed, `gadget_parachute`, 1, false, false)
	SetPedComponentVariation(playerPed, 5, 8, 3, 0)
end)