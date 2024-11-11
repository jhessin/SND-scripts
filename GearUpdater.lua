--[[
--  This script will go through a set number of gearsets and update them with
--  the recommended gear. It requires autoduty and Simple Tweaks setting
--  Gearset Update Command
--]]
--
-- Options:
-- This is the total number of gearsets to update This way you aren't updating
-- specialty gearsets.
totalGearsets = 34
-- totalGearsets = 2

-- This is the command that is set up as your "Gearset Update Command" in
-- simple tweaks.
updateCommand = "/updategearset"

-- Start script --

SNDConfigFolder = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\"
LoadFunctionsFileLocation = SNDConfigFolder .. "vac_functions.lua"
LoadFunctions = loadfile(LoadFunctionsFileLocation)
LoadFunctions()
LoadFileCheck()

if not CheckPluginsEnabled("AutoDuty") then
    return
end

yield("/echo Updating Gearsets please wait...")

for i=1,totalGearsets do
  yield("/gearset change " .. tostring(i))
  yield("/ad equiprec")
  yield(updateCommand)
  yield("/wait 5")
end
yield("/echo Finished Updating Gear!")
