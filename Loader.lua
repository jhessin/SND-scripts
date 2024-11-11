SNDConfigFolder = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\"
scriptName = "Questionable.lua"
script = SNDConfigFolder .. scriptName
runscript = loadfile(script)
runscript()
