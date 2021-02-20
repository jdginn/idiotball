
-- Utility to copy files to a remote server running this same code
--io = require("io")
component = require("component")
filesystem = require("filesystem")
shell = require("shell")
serialization = require("serialization")

rcp = {}

function rcp.sendPacket(filename)
  local path = shell.resolve(filename)
  if not filesystem.exists(path) then
    error("Requested file does not exist")
  end

  local file = io.open(path, "r")
  local data = file:read("*a")
  --print(data)
  local packet = {
    header = "rcp_transmit",
    filename = filename,
    body = data
  }
  return serialization.serialize(packet)
end

function rcp.receivePacket(packet)
  local path = shell.resolve(packet.filename)
  local file = io.open(path, "w")
  file:write(data)
end