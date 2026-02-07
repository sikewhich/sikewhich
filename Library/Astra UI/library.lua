-- Astra UI Library
-- Inspired by Vape V4
-- Author: Astra (fixed)

local Astra = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

-- Assets
local Assets = {
    Logo = "rbxassetid://7072702996",
    Dropdown = "rbxassetid://6031068421"
}

-- Config
Astra.Config = {
    ThemeColor = Color3.fromRGB(5, 134, 105),
    BackgroundColor = Color3.fromRGB(26, 25, 26),
    DarkerBackgroundColor = Color3.fromRGB(18, 18, 18),
    TextColor = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    Keybind = Enum.KeyCode.RightShift,
    TweenSpeed = 0.2
}

-- Internal
local ScreenGui
local MainGui
local Categories = {}

-- Utils
local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in pairs(props or {}) do
        obj[i] = v
    end
    return obj
end

local function Tween(obj, goal)
    TweenService:Create(
        obj,
        TweenInfo.new(Astra.Config.TweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        goal
    ):Play()
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Window
function Astra:CreateWindow()
    if ScreenGui then return end

    ScreenGui = Create("ScreenGui", {
        Name = "AstraUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    MainGui = Create("Frame", {
        Size = UDim2.fromOffset(220, 300),
        Position = UDim2.fromOffset(20, 20),
        BackgroundColor3 = Astra.Config.BackgroundColor,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MainGui})

    local Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        Parent = MainGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Header})

    Create("ImageLabel", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(10, 8),
        BackgroundTransparency = 1,
        Image = Assets.Logo,
        ImageColor3 = Astra.Config.ThemeColor,
        Parent = Header
    })

    Create("TextLabel", {
        Size = UDim2.fromOffset(120, 20),
        Position = UDim2.fromOffset(35, 8),
        BackgroundTransparency = 1,
        Text = "Astra",
        Font = Astra.Config.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Astra.Config.ThemeColor,
        Parent = Header
    })

    MakeDraggable(MainGui, Header)

    local CategoryList = Create("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = MainGui
    })

    local Layout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = CategoryList
    })

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        CategoryList.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Astra.Config.Keybind then
            MainGui.Visible = not MainGui.Visible
        end
    end)

    Astra._Container = CategoryList
end

-- Category
function Astra:CreateCategory(name, icon)
    if not Astra._Container then self:CreateWindow() end

    local Button = Create("TextButton", {
        Size = UDim2.new(1, -10, 0, 35),
        BackgroundColor3 = Astra.Config.BackgroundColor,
        Text = "  "..name,
        Font = Astra.Config.Font,
        TextSize = 14,
        TextColor3 = Astra.Config.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Astra._Container
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = Button})

    Create("ImageLabel", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(8, 8),
        BackgroundTransparency = 1,
        Image = icon,
        Parent = Button
    })

    local Arrow = Create("ImageLabel", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(1, -20, 0.5, -6),
        BackgroundTransparency = 1,
        Image = Assets.Dropdown,
        Rotation = 90,
        Parent = Button
    })

    local ModuleContainer = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        ClipsDescendants = true,
        Parent = Astra._Container
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = ModuleContainer})

    local ModuleLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = ModuleContainer
    })

    local Open = false

    Button.MouseButton1Click:Connect(function()
        Open = not Open
        Arrow.Rotation = Open and -90 or 90
        Tween(ModuleContainer, {
            Size = Open
                and UDim2.new(1, -10, 0, ModuleLayout.AbsoluteContentSize.Y + 6)
                or UDim2.new(1, -10, 0, 0)
        })
    end)

    ModuleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Open then
            ModuleContainer.Size = UDim2.new(1, -10, 0, ModuleLayout.AbsoluteContentSize.Y + 6)
        end
    end)

    Categories[name] = ModuleContainer
end

-- Module
function Astra:CreateModule(category, name, callback)
    local parent = Categories[category]
    if not parent then warn("Category not found:", category) return end

    local Button = Create("TextButton", {
        Size = UDim2.new(1, -8, 0, 30),
        BackgroundColor3 = Astra.Config.DarkerBackgroundColor,
        Text = "   "..name,
        Font = Astra.Config.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Astra.Config.TextColor,
        Parent = parent
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Button})

    local Enabled = false

    Button.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Button.TextColor3 = Enabled and Astra.Config.ThemeColor or Astra.Config.TextColor
        if callback then callback(Enabled) end
    end)
end

return Astra
