-- OpenComputers APIs
local component = require("component")
local thread = require("thread")
local event = require("event")
local os = require("os")
local serialization = require("serialization")

-- idiotball modules
local ib = require("idiotball")

local m = component.modem

network = {}

-- default broadcast port for discovery
local default_port = 100
-- increment this variable to assign a port to each remote
local next_port = default_port
m.open(default_port)

network.known_packets = {
  "ack",         -- Acknowledgement stage of a handshake protocol
  "identify",    -- Configure a new remote for messaging to this server
  "identify_ack",
  "command",     -- Send a command to a remote
  "request",     -- Request data from a remote
  "message"      -- Send data or the resturn of a command to a remote
}

known_remotes = {}

local function declareRemote(name, commands, local_data)
  print("Identifying this remote to the server")
  local packet = {
    header = "identify",
    body = {remote_name = name,
            commands = commands,
            local_data = local_data
           }}
  m.broadcast(default_port, serialization.serialize(packet))
  -- receive information from the server
  while true do
    _, _, from, port, _, serial_packet = event.pull("modem_message")
    packet = serialization.unserialize(serial_packet)
    if serialization.unserialize(serial_packet).header == "identify_ack" then
      m.open(port)
      return {port, from}
    end
  end
end  

local function addRemote(packet, address)
  print("Entering addRemote")
  next_port = next_port + 1
    
  remote = {name = packet.body.remote_name,
            address = address,
            port = next_port,
            ack = false,
            commands = {},
            local_data = {}
           }
  m.open(remote.port)
  ack_package = {header = "identify_ack",
                 body = {}
                }   
  m.send(remote.address, remote.port, serialization.serialize(ack_package))
  known_remotes[packet.body.remote_name] = remote
  print("Finished registering remote")
end

local function processPacket(packet, address, port)
  print("Entering processPacket for port " .. port)
  
  -- check whether we know how to process this packet
  if not ib.contains(network.known_packets, packet.header) then
    error("Packet presented an unknown header")
  end
  -- select which routine to run based on the header type
  if packet.header == "ack" then
    server.known_remotes[packet.header].ack = true
  elseif packet.header == "identify" then
  -- TODO define what this should do
    print("Received an identify packet on port " .. port)
    addRemote(packet, address)
  elseif packet.header == "command" then
    print("Received a command packet on port " .. port)
  end
end

network.ReceiverThread = thread.create(function()
  print("Entering ReceiverThread")
  while true
  do
    _, _, from, port, _, serial_packet = event.pull("modem_message")
    -- print the contents of the packet for debug
    print("Received packet from "  ..  from .. " on port " .. port)
    packet = serialization.unserialize(serial_packet)
    processPacket(packet, from, port)
  end
end)

network.CleanupThread = thread.create(function()
  event.pull("interrupted")
end)

return network

--thread.waitForAny({network.CleanupThread, network.ReceiverThread})
--os.exit(0)