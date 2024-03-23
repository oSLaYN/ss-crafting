local function GetCraftList(ingredients)
    local craftList = ""
    for k, v in pairs(ingredients) do
        if Config.Core.Shared.Items[k] ~= nil then
            local item = Config.Core.Shared.Items[k].label
            craftList = craftList .. item .. " x" .. tostring(v) .. "\n"
        end
    end
    return craftList
end

local function HasNeededItems(ingredients)
    local hasItems = true
    for k,v in pairs(ingredients) do
        local hasItem = Config.Core.Functions.HasItem(k, v)
        if not hasItem then hasItems = false break end
    end
    return hasItems
end

local function CraftItem(time, ingredients, item, amount)
    if not HasNeededItems(ingredients) then Config.Core.Functions.Notify('Não Tens o Que é Preciso.', 'error') return end
    Config.Core.Functions.Progressbar("crafting", "A Fazer "..Config.Core.Shared.Items[item].label.."...", time or 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mini@repair',
        anim = 'fixing_a_ped',
        flags = 16,
    }, {}, {}, function()
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 2.5)
        if not HasNeededItems(ingredients) then Config.Core.Functions.Notify('Não Tens o Que é Preciso.', 'error') return end
        lib.callback.await('ss-crafting:server:doCrafting', false, ingredients, item, amount)
    end, function()
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 2.5)
    end)
    
end

local function CreateCraftMenu(menuLabel, menuCrafts)
    local craftMenu = {}
    for k,v in pairs(menuCrafts) do
        craftMenu[#craftMenu+1] = {
            title = Config.Core.Shared.Items[v.name].label,
            description = GetCraftList(v.ingredients),
            icon = "https://cfx-nui-tnrp-inventory/html/"..Config.Core.Shared.Items[v.name].image,
            disabled = (not HasNeededItems(v.ingredients)),
            onSelect = function()
                CraftItem(v.duration, v.ingredients, v.name, 1)
            end,
        }
    end
    lib.registerContext({
        id = string.lower(menuLabel),
        title = menuLabel,
        options = craftMenu,
    })
    lib.showContext(string.lower(menuLabel))
end

exports('CreateCraftMenu', function(menuLabel, menuCrafts)
    CreateCraftMenu(menuLabel, menuCrafts)
end)

lib.callback.register('ss-crafting:client:openCrafting', function(craftLabel, craftList)
    CreateCraftMenu(craftLabel, craftList)
    return true
end)