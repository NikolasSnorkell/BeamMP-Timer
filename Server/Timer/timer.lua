Timer_max = 0
lastTime = 0

function onInit()
    print("Loading Timer Done!")
    MP.RegisterEvent("onChatMessage", "onChatMessage")
    MP.RegisterEvent("onTimer", "timer")
end

function onChatMessage(senderID, name, message)
    if string.find(message, "/timer") ~= nil then
        local length = 0
        local stopCommand = false
        local minutes = 0
        local seconds = 0
        for i in string.gmatch(message, "%S+") do
            if length == 1 then
                if i == "stop" then
                    
                    stopCommand = true
                    MP.TriggerClientEventJson(-1, "onStopTimer", {time = Timer_max})
                    MP.CancelEventTimer("onTimer")
                    break
                else
                    minutes = tonumber(i)
                    if minutes == nil then
                        MP.SendChatMessage(-1, "[TIMER] ENTERED INVALID VALUE")
                        break
                    end
                end
            elseif length == 2 then
                seconds = tonumber(i)
                if seconds == nil then
                    MP.SendChatMessage(-1, "[TIMER] ENTERED INVALID VALUE")
                    break
                end
            end
            length = length + 1
        end

        if not stopCommand and minutes ~= nil then
            Timer_max = (minutes * 60) + (seconds or 0)
            lastTime = 0
            print("Create event timer")
            MP.TriggerClientEventJson(-1, "onStartTimer", {time = Timer_max})
            
            MP.CancelEventTimer("onTimer")
            MP.CreateEventTimer("onTimer", 1000)
        end

        return 1
    end
end

function timer()
    print("Timer tick")
    if lastTime < os.time() then
        lastTime = os.time()
        Timer_max = Timer_max - 1
        MP.TriggerClientEventJson(-1, "updateTimer", {time = Timer_max})
        if Timer_max <= 0 then
            MP.TriggerClientEventJson(-1, "onStopTimer", {time = 0})
            MP.CancelEventTimer("onTimer")
        end
    end
end