--========================-- 
--  #Author: nicety#5979  -- 
--  #Version 1.0 Alpha    -- 
--========================-- 

-- DONT SELL THIS PRODUCT! - FREE RELEASE

-- Podstawy, nie ruszac !

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESX.RegisterServerCallback('icphone:getItemAmount', function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem("icphone")
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)


-- Rejestrowanie Itemu

ESX.RegisterUsableItem('icphone', function(source)

	TriggerClientEvent('icphone:openup', source)
end)