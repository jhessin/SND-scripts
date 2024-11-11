--[[
############################################################
##                           Job                          ##
##                         Unlocker                       ##
############################################################

THIS SCRIPT WILL PROBABLY BE RENAMED AND REDONE AT SOME POINT
It's features changed a lot from what it was initially meant to be and some things don't work anymore

####################
##    Version     ##
##     1.0.0      ##
####################

-> 1.0.0: Initial release


####################################################
##                  Description                   ##
####################################################

To use this script correctly, you will need different stages of MSQ completed up to certain point which are listed below, either using Questionable plugin or equivalent
While there are no minimum MSQ needing to be completed, it is recommended having a GC so you can access most of these options
All options are better used when a mount is unlocked, but are not required as it has fallback, however this will slow the speed of completion since you will spend more time moving around

Job quests (Arcanist and Archer) are completed so you have access to the armoury which allows you to unlock other jobs, only the first 3 job quests are included here
DoL unlocks are for use with the GC Supply Scripts, so you can bulk level DoL jobs for use with retainers, as they can be used for other purposes such as Quick Ventures
Maelstrom hunt log rank 1 should be used after you have selected your GC and ideally have gotten your mount, this requires Halatali to be completed
Maelstrom hunt log rank 2 should be used after you have a combat at level 47, this requires The Sunken Temple of Qarn to be completed
Dungeon unlocks are for GC related tasks, with the aforementioned being required for the GC hunt logs, Dzemael Darkhold and The Aurum Vale to be completed for higher GC ranks
Housing unlocks will unlock the first three housing areas as specified

More information on what everything does will be listed near the toggle

####################################################
##                  Requirements                  ##
####################################################

-> AutoDuty - https://puni.sh/api/repository/herc
-> Boss Mod - https://puni.sh/api/repository/veyn OR BossMod Reborn - https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
-> Lifestream - https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
-> Pandora - https://love.puni.sh/ment.json
-> Questionable - https://plugins.carvel.li/
-> Rotation Solver Reborn - https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
-> Something Need Doing (Expanded Edition) - https://puni.sh/api/repository/croizat
-> Teleporter - Base Dalamud
-> Textadvance - https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
-> Vnavmesh - https://puni.sh/api/repository/veyn
-> AutoRetainer : https://love.puni.sh/ment.json

Other:
char_list.lua file in the snd config folder with your characters configured properly unless you disable the external character list
vac_functions.lua placed in the snd config folder

######################################################
#   Stuff that doesn't work or is being worked on    #
######################################################

-- The entire arcanist line doesn't work atm
-- The lvl 1 archer quest isn't implemented yet, the two others work fine
-- Aurum vale unlock
-- possible that there's more dungeon ones broken
-- Job quests for marauder are likely to be implemented in some way soon, but none others are planned
-- Marauder Stuff

#####################
##    Settings     ##
###################]]

-- Only set one of these
DO_ARCANIST_QUESTS = false
DO_ARCHER_QUESTS = false
DO_MARAUDER_QUESTS = false

-- DoL job unlocks MIN/BTN/FSH
DO_DOL_QUESTS = false

-- Arcanist Hunt logs
DO_ARCANIST_LOG_1 = false                 -- Recommended level 14 (highest enemy)
DO_ARCANIST_LOG_2 = false                 -- Recommended level 24 (highest enemy)
DO_ARCANIST_LOG_3 = false                 -- Recommended level 33 (highest enemy)

-- Archer Hunt logs
DO_ARCHER_LOG_1 = false                   -- Recommended level 15 (highest enemy)
DO_ARCHER_LOG_2 = false                   -- Recommended level 23 (highest enemy)
DO_ARCHER_LOG_3 = false                   -- Recommended level 32 (highest enemy)

-- Marauder Hunt logs
DO_MARAUDER_LOG_1 = false                 -- Recommended level 13 (highest enemy)
DO_MARAUDER_LOG_2 = false                 -- Recommended level 20 (highest enemy)
DO_MARAUDER_LOG_3 = false                 -- Recommended level 32 (highest enemy)

-- Maelstrom Hunt logs, only does overworld enemies
DO_MAELSTROM_LOG_1 = false                -- Requires level 20 (for the dungeon). This is for unlocking Storm Sergeant First Class
DO_MAELSTROM_LOG_2 = false                -- Requires level 35 (for the dungeon), Storm Sergeant Third Class. This is for unlocking Chief Storm Sergeant

-- Dungeon unlocks, queues dungeons after unlock
DO_HALATALI = false                       -- Requires level 20. This is for unlocking GC rank by killing Maelstrom hunt log rank 1 enemies
DO_THE_SUNKEN_TEMPLE_OF_QARN = false      -- Requires level 35. This is for unlocking GC rank by killing Maelstrom hunt log rank 2 enemies
DO_DZEMAEL_DARKHOLD = false               -- Requires level 44, Storm Sergeant First Class. This is for unlocking GC rank by completing the dungeon
DO_THE_AURUM_VALE = false                 -- Requires level 47, Chief Storm Sergeant. This is for unlocking GC rank by completing the dungeon

-- Levels character to required level for housing unlocks
-- This assumes you are on a fresh level 1 character, everything in this section will assume you do not have things unlocked as if you would on a character that does
GET_LEVEL_FOR_HOUSING_WARD = false         -- Requires fresh level 1 character

-- Housing unlocks
DO_THE_LAVENDER_BEDS = false              -- This is for unlocking The Lavender Beds Housing
DO_MIST = false                           -- This is for unlocking Mist Housing
DO_THE_GOBLET = false                     -- This is for unlocking The Goblet Housing

local use_external_character_list = true  -- Options: true = uses the external character list in the same folder, default name being char_list.lua, false = use the list you put in this file 

local multi_char = true                  -- Options: true = cycles through character list, false = single character

-- This is where you put your character list if you choose to not use the external one
-- If use_external_character_list or multi_char is set to false then this list is completely skipped
-- Usage: First Last@Server
local character_list = {
    "First Last@Server",
    "First Last@Server"
}

-- #####################################
-- #  DON'T TOUCH ANYTHING BELOW HERE  #
-- # UNLESS YOU KNOW WHAT YOU'RE DOING #
-- #####################################

-- Enemy names for Arcanist quests
local ArcanistEnemies = {
    "Wharf Rat",           -- arcanist_01 "Way of the Arcanist"
    "Aurelia",             -- arcanist_02 "Way of the Arcanist"
    "Little Ladybug",      -- arcanist_03 "Way of the Arcanist"
    "Wild Dodo",           -- arcanist_04 "My First Grimoire"
    "Tiny Mandragora",     -- arcanist_05 "My First Grimoire"
    "Roseling",            -- arcanist_06 "What's in the Box"
    "Wild Jackal"          -- arcanist_07 "What's in the Box"
}

-- Enemy names for Archer quests
local ArcherEnemies = {
    "Ground Squirrel",     -- archer_01 "Way of the Archer"
    "Little Ladybug",      -- archer_02 "Way of the Archer"
    "Forest Funguar",      -- archer_03 "Way of the Archer"
    "Opo-opo",             -- archer_04 "My First Bow"
    "Microchu",            -- archer_05 "My First Bow"
    "Tree Slug",           -- archer_06 "A Matter of Perspective"
    "Northern Vulture"     -- archer_07 "A Matter of Perspective"
}

-- Enemy names for Maelstrom hunting log 1
local MaelstromEnemiesLog1 = {
    "Amalj'aa Hunter",     -- maelstrom_01
    "Heckler Imp",         -- maelstrom_02 "Halatali"
    "Doctore",             -- maelstrom_03 "Halatali"
    "Firemane",            -- maelstrom_04 "Halatali"
    "Sylvan Groan",        -- maelstrom_05
    "Sylvan Sough",        -- maelstrom_06
    "Kobold Pickman",      -- maelstrom_07
    "Amalj'aa Bruiser",    -- maelstrom_08
    "Ixali Straightbeak",  -- maelstrom_09
    "Ixali Wildtalon"      -- maelstrom_10
}

-- Enemy names for Maelstrom hunting log 2
local MaelstromEnemiesLog2 = {
    "Amalj'aa Divinator",  -- maelstrom_11
    "Kobold Pitman",       -- maelstrom_12
    "Temple Bat",          -- maelstrom_13 "The Sunken Temple of Qarn"
    "The Condemned",       -- maelstrom_14 "The Sunken Temple of Qarn"
    "Teratotaur",          -- maelstrom_15 "The Sunken Temple of Qarn"
    "Kobold Bedesman",     -- maelstrom_16
    "Kobold Priest",       -- maelstrom_17
    "Sylvan Sigh",         -- maelstrom_18
    "Shelfscale Sahagin",  -- maelstrom_19
    "Amalj'aa Pugilist"    -- maelstrom_20
}

-- Enemy names for Maelstrom hunting log 3
local MaelstromEnemiesLog3 = {
    "Ixali Boldwing",      -- maelstrom_21
    "Sylpheed Screech",    -- maelstrom_22
    "U'Ghamaro Bedesman",  -- maelstrom_23
    "Trenchtooth Sahagin", -- maelstrom_24
    "Sapsa Shelfclaw",     -- maelstrom_25
    "Zahar'ak Archer",     -- maelstrom_26
    "Natalan Fogcaller",   -- maelstrom_27
    "Natalan Boldwing",    -- maelstrom_28
    "Tonberry",            -- maelstrom_29 "The Wanderer's Palace"
    "Giant Bavarois"       -- maelstrom_30 "The Wanderer's Palace"
}

-- Edit char_list.lua file for configuring characters
char_list = "vac_char_list.lua"

snd_config_folder = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\"
vac_config_folder = snd_config_folder .. "\\VAC\\"
load_functions_file_location = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\vac_functions.lua"
LoadFunctions = loadfile(load_functions_file_location)
LoadFunctions()
LoadFileCheck()

if not CheckPluginsEnabled("AutoRetainer", "TeleporterPlugin", "Lifestream", "AutoDuty", "BossModReborn", "PandorasBox", "Questionable", "RotationSolver", "SomethingNeedDoing", "TextAdvance", "vnavmesh") then
    return -- Stops script as plugins not available
end

if HasPlugin("YesAlready") then
    PauseYesAlready()
end

LogInfo("[JU] ##############################")
LogInfo("[JU] Starting script...")
LogInfo("[JU] snd_config_folder: " .. snd_config_folder)
LogInfo("[JU] char_list: " .. char_list)
LogInfo("[JU] SNDConf+Char: " .. snd_config_folder .. "" .. char_list)
LogInfo("[JU] ##############################")

if use_external_character_list then
    local char_data = dofile(snd_config_folder .. char_list)
    character_list = char_data.character_list
end

-- ############
-- # ARCANIST #
-- ############

-- NEEDS fixing
-- Limsa Arcanists' First Quest Level 1 "Way of the Arcanist"
function Arcanist1()
    if not IsQuestDone("Way of the Arcanist") then
        if not (ZoneCheck("Limsa Lominsa Lower") or ZoneCheck("Limsa Lominsa Upper")) then
            -- needs teleport unlocked check here
            Teleporter("Limsa Lominsa", "tp")
            --Teleporter("Arcanist", "li")
        end
        
        Movement(-335.28, 12.90, 3.93)
        Target("Murie")
        InteractAndWait()
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC("SelectYesno", true, 0)
        Movement(-335.29, 11.99, 54.45)
        Teleporter("Tempest", "li")
        Movement(14.71, 64.52, 87.16)
        QuestChecker(ArcanistEnemies[1], 9999, "_ToDoList", "Slay wharf rats.")
        QuestChecker(ArcanistEnemies[3], 9999, "_ToDoList", "Slay little ladybugs.")
        Movement(232.67, 40.64, 57.39)
        QuestChecker(ArcanistEnemies[2], 9999, "_ToDoList", "Slay aureliae.")
        -- needs teleport unlocked check here
        Teleporter("Limsa", "tp")
        Teleporter("Arcanist", "li")
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        --DoQuest("My First Grimoire")
    else
        DoQuest("My First Grimoire") -- This has the echo text inside
    end
end

-- NEEDS fixing
-- Limsa Arcanists' Second Quest Level 5 "What's in the Box"
function Arcanist2()
    if GetLevel() < 5 then
        Echo("You do not have the level 5 requirement.")
        return
    end
    
    if not IsQuestDone("What's in the Box") then
        if not ZoneCheck("Limsa") then
            Teleporter("Limsa", "tp")
            Teleporter("Arcanist", "li")
        end
        
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        Movement(-335.29, 11.99, 54.45)
        Teleporter("Zephyr", "li")
        Movement(219.94, 66.81, 287.77)
        ZoneTransitions()
        Movement(381.76, 71.93, -256.04)
        --QuestChecker(ArcanistEnemies[4], 25, "_ToDoList", 13, 3, x, x, x, "Slay wild dodos.")
        Movement(418.06, 65.90, -160.37)
        --QuestChecker(ArcanistEnemies[5], 25, "_ToDoList", 13, 3, x, x, x, "Report to Thubyrgeim at the Arcanists' Guild.")
        Teleporter("Limsa", "tp")
        Teleporter("Arcanist", "li")
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        Movement(-335.29, 11.99, 54.45)
        Teleporter("Zephyr", "li")
        Movement(-0.01, 24.5, 194.68)
        Target("Practice Crates") -- Crates
        QuestNPC()
        yield("/rotation auto")
        
        repeat 
            Sleep(0.1)
        until GetCharacterCondition(26)
        
        repeat 
            Sleep(0.1)
        until not GetCharacterCondition(26)
        
        yield("/rotation off")
        Movement(-0.01, 24.5, 194.68)
        Sleep(1.6)
        WaitUntilObjectExists("Practice Crate") -- Crate
        Target("Practice Crates")
        QuestNPC("CutSceneSelectString", true, 0)
        
        repeat
            Sleep(0.1)
        until not GetCharacterCondition(35)
        
        repeat
            Sleep(0.1)
        until IsPlayerAvailable()
        
        Teleporter("Limsa", "tp")
        Teleporter("Arcanist", "li")
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        --DoQuest("What's in the Box")
    else
        DoQuest("What's in the Box") -- This has the echo text inside
    end
end

-- NEEDS fixing
-- Limsa Arcanists' Third Quest Level 10 "Tactical Planning"
function Arcanist3()
    if GetLevel() < 10 then
        Echo("You do not have the level 10 requirement.")
        return
    end
    
    if not IsQuestDone("Tactical Planning") then
        if not ZoneCheck("Limsa") then
            Teleporter("Limsa", "tp")
            Teleporter("Arcanist", "li")
        end
        
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        Teleporter("Swiftperch", "tp")
        Movement(674.92, 19.37, 436.02)
        --QuestChecker(ArcanistEnemies[6], 25, "_ToDoList", 13, 3, x, x, x, "Slay roselings.")
        Teleporter("Moraby", "tp")
        Movement(30.84, 46.18, 831.01)
        --QuestChecker(ArcanistEnemies[7], 40, "_ToDoList", 13, 3, x, x, x, "Report to Thubyrgeim at the Arcanists' Guild.")
        Teleporter("Limsa", "tp")
        Teleporter("Arcanist", "li")
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        Movement(-347.72, -2.37, 12.88)
        Target("K'lyhia")
        DoTargetLockon()
        QuestNPC()
        Teleporter("Summerford", "tp")
        Movement(-103.76, 46.15, -253.17)
        Target("K'lyhia")
        Interact()
        yield("/waitaddon SelectYesno <maxwait.10><wait.0.5>")
        yield("/pcall SelectYesno true 0")
        ZoneTransitions()
        yield("/rotation auto")
        QuestInstance()
        ZoneTransitions()
        Sleep(1.6)
        yield("/rotation off")
        Target("K'lyhia")
        DoTargetLockon()
        QuestNPC()
        Teleporter("Limsa", "tp")
        Teleporter("Arcanist", "li")
        Movement(-327.86, 12.89, 9.79)
        Target("Thubyrgeim")
        QuestNPC()
        --DoQuest("Tactical Planning")
    else
        DoQuest("Tactical Planning") -- This has the echo text inside
    end
end

-- ##########
-- # ARCHER #
-- ##########

-- Gridania Archer First Quest Level 1 "Way of the Archer"
function Archer1()
    if not IsQuestDone("My First Bow") then
        -- forgot to do this one, probs will later.
        --DoQuest("My First Bow")
    else
        DoQuest("My First Bow") -- This has the echo text inside
    end
end

-- NEEDS adjusting
-- Gridania Archer Second Quest Level 5 "A Matter of Perspective"
function Archer2()
    if GetLevel() < 5 then
        Echo("You do not have the level 5 requirement.")
        return
    end
    
    if not IsQuestDone("A Matter of Perspective") then
        if not ZoneCheck("New Gridania") then
            Teleporter("New Gridania", "tp")
            Teleporter("Archers' Guild", "li")
        end
        
        Movement(207.80, 0.10, 35.06)
        Target("Luciane")
        QuestNPC()
        Movement(187.65, -1.25, 63.54)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(109.31, 0.12, 59.86)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(50.87, 0.93, 25.88)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(51.35, -1.52, 61.06)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(66.11, -4.96, 91.91)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(57.20, -8.56, 105.41)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Movement(34.93, 1.92, 34.09)
        Teleporter("Archers' Guild", "li")
        Movement(207.80, 0.10, 35.06)
        Target("Luciane")
        QuestNPC()
        Teleporter("Fallgourd", "tp")
        Movement(307.65, -19.79, 171.31)
        QuestChecker(ArcherEnemies[4], 60, "_ToDoList", "Slay opo-opos.")
        Movement(301.68, -9.38, 11.51)
        QuestChecker(ArcherEnemies[5], 60, "_ToDoList", "Slay microchus.")
        Teleporter("New Gridania", "tp")
        Teleporter("Archers' Guild", "li")
        Movement(207.80, 0.10, 35.06)
        Target("Luciane")
        QuestNPC()
        --DoQuest("A Matter of Perspective")
    else
        DoQuest("A Matter of Perspective") -- This has the echo text inside
    end
end

-- NEEDS adjusting
-- Gridania Archer Third Quest Level 10 "Training with Leih"
function Archer3()
    if GetLevel() < 10 then
        Echo("You do not have the level 10 requirement.")
        return
    end

    if not IsQuestDone("Training with Leih") then
        if not ZoneCheck("New Gridania") then
            Teleporter("New Gridania", "tp")
            Teleporter("Archers' Guild", "li")
        end
        
        Movement(207.80, 0.10, 35.06)
        Target("Luciane")
        QuestNPC()
        Movement(208.91, 0.00, 29.65)
        Target("Leih Aliapoh")
        QuestNPC()
        Teleporter("Bentbranch", "tp")
        --First zone
        Movement(-88.03, -4.58, -73.39)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        Movement(-112.35, -3.95, -64.35)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        Movement(-135.89, -1.61, -71.04)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        --Second zone
        Movement(-146.34, 3.64, -129.18)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        Movement(-111.04, 7.75, -164.70)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        -- Third zone
        Movement(-80.48, 0.53, -176.20)
        Target("Archery Butt")
        DoAction("Heavy Shot")
        Sleep(0.2)
        -- Report to Leih Aliapoh
        Teleporter("New Gridania", "tp")
        Teleporter("Archers' Guild", "li")
        Movement(208.91, 0.00, 29.65)
        Target("Leih Aliapoh")
        QuestNPC()
        -- Kill some enemies
        -- Probably needs handling or validation adding
        Movement(147.35, -0.24, 84.22)
        Movement(115.20, -0.14, 74.28)
        Movement(94.11, 3.91, 24.27)
        Movement(99.57, 4.77, 17.09)
        Movement(101.94, 5.31, 13.12)
        ZoneTransitions()
        Movement(179.43, -2.16, -242.84)
        Target("Romarique")
        Sleep(0.5)
        Interact()
        
        repeat 
            Sleep(0.1)
        until IsAddonReady("SelectIconString")
        
        yield("/pcall SelectIconString true 0")
        Sleep(1.0)
        
        repeat 
            Sleep(0.1)
        until IsAddonReady("SelectYesno")
        
        yield("/pcall SelectYesno true 0")
        ZoneTransitions()
        Movement(-496.79, 8.99, 89.93)
        QuestChecker(ArcherEnemies[7], 50, "_ToDoList", "Slay northern vultures.")
        Movement(-448.56, -0.31, 226.01)
        QuestChecker(ArcherEnemies[6], 50, "_ToDoList", "Slay tree slugs.")
        --Report to Leih
        Teleporter("New Gridania", "tp")
        Teleporter("Archers' Guild", "li")
        Movement(208.91, 0.00, 29.65)
        Target("Leih Aliapoh")
        QuestNPC()
        -- report to Luciane
        Movement(207.80, 0.10, 35.06)
        Target("Luciane")
        Interact()
        
        repeat 
            Sleep(0.1)
        until IsAddonReady("SelectYesno")
        
        yield("/pcall SelectYesno true 0")
        
        repeat 
            Sleep(0.1)
        until IsPlayerAvailable()
        
        --DoQuest("Training with Leih")
    else
        DoQuest("Training with Leih") -- This has the echo text inside
    end
end

-- ###############
-- # JOB UNLOCKS #
-- ###############

-- NEEDS fixing
function MinerUnlock()
    if not IsQuestDone("Way of the Miner") then
        if not ZoneCheck("Ul'dah") then
            Teleporter("Ul'dah", "tp")
            Teleporter("Weaver", "li")
        end
        
        Movement(1.54, 7.6, 153.55)
        Target("Linette")
        QuestNPC("SelectYesno", true, 0)
        Sleep(1.6)
        Target("Linette")
        QuestNPC()
        Movement(-17.33, 6.2, 157.59)
        Target("Adalberta")
        QuestNPC("SelectYesno", true, 0)
        --DoQuest("Way of the Miner")
    else
        DoQuest("Way of the Miner") -- This has the echo text inside
    end
end

-- NEEDS fixing
-- Questionable does not support this yet, using alternative method
function BotanistUnlock()
    if not IsQuestDone("Way of the Botanist") then
        if not ZoneCheck("Gridania") then
            Teleporter("Gridania", "tp")
            Teleporter("Mih", "li")
        end
        
        Movement(-170.48, 10.39, -161.96)
        Movement(-238.64, 8, -144.90)
        Target("Leonceault")
        QuestNPC("SelectYesno", true, 0)
        Sleep(1.6)
        Target("Leonceault")
        QuestNPC()
        Movement(-234.09, 6.23, -170.02)
        Target("Fufucha")
        QuestNPC("SelectYesno", true, 0)
        --DoQuest("Way of the Botanist")
    else
        DoQuest("Way of the Botanist") -- This has the echo text inside
    end
end

-- NEEDS fixing
-- Questionable does not support this yet, using alternative method
function FisherUnlock()
    if not IsQuestDone("Way of the Fisher") then
        if not ZoneCheck("Limsa") then
            Teleporter("Limsa", "tp")
            Teleporter("Fish", "li")
        end
        
        Movement(-167.30, 4.55, 152.46)
        Target("N'nmulika")
        QuestNPC("SelectYesno", true, 0)
        Sleep(1.6)
        Target("N'nmulika")
        QuestNPC()
        Movement(-173.59, 4.2, 162.77)
        Movement(-165.74, 4.55, 165.38)
        Target("Sisipu")
        QuestNPC("SelectYesno", true, 0)
        --DoQuest("Way of the Fisher")
    else
        DoQuest("Way of the Fisher") -- This has the echo text inside
    end
end

-- ###############
-- # HUNTING LOG #
-- ###############

function ArcanistRank1()
    if GetLevel() < 14 then
        Echo("Warning: You are lower than level 14")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function ArcanistRank2()
    if GetLevel() < 24 then
        Echo("Warning: You are lower than level 24")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function ArcanistRank3()
    if GetLevel() < 33 then
        Echo("Warning: You are lower than level 33")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function ArcherRank1()
    if GetLevel() < 15 then
        Echo("Warning: You are lower than level 15")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function ArcherRank2()
    if GetLevel() < 23 then
        Echo("Warning: You are lower than level 23")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function ArcherRank3()
    if GetLevel() < 32 then
        Echo("Warning: You are lower than level 32")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function MarauderRank1()
    if GetLevel() < 13 then
        Echo("Warning: You are lower than level 13")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function MarauderRank2()
    if GetLevel() < 20 then
        Echo("Warning: You are lower than level 20")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

function MarauderRank3()
    if GetLevel() < 32 then
        Echo("Warning: You are lower than level 32")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    
end

-- ##################
-- # GC HUNTING LOG #
-- ##################

-- Requires GC
function MaelstromRank1()
    if GetLevel() < 37 then
        Echo("Warning: You are lower than level 37")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    if GetMaelstromGCRank() >= 5 then
        Echo("You have already completed this hunting log.")
        return
    end
    
    -- if not PandoraGetFeatureEnabled("Auto-Sync FATEs") then
        -- PandoraSetFeatureState("Auto-Sync FATEs", true)
    -- end
    
    -- Amalj'aa Hunter
    if HuntLogCheck(MaelstromEnemiesLog1[1], 9, 0) then
        if not ZoneCheck("Camp Drybone") then
            Teleporter("Camp Drybone", "tp")
        end
        
        Movement(-112.60, -27.88, 343.99)
        DoHuntLog(MaelstromEnemiesLog1[1], 2500, 9, 0)
    end
    
    -- Sylvan Groan and Sylvan Sough
    if HuntLogCheck(MaelstromEnemiesLog1[5], 9, 0) or HuntLogCheck(MaelstromEnemiesLog1[6], 9, 0) then
        if not ZoneCheck("The Hawthorne Hut") then
            Teleporter("The Hawthorne Hut", "tp")
        end
        
        if HuntLogCheck(MaelstromEnemiesLog1[5], 9, 0) then
            Movement(-135.26, 15.12, -1.46)
            DoHuntLog(MaelstromEnemiesLog1[5], 2500, 9, 0)
        end
        
        if HuntLogCheck(MaelstromEnemiesLog1[6], 9, 0) then
            Movement(-135.26, 15.12, -1.46)
            DoHuntLog(MaelstromEnemiesLog1[6], 2500, 9, 0)
        end
    end
    
    -- Kobold Pickman
    if HuntLogCheck(MaelstromEnemiesLog1[7], 9, 0) then
        if not ZoneCheck("Aleport") then
            Teleporter("Aleport", "tp")
        end
        
        Movement(417.30, 35.15, -17.66)
        ZoneTransitions()
        Movement(-399.78, 37.64, 16.40)
        DoHuntLog(MaelstromEnemiesLog1[7], 2500, 9, 0)
    end
    
    -- Amalj'aa Bruiser 
    if HuntLogCheck(MaelstromEnemiesLog1[8], 9, 0) then
        if not ZoneCheck("Little Ala Mhigo") then
            Teleporter("Little Ala Mhigo", "tp")
        end
        
        Movement(-9.38, 15.62, -291.08)
        DoHuntLog(MaelstromEnemiesLog1[8], 2500, 9, 0)
    end
    
    -- Ixali Straightbeak
    if HuntLogCheck(MaelstromEnemiesLog1[9], 9, 0) then
        if not ZoneCheck("Fallgourd Float") then
            Teleporter("Fallgourd Float", "tp")
        end
        
        Movement(53.52, -37.91, 312.72)
        DoHuntLog(MaelstromEnemiesLog1[9], 2500, 9, 0)
    end
    
    -- Ixali Wildtalon
    if HuntLogCheck(MaelstromEnemiesLog1[10], 9, 0) then
        if not ZoneCheck("Fallgourd Float") then
            Teleporter("Fallgourd Float", "tp")
        end
        
        Movement(-388.34, 3.04, 161.80)
        ZoneTransitions()
        Movement(468.13, 232.79, 321.85)
        DoHuntLog(MaelstromEnemiesLog1[10], 2500, 9, 0)
        if not IsAetheryteAttuned("Camp Dragonhead") then
            Movement(224.32, 301.51, -142.16)
            Movement(229.20, 312.91, -235.02)
            AttuneAetheryte()
        end
    end
    
    -- if not PandoraGetFeatureEnabled("Auto-Sync FATEs") then
        -- PandoraSetFeatureState("Auto-Sync FATEs", false)
    -- end
    
    Teleporter("Limsa", "tp")
end

-- Requires Storm Sergeant Third Class rank
function MaelstromRank2()
    if GetMaelstromGCRank() < 5 then
        Echo("You do not have the Storm Sergeant Third Class rank requirement.")
        return
    end
    
    if GetMaelstromGCRank() >= 8 then
        Echo("You have already completed this hunting log.")
        return
    end
    
    if GetLevel() < 48 then
        Echo("Warning: You are lower than level 48")
        Echo("It is advised to be higher level, proceed with caution.")
    end
    
    -- if not PandoraGetFeatureEnabled("Auto-Sync FATEs") then
        -- PandoraSetFeatureState("Auto-Sync FATEs", true)
    -- end
    
    -- Amalj'aa Divinator
    if HuntLogCheck(MaelstromEnemiesLog2[1], 9, 1) then
        if not ZoneCheck("Forgotten Springs") then
            Teleporter("Forgotten Springs", "tp")
        end
        
        Movement(310.98, 7.83, 641.79)
        DoHuntLog(MaelstromEnemiesLog2[1], 2500, 9, 1)
    end
    
    -- Kobold Pitman
    if HuntLogCheck(MaelstromEnemiesLog2[2], 9, 1) then
        if not ZoneCheck("Costa del Sol") then
            Teleporter("Costa del Sol", "tp")
        end

        Movement(340.18, 34.70, 227.85)
        DoHuntLog(MaelstromEnemiesLog2[2], 2500, 9, 1)
    end

    -- Kobold Bedesman and Kobold Priest
    if HuntLogCheck(MaelstromEnemiesLog2[6], 9, 1) or HuntLogCheck(MaelstromEnemiesLog2[7], 9, 1) then
        if HuntLogCheck(MaelstromEnemiesLog2[6], 9, 1) then
            if not ZoneCheck("Camp Bronze Lake") then
                Teleporter("Camp Bronze Lake", "tp")
            end

            Movement(284.54, 42.55, -204.27)
            ZoneTransitions()
            Movement(191.80, 63.95, -273.12)
            DoHuntLog(MaelstromEnemiesLog2[6], 2500, 9, 1)
            Movement(-113.44, 64.59, -216.03)
            AttuneAetheryte()
        end

        -- Checks if "Camp Overlook" aetheryte is attuned, and zone logic to save time
        if HuntLogCheck(MaelstromEnemiesLog2[7], 9, 1) then
            if IsAetheryteAttuned("Camp Overlook") then
                if not ZoneCheck("Camp Overlook") then
                    Teleporter("Camp Overlook", "tp")
                end
                Movement(39.38, 48.42, -381.98)
                DoHuntLog(MaelstromEnemiesLog2[7], 2500, 9, 1)
            else
                if ZoneCheck("Camp Bronze Lake") then
                    Movement(284.54, 42.55, -204.27)
                    ZoneTransitions()
                    Movement(-113.44, 64.59, -216.03)
                    AttuneAetheryte()
                elseif ZoneCheck("Camp Overlook") then
                    Movement(-113.44, 64.59, -216.03)
                    AttuneAetheryte()
                else
                    Teleporter("Camp Bronze Lake", "tp")
                    Movement(284.54, 42.55, -204.27)
                    ZoneTransitions()
                    Movement(-113.44, 64.59, -216.03)
                    AttuneAetheryte()
                end
            end

            Movement(39.38, 48.42, -381.98)
            DoHuntLog(MaelstromEnemiesLog2[7], 2500, 9, 1)
        end
    end

    -- Sylvan Sigh
    if HuntLogCheck(MaelstromEnemiesLog2[8], 9, 1) then
        if not ZoneCheck("The Hawthorne Hut") then
            Teleporter("The Hawthorne Hut", "tp")
        end
        
        Movement(193.44, -4.12, -4.61)
        DoHuntLog(MaelstromEnemiesLog2[8], 50, 9, 1) -- Morbols are nearby, bad breath is bad
        Movement(187.28, -0.56, 39.33)
    end
    
    -- Shelfscale Sahagin
    if HuntLogCheck(MaelstromEnemiesLog2[9], 9, 1) then
        if not ZoneCheck("Aleport") then
            Teleporter("Aleport", "tp")
        end
        
        Movement(0.56, -12.91, -96.50)
        Movement(-42.53, -22.25, -144.41)
        DoHuntLog(MaelstromEnemiesLog2[9], 2500, 9, 1)
    end
    
    -- Amalj'aa Pugilist
    if HuntLogCheck(MaelstromEnemiesLog2[10], 9, 1) then
        if not ZoneCheck("Little Ala Mhigo") then
            Teleporter("Little Ala Mhigo", "tp")
        end
        
        Movement(-36.09, 8.03, 149.24)
        DoHuntLog(MaelstromEnemiesLog2[10], 2500, 9, 1)
    end
    
    -- if not PandoraGetFeatureEnabled("Auto-Sync FATEs") then
        -- PandoraSetFeatureState("Auto-Sync FATEs", false)
    -- end
    
    Teleporter("Limsa", "tp")
end

-- ###################
-- # DUNGEON UNLOCKS #
-- ###################

function HalataliUnlock()
    if GetLevel() < 20 then
        Echo("You do not have the level 20 requirement.")
        return
    end

    if not IsQuestDone("Hallo Halatali") then
        -- could also use vesper bay ticket but needs the teleporter function adjusting
        if not ZoneCheck("Horizon") then
            Teleporter("Horizon", "tp")
        end
        
        Movement(-280.59, 15.26, -316.75) -- It gets stuck otherwise
        Movement(-314.96, 23.44, -347.65) -- It gets stuck otherwise
        Movement(-399.64, 23.00, -351.08) -- It gets stuck otherwise
        Movement(-471.06, 23.01, -354.81)
        DoQuest("Hallo Halatali")
    else
        DoQuest("Hallo Halatali") -- This has the echo text inside
    end
end

-- Questionable does not support this yet, using alternative method
function TheSunkenTempleOfQarnUnlock()
    if GetLevel() < 35 then
        Echo("You do not have the level 35 requirement.")
        return
    end

    if not IsQuestDone("Braving New Depths") then
        -- could also use vesper bay ticket but needs the teleporter function adjusting
        if not ZoneCheck("Horizon") then
            Teleporter("Horizon", "tp")
        end
        
        Movement(-280.59, 15.26, -316.75) -- It gets stuck otherwise
        Movement(-308.26, 21.15, -343.13) -- It gets stuck otherwise
        Movement(-399.64, 23.00, -351.08) -- It gets stuck otherwise
        Movement(-471.06, 23.01, -354.81)
        Target("Nedrick Ironheart")
        Interact()
        Sleep(0.5)
        
        repeat
            yield("/pcall SelectIconString true 0")
            Sleep(0.1)
        until IsAddonVisible("JournalAccept")
        
        Sleep(1.5)
        
        repeat
            yield("/pcall JournalAccept true 3 764")
            Sleep(0.1)
        until IsQuestAccepted(66300)
        
        Sleep(0.5)
        Teleporter("Little Ala Mhigo", "tp")
        Movement(184.26, 13.79, -444.12)
        Target("Bibimu")
        Interact()
        
        repeat
            yield("/pcall JournalResult true 0 0")
            Sleep(0.1)
        until IsQuestComplete(66300)
        
        EquipRecommendedGear()
        --DoQuest("Braving New Depths")
    else
        DoQuest("Braving New Depths") -- This has the echo text inside
    end
end

-- Requires Storm Sergeant First Class
-- Requires you to complete the dungeon for quest completion
function DzemaelDarkholdUnlock()
    if GetMaelstromGCRank() < 7 or GetLevel() < 44 then
        Echo("You do not have the Storm Sergeant First Class rank or the level 44 requirements.")
        return
    end
    
    if not IsQuestDone("Shadows Uncast (Maelstrom)") then
        if not IsAetheryteAttuned("Camp Dragonhead") then
            if not ZoneCheck("Fallgourd Float") then
                Teleporter("Fallgourd Float", "tp")
            end

            Movement(-388.34, 3.04, 161.80) -- Move to zone border to enter Coerthas Central Highlands
            Movement(224.32, 301.51, -142.16) -- Navmesh tends to break without this, probs won't matter since our stuck checker is a thing now
            Movement(229.20, 312.91, -235.02) -- Move to Aetheryte in Coerthas Central Highlands
            AttuneAetheryte()
        end

        if ZoneCheck("Limsa Lominsa Lower Decks") and not ZoneCheck("Limsa Lominsa Upper Decks") then
            Teleporter("Aftcastle", "li")
        elseif not ZoneCheck("Limsa Lominsa Lower Decks") and not ZoneCheck("Limsa Lominsa Upper Decks") then
            Teleporter("Limsa Lominsa Lower Decks", "tp")
            Teleporter("Aftcastle", "li")
        end

        DoQuest("Shadows Uncast (Maelstrom)")
        Teleporter("Limsa Lominsa Lower Decks", "tp")
    else
        DoQuest("Shadows Uncast (Maelstrom)") -- This has the echo text inside
    end
end

-- NEEDS doing
-- Questionable does not support this yet, using alternative method
-- Requires Chief Storm Sergeant
-- Requires you to complete the dungeon for quest completion
function TheAurumValeUnlock()
    if GetMaelstromGCRank() < 8 or GetLevel() < 47 then
        Echo("You do not have the Chief Storm Sergeant rank or the level 47 requirements.")
        return
    end

    if not IsQuestDone("Gilding the Bilious (Maelstrom)") then
        if not ZoneCheck("Limsa") then
            Teleporter("Limsa", "tp")
            Teleporter("Aftcastle", "li")
        end

        DoQuest("Shadows Uncast (Maelstrom)")
    else
        DoQuest("Gilding the Bilious (Maelstrom)") -- This has the echo text inside
    end
end

-- ####################
-- #   GET TO LEVEL   #
-- # NEEDED FOR WARDS #
-- ####################

-- This assumes you are on a fresh level 1 character, everything in this section will assume you do not have things unlocked as if you would on a character that does
-- Gridania and Ul'dah need doing
function GetLevelForHousingWard()
    local current_job = GetPlayerJob()

    -- Gridania questline
    if current_job == "LNC" or current_job == "ARC" or current_job == "CNJ" then
        if GetLevel() > 10 then
            Echo("Already above level 10.")
            return
        end
        
        DoQuest("Coming to Gridania")
        DoQuest("Close to Home")
    
    -- Limsa questline
    elseif current_job == "MRD" or current_job == "ACN" then
        if GetLevel() > 5 then
            Echo("Already above level 5.")
            return
        end

        yield("/qst start")
        
        while true do
            local level = GetCharacterLevel()
            
            if HasStatus("The Road to 90") then
                if level and level >= 4 then -- Only break if level is a valid number and >= 4
                    break
                end
            else
                if level and level >= 3 then -- Only break if level is a valid number and >= 3
                    break
                end
            end
            
            Sleep(0.1)
        end
        
        yield("/qst stop") -- Stops Questionable since we can go elsewhere for unlocks to level up now and because we can't continue msq as not high enough level anyway
        
        if GetLevel() < 5 and not IsQuestNameAccepted("On to Summerford") then
            Movement(15.47, 40.00, 70.98)
            AttuneAethernetShard()
        end
        
        if GetLevel() < 5 then
            if not ZoneCheck("Summerford Farms") then
                --Teleporter("Zephyr", "li")
                yield("/li Zephyr")
                ZoneTransitions()
            end
            Movement(102.11, 48.67, 11.91)
            
            -- Find and kill targets until level 5
            while true do
                local level = GetCharacterLevel()
                
                if level and level >= 5 then
                    break
                end
                
                FindAndKillTarget("Goblin Fisher", 9999)
                Sleep(1.0)
            end
        end
        
        if GetLevel() >= 5 and not IsAetheryteAttuned("Summerford Farms") then
            if not ZoneCheck("Summerford Farms") then
                --Teleporter("Zephyr", "li")
                yield("/li Zephyr")
                ZoneTransitions()
            end
            
            Movement(222.01, 113.10, -257.97)
            AttuneAetheryte()
        end
        
        -- Since Questionable refuses to work without having MSQ active...
        if not IsQuestNameAccepted("On to Summerford") then
            -- Check if the player is not in Limsa Lominsa Upper or Lower Decks
            if not ZoneCheck("Limsa Lominsa Upper Decks") and not ZoneCheck("Limsa Lominsa Lower Decks") then
                ReturnTeleport() -- Use return teleport if not in the required zones
            end

            -- Navigate to the Aetheryte and use the teleporter
            PathToObject("Aetheryte", 5)
            yield("/li Aftcastle") -- Teleport to "Aftcastle"
            ZoneTransitions() -- Handle the zone transition if necessary

            -- Move to the specified coordinates and interact with "Baderon"
            Movement(17.82, 40.22, -5.28)
            Target("Baderon")
            InteractAndWait()
        end
        
        if not ZoneCheck("Limsa Lominsa Lower Decks") then
            if ZoneCheck("Limsa Lominsa Upper Decks") then
                PathToObject("Aethernet Shard")
                --Teleporter("Limsa Lominsa Aetheryte Plaza", "li")
                yield("/li Limsa Lominsa Aetheryte Plaza")
                ZoneTransitions()
                PathToObject("Aetheryte", 5)
            else
                ReturnTeleport()
            end
        end
        
    -- Ul'dah questline
    elseif current_job == "GLA" or current_job == "PGL" or current_job == "THM" then
        if GetLevel() > 5 then
            Echo("Already above level 5.")
            return
        end
        
        DoQuest("Coming to Ul'dah")
        DoQuest("Close to Home")
    end
end

-- ###################
-- # HOUSING UNLOCKS #
-- ###################

function TheLavenderBedsUnlock()
    if GetLevel() < 10 then
        Echo("You do not have the level 10 requirement.")
        return
    end
    
    if not IsAetheryteAttuned("New Gridania") then
        Echo("You do not have New Gridania aetheryte attuned.")
        return
    end
    
    if not IsQuestDone("Where the Heart Is (The Lavender Beds)") then
        if IsAetheryteAttuned("Bentbranch Meadows") then
            if not ZoneCheck("Bentbranch Meadows") then
                Teleporter("Bentbranch Meadows", "tp")
            end
        else
            if ZoneCheck("New Gridania") then
                Teleporter("New Gridania", "tp")
                Teleporter("Blue Badger Gate", "li")
                Movement(6.97, -1.21, 31.54)
                AttuneAetheryte()
            elseif ZoneCheck("Bentbranch Meadows") then
                Movement(6.97, -1.21, 31.54)
                AttuneAetheryte()
            else
                Teleporter("New Gridania", "tp")
                Teleporter("Blue Badger Gate", "li")
                Movement(6.97, -1.21, 31.54)
                AttuneAetheryte()
            end
        end
        DoQuest("Where the Heart Is (The Lavender Beds)")
        Teleporter("New Gridania", "tp")
    else
        DoQuest("Where the Heart Is (The Lavender Beds)") -- This has the echo text inside
    end
end

function MistUnlock()
    if GetLevel() < 5 then
        Echo("You do not have the level 5 requirement.")
        return
    end
    
    if not IsAetheryteAttuned("Limsa Lominsa Lower Decks") then
        Echo("You do not have Limsa Lominsa Lower Decks aetheryte attuned.")
        return
    end
    
    if not IsQuestDone("Where the Heart Is (Mist)") then
        if IsAetheryteAttuned("Moraby Drydocks") then
            if not ZoneCheck("Moraby Drydocks") then
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
            end
        else
            if ZoneCheck("Limsa Lominsa Lower Decks") then
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
                Movement(154.31, 14.10, 666.92)
                AttuneAetheryte()
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
            elseif ZoneCheck("Moraby Drydocks") then
                Movement(154.31, 14.10, 666.92)
                AttuneAetheryte()
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
            else
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
                Movement(154.31, 14.10, 666.92)
                AttuneAetheryte()
                Teleporter("Limsa Lominsa Lower Decks", "tp")
                Teleporter("Tempest Gate", "li")
            end
        end
        DoQuest("Where the Heart Is (Mist)")
        Teleporter("Limsa Lominsa Lower Decks", "tp")
    else
        DoQuest("Where the Heart Is (Mist)") -- This has the echo text inside
    end
end

function TheGobletUnlock()
    if GetLevel() < 5 then
        Echo("You do not have the level 5 requirement.")
        return
    end
    
    if not IsAetheryteAttuned("Ul'dah - Steps of Nald") then
        Echo("You do not have Ul'dah - Steps of Nald aetheryte attuned.")
        return
    end
    
    if not IsQuestDone("Where the Heart Is (The Goblet)") then
        if IsAetheryteAttuned("Horizon") then
            if not ZoneCheck("Horizon") then
                Teleporter("Horizon", "tp")
            end
        else
            if ZoneCheck("Ul'dah - Steps of Nald") then
                Teleporter("Ul'dah - Steps of Nald", "tp")
                Teleporter("Gate of the Sultana", "li")
                Movement(69.83, 45.72, -223.40)
                AttuneAetheryte()
            elseif ZoneCheck("Horizon") then
                Movement(69.83, 45.72, -223.40)
                AttuneAetheryte()
            else
                Teleporter("Ul'dah - Steps of Nald", "tp")
                Teleporter("Gate of the Sultana", "li")
                Movement(69.83, 45.72, -223.40)
                AttuneAetheryte()
            end
        end
        DoQuest("Where the Heart Is (The Goblet)")
        Teleporter("Ul'dah - Steps of Nald", "tp")
    else
        DoQuest("Where the Heart Is (The Goblet)") -- This has the echo text inside
    end
end

-- ###############
-- # MAIN SCRIPT #
-- ###############

function Main()
    yield("/at e")
    yield("/p")
    --yield("/vbm cfg AI Enabled true")
    yield("/vbmai on")
    
    local actions = {
        -- Arcanist job quests
        { enabled = DO_ARCANIST_QUESTS, func = Arcanist1 },
        { enabled = DO_ARCANIST_QUESTS, func = Arcanist2 },
        { enabled = DO_ARCANIST_QUESTS, func = Arcanist3 },
        
        -- Archer job quests
        { enabled = DO_ARCHER_QUESTS, func = Archer1 },
        { enabled = DO_ARCHER_QUESTS, func = Archer2 },
        { enabled = DO_ARCHER_QUESTS, func = Archer3 },
        
        -- Marauder job quests
        { enabled = DO_MARAUDER_QUESTS, func = Marauder1 },
        { enabled = DO_MARAUDER_QUESTS, func = Marauder2 },
        { enabled = DO_MARAUDER_QUESTS, func = Marauder3 },
        
        -- DoL unlock quests
        { enabled = DO_DOL_QUESTS, func = FisherUnlock },
        { enabled = DO_DOL_QUESTS, func = MinerUnlock },
        { enabled = DO_DOL_QUESTS, func = BotanistUnlock },
        
        -- Arcanist hunt logs
        { enabled = DO_ARCANIST_LOG_1, func = ArcanistRank1 },
        { enabled = DO_ARCANIST_LOG_2, func = ArcanistRank2 },
        { enabled = DO_ARCANIST_LOG_3, func = ArcanistRank3 },
        
        -- Archer hunt logs
        { enabled = DO_ARCHER_LOG_1, func = ArcherRank1 },
        { enabled = DO_ARCHER_LOG_2, func = ArcherRank2 },
        { enabled = DO_ARCHER_LOG_3, func = ArcherRank3 },
        
        -- Marauder hunt logs
        { enabled = DO_MARAUDER_LOG_1, func = MarauderRank1 },
        { enabled = DO_MARAUDER_LOG_2, func = MarauderRank2 },
        { enabled = DO_MARAUDER_LOG_3, func = MarauderRank3 },
        
        -- Maelstrom hunt logs
        { enabled = DO_MAELSTROM_LOG_1, func = MaelstromRank1 },
        { enabled = DO_MAELSTROM_LOG_2, func = MaelstromRank2 },
        
        -- Dungeon unlocks
        { enabled = DO_HALATALI, func = HalataliUnlock },
        { enabled = DO_THE_SUNKEN_TEMPLE_OF_QARN, func = TheSunkenTempleOfQarnUnlock },
        { enabled = DO_DZEMAEL_DARKHOLD, func = DzemaelDarkholdUnlock },
        { enabled = DO_THE_AURUM_VALE, func = TheAurumValeUnlock },

        -- Level 5
        { enabled = GET_LEVEL_FOR_HOUSING_WARD, func = GetLevelForHousingWard },

        -- Housing unlocks
        { enabled = DO_THE_LAVENDER_BEDS, func = TheLavenderBedsUnlock },
        { enabled = DO_MIST, func = MistUnlock },
        { enabled = DO_THE_GOBLET, func = TheGobletUnlock },
    }
    
    -- Loop through functions
    for _, action in ipairs(actions) do
        if action.enabled then
            action.func()
        end
    end
end

if multi_char then
    for _, char in ipairs(character_list) do
        if GetCharacterName(true) == char then
            -- continue, no relogging needed
        else
            if not (ZoneCheck("Limsa Lominsa Lower") or ZoneCheck("Limsa Lominsa Upper")) then
                Teleporter("Limsa", "tp")
            end
            
            RelogCharacter(char)
            Sleep(7.5)
            LoginCheck()
        end
        
        repeat
            Sleep(0.1)
        until IsPlayerAvailable()
        
        Main()
    end
else
    Main()
end

if HasPlugin("YesAlready") then
    RestoreYesAlready()
end
