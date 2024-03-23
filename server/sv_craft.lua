local Crafting = {
    Tables = {},
    Crafts = {
        --[[ {
            name = "weapon_heavypistol",
            ingredients = {
                metalscrap = 50,
                iron_bar = 10,
            },
            duration = 5000,
        }, ]]
    }
}

local function RequestCraftTables()
    local result = MySQL.query.await('SELECT * FROM `crafting_tables`', {})
    if result[1] then
        for k,v in pairs(result) do
            Crafting.Tables[#Crafting.Tables+1] = {
                coords = json.decode(v.coords),
                gang = v.gang or nil,
                type = v.type
            }
        end
    end
end

local function RequestCraftTypes()
    local result = MySQL.query.await('SELECT * FROM `crafting_types`', {})
    if result[1] then
        for k,v in pairs(result) do
            local Crafts = {}
            for i,_ in pairs(v.crafts) do
                Crafts[v.item] = {
                    ingredients = json.decode(v.ingredients),
                    duration = v.duration
                }
            end
            Crafting.Crafts[v.type] = Crafts
        end
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    RequestCraftTables()
    RequestCraftTypes()
    if GetPlayers() > 0 then lib.callback.await('ss-crafting:client:setCrafting', -1, Crafting) end
end)

lib.callback.register('ss-crafting:server:GetCrafting', function(source)
    local src = source
    return Crafting
end)

lib.callback.register('ss-crafting:server:addCraft', function(source, type, item, ingredients, duration)
    Crafting.Crafts[type][item] = { ingredients = json.encode(v.ingredients), duration = v.duration }
    local response = MySQL.update.await('UPDATE crafting_types SET crafts = ? WHERE type = ?', {json.encode(Crafting.Crafts[type]), type})
    return (response ~= 0)
end)

lib.callback.register('ss-crafting:server:delCraft', function(source, type, item)
    Crafting.Crafts[type][item] = nil
    local response = MySQL.update.await('UPDATE crafting_types SET crafts = ? WHERE type = ?', {json.encode(Crafting.Crafts[type]), type})
    return (response ~= 0)
end)

lib.callback.register('ss-crafting:server:updateCraft', function(source, type, item, ingredients)
    Crafting.Crafts[type][item].ingredients = ingredients
    local response = MySQL.update.await('UPDATE crafting_types SET crafts = ? WHERE type = ?', {json.encode(Crafting.Crafts[type]), type})
    return (response ~= 0)
end)