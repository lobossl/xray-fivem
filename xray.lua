RegisterCommand("triggerNigger", function()
     sendNuiMessageOnRayUpdate()
end, false)
RegisterKeyMapping("triggerNigger", "Trigger N key command", "keyboard", "N")

function sendNuiMessageOnRayUpdate()
     local getEntity = GetEntityInFrontOfPlayer(5.0)
     local getType = GetEntityType(getEntity)

     if getType > 0 and getType < 5 then
          SendNUIMessage({
               action = "popup",
               getType = getType,
               getEntity = getEntity
          })
          SetNuiFocus(true, true)
          activatedRay(getEntity,getType)
     else
          print("no entity close to you")
     end
end

function activatedRay(getEntity,getType)
     -- 1 = ped 2 = vehicle 3 = object 4 = player
     if getType == 1 then
          DeleteEntity(getEntity)
     end
end

function GetEntityInFrontOfPlayer(radius)
     local playerPed = PlayerPedId()
     local pos = GetEntityCoords(playerPed, true)
     local forwardVector = GetEntityForwardVector(playerPed)
     local testPos = vector3(
         pos.x + forwardVector.x * radius,
         pos.y + forwardVector.y * radius,
         pos.z + forwardVector.z * radius
     )
     local rayHandle = StartShapeTestRay(
         pos.x, pos.y, pos.z,
         testPos.x, testPos.y, testPos.z,
         -1, -- (15) or (-1)
         playerPed,
         4
     )
     local a, hit, endCoords, b, c, entityHit = GetShapeTestResult(rayHandle)

     return hit == 1 and c or nil
end

RegisterCommand("kill", function(source, args)
     local ped = PlayerPedId()
     SetEntityHealth(ped, 0)
     TriggerServerEvent("kill")
end,false)

RegisterNUICallback("closeBtn",function(data,cb)
     SetNuiFocus(false, false)
     SendNUIMessage({
          action = "closeBtn",
          getType = "",
          getEntity = ""
     })
     cb("ok") -- you have to return the callback at all times
end)
