local cashAmount = 0
local bankAmount = 0

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if IsDisabledControlJustPressed(0, 37) then
            TriggerEvent("hud:client:ShowMoney", "cash", true)
        end

        if IsDisabledControlJustReleased(0, 37) then
            TriggerEvent("hud:client:ShowMoney", "cash", false)
        end
    end
end)

RegisterNetEvent("hud:client:SetMoney")
AddEventHandler("hud:client:SetMoney", function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData and PlayerData.money then
        cashAmount = QBCore.Shared.Round(PlayerData.money.cash)
        bankAmount = QBCore.Shared.Round(PlayerData.money.bank)
    end
end)

RegisterNetEvent("hud:client:ShowMoney")
AddEventHandler("hud:client:ShowMoney", function(type, show)
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({
        action = "show",
        cash = cashAmount,
        bank = bankAmount,
        type = type,
        show = show
    })
end)

RegisterNetEvent("hud:client:OnMoneyChange")
AddEventHandler("hud:client:OnMoneyChange", function(type, amount, isMinus)
    PlayerData = QBCore.Functions.GetPlayerData()
    cashAmount = QBCore.Shared.Round(PlayerData.money.cash)
    bankAmount = QBCore.Shared.Round(PlayerData.money.bank)

    SendNUIMessage({
        action = "update",
        cash = cashAmount,
        bank = bankAmount,
        amount = amount,
        minus = isMinus,
        type = type,
    })
end)
