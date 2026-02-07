-- Astra UI Library (Based on WindUI v1.6.64)
-- Author: Adapted for User Request
-- License: MIT

local AstraUI = {}

-- // Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- // Utility Functions
local function cloneref(instance)
    if cloneref then return cloneref(instance) end
    if clonefunction then return clonefunction(instance) end
    return instance
end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local LocalPlayer = Players.LocalPlayer

-- // Icon Loader (Internal Lucide/Solar Support)
local Icons = {
    ["add-circle"] = "rbxassetid://10709790775", -- Placeholder IDs for demonstration
    ["check"] = "rbxassetid://10723376738",
    ["x"] = "rbxassetid://10723375899",
    ["search"] = "rbxassetid://10709792726",
    ["settings"] = "rbxassetid://10723402496",
    ["bell"] = "rbxassetid://10709790442",
    ["home-2"] = "rbxassetid://10723370241",
    ["info-square-bold"] = "rbxassetid://10709791431",
    ["check-square-bold"] = "rbxassetid://10723386444",
    ["cursor-square-bold"] = "rbxassetid://10723386809",
    ["password-minimalistic-input-bold"] = "rbxassetid://10723388039",
    ["square-transfer-horizontal-bold"] = "rbxassetid://10723403748",
    ["hamburger-menu-bold"] = "rbxassetid://10723371145",
    ["file-text-bold"] = "rbxassetid://10723369625",
    ["folder-with-files-bold"] = "rbxassetid://10723369997",
    ["lock"] = "rbxassetid://10723376005",
    ["move"] = "rbxassetid://10723383491",
    ["chevrons-up-down"] = "rbxassetid://10723385724",
    ["chevron-down"] = "rbxassetid://10723385133",
    ["copy"] = "rbxassetid://10723387307",
    ["terminal"] = "rbxassetid://10723404846",
    ["palette"] = "rbxassetid://10723388559",
    ["key"] = "rbxassetid://10723374786",
    ["log-out"] = "rbxassetid://10723376874",
    ["arrow-right"] = "rbxassetid://10723374558",
    ["trash"] = "rbxassetid://10723405278",
    ["frown"] = "rbxassetid://10723370241",
    ["triangle-alert"] = "rbxassetid://10723405574",
    ["minimize"] = "rbxassetid://10723382033",
    ["maximize"] = "rbxassetid://10723381802",
    ["expand"] = "rbxassetid://10723369294",
    ["mouse-pointer-click"] = "rbxassetid://10723383565",
    ["toggle-right"] = "rbxassetid://10723405188",
    ["sliders-horizontal"] = "rbxassetid://10723404396",
    ["command"] = "rbxassetid://10723386205",
    ["text-cursor-input"] = "rbxassetid://10723404997",
    ["type"] = "rbxassetid://10723405668",
    ["table-of-contents"] = "rbxassetid://10723404504",
}

-- // Defaults
AstraUI.Theme = "Dark"
AstraUI.Scale = 1
AstraUI.Folder = "AstraUI"

-- // Theme Definitions
AstraUI.Themes = {
    Dark = {
        Name = "Dark",
        Accent = Color3.fromHex("#18181b"),
        Dialog = Color3.fromHex("#161616"),
        Text = Color3.fromHex("#FFFFFF"),
        Background = Color3.fromHex("#101010"),
        Button = Color3.fromHex("#52525b"),
        Icon = Color3.fromHex("#a1a1aa"),
        Toggle = Color3.fromHex("#33C759"),
        Slider = Color3.fromHex("#0091FF"),
        Checkbox = Color3.fromHex("#0091FF"),
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0.95,
    },
    Light = {
        Name = "Light",
        Accent = Color3.fromHex("#FFFFFF"),
        Dialog = Color3.fromHex("#f4f4f5"),
        Text = Color3.fromHex("#000000"),
        Background = Color3.fromHex("#e9e9e9"),
        Button = Color3.fromHex("#18181b"),
        Icon = Color3.fromHex("#52525b"),
        Toggle = Color3.fromHex("#33C759"),
        Slider = Color3.fromHex("#0091FF"),
        Checkbox = Color3.fromHex("#0091FF"),
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0,
    },
    Midnight = {
        Name = "Midnight",
        Accent = Color3.fromHex("#1e3a8a"),
        Dialog = Color3.fromHex("#0c1e42"),
        Text = Color3.fromHex("#dbeafe"),
        Background = Color3.fromHex("#0a0f1e"),
        Button = Color3.fromHex("#2563eb"),
        Primary = Color3.fromHex("#2563eb"),
        Icon = Color3.fromHex("#5591f4"),
    }
}

-- // GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = (gethui and gethui()) or cloneref(game:GetService("CoreGui"))

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "AstraUI/Notifications"
NotificationGui.ResetOnSpawn = false
if syn then syn.protect_gui(NotificationGui) end
NotificationGui.Parent = ScreenGui.Parent

local DropdownGui = Instance.new("ScreenGui")
DropdownGui.Name = "AstraUI/Dropdowns"
DropdownGui.ResetOnSpawn = false
if syn then syn.protect_gui(DropdownGui) end
DropdownGui.Parent = ScreenGui.Parent

local TooltipGui = Instance.new("ScreenGui")
TooltipGui.Name = "AstraUI/Tooltips"
TooltipGui.ResetOnSpawn = false
if syn then syn.protect_gui(TooltipGui) end
TooltipGui.Parent = ScreenGui.Parent

-- // Helper Functions
function AstraUI:GetThemeProperty(propName)
    local currentTheme = AstraUI.Themes[AstraUI.Theme]
    if not currentTheme then return Color3.fromHex(1,1,1) end
    
    local value = currentTheme[propName]
    if typeof(value) == "string" and string.sub(value, 1, 1) == "#" then
        return Color3.fromHex(value)
    end
    return value or Color3.new(1,1,1)
end

function AstraUI:GetIcon(name)
    return Icons[name] or ""
end

function AstraUI:Tween(instance, info, goal)
    return TweenService:Create(instance, TweenInfo.new(info.Time or 0.3, info.EasingStyle or Enum.EasingStyle.Quint, info.EasingDirection or Enum.EasingDirection.Out), goal)
end

-- // Notification System
AstraUI.Notifications = {}
function AstraUI:Notify(options)
    options = options or {}
    local Title = options.Title or "Notification"
    local Content = options.Content or ""
    local Icon = options.Icon or "bell"
    local Duration = options.Duration or 5
    local Callback = options.Callback or function() end

    local NotifHolder = ScreenGui:FindFirstChild("NotificationHolder") or Instance.new("Frame")
    NotifHolder.Name = "NotificationHolder"
    NotifHolder.Size = UDim2.new(1, 0, 1, 0)
    NotifHolder.Position = UDim2.new(1, -320, 0, 50)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = ScreenGui

    local Layout = NotifHolder:FindFirstChild("Layout") or Instance.new("UIListLayout")
    Layout.Name = "Layout"
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Parent = NotifHolder

    local Frame = Instance.new("Frame")
    Frame.Name = "Notif_" .. tick()
    Frame.Size = UDim2.new(0, 300, 0, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.BackgroundColor3 = self:GetThemeProperty("Dialog")
    Frame.BorderSizePixel = 0
    Frame.Parent = NotifHolder
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 16)
    Padding.PaddingLeft = UDim.new(0, 16)
    Padding.PaddingRight = UDim.new(0, 16)
    Padding.PaddingBottom = UDim.new(0, 16)
    Padding.Parent = Frame

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 0)
    Header.AutomaticSize = Enum.AutomaticSize.Y
    Header.BackgroundTransparency = 1
    Header.Parent = Frame

    local HeaderLayout = Instance.new("UIListLayout")
    HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    HeaderLayout.Padding = UDim.new(0, 12)
    HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    HeaderLayout.Parent = Header

    if Icon and Icons[Icon] then
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(0, 24, 0, 24)
        IconImg.Image = Icons[Icon]
        IconImg.BackgroundTransparency = 1
        IconImg.Parent = Header
    end

    local TitleText = Instance.new("TextLabel")
    TitleText.Text = Title
    TitleText.FontFace = Font.fromName("Gotham", Enum.FontWeight.Bold)
    TitleText.TextSize = 18
    TitleText.TextColor3 = self:GetThemeProperty("Text")
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, -36, 0, 0)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.AutomaticSize = Enum.AutomaticSize.Y
    TitleText.Parent = Header

    if Content and Content ~= "" then
        local ContentText = Instance.new("TextLabel")
        ContentText.Name = "Content"
        ContentText.Text = Content
        ContentText.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
        ContentText.TextSize = 15
        ContentText.TextColor3 = self:GetThemeProperty("Text")
        ContentText.TextTransparency = 0.3
        ContentText.BackgroundTransparency = 1
        ContentText.Size = UDim2.new(1, 0, 0, 0)
        ContentText.TextXAlignment = Enum.TextXAlignment.Left
        ContentText.TextWrapped = true
        ContentText.AutomaticSize = Enum.AutomaticSize.Y
        ContentText.Parent = Frame
        ContentText.LayoutOrder = 2
    end

    -- Animate In
    Frame.Size = UDim2.new(0, 300, 0, 0)
    self:Tween(Frame, {Time = 0.4}, {Size = UDim2.new(0, 300, 1, 0)}):Play()

    -- Remove
    task.spawn(function()
        task.wait(Duration)
        self:Tween(Frame, {Time = 0.4}, {Size = UDim2.new(0, 300, 0, 0), Position = UDim2.new(1, 50, 0, Frame.Position.Y.Offset)}):Play()
        task.wait(0.4)
        Frame:Destroy()
    end)
end

-- // Window System
function AstraUI:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Astra UI"
    local SubTitle = config.SubTitle or "Made by Astra"
    local Icon = config.Icon or "settings"
    local Size = config.Size or UDim2.fromOffset(600, 500)
    local Theme = config.Theme or "Dark"

    self.Theme = Theme
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Window"
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = self:GetThemeProperty("Background")
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 120, 1, 116)
    Shadow.Position = UDim2.new(0, -60, 0, -58)
    Shadow.AnchorPoint = Vector2.new(0, 0)
    Shadow.Image = "rbxassetid://1316045217" -- Shadow asset
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame

    -- Dragging Logic
    local Dragging = false
    local DragInput, DragStart, StartPos

    local function UpdateDrag(input)
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not (input.Target:IsA("TextButton") or input.Target:IsA("ImageButton") or input.Target:IsA("Frame") and input.Target.Name ~= "Window") then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input == DragInput then
            UpdateDrag(input)
        end
    end)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = self:GetThemeProperty("Accent")
    Topbar.BackgroundTransparency = 0.5
    Topbar.Parent = MainFrame
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 16)
    TopbarCorner.Parent = Topbar
    local TopbarMask = Instance.new("Frame")
    TopbarMask.Size = UDim2.new(1, 0, 0.5, 0)
    TopbarMask.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarMask.BackgroundColor3 = self:GetThemeProperty("Accent")
    TopbarMask.BackgroundTransparency = 0.5
    TopbarMask.BorderSizePixel = 0
    TopbarMask.Parent = Topbar

    -- Title & Icon
    local IconImg = Instance.new("ImageLabel")
    IconImg.Name = "Icon"
    IconImg.Size = UDim2.new(0, 24, 0, 24)
    IconImg.Position = UDim2.new(0, 16, 0.5, -12)
    IconImg.Image = self:GetIcon(Icon)
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 50, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.FontFace = Font.fromName("Gotham", Enum.FontWeight.Bold)
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = self:GetThemeProperty("Text")
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"
    SubTitleLabel.Size = UDim2.new(1, -100, 1, 0)
    SubTitleLabel.Position = UDim2.new(0, 50, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = SubTitle
    SubTitleLabel.FontFace = Font.fromName("Gotham", Enum.FontWeight.Regular)
    SubTitleLabel.TextSize = 14
    SubTitleLabel.TextColor3 = self:GetThemeProperty("Text")
    SubTitleLabel.TextTransparency = 0.5
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    SubTitleLabel.Parent = Topbar

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 18
    CloseBtn.FontFace = Font.fromName("GothamBold")
    CloseBtn.Parent = Topbar
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame:Destroy()
    end)

    -- Content Layout
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -50)
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.new(1,1,1)
    Sidebar.BackgroundTransparency = 0.95
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = Content
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 16)
    SideCorner.Parent = Sidebar
    local SideMask = Instance.new("Frame")
    SideMask.Size = UDim2.new(1, 0, 1, 0)
    SideMask.Position = UDim2.new(0, 0, 0, 0)
    SideMask.BackgroundColor3 = Color3.new(1,1,1)
    SideMask.BackgroundTransparency = 0.95
    SideMask.BorderSizePixel = 0
    SideMask.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = Sidebar

    -- Main Pages Container
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -150, 1, 0)
    Pages.Position = UDim2.new(0, 150, 0, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Content

    local WindowObj = {
        Frame = MainFrame,
        Content = Content,
        Sidebar = Sidebar,
        Pages = Pages,
        Theme = self.Theme,
        Opened = true
    }

    -- Methods
    function WindowObj:Toggle()
        WindowObj.Opened = not WindowObj.Opened
        if WindowObj.Opened then
            MainFrame.Visible = true
            MainFrame:TweenSizeAndPosition(Size, UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.4, true)
        else
            MainFrame:TweenSizeAndPosition(UDim2.fromOffset(0,0), UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.4, true)
            task.wait(0.4)
            MainFrame.Visible = false
        end
    end

    function WindowObj:Tab(config)
        config = config or {}
        local Title = config.Title or "Tab"
        local Icon = config.Icon or "home-2"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = Title
        TabBtn.Size = UDim2.new(1, -10, 0, 40)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = Color3.new(1,1,1)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Image = self:GetIcon(Icon)
        TabIcon.BackgroundTransparency = 1
        TabIcon.ImageColor3 = self:GetThemeProperty("Text")
        TabIcon.Parent = TabBtn

        local TabTitle = Instance.new("TextLabel")
        TabTitle.Size = UDim2.new(1, -40, 1, 0)
        TabTitle.Position = UDim2.new(0, 40, 0, 0)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Text = Title
        TabTitle.TextColor3 = self:GetThemeProperty("Text")
        TabTitle.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
        TabTitle.TextSize = 16
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Parent = TabBtn

        -- Page
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Title
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = self:GetThemeProperty("Button")
        Page.Visible = false
        Page.Parent = Pages

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        -- Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
            
            for _, v in ipairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.new(1,1,1)
                    v.BackgroundTransparency = 1
                end
            end
            TabBtn.BackgroundColor3 = self:GetThemeProperty("Button")
            TabBtn.BackgroundTransparency = 0.5
        end)

        -- Auto-resize canvas
        Page:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Tab Object
        local TabObj = {
            Frame = Page,
            Layout = PageLayout
        }

        function TabObj:Button(config)
            config = config or {}
            local Title = config.Title or "Button"
            local Callback = config.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Name = "Button"
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = self:GetThemeProperty("Button")
            Btn.BackgroundTransparency = 0.5
            Btn.BorderSizePixel = 0
            Btn.Text = Title
            Btn.TextColor3 = self:GetThemeProperty("Text")
            Btn.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
            Btn.TextSize = 15
            Btn.Parent = Page
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                Callback()
                self:Tween(Btn, {Time = 0.1}, {BackgroundColor3 = self:GetThemeProperty("Text")}):Play()
                task.wait(0.1)
                self:Tween(Btn, {Time = 0.1}, {BackgroundColor3 = self:GetThemeProperty("Button")}):Play()
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end

        function TabObj:Toggle(config)
            config = config or {}
            local Title = config.Title or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end

            local Container = Instance.new("Frame")
            Container.Name = "Toggle"
            Container.Size = UDim2.new(1, 0, 0, 36)
            Container.BackgroundTransparency = 1
            Container.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Title
            Label.TextColor3 = self:GetThemeProperty("Text")
            Label.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
            ToggleFrame.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            ToggleFrame.Parent = Container
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 10)
            TCorner.Parent = ToggleFrame

            local ToggleDot = Instance.new("Frame")
            ToggleDot.Name = "Dot"
            ToggleDot.Size = UDim2.new(0, 16, 0, 16)
            ToggleDot.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleDot.BackgroundColor3 = Color3.new(1,1,1)
            ToggleDot.Parent = ToggleFrame
            local DCorners = Instance.new("UICorner")
            DCorners.CornerRadius = UDim.new(0, 8)
            DCorners.Parent = ToggleDot

            local State = Default
            if State then
                ToggleFrame.BackgroundColor3 = self:GetThemeProperty("Toggle")
                ToggleDot.Position = UDim2.new(1, -18, 0.5, -8)
            end

            Container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    State = not State
                    if State then
                        self:Tween(ToggleFrame, {Time = 0.2}, {BackgroundColor3 = self:GetThemeProperty("Toggle")}):Play()
                        self:Tween(ToggleDot, {Time = 0.2}, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        self:Tween(ToggleFrame, {Time = 0.2}, {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
                        self:Tween(ToggleDot, {Time = 0.2}, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    Callback(State)
                end
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end

        function TabObj:Slider(config)
            config = config or {}
            local Title = config.Title or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end

            local Container = Instance.new("Frame")
            Container.Name = "Slider"
            Container.Size = UDim2.new(1, 0, 0, 50)
            Container.BackgroundTransparency = 1
            Container.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = Title .. " : " .. tostring(Default)
            Label.TextColor3 = self:GetThemeProperty("Text")
            Label.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local Bar = Instance.new("Frame")
            Bar.Name = "Bar"
            Bar.Size = UDim2.new(1, 0, 0, 6)
            Bar.Position = UDim2.new(0, 0, 1, -10)
            Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Bar.Parent = Container
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 3)
            BCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = self:GetThemeProperty("Slider")
            Fill.Parent = Bar
            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(0, 3)
            FCorner.Parent = Fill

            local function Update(val)
                Fill.Size = UDim2.new((val - Min) / (Max - Min), 0, 1, 0)
                Label.Text = Title .. " : " .. tostring(math.floor(val))
                Callback(val)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local dragging = true
                    local moveConn, upConn
                    
                    moveConn = UserInputService.InputChanged:Connect(function(inp)
                        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local scale = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            local val = Min + (scale * (Max - Min))
                            Update(val)
                        end
                    end)
                    
                    upConn = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            moveConn:Disconnect()
                            upConn:Disconnect()
                        end
                    end)
                    
                    -- Initial click
                    local scale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = Min + (scale * (Max - Min))
                    Update(val)
                end
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end

        function TabObj:Dropdown(config)
            config = config or {}
            local Title = config.Title or "Dropdown"
            local List = config.List or {}
            local Callback = config.Callback or function() end

            local Container = Instance.new("Frame")
            Container.Name = "Dropdown"
            Container.Size = UDim2.new(1, 0, 0, 36)
            Container.BackgroundTransparency = 1
            Container.Parent = Page
            
            -- Dropdown Button
            local Btn = Instance.new("TextButton")
            Btn.Name = "Btn"
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundColor3 = self:GetThemeProperty("Button")
            Btn.BackgroundTransparency = 0.5
            Btn.BorderSizePixel = 0
            Btn.Text = Title
            Btn.TextColor3 = self:GetThemeProperty("Text")
            Btn.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
            Btn.TextSize = 15
            Btn.ZIndex = 10
            Btn.Parent = Container
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn

            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.new(0, 16, 0, 16)
            Arrow.Position = UDim2.new(1, -25, 0.5, -8)
            Arrow.Image = self:GetIcon("chevron-down")
            Arrow.BackgroundTransparency = 1
            Arrow.ImageColor3 = self:GetThemeProperty("Text")
            Arrow.Parent = Btn

            -- Dropdown Menu (Created on click to handle z-index properly)
            local DropdownFrame
            local Opened = false

            local function CloseDropdown()
                if DropdownFrame then
                    DropdownFrame:Destroy()
                    DropdownFrame = nil
                end
                Opened = false
            end

            local function OpenDropdown()
                if DropdownFrame then CloseDropdown() return end
                Opened = true
                
                DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "DropdownMenu"
                DropdownFrame.Size = UDim2.new(0, Container.AbsoluteSize.X, 0, 0)
                DropdownFrame.Position = UDim2.new(0, Container.AbsolutePosition.X, 0, Container.AbsolutePosition.Y + 36)
                DropdownFrame.BackgroundColor3 = self:GetThemeProperty("Dialog")
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ZIndex = 100
                DropdownFrame.Parent = DropdownGui -- Parent to separate GUI for higher ZIndex control relative to main window
                
                local DF_Corner = Instance.new("UICorner")
                DF_Corner.CornerRadius = UDim.new(0, 8)
                DF_Corner.Parent = DropdownFrame
                
                local DF_Stroke = Instance.new("UIStroke")
                DF_Stroke.Color = self:GetThemeProperty("Text")
                DF_Stroke.Transparency = 0.9
                DF_Stroke.Thickness = 1
                DF_Stroke.Parent = DropdownFrame

                local DF_Padding = Instance.new("UIPadding")
                DF_Padding.PaddingTop = UDim.new(0, 5)
                DF_Padding.PaddingBottom = UDim.new(0, 5)
                DF_Padding.Parent = DropdownFrame

                local DF_Layout = Instance.new("UIListLayout")
                DF_Layout.Padding = UDim.new(0, 2)
                DF_Layout.Parent = DropdownFrame

                -- Add Items
                for _, v in ipairs(List) do
                    local ItemBtn = Instance.new("TextButton")
                    ItemBtn.Name = "Item"
                    ItemBtn.Size = UDim2.new(1, 0, 0, 30)
                    ItemBtn.BackgroundColor3 = Color3.new(1,1,1)
                    ItemBtn.BackgroundTransparency = 1
                    ItemBtn.Text = "   " .. tostring(v)
                    ItemBtn.TextColor3 = self:GetThemeProperty("Text")
                    ItemBtn.FontFace = Font.fromName("Gotham", Enum.FontWeight.Medium)
                    ItemBtn.TextSize = 14
                    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ItemBtn.Parent = DropdownFrame
                    ItemBtn.ZIndex = 101

                    ItemBtn.MouseButton1Click:Connect(function()
                        Btn.Text = Title .. " : " .. tostring(v)
                        Callback(v)
                        CloseDropdown()
                    end)
                    
                    ItemBtn.MouseEnter:Connect(function()
                        ItemBtn.BackgroundTransparency = 0.9
                        ItemBtn.BackgroundColor3 = self:GetThemeProperty("Button")
                    end)
                    ItemBtn.MouseLeave:Connect(function()
                        ItemBtn.BackgroundTransparency = 1
                    end)
                end

                -- Animate Open
                DropdownFrame.Size = UDim2.new(0, Container.AbsoluteSize.X, 0, 0)
                self:Tween(DropdownFrame, {Time = 0.2}, {Size = UDim2.new(0, Container.AbsoluteSize.X, 0, DF_Layout.AbsoluteContentSize.Y + 10)}):Play()
                
                -- Click outside to close
                local CloseConn
                CloseConn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if not (DropdownFrame and DropdownFrame:IsDescendantOf(input.Target)) then
                            CloseDropdown()
                            CloseConn:Disconnect()
                        end
                    end
                end)
            end

            Btn.MouseButton1Click:Connect(function()
                if Opened then CloseDropdown() else OpenDropdown() end
            end)
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end
        
        function TabObj:Label(config)
            config = config or {}
            local Title = config.Title or "Label"
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Name = "Label"
            Lbl.Size = UDim2.new(1, 0, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Title
            Lbl.TextColor3 = self:GetThemeProperty("Text")
            Lbl.TextTransparency = 0.5
            Lbl.FontFace = Font.fromName("Gotham", Enum.FontWeight.Bold)
            Lbl.TextSize = 16
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Page
            
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end

        return TabObj
    end

    -- Auto select first tab
    task.wait(0.1)
    if #Sidebar:GetChildren() > 2 then -- 2 because Layout and Mask
        Sidebar:GetChildren()[3]:MouseButton1Click()
    end

    -- Intro Animation
    MainFrame.Size = UDim2.fromOffset(0, 0)
    MainFrame.Visible = true
    self:Tween(MainFrame, {Time = 0.4}, {Size = Size}):Play()

    return WindowObj
end

return AstraUI
