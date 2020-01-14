print('start.lua')
local dummy,reason = node.bootreason()
if reason == nil then
    print('node.bootreason() returns nil as second value. Setting to 2')
    reason = 2
end

--node.egc.setmode(node.egc.ON_MEM_LIMIT, 4096)

local esp01 = node.chipid() == 1757122

print('bootreason: '..reason)
print(node.bootreason())

local signalPin = nil
if reason ~= 4 or not esp01 then
    signalPin = 7
    if esp01 then
        signalPin = 10  -- on esp 01  =  GPIO1  =  TX
    end
    gpio.mode(signalPin, gpio.OUTPUT)
end

if file.open('PANIC_GUARD') then
    file.close()
    if signalPin then
        pwm.setup(signalPin, 2, 0)
        pwm.setduty(signalPin, 900)
    end
    print('aborting autostart since last run crashed too early')
    print('jsut restart to resume normal operation')
    file.remove('PANIC_GUARD')
else
    file.close()
    if signalPin then
        pwm.setup(signalPin, 1, 0)
        pwm.setduty(signalPin, 512)
    end

    print('Setting up CRASH_GUARD')
    file.open('PANIC_GUARD','w')
    tmr.alarm(0,10000,0,function()
            print('removing PANIC_GUARD')
            file.remove('PANIC_GUARD')
            if signalPin then
              pwm.close(signalPin)
              gpio.write(signalPin, gpio.LOW);  -- turn light off permanently
            end
        end)

    print('Starting Application')
    
      dofile("renameDataFiles.lua")

      pcall(function() dofile("SonoffRunner.lua") end)

      print('heap: ',node.heap(),(function() collectgarbage() return node.heap() end) ())
      if file.exists("httpserver-compile.lc") then
         dofile("httpserver-compile.lc")
      else
         dofile("httpserver-compile.lua")
      end

      -- Set up NodeMCU's WiFi
      dofile("httpserver-wifi.lc")

      -- Start nodemcu-httpsertver
      dofile("httpserver-init.lc")
      print('heap: ',node.heap(),(function() collectgarbage() return node.heap() end) ())

end
