local windUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local rs = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local hmd = player.Character:WaitForChild("Humanoid")
local hrp = player.Character:WaitForChild("HumanoidRootPart")

local fnafsFolder = workspace:FindFirstChild("ToFind")
local map = workspace:FindFirstChild("Juego"):FindFirstChild("MAPAS")
local other = workspace:FindFirstChild("Juego"):FindFirstChild("Other")
local flipSlide = map:FindFirstChild("Flipside")["Level 4"]

local config = {
    autoRebirth = false,
    autoRebirthInterval = 1
}
local fnafs = {}

player.CharacterAdded:Connect(function(chr)
    hmd = chr:WaitForChild("Humanoid")
	hrp = chr:WaitForChild("HumanoidRootPart")
end)

for _, fnaf in pairs(fnafsFolder:GetChildren()) do table.insert(fnafs, fnaf) end
for _, part in pairs(map["Morph Zone"]:GetChildren()) do if part.Name == "WrongAnswer" then part:Destroy() end end

local window = windUI:CreateWindow({
    Title = "Find the FNAF Character! script",
    Icon = "cat",
    Author = "by k1llm3sixy",
    Folder = "ftfc",
})

window:OnDestroy(function() config.autoRebirth = false end)

window:EditOpenButton({
    Title = "Open",
    Icon = "chevrons-left-right-ellipsis",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

function addButton(tab, title, desc, cb)
    tab:Button({
        Title = title,
        Desc = desc,
        Locked = false,
        Callback = cb
    })
end

function addToggle(tab, title, desc, def, cb)
    tab:Toggle({
        Title = title,
        Desc = desc,
        Icon = "check",
        Default = def,
        Callback = cb
    })
end

function addSlider(tab, title, desc, step, min, max, def, cb)
    tab:Slider({
        Title = title,
        Desc = desc,
        Step = step,
        Value = {
            Min = min,
            Max = max,
            Default = def
        },
        Callback = cb
    })
end

function teleport(pos) hrp.CFrame = pos.CFrame end

function isCollected(fnafName)
    local val = player.ToFindFolder[fnafName]
    if val.Value then return val.Value end
    return false
end

function getFnafs()
    for _, fnaf in pairs(fnafs) do
        if isCollected(fnaf.Name) then continue end

        local touch = fnaf:FindFirstChild("TouchInterest")
        if touch then firetouchinterest(hrp, touch.Parent, 0) end
        task.wait(0.1)
    end
end

function getBadges()
    local touch

    for _, fnaf in pairs(fnafs) do
        if isCollected(fnaf.Name) then continue end

        local badgeId = fnaf:FindFirstChild("BadgeID", true).Value
        if badgeId then rs.AwardBadgeEvent:FireServer(badgeId) end
        task.wait(0.1)
    end

    for _, obj in pairs(flipSlide:GetChildren()) do
        touch = obj:FindFirstChild("TouchInterest", true)
        if touch then firetouchinterest(hrp, touch.Parent, 0) end
        task.wait(0.1)
    end

    for _, obj in pairs(other:GetChildren()) do
        touch = obj:FindFirstChild("TouchInterest", true)
        if touch then firetouchinterest(hrp, touch.Parent, 0) end
        task.wait(0.1)
    end
end

function autoRebirth()
    while config.autoRebirth do
        rs.FindTheEvents.DataReset:FireServer()
        task.wait(config.autoRebirthInterval)
    end
end

local mainTab = window:Tab({ Title = "Main", Locked = false })
local gameTab = window:Tab({ Title = "Game", Locked = false })
local playerTab = window:Tab({ Title = "Player", Locked = false })

addButton(mainTab, "Get all fnafs", nil, function() task.spawn(getFnafs()) end)
addButton(mainTab, "Get all badges", nil, function() task.spawn(getBadges()) end)

addSlider(gameTab, "Auto rebirth interval", nil, 1, 1, 60, 1, function(val) config.autoRebirthInterval = val end)
addToggle(gameTab, "Auto rebirth", nil, false, function(state)
    config.autoRebirth = state
    autoRebirth()
end)

addSlider(playerTab, "Walk speed", nil, 1, 1, 100, hmd.WalkSpeed, function(speed) hmd.WalkSpeed = speed end)
addSlider(playerTab, "Jump height", nil, 10, 1, 500, hmd.JumpHeight, function(height) hmd.JumpHeight = height end)
