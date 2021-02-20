-- Miscellaneous utility functions

local thread = require("thread")
local event = require("event")

idiotball = {}

function idiotball.contains(table, key)
  for _, value in pairs(table) do
    if value == key then
      return true
    end
  end
  return false
end

idiotball.CleanupThread = thread.create(function()
  print("pending")
  event.pull("interrupted")
  print("Entering CleanupThread")
end)

return idiotball