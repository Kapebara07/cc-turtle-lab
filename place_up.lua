-- place_up.lua: turtle places every block put into it above itself.
-- Runs forever. Put blocks in any slot (hand, hopper, chest, etc.).

local function placeAll()
  local placed = 0
  local blocked = false
  for slot = 1, 16 do
    while turtle.getItemCount(slot) > 0 do
      turtle.select(slot)
      if turtle.placeUp() then
        placed = placed + 1
      else
        -- something is above (block/entity) or this item cannot be placed
        blocked = true
        break
      end
    end
  end
  turtle.select(1)
  return placed, blocked
end

print("place_up: waiting for blocks, they will be placed above")

while true do
  local placed, blocked = placeAll()
  if placed > 0 then
    print("placed: " .. placed)
  end
  if blocked then
    -- space above is busy: retry in 2 seconds or when inventory changes
    local t = os.startTimer(2)
    while true do
      local ev, id = os.pullEvent()
      if ev == "timer" and id == t then break end
      if ev == "turtle_inventory" then break end
    end
  else
    os.pullEvent("turtle_inventory")
  end
end
