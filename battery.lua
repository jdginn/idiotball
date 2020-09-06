-- libraries supporting threading
local thread = require("thread")
local event = require("event")
local math = require("math")

-- libraries supporting component interaction
local component = require("component")
local sides = require("sides")

-- idiotball API
local system = requires("system")

-------- class representing a EU storage device --------
Battery = {
  component = nil,
  charging = true
}

function Battery:new (o, i_component)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.component = i_component
  self.capacity = self.component.getCapacity()
  self.charging = true
  return o
end

function Battery:updateToCharge ()
  percent = self.component.getEnergy()/self.capacity
  -- because there may be lag time between starting a power source and its acheiving efficiency,
  -- we want to void rapid toggling so we ipmlement hysteresis in this function and only switch
  -- for charges below 85% or above 95%
  if percent <= 0.85 then
    self.charging = true
  elseif percent >= 0.95 then
    self.charging = false
  end
end
