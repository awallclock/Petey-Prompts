local addOnName, pPrompt = ...

-- loading ace3
local PeteyPrompts = LibStub("AceAddon-3.0"):NewAddon("Petey's Prompts", "AceConsole-3.0", "AceTimer-3.0", "AceComm-3.0",
    "AceEvent-3.0")

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
_G["pPrompt"] = pPrompt
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

PeteyPrompts.playerGUID = UnitGUID("player")
PeteyPrompts.playerName = UnitName("player")
PeteyPrompts._commPrefix = string.upper(addOnName)

local IsInRaid, IsInGroup, IsGUIDInGroup, isOnline = IsInRaid, IsInGroup, IsGUIDInGroup, isOnline
local _G = _G

local raidUnit, raidUnitPet = {}, {}
local partyUnit, partyUnitPet = {}, {}
for i = 1, _G.MAX_RAID_MEMBERS do
    raidUnit[i] = "raid" .. i
    raidUnitPet[i] = "raidpet" .. i
end
for i = 1, _G.MAX_PARTY_MEMBERS do
    partyUnit[i] = "party" .. i
    partyUnitPet[i] = "partypet" .. i
end



function PeteyPrompts:BuildOptionsPanel()
    local options = {
        name = "Petey's Prompts",
        handler = PeteyPrompts,
        type = "group",
        args = {

            titleText = {
                type = "description",
                fontSize = "large",
                order = 1,
                name = "                |cFF36F7BC" ..
                    "Petey's Prompts: v" .. GetAddOnMetadata("PeteysPrompts", "Version")
            },
            authorText = {
                type = "description",
                fontSize = "medium",
                order = 2,
                name =
                "|TInterface\\AddOns\\PeteyPrompts\\Media\\Icon64:64:64:0:20|t |cFFFFFFFFMade with love by  |cFFC41E3AHylly/Hogcrankr-Faerlina|r \n |cFFFFFFFFMake sure to check out AnimalFacts on Curse for facts about more animals!",
            },

            main = {
                name = "General Options",
                type = "group",
                order = 1,
                args = {
                    generalHeader = {
                        name = "General",
                        type = "header",
                        width = "full",
                        order = 1.0
                    },
                    introPrompt = {
                        name = "Enter Prompt Here",
                        type = "input",
                        multiline = true,
                        set = function()

                        end
                    },
                }
            },

            info = {
                name = "Information",
                type = "group",
                order = 2,
                args = {
                    infoText = {
                        type = "description",
                        fontSize = "medium",
                        name =
                            "A simple dumb addon that allows you to say / yell / raid warning a random bird fact\n" ..
                            "For help or to submit a fact: https://discord.gg/AqGTbYMgtK\n\n" ..
                            "How to use:\n" ..
                            "|cFFF5A242/af|r |cFF42BEF5<command>|r  OR  |cFFF5A242/animalfact|r |cFF42BEF5<command>|r\n\n" ..
                            "List of commands:\n" ..
                            "|cFF42BEF5s|r: Sends fact to the /say channel.\n\n" ..
                            "|cFF42BEF5p|r: Sends fact to the /party channel.\n\n" ..
                            "|cFF42BEF5ra|r: Sends fact to the /raid channel.\n\n" ..
                            "|cFF42BEF5rw|r: Sends fact to the /raidwarning channel.\n\n" ..
                            "|cFF42BEF5g|r: Sends fact to the /guild channel.\n\n" ..
                            "|cFF42BEF5i|r or |cFF42BEF5bg|r: Sends a bird fact to /instance or /bg channel.\n\n" ..
                            "|cFF42BEF5w|r or |cFF42BEF5t|r: Whispers a bird fact to your current target\n\n" ..
                            "|cFF42BEF5r|r: Whispers a bird fact to your last reply. Or you can start a new whisper and type '|cFFF5A242/af|r |cFF42BEF5r|r' to send them a fact\n\n" ..
                            "|cFF42BEF51-5|r: Use the numbers 1 through 5 to send a bird fact to global channels ('|cFFF5A242/af|r |cFF42BEF51|r' for example)\n\n" ..
                            "Also responds when people say |cFF42BEF5!af|r in chat (party and raid)"

                    },
                },
            },
        },
    }
    PeteyPrompts.optionsFrame = ACD:AddToBlizOptions("PeteyPrompts_options", "PeteyPrompts")
    AC:RegisterOptionsTable("PeteyPrompts_options", options)
end

-- things to do on initialize
function PeteyPrompts:OnInitialize()
    local defaults = {
        profile = {
            delayTimer = "60",
            defaultChannel = "PARTY",
        }
    }
    SLASH_PeteyPrompts1 = "/pp"
    SLASH_PeteyPrompts2 = "/peteysprompts"
    SlashCmdList["PeteyPrompts"] = function(msg)
        PeteyPrompts:SlashCommand(msg)
    end
    self.db = LibStub("AceDB-3.0"):New("PeteyPromptsDB", defaults, true)
end

function PeteyPrompts:OnEnable()
    self:RegisterComm(self._commPrefix)
    PeteyPrompts:BuildOptionsPanel()
    self:ScheduleTimer("TimerFeedback", 10)
    --register chat events
    self:RegisterEvent("CHAT_MSG_RAID", "readChat")
    self:RegisterEvent("CHAT_MSG_PARTY", "readChat")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "readChat")
    self:RegisterEvent("CHAT_MSG_RAID_LEADER", "readChat")
end

function PeteyPrompts:OnDisable()
    self:CancelTimer(self.timer)
end

--register the events for chat messages, (Only for Raid and Party), and read the messages for the command "!bf", and then run the function PeteyPrompts:SlashCommand
function PeteyPrompts:readChat(event, msg, _, _, _, sender)
    local msg = string.lower(msg)
    local channel = event:match("CHAT_MSG_(%w+)")
    local outChannel = ""

    if (msg == "!bf" and leader == self.playerName) then
        if (channel == "RAID" or channel == "RAID_LEADER") then
            outChannel = "ra"
        elseif (channel == "PARTY" or channel == "PARTY_LEADER") then
            outChannel = "p"
        end
        PeteyPrompts:SlashCommand(outChannel)
    end
end

function PeteyPrompts:GetFact()

end

function PeteyPrompts:OnCommReceived(prefix, message, distribution, sender)
    --PeteyPrompts:Print("pre comm receive" .. self.db.profile.leader)
    if prefix ~= PeteyPrompts._commPrefix or sender == self.playerName then return end
    if distribution == "PARTY" or distribution == "RAID" then
        self.db.profile.leader = message
    end
    --PeteyPrompts:Print("post comm receive" .. self.db.profile.leader)
end

-- slash commands and their outputs
function PeteyPrompts:SlashCommand(msg)
    local msg = string.lower(msg)
    local out = PeteyPrompts:GetFact()
    local default = self.db.profile.defaultChannel
    local defaultAuto = self.db.profile.defaultAutoChannel
end

-- error message
function PeteyPrompts:factError()

end

function PeteyPrompts:TimerFeedback()
    self:Print("Type \'/bf help\' to view available commands or \'/bf options\' to view the options panel")
end
