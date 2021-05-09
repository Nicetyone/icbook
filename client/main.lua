--========================-- 
--  #Author: nicety#5979  -- 
--  #Version 1.0 Alpha    -- 
--========================-- 

-- DONT SELL THIS PRODUCT! - FREE RELEASE

ESX              = nil
local PlayerData = {}






local isMenuOpen = false



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)








RegisterCommand("icbook", function()
    Citizen.CreateThread(function()
		if Config.UzywanieKomendy then
			if isMenuOpen == false then
				PhonePlayOut()	
				if not Config.ItemUsage then    
					SetDisplay(not display) 
					isMenuOpen = true
					PhonePlayIn()
				else
					ESX.TriggerServerCallback('icphone:getItemAmount', function(qtty)
						if qtty > 0 then
							SetDisplay(not display)
							PhonePlayIn() 
							isMenuOpen = true
						else
							ESX.ShowAdvancedNotification('Operator', 'Telefon', 'Nie posiadasz ~r~IC-Phone', 'CHAR_CHAT_CALL', 1)
							PhonePlayOut()
						end
					end)
				end
			end
		else
			ESX.ShowAdvancedNotification('Operator', 'Telefon', 'Komenda jest ~r~Wyłączona', 'CHAR_CHAT_CALL', 1)
		end
	end)
end, false)


-- UI --
Citizen.CreateThread(function()
	local blocker = false
	local czas = 0
	while true do
	Citizen.Wait(4+czas)

	--print(blocker)

	if Config.Optymalizacja == true then
		czas = 1000
		blocker = true
	else
		czas = 0
	end
	if blocker == false then
		if isMenuOpen == false then
				PhonePlayOut()
                    if IsControlJustReleased(0, Config.GuzikOdpalania) then
                        if Config.ItemUsage then    
                            SetDisplay(not display) 
						    isMenuOpen = true
                            PhonePlayIn()
                        else
                            ESX.TriggerServerCallback('icphone:getItemAmount', function(qtty)
                                if qtty > 0 then
                                    SetDisplay(not display)
                                    PhonePlayIn() 
                                    isMenuOpen = true
                                else
                                    ESX.ShowAdvancedNotification('Operator', 'Telefon', 'Nie posiadasz ~r~IC-Phone', 'CHAR_CHAT_CALL', 1)
                                    PhonePlayOut()
                                end
                            end)
                        end
					end
					--PhonePlayOut()	
			
		end

	else
		if isMenuOpen == false then
			PhonePlayOut()
		end
	end

end	
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
	isMenuOpen = false
end)


function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
		bitcoinMiningValue = bitcoinMiningValue,
		bitcoinAmount = bitcoinAmount,
		bitcoinSellValue = bitcoinSellValue,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)





--====================================================================================--
--                                    ANIMACJE                                        --
--====================================================================================--

local myPedId = nil

local phoneProp = 0
local phoneModel = "prop_amb_phone"
-- OR "prop_npc_phone"
-- OR "prop_npc_phone_02"
-- OR "prop_cs_phone_01"

local currentStatus = 'out'
local lastDict = nil
local lastAnim = nil
local lastIsFreeze = false

local ANIMS = {
	['cellphone@'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_listen_base',
			
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_call_out',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	},
	['anim@cellphone@in_car@ps'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_in',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_horizontal_exit',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	}
}

function newPhoneProp()
	deletePhone()
	local hash = GetHashKey(phoneModel)

	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(0)
	end

	local coords = GetEntityCoords(myPedId, true)
	phoneProp = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
	local bone = GetPedBoneIndex(myPedId, 28422)
	AttachEntityToEntity(phoneProp, myPedId, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(hash)
end

function deletePhone ()
	if phoneProp ~= 0 then
		SetEntityAsMissionEntity(phoneProp,  true,  true)
		Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(phoneProp))
		phoneProp = 0
	end
end

--[[
	out || text || call
--]]
function PhonePlayAnim (status, freeze, force)
	if currentStatus == status and not force then
		return
	end

	myPedId = GetPlayerPed(-1)
	local freeze = freeze or false

	local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId, false) then
		dict = "anim@cellphone@in_car@ps"
	end

	loadAnimDict(dict)
	local anim = ANIMS[dict][currentStatus][status]
	if currentStatus ~= 'out' then
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end

	local flag = 50
	if freeze == true then
		flag = 14
	end

	TaskPlayAnim(myPedId, dict, anim, 3.0, -1, -1, flag, 0, false, false, false)
	if status ~= 'out' and currentStatus == 'out' then
		Citizen.Wait(380)
		newPhoneProp()
	end

	lastDict = dict
	lastAnim = anim
	lastIsFreeze = freeze
	currentStatus = status

	if status == 'out' then
		Citizen.Wait(180)
		deletePhone()
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end

end

function PhonePlayOut()
	PhonePlayAnim('out')
end

function PhonePlayText()
	PhonePlayAnim('text')
end

function PhonePlayCall(freeze)
	PhonePlayAnim('call', freeze)
end

function PhonePlayIn() 
	if currentStatus == 'out' then
		PhonePlayText()
	end
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
end