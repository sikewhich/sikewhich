-- NOVA UI LIBRARY ONLY (NO LOGIC)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- CONFIGURATION
local CONFIG = {
    Name = "Nova Library",
    Theme = "Cyan", -- Options: Cyan, Red, Green, Purple, Orange, Midnight, Synapse, Gold, Toxic, CottonCandy, Ocean, Vaporwave, Dracula
    Keybind = "RightControl",
    Size = UDim2.new(0, 500, 0, 350)
}

-- THEMES
local Themes = {
    Cyan = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(25, 25, 30),
        ContentBg = Color3.fromRGB(32, 32, 36),
        Accent = Color3.fromRGB(0, 160, 255),
        TextPrimary = Color3.fromRGB(245, 245, 245),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Outline = Color3.fromRGB(50, 50, 60),
        ItemHover = Color3.fromRGB(40, 40, 50),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Red = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(30, 25, 25),
        ContentBg = Color3.fromRGB(36, 32, 32),
        Accent = Color3.fromRGB(255, 60, 60),
        TextPrimary = Color3.fromRGB(255, 245, 245),
        TextSecondary = Color3.fromRGB(180, 150, 150),
        Outline = Color3.fromRGB(60, 50, 50),
        ItemHover = Color3.fromRGB(50, 40, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Green = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(25, 30, 25),
        ContentBg = Color3.fromRGB(32, 36, 32),
        Accent = Color3.fromRGB(60, 255, 100),
        TextPrimary = Color3.fromRGB(245, 255, 245),
        TextSecondary = Color3.fromRGB(150, 180, 150),
        Outline = Color3.fromRGB(50, 60, 50),
        ItemHover = Color3.fromRGB(40, 50, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Purple = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(28, 25, 30),
        ContentBg = Color3.fromRGB(34, 32, 36),
        Accent = Color3.fromRGB(170, 0, 255),
        TextPrimary = Color3.fromRGB(250, 245, 255),
        TextSecondary = Color3.fromRGB(170, 160, 180),
        Outline = Color3.fromRGB(55, 50, 60),
        ItemHover = Color3.fromRGB(45, 40, 50),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Orange = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(30, 28, 25),
        ContentBg = Color3.fromRGB(36, 34, 32),
        Accent = Color3.fromRGB(255, 140, 0),
        TextPrimary = Color3.fromRGB(255, 250, 245),
        TextSecondary = Color3.fromRGB(180, 170, 160),
        Outline = Color3.fromRGB(60, 55, 50),
        ItemHover = Color3.fromRGB(50, 45, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Midnight = {
        MainBg = Color3.fromRGB(10, 10, 15),
        SidebarBg = Color3.fromRGB(15, 15, 20),
        ContentBg = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(100, 100, 255),
        TextPrimary = Color3.fromRGB(200, 200, 255),
        TextSecondary = Color3.fromRGB(120, 120, 160),
        Outline = Color3.fromRGB(30, 30, 50),
        ItemHover = Color3.fromRGB(25, 25, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Synapse = {
        MainBg = Color3.fromRGB(40, 40, 40),
        SidebarBg = Color3.fromRGB(50, 50, 50),
        ContentBg = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 255, 255),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Outline = Color3.fromRGB(70, 70, 70),
        ItemHover = Color3.fromRGB(60, 60, 60),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Gold = {
        MainBg = Color3.fromRGB(25, 25, 25),
        SidebarBg = Color3.fromRGB(30, 30, 30),
        ContentBg = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(255, 215, 0),
        TextPrimary = Color3.fromRGB(255, 255, 240),
        TextSecondary = Color3.fromRGB(189, 183, 107),
        Outline = Color3.fromRGB(70, 65, 50),
        ItemHover = Color3.fromRGB(50, 50, 40),
        Red = Color3.fromRGB(255, 80, 80),
        Green = Color3.fromRGB(80, 255, 80),
        Yellow = Color3.fromRGB(255, 215, 0)
    },
    Toxic = {
        MainBg = Color3.fromRGB(10, 15, 10),
        SidebarBg = Color3.fromRGB(15, 20, 15),
        ContentBg = Color3.fromRGB(20, 25, 20),
        Accent = Color3.fromRGB(124, 252, 0),
        TextPrimary = Color3.fromRGB(200, 255, 200),
        TextSecondary = Color3.fromRGB(100, 150, 100),
        Outline = Color3.fromRGB(30, 50, 30),
        ItemHover = Color3.fromRGB(25, 35, 25),
        Red = Color3.fromRGB(255, 50, 50),
        Green = Color3.fromRGB(50, 255, 50),
        Yellow = Color3.fromRGB(255, 255, 50)
    },
    CottonCandy = {
        MainBg = Color3.fromRGB(255, 240, 245),
        SidebarBg = Color3.fromRGB(255, 228, 225),
        ContentBg = Color3.fromRGB(240, 248, 255),
        Accent = Color3.fromRGB(255, 105, 180),
        TextPrimary = Color3.fromRGB(70, 70, 90),
        TextSecondary = Color3.fromRGB(100, 100, 120),
        Outline = Color3.fromRGB(200, 200, 220),
        ItemHover = Color3.fromRGB(230, 230, 250),
        Red = Color3.fromRGB(255, 100, 100),
        Green = Color3.fromRGB(100, 200, 100),
        Yellow = Color3.fromRGB(255, 200, 100)
    },
    Ocean = {
        MainBg = Color3.fromRGB(10, 25, 40),
        SidebarBg = Color3.fromRGB(15, 35, 55),
        ContentBg = Color3.fromRGB(20, 45, 70),
        Accent = Color3.fromRGB(0, 190, 255),
        TextPrimary = Color3.fromRGB(220, 240, 255),
        TextSecondary = Color3.fromRGB(100, 140, 170),
        Outline = Color3.fromRGB(30, 60, 90),
        ItemHover = Color3.fromRGB(25, 55, 85),
        Red = Color3.fromRGB(255, 80, 80),
        Green = Color3.fromRGB(80, 255, 150),
        Yellow = Color3.fromRGB(255, 220, 80)
    },
    Vaporwave = {
        MainBg = Color3.fromRGB(20, 10, 30),
        SidebarBg = Color3.fromRGB(30, 15, 40),
        ContentBg = Color3.fromRGB(40, 20, 50),
        Accent = Color3.fromRGB(255, 0, 255),
        TextPrimary = Color3.fromRGB(0, 255, 255),
        TextSecondary = Color3.fromRGB(255, 150, 255),
        Outline = Color3.fromRGB(60, 30, 80),
        ItemHover = Color3.fromRGB(50, 25, 60),
        Red = Color3.fromRGB(255, 50, 100),
        Green = Color3.fromRGB(50, 255, 150),
        Yellow = Color3.fromRGB(255, 255, 100)
    },
    Dracula = {
        MainBg = Color3.fromRGB(40, 42, 54),
        SidebarBg = Color3.fromRGB(68, 71, 90),
        ContentBg = Color3.fromRGB(56, 58, 89),
        Accent = Color3.fromRGB(255, 121, 198),
        TextPrimary = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(98, 114, 164),
        Outline = Color3.fromRGB(98, 114, 164),
        ItemHover = Color3.fromRGB(80, 80, 100),
        Red = Color3.fromRGB(255, 85, 85),
        Green = Color3.fromRGB(80, 250, 123),
        Yellow = Color3.fromRGB(241, 250, 140)
    }
}

local CurrentTheme = Themes[CONFIG.Theme]

-- UI REFERENCES
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local SideBar = Instance.new("Frame")
local TabButtonsContainer = Instance.new("ScrollingFrame")
local ContentArea = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")

local NotificationLayout
local OpenedTabs = {}

-- HELPERS
local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CurrentTheme.Outline
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createLayout(parent)
    local layout = Instance.new("UIListLayout")
    layout.Parent = parent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return layout
end

-- NOTIFICATIONS
local function SendNotification(text, color)
    if not NotificationLayout then return end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 250, 0, 40)
    container.BackgroundColor3 = CurrentTheme.SidebarBg
    container.BackgroundTransparency = 1
    container.Parent = NotificationLayout.Parent
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Position = UDim2.new(1, 10, 0, 0) 
    content.BackgroundColor3 = CurrentTheme.SidebarBg
    content.Parent = container
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
    AddStroke(content, color or CurrentTheme.Accent, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CurrentTheme.TextPrimary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    
    TweenService:Create(content, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.spawn(function()
        task.wait(3)
        TweenService:Create(content, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 0)}):Play()
        task.wait(0.5)
        container:Destroy()
    end)
end

-- MAIN INITIALIZATION
ScreenGui.Name = "NOVA_UI_Lib"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true 
ScreenGui.Parent = PlayerGui

-- NOTIFICATION CONTAINER
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(1, 0, 1, 0)
NotifContainer.Position = UDim2.new(0, 0, 0.05, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 20000
NotifContainer.Parent = ScreenGui

NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Parent = NotifContainer
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.Padding = UDim.new(0, 5)

-- TOGGLE BUTTON (Watermark)
ToggleBtn.Name = "OpenButton"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = CurrentTheme.SidebarBg
ToggleBtn.Text = "N" 
ToggleBtn.TextColor3 = CurrentTheme.Accent
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 30
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 14)
AddStroke(ToggleBtn, CurrentTheme.Accent, 2)

-- MAIN WINDOW
MainFrame.Name = "MainFrame"
MainFrame.Size = CONFIG.Size
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = CurrentTheme.MainBg
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
AddStroke(MainFrame, CurrentTheme.Outline, 1.5)

-- SIDEBAR
SideBar.Size = UDim2.new(0.25, 0, 1, 0)
SideBar.BackgroundColor3 = CurrentTheme.SidebarBg
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

-- DRAGGING LOGIC
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
SideBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
SideBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

-- TITLE
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 60)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = CONFIG.Name
TitleLabel.TextColor3 = CurrentTheme.Accent
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 26
TitleLabel.Parent = SideBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0,0,0,35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Library UI"
SubTitle.TextColor3 = CurrentTheme.TextSecondary
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 10
SubTitle.Parent = TitleLabel

-- TAB LIST
TabButtonsContainer.Size = UDim2.new(1, 0, 0.8, 0)
TabButtonsContainer.Position = UDim2.new(0, 0, 0.2, 0)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.ScrollBarThickness = 0
TabButtonsContainer.Parent = SideBar
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtonsContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT AREA
ContentArea.Size = UDim2.new(0.75, 0, 1, 0)
ContentArea.Position = UDim2.new(0.25, 0, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame
local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop = UDim.new(0, 15)
ContentPad.PaddingBottom = UDim.new(0, 15)
ContentPad.PaddingLeft = UDim.new(0, 15)
ContentPad.PaddingRight = UDim.new(0, 15)
ContentPad.Parent = ContentArea

-- LIBRARY FUNCTIONS

local NovaLibrary = {}

function NovaLibrary.CreateTab(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Frame"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.Parent = ContentArea
    createLayout(page)
    OpenedTabs[name] = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = CurrentTheme.SidebarBg
    btn.Text = name
    btn.TextColor3 = CurrentTheme.TextSecondary
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = TabButtonsContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(0, 0, 0.8, 0)
    bar.Position = UDim2.new(0, 0, 0.1, 0)
    bar.BackgroundColor3 = CurrentTheme.Accent
    bar.BorderSizePixel = 0
    bar.Parent = btn
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

    btn.MouseButton1Click:Connect(function()
        -- Hide all
        for _, f in pairs(OpenedTabs) do f.Visible = false end
        page.Visible = true
        
        -- Reset styles
        for _, child in pairs(TabButtonsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.SidebarBg, TextColor3 = CurrentTheme.TextSecondary}):Play()
                if child:FindFirstChild("Bar") then
                    TweenService:Create(child.Bar, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0.8, 0)}):Play()
                end
            end
        end
        -- Set active style
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.ContentBg, TextColor3 = CurrentTheme.TextPrimary}):Play()
        TweenService:Create(bar, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0.8, 0)}):Play()
    end)

    -- Auto open first tab
    if #TabButtonsContainer:GetChildren() == 1 then
        btn:MouseButton1Click()
    end

    local TabFunctions = {}

    function TabFunctions:AddToggle(text, callback)
        local toggleObj = {}
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.96, 0, 0, 36)
        container.BackgroundColor3 = CurrentTheme.ContentBg
        container.Parent = page
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
        AddStroke(container, CurrentTheme.Outline, 1)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.Text = text
        label.TextColor3 = CurrentTheme.TextPrimary
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.BackgroundTransparency = 1
        label.Parent = container

        local switchBg = Instance.new("TextButton")
        switchBg.Size = UDim2.new(0, 36, 0, 18)
        switchBg.Position = UDim2.new(1, -45, 0.5, -9)
        switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        switchBg.Text = ""
        switchBg.AutoButtonColor = false
        switchBg.Parent = container
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = CurrentTheme.TextPrimary
        circle.Parent = switchBg
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local isOn = false
        local function updateVisuals()
            local targetPos = isOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            local targetColor = isOn and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)
            
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        end

        switchBg.MouseButton1Click:Connect(function()
            isOn = not isOn
            updateVisuals()
            task.spawn(function() if callback then callback(isOn) end end)
        end)

        function toggleObj:SetState(state)
            if isOn ~= state then
                isOn = state
                updateVisuals()
                task.spawn(function() if callback then callback(isOn) end end)
            end
        end
        
        return toggleObj
    end

    function TabFunctions:AddSlider(text, minVal, maxVal, defaultVal, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.96, 0, 0, 48)
        container.BackgroundColor3 = CurrentTheme.ContentBg
        container.Parent = page
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
        AddStroke(container, CurrentTheme.Outline, 1)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 2)
        label.Text = text
        label.TextColor3 = CurrentTheme.TextPrimary
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.BackgroundTransparency = 1
        label.Parent = container

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, 0, 0, 20)
        valueLabel.Position = UDim2.new(0, -10, 0, 2)
        valueLabel.Text = tostring(defaultVal)
        valueLabel.TextColor3 = CurrentTheme.Accent
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 12
        valueLabel.BackgroundTransparency = 1
        valueLabel.Parent = container

        local sliderBg = Instance.new("TextButton")
        sliderBg.Size = UDim2.new(0.92, 0, 0, 4)
        sliderBg.Position = UDim2.new(0.04, 0, 0.7, 0)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderBg.Text = ""
        sliderBg.AutoButtonColor = false
        sliderBg.Parent = container
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

        local sliderFill = Instance.new("Frame")
        sliderFill.BackgroundColor3 = CurrentTheme.Accent
        sliderFill.Parent = sliderBg
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

        local draggingSlider = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + ((maxVal - minVal) * pos))
            
            TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
            valueLabel.Text = tostring(val)
            
            if callback then callback(val) end
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
                updateSlider(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)

        -- Init
        local startPercent = (defaultVal - minVal) / (maxVal - minVal)
        sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
    end

    function TabFunctions:AddButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.96, 0, 0, 38)
        btn.BackgroundColor3 = CurrentTheme.ContentBg
        btn.Text = text
        btn.TextColor3 = color or CurrentTheme.TextPrimary
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = page
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = AddStroke(btn, CurrentTheme.Outline, 1)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.ItemHover}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = color or CurrentTheme.Accent}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.ContentBg}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = CurrentTheme.Outline}):Play()
        end)
        
        btn.MouseButton1Click:Connect(callback)
    end

    function TabFunctions:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.96, 0, 0, 25)
        label.BackgroundColor3 = CurrentTheme.ContentBg
        label.Text = text
        label.TextColor3 = CurrentTheme.Accent
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = page
        Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
        AddStroke(label, CurrentTheme.Outline, 1)
        return label
    end

    return TabFunctions
end

function NovaLibrary:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        SendNotification("Theme Changed: " .. themeName, CurrentTheme.Accent)
        -- Note: Real-time theme update of existing elements requires more complex reparenting or value updating. 
        -- For this library version, new elements take the theme.
    end
end

function NovaLibrary:Notify(text, color)
    SendNotification(text, color)
end

-- INPUT HANDLING
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode[CONFIG.Keybind] then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

return NovaLibrary
