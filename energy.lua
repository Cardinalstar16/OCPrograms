local component = require("component")
local rs = component.redstone
local geo = component.geolyzer

local needsToRun = false

function numFinderWithComma(str)
  local array = {}
  local k = 0
  for w in string.gmatch(str, "[0123456789,]+") do
    array[k] = w
    k = k+1
  end
  return array
end

function cNumtoNum(str)
  local num = {}
  local k = 1
  for w in string.gmatch(str, "%d+") do
    num[k] = w
    k=k+1
  end
  return table.concat(num)
end

while (true) do
  os.sleep(.5)
  local item = geo.analyze(1)
  local powerInfo
  local EUin
  local EUout
  for i, value in pairs(item) do
    if i == 'sensorInformation' then
      for v, p in pairs(item['sensorInformation']) do
        if v == 3 then
          powerInfo = p
        elseif v == 5 then
          EUin = p
        elseif v == 7 then
          EUout = p
        end
      end
    end 
  end

  powerArray = numFinderWithComma(powerInfo)
  local powerHeld = powerArray[0]
  local powerMax = powerArray[1]
  os.execute("clear")
  print("Power: "..powerArray[0].." EU / "..powerArray[1].." EU") 
  print("Power In: "..EUin)
  print("Power Out: "..EUout)

  local numpowerHeld = tonumber(cNumtoNum(powerArray[0]))
  local numpowerMax = tonumber(cNumtoNum(powerArray[1]))
  
  if ((numpowerHeld/numpowerMax < .1) and (needsToRun == false)) then
    needsToRun = true
    rs.setOutput(1,10)
  end


  if((numpowerHeld/numpowerMax > .95) and (needsToRun== true)) then
    needsToRun = false
    rs.setOutput(1,0)
  end
end