-- OpenComputers APIs
local component = require("component")
local thread = require("thread")
local event = require("event")
local os = require("os")
local serialization = require("serialization")

-- idiotball APIs
local ib = require("idiotball")
local n = require("network")
local rcp = require("rcp")

local m = component.modem

-- Characteristics of this server
local hostname = "defaulthost"
local commands = {"rcp"}
local shared_data = {}

-- Start primary threads

local CleanupThread = thread.create(function()
  event.pull("interrupted")
  print("Entering CleanupThread")
end)

local SetupThread = thread.create(function()
  -- If we don't get a response, assume we are the first host to come online
  n.declareRemote(hostname, commands, shared_data)
end)

local InteractiveThread = thread.create(function()
  print("stub")
end)

thread.waitForAny({n.CleanupThread, n.ReceiverThread})
os.exit(0)


-- Threads and processess to support:

-- file copy
-- backup to a master backup server
-- remote identification and port allocation
-- generalized data syncing