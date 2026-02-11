local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Global Settings
_G.RainbowMode = _G.RainbowMode or false
_G.Noclip = false
_G.SpeedEnabled = false
_G.SpeedValue = 16

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WaveHub_V9"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Helper function for UI Styling (Main Hub Style)
local function StyleUI(frame)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 0
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    return stroke
end

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true
local MainStroke = StyleUI(MainFrame)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "WAVE"
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.TextSize = 22
Logo.Font = Enum.Font.GothamBlack
Logo.BackgroundTransparency = 1

local ContainerHolder = Instance.new("Frame", MainFrame)
ContainerHolder.Position = UDim2.new(0, 130, 0, 15)
ContainerHolder.Size = UDim2.new(1, -145, 1, -30)
ContainerHolder.BackgroundTransparency = 1

local Pages, TabButtons, Sliders, Strokes, ActiveToggles = {}, {}, {}, {MainStroke}, {}
local Tabs = {"Main", "Player", "Visual", "Settings"}

-- iPhone Toggle Creator
local function createiPhoneToggle(parent, text, startState, callback)
    local TF = Instance.new("Frame", parent)
    TF.Size = UDim2.new(1, 0, 0, 40)
    TF.BackgroundTransparency = 1

    local L = Instance.new("TextLabel", TF)
    L.Size = UDim2.new(0.6, 0, 1, 0)
    L.Text = text
    L.TextSize = 16
    L.Font = Enum.Font.GothamBold
    L.TextColor3 = Color3.new(1, 1, 1)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1

    local Sw = Instance.new("TextButton", TF)
    Sw.Size = UDim2.new(0, 45, 0, 24)
    Sw.Position = UDim2.new(1, -50, 0.5, -12)
    Sw.BackgroundColor3 = startState and Color3.fromRGB(76, 217, 100) or Color3.fromRGB(50, 50, 50)
    Sw.Text = ""
    Instance.new("UICorner", Sw).CornerRadius = UDim.new(1, 0)

    local Circ = Instance.new("Frame", Sw)
    Circ.Size = UDim2.new(0, 20, 0, 20)
    Circ.Position = startState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circ.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)

    local act = startState
    if act then ActiveToggles[Sw] = true end

    Sw.MouseButton1Click:Connect(function()
        act = not act
        Circ:TweenPosition(act and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), "Out", "Quart", 0.2)
        
        if act then
            ActiveToggles[Sw] = true
            if not _G.RainbowMode then Sw.BackgroundColor3 = Color3.fromRGB(76, 217, 100) end
        else
            ActiveToggles[Sw] = nil
            Sw.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        callback(act)
    end)
    return Sw
end

-- Slider Creator
local function createSlider(parent, name, min, max, startVal, callback)
    local SF = Instance.new("Frame", parent)
    SF.Size = UDim2.new(1, 0, 0, 55)
    SF.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", SF)
    L.Size = UDim2.new(1, 0, 0, 25)
    L.Text = name .. ": " .. startVal
    L.TextSize = 14
    L.Font = Enum.Font.GothamBold
    L.TextColor3 = Color3.new(1, 1, 1)
    L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", SF)
    B.Size = UDim2.new(1, 0, 0, 8)
    B.Position = UDim2.new(0, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    B.Text = ""
    Instance.new("UICorner", B)
    local Fill = Instance.new("Frame", B)
    local startPct = math.clamp((startVal - min) / (max - min), 0, 1)
    Fill.Size = UDim2.new(startPct, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", Fill)
    table.insert(Sliders, Fill)
    B.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local pct = math.clamp((Mouse.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pct)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            L.Text = name .. ": " .. val
            callback(val)
        end)
        local rel; rel = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect(); rel:Disconnect() end
        end)
    end)
end

-- Tab Logic
local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -110)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center

for i, tabName in pairs(Tabs) do
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0, 105, 0, 32)
    TabBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 30)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 12)
    TabButtons[tabName] = TabBtn
    local Page = Instance.new("ScrollingFrame", ContainerHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (i == 1)
    Page.ScrollBarThickness = 0
    Pages[tabName] = Page
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    TabBtn.MouseButton1Click:Connect(function()
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Pages[name].Visible = false
        end
        if not _G.RainbowMode then TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) end
        Page.Visible = true
    end)
end

-- SPEED UI MENU (Separate Window)
local SpeedMenu = Instance.new("Frame", ScreenGui)
SpeedMenu.Size = UDim2.new(0, 200, 0, 130)
SpeedMenu.Position = UDim2.new(0.5, 250, 0.5, -65)
SpeedMenu.Visible = false
SpeedMenu.Active = true
SpeedMenu.Draggable = true
local SpeedStroke = StyleUI(SpeedMenu)
table.insert(Strokes, SpeedStroke)

local SpeedTitle = Instance.new("TextLabel", SpeedMenu)
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.Text = "SPEED SETTINGS"
SpeedTitle.TextColor3 = Color3.new(1, 1, 1)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.BackgroundTransparency = 1

local SpeedContent = Instance.new("Frame", SpeedMenu)
SpeedContent.Size = UDim2.new(1, -20, 1, -40)
SpeedContent.Position = UDim2.new(0, 10, 0, 35)
SpeedContent.BackgroundTransparency = 1
Instance.new("UIListLayout", SpeedContent).Padding = UDim.new(0, 5)

-- Speed Menu Content
createiPhoneToggle(SpeedContent, "Status", false, function(v) _G.SpeedEnabled = v end)
createSlider(SpeedContent, "Value", 16, 500, 16, function(v) _G.SpeedValue = v end)

-- Main Player Page Content
local pPage = Pages["Player"]
createiPhoneToggle(pPage, "Speed Menu", false, function(v) SpeedMenu.Visible = v end)
createiPhoneToggle(pPage, "Noclip", false, function(v) _G.Noclip = v end)
createSlider(pPage, "Jump Power", 1, 999, 50, function(v) 
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = v
        Player.Character.Humanoid.UseJumpPower = true
    end
end)

createiPhoneToggle(Pages["Settings"], "Rainbow Mode", _G.RainbowMode, function(v) _G.RainbowMode = v end)

-- Main Loops
RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    
    if _G.RainbowMode then
        Logo.TextColor3 = c
        for _, str in pairs(Strokes) do str.Color = c end
        for _, sl in pairs(Sliders) do sl.BackgroundColor3 = c end
        for name, btn in pairs(TabButtons) do if Pages[name].Visible then btn.BackgroundColor3 = c end end
        for toggleBtn, _ in pairs(ActiveToggles) do toggleBtn.BackgroundColor3 = c end
    end
    
    if _G.SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = _G.SpeedValue
    end
    
    if _G.Noclip and Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Toggle All with K
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        local newState = not MainFrame.Visible
        MainFrame.Visible = newState
        SpeedMenu.Visible = false -- Reset speed menu on close
    end
end)
