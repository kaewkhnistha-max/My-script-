local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lplayer = Players.LocalPlayer
local cam = workspace.CurrentCamera

if CoreGui:FindFirstChild("KaijuCombatHub") then
    CoreGui.KaijuCombatHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KaijuCombatHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ปุ่มเปิด-ปิด UI (ปุ่มกลม ZK)
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
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 270)
MainFrame.Position = UDim2.new(0.12, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- สร้าง Background Image สำหรับเปลี่ยนพื้นหลัง
local BgImage = Instance.new("ImageLabel", MainFrame)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.ZIndex = 4
BgImage.Visible = false
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- แถบหัวข้อ (Header)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
Header.ZIndex = 6
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = " Zk | Kaiju Alpha Combat"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 8, 0, 0)
Title.ZIndex = 7

-- ปุ่มปิด (X)
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

-- แถบเมนูด้านซ้าย (Tabs)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 85, 1, -28)
TabContainer.Position = UDim2.new(0, 0, 0, 28)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TabContainer.ZIndex = 6

-- พื้นที่แสดงเนื้อหาด้านขวา
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
    page.CanvasSize = UDim2.new(0, 0, 0, 320)
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

-- ระบบสลับสีธีม
local function applyTheme(color)
    Header.BackgroundColor3 = color:Lerp(Color3.new(0,0,0), 0.2)
    ToggleBtn.TextColor3 = color
    Title.TextColor3 = color
    for _, btn in pairs(tabButtons) do
        if btn then btn.BackgroundColor3 = Color3.fromRGB(32, 32, 45) end
    end
end

-- ฟังก์ชันสร้างปุ่ม Toggle
local function addToggle(parent, name, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Text = "  " .. name
    btn.Size = UDim2.new(0, 215, 0, 26)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
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

-- ฟังก์ชันสร้างกล่องพิมพ์ข้อความ (Input)
local function addInput(parent, labelName, defaultVal, yPos, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 215, 0, 26)
    frame.Position = UDim2.new(0.04, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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

-- ==================== [ 1. หน้า Main ] ====================
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

-- ==================== [ 2. หน้า Combat ] ====================
local targetLockActive = false
local lockedTarget = nil
addToggle(combatPage, "Lock Target", 8, function(s) targetLockActive = s end)

local TargetBtn = Instance.new("TextButton", combatPage)
TargetBtn.Text = "🎯 Pick Player"
TargetBtn.Size = UDim2.new(0, 215, 0, 26)
TargetBtn.Position = UDim2.new(0.04, 0, 0, 38)
TargetBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
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

RunService.RenderStepped:Connect(function()
    if targetLockActive and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        cam.CFrame = CFrame.new(cam.CFrame.Position, lockedTarget.Character.HumanoidRootPart.Position)
    end
end)

-- ==================== [ 3. หน้า ESP ] ====================
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

-- ==================== [ 4. หน้า Visual ] ====================
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

-- ==================== [ 5. หน้า Settings ] ====================
local function createSettingsHeader(text, y)
    local lbl = Instance.new("TextLabel", settingsPage)
    lbl.Size = UDim2.new(0, 215, 0, 20)
    lbl.Position = UDim2.new(0.04, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 180, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 8
    return lbl
end

createSettingsHeader("Theme Colors:", 8)

local function createThemeBtn(name, color, x, y)
    local btn = Instance.new("TextButton", settingsPage)
    btn.Text = name
    btn.Size = UDim2.new(0, 102, 0, 26)
    btn.Position = UDim2.new(x, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 9
    btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() applyTheme(color) end)
    return btn
end

createThemeBtn("🟣 Purple", Color3.fromRGB(90, 50, 180), 0.04, 32)
createThemeBtn("🔵 Blue", Color3.fromRGB(40, 90, 180), 0.53, 32)
createThemeBtn("🔴 Red", Color3.fromRGB(180, 40, 40), 0.04, 64)
createThemeBtn("🟢 Green", Color3.fromRGB(40, 150, 70), 0.53, 64)

-- ระบบเปลี่ยนพื้นหลัง พร้อมปุ่มยืนยัน (Confirm)
createSettingsHeader("Custom BG Image (Asset ID):", 100)
local BgInputFrame = Instance.new("Frame", settingsPage)
BgInputFrame.Size = UDim2.new(0, 215, 0, 26)
BgInputFrame.Position = UDim2.new(0.04, 0, 0, 124)
BgInputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
BgInputFrame.ZIndex = 8
Instance.new("UICorner", BgInputFrame).CornerRadius = UDim.new(0, 5)

local BgTextBox = Instance.new("TextBox", BgInputFrame)
BgTextBox.Size = UDim2.new(0, 135, 0, 18)
BgTextBox.Position = UDim2.new(0.03, 0, 0.15, 0)
BgTextBox.Text = ""
BgTextBox.PlaceholderText = "ใส่เลขไอดี เช่น 602342"
BgTextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
BgTextBox.TextColor3 = Color3.fromRGB(200, 180, 255)
BgTextBox.Font = Enum.Font.GothamBold
BgTextBox.TextSize = 9
BgTextBox.ZIndex = 9
Instance.new("UICorner", BgTextBox).CornerRadius = UDim.new(0, 4)

local ConfirmBgBtn = Instance.new("TextButton", BgInputFrame)
ConfirmBgBtn.Size = UDim2.new(0, 50, 0, 18)
ConfirmBgBtn.Position = UDim2.new(0.70, 0, 0.15, 0)
ConfirmBgBtn.Text = "Confirm"
ConfirmBgBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 180)
ConfirmBgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmBgBtn.Font = Enum.Font.GothamBold
ConfirmBgBtn.TextSize = 8
ConfirmBgBtn.ZIndex = 9
Instance.new("UICorner", ConfirmBgBtn).CornerRadius = UDim.new(0, 4)

local function applyBackground()
    local idText = BgTextBox.Text:gsub("%D", "")
    if idText ~= "" then
        BgImage.Image = "rbxassetid://" .. idText
        BgImage.Visible = true
    else
        BgImage.Image = ""
        BgImage.Visible = false
    end
end

ConfirmBgBtn.MouseButton1Click:Connect(applyBackground)
BgTextBox.FocusLost:Connect(applyBackground)
