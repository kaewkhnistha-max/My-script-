local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lplayer = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ลบ UI เก่า
if CoreGui:FindFirstChild("KaijuCombatHub") then
    CoreGui.KaijuCombatHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KaijuCombatHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ตัวแปรภาษาปัจจุบัน ('EN', 'VN', 'TH')
local currentLang = 'TH'

local translations = {
    EN = {
        Title = " Zk | Kaiju Alpha Combat",
        Tabs = {"Main", "Combat", "ESP", "Visual", "Settings"},
        Main = {"CFrame Speed", "Toggle Speed", "Toggle Fly (Hover)", "Toggle Noclip"},
        Combat = {"Lock Target", "🎯 Pick Player", "⚡ Teleport Behind Target"},
        ESP = {"Name ESP (Show Names)"},
        Visual = {"Rainbow Character", "Custom FOV (Angle)", "Toggle Custom FOV"},
        Settings = {"Theme Colors:", "🟣 Purple", "🔵 Blue", "🔴 Red", "🟢 Green", "Language:", "🇬🇧 English", "🇻🇳 Tiếng Việt", "🇹🇭 ไทย"}
    },
    VN = {
        Title = " Zk | Kaiju Alpha Chiến Đấu",
        Tabs = {"Chính", "Chiến", "ESP", "Hình Ảnh", "Cài Đặt"},
        Main = {"Tốc Độ CFrame", "Bật Tốc Độ", "Bật Bay (Lơ Lửng)", "Bật Xuyên Tường"},
        Combat = {"Khóa Mục Tiêu", "🎯 Chọn Người Chơi", "⚡ Dịch Chuyển Ra Sau"},
        ESP = {"Hiện Tên (Name ESP)"},
        Visual = {"Nhân Vật 7 Màu", "Góc Nhìn FOV", "Bật FOV Tùy Chỉnh"},
        Settings = {"Màu Giao Diện:", "🟣 Tím", "🔵 Xanh Dương", "🔴 Đỏ", "🟢 Xanh Lá", "Ngôn Ngữ:", "🇬🇧 Tiếng Anh", "🇻🇳 Tiếng Việt", "🇹🇭 Thái Lan"}
    },
    TH = {
        Title = " Zk | ไคจู อัลฟ่า คอมแบท",
        Tabs = {"หลัก", "ต่อสู้", "มองทะลุ", "ภาพ", "ตั้งค่า"},
        Main = {"ความเร็ว (CFrame)", "เปิด/ปิด วิ่งเร็ว", "เปิด/ปิด ลอยตัว", "เปิด/ปิด ทะลุกำแพง"},
        Combat = {"ล็อกเป้าหันตาม", "🎯 จิ้มเลือกตัวผู้เล่น", "⚡ วาร์ปไปด้านหลังเป้าหมาย"},
        ESP = {"แสดงชื่อผู้เล่น (Name ESP)"},
        Visual = {"ตัวละครเปลี่ยนสีรุ้ง", "ปรับมุมกล้อง (FOV)", "เปิด/ปิด ล็อกมุมกล้อง FOV"},
        Settings = {"ธีมสี UI:", "🟣 สีม่วง", "🔵 สีน้ำเงิน", "🔴 สีแดง", "🟢 สีเขียว", "ภาษา (Language):", "🇬🇧 English", "🇻🇳 Tiếng Việt", "🇹🇭 ไทย"}
    }
}

-- ปุ่มเปิด-ปิด UI
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
Title.Text = translations[currentLang].Title
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 7

-- ฟังก์ชันเปลี่ยนสี UI ทั้งหมด
local themeElements = {}
local function applyTheme(color)
    Header.BackgroundColor3 = color:Lerp(Color3.new(0,0,0), 0.2)
    ToggleBtn.TextColor3 = color
    Title.TextColor3 = color
    for _, obj in pairs(themeElements) do
        if obj and obj.Parent then
            obj.BackgroundColor3 = color
        end
    end
end

-- ปุ่มปิดสคริปต์ (X)
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

-- เมนูด้านซ้าย (Tab List)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 85, 1, -28)
TabContainer.Position = UDim2.new(0, 0, 0, 28)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TabContainer.ZIndex = 6

-- พื้นที่แสดงฟังก์ชันด้านขวา
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
    page.CanvasSize = UDim2.new(0, 0, 0, 300)
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
    
    tabButtons[index] = {Btn = btn, TKey = index}
    table.insert(themeElements, btn)
    return btn
end

local mainPage = createPage("Main")
local combatPage = createPage("Combat")
local espPage = createPage("ESP")
local visualPage = createPage("Visual")
local settingsPage = createPage("Settings")

createTabButton(translations[currentLang].Tabs[1], 8, mainPage, 1)
createTabButton(translations[currentLang].Tabs[2], 38, combatPage, 2)
createTabButton(translations[currentLang].Tabs[3], 68, espPage, 3)
createTabButton(translations[currentLang].Tabs[4], 98, visualPage, 4)
createTabButton(translations[currentLang].Tabs[5], 128, settingsPage, 5)
mainPage.Visible = true

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
    return btn
end

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
    return label
end

-- ==================== [ ใส่ฟังก์ชันระบบ ] ====================

-- 1. Main
local speedVal = 1
local lblSpeed = addInput(mainPage, translations[currentLang].Main[1], 1, 8, function(v) speedVal = v end)
local tglSpeed = addToggle(mainPage, translations[currentLang].Main[2], 38, function(s)
    RunService.RenderStepped:Connect(function()
        if s and lplayer.Character and lplayer.Character:FindFirstChild("Humanoid") and lplayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            lplayer.Character.HumanoidRootPart.CFrame = lplayer.Character.HumanoidRootPart.CFrame + (lplayer.Character.Humanoid.MoveDirection * speedVal)
        end
    end)
end)
local tglFly = addToggle(mainPage, translations[currentLang].Main[3], 68, function(s)
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
local tglNoclip = addToggle(mainPage, translations[currentLang].Main[4], 98, function(s)
    RunService.Stepped:Connect(function()
        if s and lplayer.Character then
            for _, p in pairs(lplayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

-- 2. Combat
local targetLockActive = false
local lockedTarget = nil
local tglLock = addToggle(combatPage, translations[currentLang].Combat[1], 8, function(s) targetLockActive = s end)

local TargetBtn = Instance.new("TextButton", combatPage)
TargetBtn.Text = translations[currentLang].Combat[2]
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
    TargetBtn.Text = "⏳ กำลังจิ้มตัว..."
    local conn
    conn = mouse.Button1Down:Connect(function()
        if mouse.Target and mouse.Target.Parent then
            local p = Players:GetPlayerFromCharacter(mouse.Target.Parent)
            if p and p ~= lplayer then
                lockedTarget = p
                TargetBtn.Text = "✅ ล็อก: " .. p.Name
            else
                TargetBtn.Text = "❌ ไม่ใช่ผู้เล่น"
            end
        end
        conn:Disconnect()
    end)
end)

local TpBehindBtn = Instance.new("TextButton", combatPage)
TpBehindBtn.Text = translations[currentLang].Combat[3]
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

-- 3. ESP
local tglESP = addToggle(espPage, translations[currentLang].ESP[1], 8, function(s)
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

-- 4. Visual
local tglRainbow = addToggle(visualPage, translations[currentLang].Visual[1], 8, function(s)
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
local lblFOV = addInput(visualPage, translations[currentLang].Visual[2], 90, 42, function(v) customFOV = v end)
local tglFOV = addToggle(visualPage, translations[currentLang].Visual[3], 76, function(s) fovEnabled = s end)

RunService.RenderStepped:Connect(function()
    local currentCam = workspace.CurrentCamera
    if currentCam and fovEnabled then
        currentCam.FieldOfView = customFOV
    end
end)

-- ==================== [ 5. Settings (Theme & Language) ] ====================
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

local setLbl1 = createSettingsHeader(translations[currentLang].Settings[1], 8)

-- ปุ่มเปลี่ยนสีธีม
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
    btn.MouseButton1Click:Connect(function()
        applyTheme(color)
    end)
    return btn
end

createThemeBtn(translations[currentLang].Settings[2], Color3.fromRGB(90, 50, 180), 0.04, 32)
createThemeBtn(translations[currentLang].Settings[3], Color3.fromRGB(40, 90, 180), 0.53, 32)
createThemeBtn(translations[currentLang].Settings[4], Color3.fromRGB(180, 40, 40), 0.04, 64)
createThemeBtn(translations[currentLang].Settings[5], Color3.fromRGB(40, 150, 70), 0.53, 64)

local setLbl2 = createSettingsHeader(translations[currentLang].Settings[6], 100)

-- ปุ่มเปลี่ยนภาษา (EN / VN / TH)
local function createLangBtn(name, langCode, x, y)
    local btn = Instance.new("TextButton", settingsPage)
    btn.Text = name
    btn.Size = UDim2.new(0, 67, 0, 26)
    btn.Position = UDim2.new(x, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 9
    btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        currentLang = langCode
        -- อัปเดตข้อความ UI ทั้งหมดทันที
        Title.Text = translations[currentLang].Title
        tabButtons[1].Btn.Text = translations[currentLang].Tabs[1]
        tabButtons[2].Btn.Text = translations[currentLang].Tabs[2]
        tabButtons[3].Btn.Text = translations[currentLang].Tabs[3]
        tabButtons[4].Btn.Text = translations[currentLang].Tabs[4]
        tabButtons[5].Btn.Text = translations[currentLang].Tabs[5]
        
        lblSpeed.Text = "  " .. translations[currentLang].Main[1]
        tglSpeed.Text = "  " .. translations[currentLang].Main[2]
        tglFly.Text = "  " .. translations[currentLang].Main[3]
        tglNoclip.Text = "  " .. translations[currentLang].Main[4]
        
        tglLock.Text = "  " .. translations[currentLang].Combat[1]
        TargetBtn.Text = translations[currentLang].Combat[2]
        TpBehindBtn.Text = translations[currentLang].Combat[3]
        
        tglESP.Text = "  " .. translations[currentLang].ESP[1]
        
        tglRainbow.Text = "  " .. translations[currentLang].Visual[1]
        lblFOV.Text = "  " .. translations[currentLang].Visual[2]
        tglFOV.Text = "  " .. translations[currentLang].Visual[3]
        
        setLbl1.Text = translations[currentLang].Settings[1]
        setLbl2.Text = translations[currentLang].Settings[6]
    end)
    return btn
end

createLangBtn("🇬🇧 EN", 'EN', 0.04, 124)
createLangBtn("🇻🇳 VN", 'VN', 0.36, 124)
createLangBtn("🇹🇭 TH", 'TH', 0.68, 124)
