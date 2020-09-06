--libraries
local thread = require("thread")
local event = require("event")
local math = require("math")

--libraries for component interaction
local component = require("component")
local sides = require("sides")

--network libraries
local serialization = requires("serialization")

--idiotball API
local system = requires("system")

-------- Idiotball implementation --------
-- class representing control of the entire machine floor
Idiotball = {
  modem = nil
  ports = {}
  -- collection of all idiotball subsystems running on the machine floor
  -- these will be of class System
  systems = {}
}

function Idiotball:new ()
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.modem = component.modem
  return o
end

function Idiotball:registerSystem (systemDef, port)
	-- associate this port with this system
	self.ports[port] = systemDef.systemName
	self.systems[systemDef.systemName] = System(systemDef)
end

-- should these functions discriminate by port? Should listen discriminate by port?
function Idiotball:handleStatusPacket (statusPacket)
	if has_key(self.systems, systemDef.systemName) then
		self.systems[systemDef.systemName].updateStatus()
	end
end

-- JDG TODO: pseudocode
function Idiotball:handleUpstreamCommand (commandPacket)
	if has_key(self.systems, systemDef.systemName) then
		-- what next?
	end
end

function Idiotball:sendDownstreamCommand ()
	print("Unimplemented")
end

-- listen for packets on all ports
-- use packets to configure new systems, udpate status for existing systems, or handle commands
-- JDG TODO: is this really a function or does it need to be definied differently as a thread?
function Idiotball:listen ()
	_, _, from, port, _, message = event.pull("modem_message")
	packet = serialize.deserialize(message)
	-- detect new packets to configure
	if packet.packetType == "SystemDef" then self.registerSytem(packet, port)
	-- update status for StatusPackets corresponding to any configured system
	elseif packet.packetType == "StatusPacket" then self.handleStatusPacket(packet)
	-- handle upstream commands from a system to Idiotball
	elseif packet.packetType == "CommandPacket" then self.handleUpstreamCommand(packet)
end

-------- Threads --------
local network_status_thread = thread.create(function()
	return true
end)

local global_sync_thread = thread.create(function()
	return true
end)

local console_thread = thread.create(function()
	return true
end)
