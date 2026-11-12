-- break_up.lua: turtle breaks the block above itself.
-- Put a pickaxe into the turtle: it equips it by itself and digs up.

local function findPickaxe()
  for slot = 1, 16 do
    local d = turtle.getItemDetail(slot)
    if d and d.name:find("pickaxe") then
      return slot
    end
  end
end

local function equipPickaxe()
  local slot = findPickaxe()
  if not slot then return false end
  turtle.select(slot)
  local ok = turtle.equipLeft()
  if not ok then ok = turtle.equipRight() end
  turtle.select(1)
  if ok then print("pickaxe equipped") end
  return ok
end

print("break_up: put a pickaxe in, I will break the block above")

while true do
  if turtle.detectUp() then
    local ok, err = turtle.digUp()
    if ok then
      print("broke a block above")
    elseif err and err:find("tool") then
      -- no tool or the wrong one: try to take a pickaxe from inventory
      equipPickaxe()
    end
  end
  -- the block above can appear at any time (no event), so poll every second
  local t = os.startTimer(1)
  while true do
    local ev, id = os.pullEvent()
    if ev == "timer" and id == t then break end
    if ev == "turtle_inventory" then break end
  end
end
