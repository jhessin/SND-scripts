SNDConfigFolder = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\"
LoadFunctionsFileLocation = SNDConfigFolder .. "vac_functions.lua"
LoadFunctions = loadfile(LoadFunctionsFileLocation)
LoadFunctions()
LoadFileCheck()

if not CheckPluginsEnabled("AutoDuty") then
    return
end

yield("/echo Updating Gearsets please wait...")
totalGearsets = 34

for i=1,totalGearsets do
  yield("/gearset change " .. tostring(i))
  yield("/ad equiprec")
  yield("/updategearset")
  yield("/wait 5")
end
yield("/echo Finished Updating Gear!")
