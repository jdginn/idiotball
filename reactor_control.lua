-- libraries supporting threading
local thread = require("thread")
local event = require("event")
local math = require("math")

-- libraries supporting component interaction
local component = require("component")
local sides = require("sides")

-- serialization for transmitting tables across network
local serialization = require("serialization")

-- idiotball API
local system = requires("system")
local system = requries("battery")
local system = requires("reactor")

-- broadcast reactor status to connectd devices
m = component.modem

local battery = Battery:new(nil, component.ic2_te_mfsu)
local reactor = Reactor:new(nil, component.reactor_chamber, battery, component.redstone, 0.01)

local reactor_control_thread = thread.create(function()
  print("Entering reactor control thread")
  status = {}
  while true do
    os.sleep(15)
    print("reporting status")
    reactor:toggle()
    status.charge = component.ic2_te_mfsu.getEnergy()/battery.capacity
    status.heat = component.reactor_chamber.getHeat()/reactor.max_heat
    status.charging = battery.charge
    m.broadcast(100, serialization.serialize(status))
    print("charge: ", status.charge)
    print("heat: ", status.heat)
    print("charging: ", status.charging)
    print("")
  end
end)

local cleanup_thread = thread.create(function()
  event.pull("interrupted")
  print("Entering cleanup thread")
end)
    
thread.waitForAny({cleanup_thread, reactor_control_thread})
os.exit(0)  
    
