-- Astra UI Library
-- Inspired by Vape V4
-- Author: Astra

local Astra = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

-- Asset Table (Using placeholders or Roblox assets for demonstration, replace with your custom assets)
local Assets = {
    Logo = "rbxassetid://7072702996", -- Replace with Vape Logo ID
    V4Logo = "rbxassetid://7072702996",
    Dropdown = "rbxassetid://6031068421",
    Toggle = "rbxassetid://6031068428",
    Slider = "rbxassetid://6031094673",
    Bind = "rbxassetid://6031090940",
    Search = "rbxassetid://6031068429",
    Close = "rbxassetid://6031068423",
    Blur = "rbxassetid://6035047407", -- A 9 slice image for blur effect
    Dot = "rbxassetid://6031094667",
    Add = "rbxassetid://6031068422",
    Friend = "rbxassetid://7072727346",
    Target = "rbxassetid://7072727346"
}

-- Configuration
Astra.Config = {
    ThemeColor = Color3.fromHSV(0.44, 1, 1), -- Default Green
    BackgroundColor = Color3.fromRGB(26, 25, 26),
    TextColor = Color3.fromRGB(200, 200, 200),
    DarkerBackgroundColor = Color3.fromRGB(18, 18, 18),
    Font = Enum.Font.Gotham,
    Accent = Color3.fromRGB(5, 134, 105),
    Keybind = "RightShift",
    TweenSpeed = 0.2
}

-- Internal Variables
local ScreenGui
local MainGui
local ToggleKey = Enum.KeyCode[Astra.Config.Keybind]
local Categories = {}
local Modules = {}

-- Utility Functions
local function CloneRef(Obj)
    if cloneref then return cloneref(Obj) end
    return Obj
end

local function GetTextBounds(Text, Size, Font)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.Size = Size
    Params.Font = Font
    return TextService:GetTextBoundsAsync(Params)
end

local function Create(UIClass, Properties)
    local Obj = Instance.new(UIClass)
    for Property, Value in next, Properties or {} do
        Obj[Property] = Value
    end
    return Obj
end

local function CreateBlur(Parent)
    local Blur = Create("ImageLabel", {
        Name = "Blur",
        Size = UDim2.new(1, 50, 1, 50),
        Position = UDim2.fromOffset(-25, -25),
        BackgroundTransparency = 1,
        Image = Assets.Blur,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ImageTransparency = 0.5,
        ZIndex = Parent.ZIndex - 1,
        Parent = Parent
    })
    return Blur
end

local function MakeDraggable(Gui, Header)
    local Dragging = false
    local DragInput, MousePos, FramePos

    Header.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = Gui.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = Input.Position - MousePos
            Gui.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)
end

local function Tween(Object, Info, Goal)
    TweenService:Create(Object, Info, Goal):Play()
end

-- UI Components
function Astra:CreateWindow()
    if ScreenGui then return ScreenGui end

    -- Init
    ScreenGui = Create("ScreenGui", {
        Name = "AstraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or game:GetService("CoreGui")
    })

    -- Scaled GUI (for resolution scaling if needed, simplified here)
    local ScaledGui = Create("Frame", {
        Name = "ScaledGui",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = ScreenGui
    })

    -- Main Container (Sidebar)
    MainGui = Create("Frame", {
        Name = "MainGui",
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.fromOffset(220, 0), -- Auto height
        BackgroundColor3 = Astra.Config.BackgroundColor,
        Parent = ScaledGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = MainGui})
    CreateBlur(MainGui)

    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        Parent = MainGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = Header})

    local Logo = Create("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(10, 7),
        BackgroundTransparency = 1,
        Image = Assets.Logo,
        ImageColor3 = Astra.Config.ThemeColor,
        Parent = Header
    })

    local Title = Create("TextLabel", {
        Size = UDim2.fromOffset(100, 20),
        Position = UDim2.fromOffset(40, 7),
        BackgroundTransparency = 1,
        Text = "Astra",
        TextColor3 = Astra.Config.ThemeColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Astra.Config.Font,
        TextSize = 14,
        Parent = Header
    })

    MakeDraggable(MainGui, Header)

    -- Categories Container
    local CategoryList = Create("ScrollingFrame", {
        Name = "CategoryList",
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.fromOffset(0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = MainGui
    })
    local CategoryLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = CategoryList
    })

    CategoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
    CategoryList:GetPropertyChangedSignal("CanvasSize"):Connect(function()
        MainGui.Size = UDim2.fromOffset(220, math.clamp(CategoryList.CanvasSize.Y.Offset + 50, 300, 600))
    end)

    -- Toggle Visibility
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == ToggleKey then
            MainGui.Visible = not MainGui.Visible
        end
    end)

    MainGui.Visible = true

    return {
        Container = CategoryList,
        Layout = CategoryLayout
    }
end

function Astra:CreateCategory(Name, Icon)
    local WindowData = self:CreateWindow()
    local Container = WindowData.Container
    local Layout = WindowData.Layout

    local CategoryFrame = Create("TextButton", {
        Name = Name .. "Category",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Astra.Config.BackgroundColor,
        Text = " " .. Name,
        TextColor3 = Astra.Config.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Astra.Config.Font,
        TextSize = 14,
        Parent = Container
    })
    
    local CategoryIcon = Create("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(10, 7),
        BackgroundTransparency = 1,
        Image = Icon,
        Parent = CategoryFrame
    })

    local Arrow = Create("ImageLabel", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(1, -25, 0.5, -6),
        BackgroundTransparency = 1,
        Image = Assets.Dropdown,
        Rotation = 90,
        Parent = CategoryFrame
    })

    -- Module Container (Hidden by default)
    local ModuleContainer = Create("ScrollingFrame", {
        Name = "ModuleContainer",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        ScrollBarThickness = 2,
        Visible = false,
        Parent = Container
    })
    Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200))}), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)}), Parent = ModuleContainer.ScrollBarImageLabel}) -- Optional scrollbar styling

    local ModuleLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = ModuleContainer
    })

    -- Logic
    local Expanded = false

    CategoryFrame.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        ModuleContainer.Visible = Expanded
        Arrow.Rotation = Expanded and -90 or 90
        
        Tween(ModuleContainer, TweenInfo.new(0.2), {
            Size = Expanded and UDim2.new(1, 0, 0, math.clamp(ModuleLayout.AbsoluteContentSize.Y, 0, 300)) or UDim2.new(1, 0, 0, 0)
        })
        
        -- Adjust canvas size based on expansion
        task.wait(0.2)
    end)

    ModuleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Expanded then
            ModuleContainer.Size = UDim2.new(1, 0, 0, math.clamp(ModuleLayout.AbsoluteContentSize.Y, 0, 300))
        end
    end)

    Categories[Name] = {
        Container = ModuleContainer,
        Layout = ModuleLayout
    }

    return Name
end

function Astra:CreateModule(CategoryName, Name, Callback)
    local CatData = Categories[CategoryName]
    if not CatData then return warn("Category not found: " .. CategoryName) end

    local ModuleFrame = Create("TextButton", {
        Name = Name .. "Module",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        Text = "   " .. Name,
        TextColor3 = Astra.Config.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Astra.Config.Font,
        TextSize = 13,
        Parent = CatData.Container
    })
    
    local ToggleBtn = Create("TextButton", {
        Name = "Toggle",
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(1, -25, 0.5, -9),
        BackgroundColor3 = Astra.Config.BackgroundColor,
        Parent = ModuleFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ToggleBtn})
    
    local ToggleState = Create("Frame", {
        Name = "State",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Astra.Config.ThemeColor,
        Visible = false,
        Parent = ToggleBtn
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = ToggleState})

    local Enabled = false

    local function UpdateVisuals()
        ToggleState.Visible = Enabled
        ModuleFrame.TextColor3 = Enabled and Astra.Config.ThemeColor or Astra.Config.TextColor
        
        if Enabled then
            Tween(ModuleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Astra.Config.BackgroundColor})
        else
            Tween(ModuleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Astra.Config.DarkerBackgroundColor})
        end
    end

    ModuleFrame.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        UpdateVisuals()
        if Callback then Callback(Enabled) end
    end)
    
    -- Hover Effects
    ModuleFrame.MouseEnter:Connect(function()
        if not Enabled then
            Tween(ModuleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
        end
    end)
    
    ModuleFrame.MouseLeave:Connect(function()
        if not Enabled then
            Tween(ModuleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Astra.Config.DarkerBackgroundColor})
        end
    end)

    return {
        SetState = function(State)
            Enabled = State
            UpdateVisuals()
        end
    }
end

function Astra:Notification(Title, Text, Duration)
    -- Placeholder for notification system
    warn("Notification: ["..Title.."] "..Text)
end

return Astra
