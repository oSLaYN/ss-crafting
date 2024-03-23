local function RemoveItemsFromList(Player, items)
    local removedAll = false
    for k,v in pairs(items) do
        removedAll = Player.Functions.RemoveItem(k,v)
    end
    return removedAll
end

lib.callback.register('ss-crafting:server:doCrafting', function(source, items, itemToAdd, amountToAdd)
    local src = source 
    local Player = Config.Core.Functions.GetPlayer(src)
    if RemoveItemsFromList(Player, items) then
        if Player.Functions.AddItem(itemToAdd, amountToAdd) then
            return true
        end
    end
    return false
end)

lib.callback.register('ss-crafting:server:openCrafting', function(source, craftLabel, craftList)
    local src = source
    lib.callback.await('ss-crafting:client:openCrafting', src, craftLabel, craftList)
end)