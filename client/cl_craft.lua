PlayerData = Config.Core.Functions.GetPlayerData()
local Crafting = {}
local tableProps = {}

function GetCrafting()
    Crafting = lib.callback.await('ss-crafting:server:GetCrafting', false)
end

function CreateCraftTables()
    if not Crafting.Tables then return end
    lib.requestModel(Config.TableProp, 100)
    for k,v in pairs(Crafting.Tables) do
        tableProps[#tableProps+1] = CreateObject(GetHashKey(Config.TableProp), v.coords.x, v.coords.y, v.coords.z-1, false, false, false)
        SetEntityHeading(tableProps[#tableProps], v.coords.w+180)
        exports.ox_target:addLocalEntity(tableProps[#tableProps],{
            {
                label = "Abrir Craft de Armas",
                icon = "fas fa-hand-paper",
                canInteract = function()
                    if (v.gang ~= nil) then return (PlayerData.gang.name == v.gang) else return true end
                end,
                onSelect = function()
                    exports[GetCurrentResourceName()]:CreateCraftMenu("Crafting Table", Crafting.Crafts[v.type])
                end,
            },
        })
    end
end

function DeleteCraftTables()
    for k,v in pairs(tableProps) do DeleteEntity(v) DeleteObject(v) v = nil end
    tableProps = {}
end

lib.callback.register('ss-crafting:client:setCrafting', function(source, NewCrafting)
    Crafting = NewCrafting
    return true
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = Config.Core.Functions.GetPlayerData()
    GetCrafting()
    CreateCraftTables()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    DeleteCraftTables()
    Crafting = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(value)
    PlayerData = value
end)

RegisterNetEvent('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DeleteCraftTables()
end)