local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lplayer = Players.LocalPlayer
local cam = workspace.CurrentCamera

if CoreGui:FindFirstChild("KaijuCombatHub") then
    CoreGui.KaijuCombatHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KaijuCombatHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui.Parent then
        getgenv().AutoClickerRunning = false
    end
end)

-- ==================== [ ระบบเกล็ดหิมะตก (Snowflakes Effect) ] ====================
local SnowContainer = Instance.new("Folder", ScreenGui)
SnowContainer.Name = "SnowContainer"

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.15)
        if #SnowContainer:GetChildren() < 40 then
            local snowflake = Instance.new("TextLabel", SnowContainer)
            snowflake.Size = UDim2.new(0, math.random(10, 20), 0, math.random(10, 20))
            snowflake.Position = UDim2.new(math.random(), 0, -0.05, 0)
            snowflake.BackgroundTransparency = 1
            snowflake.Text = "❄"
            snowflake.TextColor3 = Color3.fromRGB(220, 240, 255)
            snowflake.TextSize = math.random(10, 18)
            snowflake.TextTransparency = math.random(2, 6) / 10
            snowflake.ZIndex = 25
            
            task.spawn(function()
                local fallTime = math.random(3, 7)
                local endPos = UDim2.new(snowflake.Position.X.Scale + math.random(-15, 15)/100, 0, 1.05, 0)
                local tween = TweenService:Create(snowflake, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {Position = endPos})
                tween:Play()
                tween.Completed:Wait()
                snowflake:Destroy()
            end)
        end
    end
end)

-- ==================== [ หน้าจอโหลด (Loading Screen 1-100%) ] ====================
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(0, 340, 0, 180)
LoadFrame.Position = UDim2.new(0.5, -170, 0.5, -90)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
LoadFrame.ZIndex = 15
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 10)

-- พื้นหลังโหลดแบบสำรอง (โหลดไว ไม่ค้าง)
local LoadBgImg = Instance.new("ImageLabel", LoadFrame)
LoadBgImg.Size = UDim2.new(1, 0, 1, 0)
LoadBgImg.BackgroundTransparency = 1
LoadBgImg.Image = "rbxassetid://6031094678" -- ใช้ Asset สำรองที่ระบบโหลดเสถียร
LoadBgImg.ImageTransparency = 0.7
LoadBgImg.ScaleType = Enum.ScaleType.Crop
LoadBgImg.ZIndex = 15
Instance.new("UICorner", LoadBgImg).CornerRadius = UDim.new(0, 10)

local LoadStroke = Instance.new("UIStroke", LoadFrame)
LoadStroke.Color = Color3.fromRGB(120, 90, 220)
LoadStroke.Thickness = 2

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0.15, 0)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "❄ Showa Godzilla | Loader ❄"
LoadTitle.TextColor3 = Color3.fromRGB(220, 200, 255)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 14
LoadTitle.ZIndex = 16

local StatusLabel = Instance.new("TextLabel", LoadFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.38, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "กำลังเตรียมระบบ..."
StatusLabel.TextColor3 = Color3.fromRGB(170, 170, 190)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.ZIndex = 16

local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(0.8, 0, 0, 12)
BarBg.Position = UDim2.new(0.1, 0, 0.62, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
BarBg.ZIndex = 16
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(120, 90, 220)
BarFill.ZIndex = 17
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

local PercentLabel = Instance.new("TextLabel", LoadFrame)
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0.78, 0)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextSize = 12
PercentLabel.ZIndex = 16

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ToggleBtn.Text = "ZK"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Draggable = true
ToggleBtn.ZIndex = 10
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- หน้าต่างหลักของสคริปต์
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 270)
MainFrame.Position = UDim2.new(0.12, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- พื้นหลังหน้าหลักแบบโหลดไว
local GodzillaBg = Instance.new("ImageLabel", MainFrame)
GodzillaBg.Size = UDim2.new(1, 0, 1, 0)
GodzillaBg.BackgroundTransparency = 1
GodzillaBg.Image = "rbxassetid://6031094678" 
GodzillaBg.ImageTransparency = 0.8
GodzillaBg.ScaleType = Enum.ScaleType.Crop
GodzillaBg.ZIndex = 5
Instance.new("UICorner", GodzillaBg).CornerRadius = UDim.new(0, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

task.spawn(function()
    local steps = {
        {25, "กำลังโหลดทรัพยากรเกม..."},
        {50, "เปิดระบบ Combat & ESP..."},
        {75, "กำลังเชื่อมต่อระบบฟังก์ชัน..."},
        {100, "พร้อมใช้งาน!"}
    }
    
    local currentProgress = 0
    for _, step in ipairs(steps) do
        local target = step[1]
        StatusLabel.Text = step[2]
        while currentProgress < target do
            currentProgress = currentProgress + 1
            PercentLabel.Text = currentProgress .. "%"
            BarFill.Size = UDim2.new(currentProgress / 100, 0, 1, 0)
            task.wait(0.01) -- เร่งความเร็วการโหลดขึ้นเพื่อไม่ให้รอนาน
        end
        task.wait(0.1)
    end
    
    TweenService:Create(LoadFrame, TweenInfo.new(0.3), {Transparency = 1}):Play()
    task.wait(0.3)
    LoadFrame:Destroy()
    ToggleBtn.Visible = true
    MainFrame.Visible = true
end)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Header.BackgroundTransparency = 0.2
Header.ZIndex = 6
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = " Zk | Showa Godzilla Hub"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 8, 0, 0)
Title.ZIndex = 7

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -25, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 9
CloseBtn.ZIndex = 7
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 85, 1, -28)
TabContainer.Position = UDim2.new(0, 0, 0, 28)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TabContainer.BackgroundTransparency = 0.3
TabContainer.ZIndex = 6

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -85, 1, -28)
Content.Position = UDim2.new(0, 85, 0, 28)
Content.BackgroundTransparency = 1
Content.ZIndex = 6

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 340)
    page.ScrollBarThickness = 3
    page.ZIndex = 6
    pages[name] = page
    return page
end

local tabButtons = {}
local function createTabButton(name, yPos, targetPage, index)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 26)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.ZIndex = 7
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        targetPage.Visible = true
    end)
    
    tabButtons[index] = btn
    return btn
end

local mainPage = createPage("Main")
local combatPage = createPage("Combat")
local espPage = createPage("ESP")
local visualPage = createPage("Visual")
local settingsPage = createPage("Settings")

createTabButton("Main", 8, mainPage, 1)
createTabButton("Combat", 38, combatPage, 2)
createTabButton("ESP", 68, espPage, 3)
createTabButton("Visual", 98, visualPage, 4)
createTabButton("Settings", 128, settingsPage, 5)
mainPage.Visible = true

local function applyTheme(color)
    Header.BackgroundColor3 = color:Lerp(Color3.new(0,0,0), 0.2)
    ToggleBtn.TextColor3 = color
    Title.TextColor3 = color
end

local function addToggle(parent, name, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Text = "  " .. name
    btn.Size = UDim2.new(0, 215, 0, 26)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(90, 50, 180) or Color3.fromRGB(30, 30, 42)
        callback(active)
    end)
end

local function addInput(parent, labelName, defaultVal, yPos, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 215, 0, 26)
    frame.Position = UDim2.new(0.04, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.2
    frame.ZIndex = 8
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)
    
    local label = Instance.new("TextLabel", frame)
    label.Text = "  " .. labelName
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 9
    
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 45, 0, 18)
    input.Position = UDim2.new(0.75, 0, 0.15, 0)
    input.Text = tostring(defaultVal)
    input.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    input.TextColor3 = Color3.fromRGB(200, 180, 255)
    input.Font = Enum.Font.GothamBold
    input.TextSize = 9
    input.ZIndex = 9
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then callback(val) else input.Text = tostring(defaultVal) end
    end)
end

-- ==================== [ เมนู Main ] ====================
local speedVal = 1
addInput(mainPage, "CFrame Speed", 1, 8, function(v) speedVal = v end)
addToggle(mainPage, "Toggle Speed", 38, function(s)
    RunService.RenderStepped:Connect(function()
        if s and lplayer.Character and lplayer.Character:FindFirstChild("Humanoid") and lplayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            lplayer.Character.HumanoidRootPart.CFrame = lplayer.Character.HumanoidRootPart.CFrame + (lplayer.Character.Humanoid.MoveDirection * speedVal)
        end
    end)
end)
addToggle(mainPage, "Toggle Fly (Hover)", 68, function(s)
    local hrp = lplayer.Character and lplayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if s then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "MiniFly"
            bv.MaxForce = Vector3.new(0, 99999, 0)
            bv.Velocity = Vector3.new(0, 0, 0)
        else
            if hrp:FindFirstChild("MiniFly") then hrp.MiniFly:Destroy() end
        end
    end
end)
addToggle(mainPage, "Toggle Noclip", 98, function(s)
    RunService.Stepped:Connect(function()
        if s and lplayer.Character then
            for _, p in pairs(lplayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)
addToggle(mainPage, "Infinite Jump (Fly Jump)", 128, function(s)
    local jumpConn
    if s then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if lplayer.Character and lplayer.Character:FindFirstChild("Humanoid") then
                lplayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

addToggle(mainPage, "Auto Clicker (Fast)", 158, function(s)
    getgenv().AutoClickerRunning = s
    task.spawn(function()
        while getgenv().AutoClickerRunning and ScreenGui.Parent do
            task.wait(0.1)
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end)
end)

-- ==================== [ เมนู Combat ] ====================
local targetLockActive = false
local lockedTarget = nil
addToggle(combatPage, "Lock Camera Target", 8, function(s) targetLockActive = s end)

local TargetBtn = Instance.new("TextButton", combatPage)
TargetBtn.Text = "🎯 Pick Player"
TargetBtn.Size = UDim2.new(0, 215, 0, 26)
TargetBtn.Position = UDim2.new(0.04, 0, 0, 38)
TargetBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
TargetBtn.BackgroundTransparency = 0.2
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.Font = Enum.Font.GothamBold
TargetBtn.TextSize = 9
TargetBtn.ZIndex = 8
Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 5)

TargetBtn.MouseButton1Click:Connect(function()
    local mouse = lplayer:GetMouse()
    TargetBtn.Text = "⏳ Clicking..."
    local conn
    conn = mouse.Button1Down:Connect(function()
        if mouse.Target and mouse.Target.Parent then
            local p = Players:GetPlayerFromCharacter(mouse.Target.Parent)
            if p and p ~= lplayer then
                lockedTarget = p
                TargetBtn.Text = "✅ Locked: " .. p.Name
            else
                TargetBtn.Text = "❌ Not a player"
            end
        end
        conn:Disconnect()
    end)
end)

local TpBehindBtn = Instance.new("TextButton", combatPage)
TpBehindBtn.Text = "⚡ Teleport Behind Target"
TpBehindBtn.Size = UDim2.new(0, 215, 0, 26)
TpBehindBtn.Position = UDim2.new(0.04, 0, 0, 68)
TpBehindBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
TpBehindBtn.BackgroundTransparency = 0.2
TpBehindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBehindBtn.Font = Enum.Font.GothamBold
TpBehindBtn.TextSize = 9
TpBehindBtn.ZIndex = 8
Instance.new("UICorner", TpBehindBtn).CornerRadius = UDim.new(0, 5)

TpBehindBtn.MouseButton1Click:Connect(function()
    if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetHrp = lockedTarget.Character.HumanoidRootPart
        local myHrp = lplayer.Character and lplayer.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

addToggle(combatPage, "Hitbox Extender (Big Head/Body)", 98, function(s)
    RunService.RenderStepped:Connect(function()
        if s then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lplayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(6, 6, 6)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if targetLockActive and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        cam.CFrame = CFrame.new(cam.CFrame.Position, lockedTarget.Character.HumanoidRootPart.Position)
    end
end)

-- ==================== [ เมนู ESP ] ====================
addToggle(espPage, "Name ESP (Show Names)", 8, function(s)
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lplayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local billboard = head:FindFirstChild("MiniNameESP")
                if s and not billboard then
                    local bg = Instance.new("BillboardGui", head)
                    bg.Name = "MiniNameESP"
                    bg.Size = UDim2.new(0, 100, 0, 40)
                    bg.StudsOffset = Vector3.new(0, 2, 0)
                    bg.AlwaysOnTop = true
                    
                    local txt = Instance.new("TextLabel", bg)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = p.Name
                    txt.TextColor3 = Color3.fromRGB(255, 100, 100)
                    txt.TextScaled = true
                    txt.Font = Enum.Font.GothamBold
                elseif not s and billboard then
                    billboard:Destroy()
                end
            end
        end
    end)
end)

-- ==================== [ เมนู Visual ] ====================
addToggle(visualPage, "Rainbow Character", 8, function(s)
    task.spawn(function()
        while s do
            task.wait(0.2)
            local char = lplayer.Character
            if char then
                local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = color
                    end
                end
            end
        end
    end)
end)

local fovEnabled = false
local customFOV = 90
addInput(visualPage, "Custom FOV (Angle)", 90, 42, function(v) customFOV = v end)
addToggle(visualPage, "Toggle Custom FOV", 76, function(s) fovEnabled = s end)

RunService.RenderStepped:Connect(function()
    if cam and fovEnabled then
        cam.FieldOfView = customFOV
    end
end)

-- ==================== [ เมนู Settings ] ====================
local function createSettingsHeader(text, y)
    local lbl = Instance.new("TextLabel", settingsPage)
    lbl.Size = UDim2.new(0, 215, 0, 20)
    lbl.Position = UDim2.new(0.04, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = 
