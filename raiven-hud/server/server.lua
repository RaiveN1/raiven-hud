QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('tgiann-hud:car:eject-other-player-car')
AddEventHandler('tgiann-hud:car:eject-other-player-car', function(table, velocity)
    for i=1, #table do
        TriggerClientEvent("tgiann-hud:car:eject-other-player-car-client", table[i], velocity)
    end
end)

QBCore.Commands.Add("hud", "Hud Menüsünü Açar", {}, false, function(source, args)
    TriggerClientEvent('tgiann-hud:open-hud', source, item)
end)

QBCore.Commands.Add("fulle", "Can Fulle", {}, false, function(source, args) -- name, help, arguments, argsrequired,  end sonuna persmission
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    TriggerEvent('DiscordBot:ToDiscord', 'adminlog', '/fulle', source, item)
    TriggerClientEvent("tgiann-hud:fulle", xPlayer.PlayerData.source, item)
end, "god")

RegisterNetEvent("tgiann-basicneeds:bilgilerKaydet")
AddEventHandler("tgiann-basicneeds:bilgilerKaydet", function(yemek, su, sarhos, zirh, heal, oyunSuresi)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)	
    if xPlayer then
        xPlayer.Functions.SetMetaData("hunger", yemek)
        xPlayer.Functions.SetMetaData("thirst", su)
        xPlayer.Functions.SetMetaData("armor", zirh)
        xPlayer.Functions.SetMetaData("drunk", sarhos)
        xPlayer.Functions.SetMetaData("heal", heal)
        if xPlayer.PlayerData.job.onduty then
            xPlayer.Functions.SetMetaData("dutytime", xPlayer.PlayerData.metadata["dutytime"] + 5)
        end
        xPlayer.Functions.SetSure(oyunSuresi)
    end
end)

RegisterNetEvent("tgiann-basicneeds:esya-sil")
AddEventHandler("tgiann-basicneeds:esya-sil", function(item, item2)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        xPlayer.Functions.RemoveItem(item, 1)
        if item2 then
            xPlayer.Functions.RemoveItem(item2, 1)
        end
    end
end)

QBCore.Functions.CreateCallback("tgiann-basicneeds:esya-sil-cb", function(source, cb, item)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer then
        if xPlayer.Functions.RemoveItem(item, 1) then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent("tgiann-basicneeds:give-item")
AddEventHandler("tgiann-basicneeds:give-item", function(item, key)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if QBCore.Functions.kickHacKer(src, key) then -- QBCore.Key
        if xPlayer then
            xPlayer.Functions.AddItem(item, 1)
        end
    end
end)

QBCore.Functions.CreateUseableItem('cigarette', function(source, item)
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    if xPlayer.Functions.GetItemByName("lighter").amount > 0 then
        if math.random(1,100) < 2 then
            xPlayer.Functions.RemoveItem('lighter', 1, xPlayer.Functions.GetItemByName("lighter").slot)
            TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Çakmağın Gazı Bitti")
        else
            xPlayer.Functions.RemoveItem('cigarette', 1, xPlayer.Functions.GetItemByName("cigarette").slot)
            TriggerClientEvent('tgiann-basicneeds:sigara', xPlayer.PlayerData.source, item)
        end 
    else
        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "Sigarayı Yakmak İçin Çakmağın Yok")
    end
end)

function removeItemHud(src, item)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    xPlayer.Functions.RemoveItem(item, 1)
end

QBCore.Functions.CreateUseableItem('book', function(source, item)
    TriggerClientEvent("dpemotes:play-anim", source, {"kitap"})
end)

QBCore.Functions.CreateUseableItem('umbrella', function(source, item)
    TriggerClientEvent("dpemotes:play-anim", source, {"şemsiye"})
end)

QBCore.Functions.CreateUseableItem('kahve', function(source, item)
    removeItemHud(source, "kahve")
    TriggerClientEvent("dpemotes:play-anim", source, {"kahve"})
end)

QBCore.Functions.CreateUseableItem('water', function(source, item)
	TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 800, 0.1)
end)

QBCore.Functions.CreateUseableItem('sut', function(source, item)
	TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 250, 0.1)
end)

QBCore.Functions.CreateUseableItem('portakal_suyu', function(source, item)
	TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 2500, 0.5)
end)

QBCore.Functions.CreateUseableItem('domates_suyu', function(source, item)
	TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 2500, 0.5)
end)

QBCore.Functions.CreateUseableItem('ekmek', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 100, 0.05)
end)

QBCore.Functions.CreateUseableItem('kraker', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 800, 0.05)
end)

QBCore.Functions.CreateUseableItem('turtle_soup', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 1000, 0.5)
end)

QBCore.Functions.CreateUseableItem('nos', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Böyle bir kullanım yöntemi de var tabi :D')
    TriggerClientEvent('kfzeu-basicneeds:nosAnimation', source, item)
end)

QBCore.Functions.CreateUseableItem('abc', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:nosAnimation2', source, item)
end)

QBCore.Functions.CreateUseableItem('fish', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Evladım bu çiğ yenir mi?')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -21, "yemek", "fish")
end)

QBCore.Functions.CreateUseableItem('asit', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Gerçekten mi :D?')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -51, "yemek", "asit")
end)

QBCore.Functions.CreateUseableItem('parasut', function(source, item)
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    xPlayer.Functions.RemoveItem('parasut', 1)
    TriggerClientEvent("QBCore:Notify", source, "Paraşütü Giydin! Tekrar Paraşüt Kullanmamaya Dikkat Et! (Eline Silah vs Alırsan Paraşütün Gider)", "error")
    TriggerClientEvent('tgiann-hud:parasut', source)
end)

QBCore.Functions.CreateUseableItem('azot', function(source, item)
    local xPlayer = QBCore.Functions.GetPlayer(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Biri tabut taşıyan abilere haber versin...')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -51, "yemek", "azot")
end)

QBCore.Functions.CreateUseableItem('balon_baligi', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'Zehirli kanka bu')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -21, "yemek", "balon_baligi")
end)

QBCore.Functions.CreateUseableItem('madde_x', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'O kadar uğraştın değdi mi :D?')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -101, "yemek", "madde_x")
end)

QBCore.Functions.CreateUseableItem('kuru_ot', function(source, item)
    TriggerClientEvent("QBCore:Notify", source, 'O öyle kuru kuru gitmez :D')
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, -6, "yemek", "kuru_ot")
end)

QBCore.Functions.CreateUseableItem('su_alti', function(source, item)
	TriggerClientEvent('kfzeu-basicneeds:su_alti', source, 5, item.name)
end)

QBCore.Functions.CreateUseableItem('su_alti2', function(source, item)
	TriggerClientEvent('kfzeu-basicneeds:su_alti', source, 15, item.name)
end)

QBCore.Functions.CreateUseableItem('cigarette', function(source, item)
	local xPlayer = QBCore.Functions.GetPlayer(source, item)
	xPlayer.Functions.RemoveItem('cigarette', 1)
	TriggerClientEvent('tgiann-basicneeds:sigara', source, item)
end)

QBCore.Functions.CreateUseableItem('ab', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "ot", "ab")
end)

QBCore.Functions.CreateUseableItem('pk', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "ot", "pk")
end)

QBCore.Functions.CreateUseableItem('sarma_ot', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "ot", "sarma_ot")
end)

QBCore.Functions.CreateUseableItem('enerji_icecegi', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "enerji", "enerji_icecegi")
end)

QBCore.Functions.CreateUseableItem('shark_doping', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "doping", "shark_doping")
end)

QBCore.Functions.CreateUseableItem('adrenalin', function(source, item)
    TriggerClientEvent('kfzeu-basicneeds:zehir', source, 200, "adrenalin", "adrenalin")
end)

QBCore.Functions.CreateUseableItem('beer', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 800)
end)

QBCore.Functions.CreateUseableItem('grand_cru', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 4500)
end)

QBCore.Functions.CreateUseableItem('rhum', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 4000)
end)

QBCore.Functions.CreateUseableItem('golem', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 10000)
end)

QBCore.Functions.CreateUseableItem('jagerbomb', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 8000)
end)

QBCore.Functions.CreateUseableItem('whiskycoca', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('rhumcoca', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('tequila', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('vodkaenergy', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('vodkafruit', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('rhumfruit', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5500)
end)

QBCore.Functions.CreateUseableItem('teqpaf', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 7000)
end)

QBCore.Functions.CreateUseableItem('mojito', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 3000)
end)

QBCore.Functions.CreateUseableItem('jagercerbere', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 6000)
end)

QBCore.Functions.CreateUseableItem('vodka', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5000)
end)

QBCore.Functions.CreateUseableItem('whisky', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 4500)
end)

QBCore.Functions.CreateUseableItem('whitewine', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 2500)
end)

QBCore.Functions.CreateUseableItem('jager', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 7500)
end)

QBCore.Functions.CreateUseableItem('martini', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 5000)
end)

QBCore.Functions.CreateUseableItem('wine', function(source, item)
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 200, 0.1)
    TriggerClientEvent('tgiann-basicneeds:icki', source, 2500)
end)

-- Burger
QBCore.Functions.CreateUseableItem('burgers', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burgerm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burgerl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burger', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('sosisli', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('taco', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('burgerxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

--Patates Kızartması
QBCore.Functions.CreateUseableItem('friess', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 2000, 1)
end)

QBCore.Functions.CreateUseableItem('friesm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 4000, 1.5)
end)

QBCore.Functions.CreateUseableItem('friesl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5500, 2)
end)

QBCore.Functions.CreateUseableItem('friesxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

-- HotDog
QBCore.Functions.CreateUseableItem('hotdogs', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('hotdogm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('hotdogl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('hotdogxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

--Taco
QBCore.Functions.CreateUseableItem('tacos', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tacot', function(source, item) --M
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tacok', function(source, item) --L
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tacoxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

-- Tavuk Burger
QBCore.Functions.CreateUseableItem('tburgers', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tburgerm', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tburgerl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tburgerxl', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

--İçecekler
QBCore.Functions.CreateUseableItem('atom', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 7500, 1)
end)

QBCore.Functions.CreateUseableItem('ayran', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 8500, 1)
end)

QBCore.Functions.CreateUseableItem('kola', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 8500, 1)
end)

QBCore.Functions.CreateUseableItem('cay', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 1000, 3)
end)

-- Pops Diner
QBCore.Functions.CreateUseableItem('pburger', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('makarna', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('tavukmenu', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('etmenu', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('ahtapotsalata', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 5)
end)

QBCore.Functions.CreateUseableItem('balikizgara', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 5)
end)

QBCore.Functions.CreateUseableItem('prisonmeal', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 5)
end)

QBCore.Functions.CreateUseableItem('karidesizgara', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 10000, 5)
end)

QBCore.Functions.CreateUseableItem('mezetabagi', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 3)
end)

QBCore.Functions.CreateUseableItem('raki', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 2500, 1)
end)

QBCore.Functions.CreateUseableItem('americano', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 5000, 1)
end)

QBCore.Functions.CreateUseableItem('latte', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 5000, 1)
end)

QBCore.Functions.CreateUseableItem('graphius', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 5000, 1)
end)

QBCore.Functions.CreateUseableItem('macha', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "drink", 5000, 1)
end)

QBCore.Functions.CreateUseableItem('kahvekek', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 2)
end)

QBCore.Functions.CreateUseableItem('kekuzum', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 2)
end)

QBCore.Functions.CreateUseableItem('pogacadomates', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 2)
end)

QBCore.Functions.CreateUseableItem('pogacapatates', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 2)
end)

QBCore.Functions.CreateUseableItem('mochi', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 5000, 2)
end)

QBCore.Functions.CreateUseableItem('sushi', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('wakame', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('generaltso', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

QBCore.Functions.CreateUseableItem('ramen', function(source, item)
    if not checkDurubality(item, source) then return end
    TriggerClientEvent('tgiann-basicneeds:eatOrDrink', source, item.name, "eat", 7500, 3)
end)

function checkDurubality(item, src)
    if item.info then
        local durubality = 1
        if item.info.durubality then
            local date = item.info.durubality + 172800
            local durubality_frist = (date - os.time()) / (60 * 60 * 24)
            durubality = 100 - ((2 - durubality_frist)*50)
        end
        if durubality > 0 then
            return true
        else
            TriggerClientEvent("QBCore:Notify", src, item.label.." Bozulmuş", "error")
            local xPlayer = QBCore.Functions.GetPlayer(src)	
            xPlayer.Functions.RemoveItem(item.name, 1, item.slot)
            return false
        end
    end
    return true
end