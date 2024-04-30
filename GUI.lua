local addOnName, pPrompt = ...
local ppGUI = LibStub("AceGUI-3.0")
-- gui section
local output
local _optionA
local _optionB
local _prompt
local _dropdown

ddTable = {}

function openWindow()
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
    prompt:SetMaxLetters(250)
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
    sendBtn:SetText("Send Prompt >>")
    sendBtn:SetWidth(175)
    f:AddChild(sendBtn)

    local saveBtn = ppGUI:Create("Button")
    saveBtn:SetText("Save Prompt")
    saveBtn:SetWidth(175)
    saveBtn:SetCallback("OnClick", function()
        savePrompt(prompt.text, optionA.text, optionB.text)
    end)
    f:AddChild(saveBtn)

    local line = ppGUI:Create("Heading")
    line:SetText("Re-use a saved prompt")
    line:SetFullWidth(true)
    f:AddChild(line)

    local dropdown = ppGUI:Create("Dropdown")
    dropdown:SetLabel("Saved prompts")
    dropdown:SetFullWidth(true)
    dropdown:SetCallback("OnValueChanged", function(widget)
        recallPrompt(widget)
    end)
    for k in pairs(ddTable) do
        dropdown:AddItem(k, k)
    end
    f:AddChild(dropdown)

    local deleteBtn = ppGUI:Create("Button")
    deleteBtn:SetText("Delete Selected Prompt")
    deleteBtn:SetCallback("OnClick", function()
        local selectedPrompt = dropdown.value
        ddTable[selectedPrompt] = nil
    end)
    f:AddChild(deleteBtn)

    _optionA = optionA
    _optionB = optionB
    _prompt = prompt
    _dropdown = dropdown
end

function recallPrompt(widget)
    local master = widget.value
    _prompt:SetText(ddTable[master].prompt)
    _optionA:SetText(ddTable[master].optiona)
    _optionB:SetText(ddTable[master].optionb)
end

function savePrompt(prompt, optionA, optionB)
    local name = _prompt:GetText()
    local pText = _prompt:GetText()
    local aText = _optionA:GetText()
    local bText = _optionB:GetText()

    ddTable[name] = { prompt = pText, optiona = aText, optionb = bText, name = name }

    _dropdown:AddItem(pText, pText)

    --print(ddTable[1].name)
    --print(ddTable[2].name)
end
