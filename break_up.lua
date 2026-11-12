-- break_up.lua v4: turtle breaks the block above itself.
-- Put a pickaxe into the turtle: it equips it by itself and digs up.

local VERSION = "v4"
local equipped = false
local noPickPrinted = false

local function findPickaxe()
  for slot = 1, 16 do
    local d = turtle.getItemDetail(slot)
    if d and d.name:lower():find("pickaxe") then
      return slot, d.name
    end
  end
end

local function equipPickaxe()
  local slot, name = findPickaxe()
  if not slot then
    if not noPickPrinted then
      noPickPrinted = true
      print("no pickaxe in inventory")
      for s = 1, 16 do
        local d = turtle.getItemDetail(s)
        if d then print("  slot " .. s .. ": " .. d.name) end
      end
    end
    return false
  end
  turtle.select(slot)
  -- use only a FREE side so the crafting table is never swapped out
  local leftBusy = turtle.getEquippedLeft and turtle.getEquippedLeft() ~= nil
  local rightBusy = turtle.getEquippedRight and turtle.getEquippedRight() ~= nil
  local ok, err
  if not leftBusy then
    ok, err = turtle.equipLeft()
  end
  if not ok and not rightBusy then
    ok, err = turtle.equipRight()
  end
  if not ok and err == nil then err = "no free side for the pickaxe" end
  turtle.select(1)
  if ok then
    equipped = true
    print("equipped " .. name)
  else
    print("equip failed: " .. tostring(err))
    if err == "Not a valid upgrade" then
      print("  need a NEW diamond pickaxe: no damage, no enchants")
    end
  end
  return ok
end

print("break_up " .. VERSION .. ": put a pickaxe in, I will break the block above")

local lastMsg
while true do
  if turtle.detectUp() then
    local ok, err = turtle.digUp()
    if ok then
      print("broke a block above")
    else
      if err ~= lastMsg then
        print("digUp failed: " .. tostring(err))
        lastMsg = err
      end
      if not equipped then equipPickaxe() end
    end
  else
    lastMsg = nil
  end
  -- the block above can appear at any time (no event), so poll every second
  local t = os.startTimer(1)
  while true do
    local ev, id = os.pullEvent()
    if ev == "timer" and id == t then break end
    if ev == "turtle_inventory" then
      equipped = false -- inventory changed: allow trying a pickaxe again
      noPickPrinted = false
      break
    end
  end
end
