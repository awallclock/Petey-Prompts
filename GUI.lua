local addOnName, pPrompt = ...
local ppGUI = LibStub("AceGUI-3.0")
-- gui section
local f = ppGUI:Create("Frame")
f:SetCallback("OnClose", function(widget) ppGUI:Release(widget) end)
f:SetTitle("Petey's Prompts")
f:SetStatusText("Status Bar or something")
f:SetLayout("Flow")
f:SetWidth(400)
f:SetHeight(500)
f:EnableResize(false)

local newLabel = ppGUI:Create("Heading")
newLabel:SetText("Create a new prompt")
newLabel:SetFullWidth(true)
f:AddChild(newLabel)

local prompt = ppGUI:Create("MultiLineEditBox")
prompt:DisableButton(true)
prompt:SetNumLines(3)
prompt:SetRelativeWidth(1)
prompt:SetLabel("Add prompt here")
prompt:SetMaxLetters(220)
prompt:ClearAllPoints()
f:AddChild(prompt)


local optionA = ppGUI:Create("EditBox")
optionA:DisableButton(true)
optionA:SetWidth(175)
optionA:SetLabel("Option A")
optionA:SetMaxLetters(100)
f:AddChild(optionA)



local optionB = ppGUI:Create("EditBox")
optionB:DisableButton(true)
optionB:SetWidth(175)
optionB:SetLabel("Option B")
optionB:SetMaxLetters(100)
f:AddChild(optionB)

local sendBtn = ppGUI:Create("Button")
sendBtn:SetText("Send Prompt")
sendBtn:SetWidth(175)
f:AddChild(sendBtn)

local saveBtn = ppGUI:Create("Button")
saveBtn:SetText("Save Prompt")
saveBtn:SetWidth(175)
f:AddChild(saveBtn)

local line = ppGUI:Create("Heading")
line:SetText("Re-use a saved prompt")
line:SetFullWidth(true)
f:AddChild(line)
