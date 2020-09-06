--libraries
local thread = require("thread")
local event = require("event")
local math = require("math")

--libraries for component interaction
local component = require("component")
local sides = require("sides")

--network libraries
local serialization = requires("serialization")

-------- Generic functions --------
function has_key(table, key)
	return table[key] ~= nil
end

-------- System library --------
-- JDG TODO: split this into its own file
-- class allowing a system to reveal its API to Idiotball
-- implemented as a standardized packet definition to be shared across the network
SystemDef = {
	packetType = "SystemDef",
	systemName = "",
	-- example status packet reveals the status attributes
	statusPacket = {},
	-- command messages this system is allowed to pass to Idiotball
	upstreamCommands = {},
	-- command messages Idiotball is allowed to pass to thos system
	downstreamCommands = {},
}

-- standardized packet definition for status messages
StatusPacket = {
	packetType = "StatusPacket",
	systemName = "",
	elems = {}
}

-- standardized packet definition for command messages
CommandPacket = {
	packetType = "CommandPacket",
	systemName = ""
}

-- Idiotball-side class for integrating a system into the larger API
-- This class will reside below the Idiotball class and support API calls to the respective systems
System = {
	systemName = "",
	status = {}
}

function System:new (systemDef)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.name = systemDef.systemName
	
	return o
end

function System:updateStatus (statusPacket)
	for element in statusPacket.elems do
		self.status[element] = statusPacket.elem(data)
	end
end

function System:showStatus ()
	for element in self.status do
		print("element: " .. self.status[element])
	end
end

