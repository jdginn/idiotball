-- libraries supporting component interaction
local component = require("component")
local sides = require("sides")
local math = require("math")

-- idiotball API
local systemtools = require("systemtools")
local Battery = require("Battery")

local Reactor = {}
---------- class representing a fluid reactor system --------
Reactor = {
  component = nil,
  -- this class is designed to interact with an EU storage device
  -- EU storage is essential to regulate load and must be provided as an EU sink for a fluid reactor
  -- failure to integrate a battery will result in reactor instability
  battery = nil,
  interval = 1
}

-- inherit from System class
setmetatable(Reactor, systemtools.System)

function Reactor:new (o, i_component, i_battery, i_redstone, i_threshold)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
	
	self.systemName = "reactor"
	self.status = {
		charge = 0,
		heat = 0,
		charging = true
	}

    self.component = i_component
    self.battery = i_battery
    print("self.battery: ", self.battery)
    self.redstone = i_redstone
    self.heat_threshold = i_threshold
    self.max_heat = self.component.getMaxHeat()
    return o
end

function Reactor:toggle ()
  self.battery:updateToCharge()
  percent_heat = self.component.getHeat()/self.max_heat
  if self.battery.charging == true and percent_heat <= self.heat_threshold then
  --if self.battery.charge == true then
    -- redstone on = reactor off
    self.redstone.setOutput(sides.south, 0)
  else
    self.redstone.setOutput(sides.south, 14)
  end
end

return Reactor
