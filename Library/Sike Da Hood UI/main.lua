--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// THEME
local Theme = {
    Accent = Color3.fromRGB(255,255,255),
    Background = Color3.fromRGB(7,7,7),
    Panel = Color3.fromRGB(12,12,12),
    Button = Color3.fromRGB(20,20,20),
    Text = Color3.fromRGB(255,255,255),
    Sub = Color3.fromRGB(170,170,170),
    Green = Color3.fromRGB(46,204,113),
    Red = Color3.fromRGB(231,76,60)
}

--// BLUR SETUP
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

--// MAIN GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "SikeHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,620,0,380)
Main.Position = UDim2.new(0.5,-310,0.5,-190)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,20)

--// STATE MANAGER
local UIState = {
    mode = "green",
    canToggle = true
}

--// TOGGLE WITH K KEY
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        if UIState.mode == "red" then return end -- Disabled if closed via red button
        Main.Visible = not Main.Visible
        TweenService:Create(Blur,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            Size = Main.Visible and 18 or 0
        }):Play()
    end
end)

--// DRAGGING LOGIC
local dragging,startPos,startFrame
local allowDrag = true

Main.InputBegan:Connect(function(i)
    if allowDrag and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        startPos = i.Position
        startFrame = Main.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and allowDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - startPos
        Main.Position = UDim2.new(
            startFrame.X.Scale,startFrame.X.Offset + delta.X,
            startFrame.Y.Scale,startFrame.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0,150,1,0)
Sidebar.BackgroundColor3 = Theme.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner",Sidebar).CornerRadius = UDim.new(0,20)

--// SIDEBAR LOGO
local SidebarLogo = Instance.new("TextLabel")
SidebarLogo.Size = UDim2.new(1,0,0,50)
SidebarLogo.Position = UDim2.new(0,0,0,0)
SidebarLogo.BackgroundTransparency = 1
SidebarLogo.Text = "SIKE HUB"
SidebarLogo.Font = Enum.Font.GothamBlack
SidebarLogo.TextSize = 18
SidebarLogo.TextColor3 = Theme.Accent
SidebarLogo.TextYAlignment = Enum.TextYAlignment.Center
SidebarLogo.Parent = Sidebar

--// SCROLLING FRAME FOR TABS
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,0,1,-140) -- Adjusted height to account for logo and bottom profile
TabScroll.Position = UDim2.new(0,0,0,50)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 4
TabScroll.ScrollBarImageColor3 = Theme.Sub
TabScroll.CanvasSize = UDim2.new(0,0,0,0)
TabScroll.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,8)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = TabScroll

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize = UDim2.new(0,0,0,SideLayout.AbsoluteContentSize.Y + 8)
end)

--// CONTENT AREA
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1,-150,1,0)
Content.Position = UDim2.new(0,150,0,0)
Content.BackgroundTransparency = 1
Content.Parent = Main

--// HEADER
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1,-20,0,36)
Header.Position = UDim2.new(0,10,0,10)
Header.BackgroundTransparency = 1
Header.Text = "SIKE HUB"
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 20
Header.TextColor3 = Theme.Accent
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Content

--// TRAFFIC LIGHT CONTROLS
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0,80,0,32)
ControlFrame.Position = UDim2.new(1,-90,0,10)
ControlFrame.BackgroundColor3 = Theme.Panel
Instance.new("UICorner",ControlFrame).CornerRadius = UDim.new(0,16)
ControlFrame.Parent = Content

local btnSize = 18
local spacing = 10

local function SetMode(mode)
    UIState.mode = mode
    
    for _,v in pairs(ControlFrame:GetChildren()) do
        if v:IsA("TextButton") then
            TweenService:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                Size = UDim2.new(0,btnSize,0,btnSize),
                BackgroundTransparency = 0.6
            }):Play()
        end
    end
    
    for _,v in pairs(ControlFrame:GetChildren()) do
        if v:IsA("TextButton") and v.Name == mode then
            TweenService:Create(v,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
                Size = UDim2.new(0,btnSize+1,0,btnSize+1),
                BackgroundTransparency = 0
            }):Play()
        end
    end
    
    if mode == "red" or mode == "green" then
        Main.Visible = false
        TweenService:Create(Blur,TweenInfo.new(0.3),{Size = 0}):Play()
    end
end

local function CreateLightBtn(color,pos,modeName)
    local btn = Instance.new("TextButton")
    btn.Name = modeName
    btn.Size = UDim2.new(0,btnSize,0,btnSize)
    btn.Position = UDim2.new(0,pos,0.5,-btnSize/2)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BackgroundTransparency = 0.6
    btn.Parent = ControlFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        SetMode(modeName)
    end)
end

CreateLightBtn(Theme.Red,spacing,"red")
CreateLightBtn(Theme.Green,spacing*2+btnSize+8,"green")

task.wait(0.1)
SetMode("green")

--// TAB SYSTEM
local Tabs = {}
local CurrentTab

local function SwitchTab(name)
    for _,tab in pairs(Tabs) do
        if tab.Frame then tab.Frame.Visible = false end
        if tab.Button then
            TweenService:Create(tab.Button,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
                TextColor3 = Theme.Sub,
                BackgroundColor3 = Theme.Button
            }):Play()
        end
    end
    
    if Tabs[name] then
        Tabs[name].Frame.Visible = true
        TweenService:Create(Tabs[name].Button,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
            TextColor3 = Theme.Accent,
            BackgroundColor3 = Color3.fromRGB(25,25,25)
        }):Play()
        CurrentTab = name
    end
end

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-16,0,36)
    btn.BackgroundColor3 = Theme.Button
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Theme.Sub
    btn.AutoButtonColor = false
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)
    btn.Parent = TabScroll

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,1,-60)
    frame.Position = UDim2.new(0,10,0,56)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,10)
    layout.Parent = frame

    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)

    Tabs[name] = {Button = btn, Frame = frame}
    
    -- Initialize first tab
    if not CurrentTab then
        CurrentTab = name
        SwitchTab(name)
    end

    return frame
end

--// ELEMENTS
local function Label(parent,txt)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,20)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextColor3 = Theme.Sub
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

local function Toggle(parent,txt,callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,0,0,32)
    holder.BackgroundTransparency = 1
    holder.Parent = parent

    Label(holder,txt)

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0,38,0,18)
    switch.Position = UDim2.new(1,-38,0.5,-9)
    switch.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Instance.new("UICorner",switch).CornerRadius = UDim.new(1,0)
    switch.Parent = holder

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(0,2,0.5,-7)
    knob.BackgroundColor3 = Theme.Text
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
    knob.Parent = switch

    local state = false
    
    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            
            TweenService:Create(switch,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
                BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
            }):Play()
            
            TweenService:Create(knob,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),
                BackgroundColor3 = state and Color3.fromRGB(0,0,0) or Theme.Text
            }):Play()
            
            callback(state)
        end
    end)
end

local function Slider(parent,txt,min,max,default,callback)
    Label(parent,txt)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,26)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0,40,1,0)
    valueText.Position = UDim2.new(1,-40,0,0)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(default)
    valueText.Font = Enum.Font.GothamBlack
    valueText.TextSize = 14
    valueText.TextColor3 = Theme.Text
    valueText.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-50,0,6)
    track.Position = UDim2.new(0,0,0.5,-3)
    track.BackgroundColor3 = Theme.Button
    Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)
    track.Parent = container

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.Accent
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BorderSizePixel = 0
    Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)
    fill.Parent = track

    local sliderDragging = false
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
            allowDrag = false
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
            allowDrag = true
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            TweenService:Create(fill,TweenInfo.new(0.1,Enum.EasingStyle.Quad),{
                Size = UDim2.new(percent,0,1,0)
            }):Play()
            
            valueText.Text = value
            callback(value)
        end
    end)
end

local function Dropdown(parent,txt,options,callback)
    local isOpen = false
    Label(parent,txt)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,0,0,32)
    button.BackgroundColor3 = Theme.Button
    button.Text = "Select ▼"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Theme.Text
    Instance.new("UICorner",button).CornerRadius = UDim.new(0,12)
    button.Parent = parent

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1,0,0,0)
    optionsFrame.ClipsDescendants = true
    optionsFrame.BackgroundTransparency = 1
    optionsFrame.Parent = parent

    local optLayout = Instance.new("UIListLayout")
    optLayout.Padding = UDim.new(0,6)
    optLayout.Parent = optionsFrame

    for i,opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1,0,0,28)
        optBtn.BackgroundColor3 = Theme.Button
        optBtn.Text = opt
        optBtn.Font = Enum.Font.GothamBold
        optBtn.TextSize = 14
        optBtn.TextColor3 = Theme.Text
        Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,10)
        optBtn.Parent = optionsFrame

        optBtn.MouseButton1Click:Connect(function()
            button.Text = opt
            callback(opt)
            isOpen = false
            TweenService:Create(optionsFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
                Size = UDim2.new(1,0,0,0)
            }):Play()
        end)
    end

    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        -- Calculate size based on number of options
        local targetSize = isOpen and (UDim2.new(1,0,0,#options * 34)) or UDim2.new(1,0,0,0)
        TweenService:Create(optionsFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            Size = targetSize
        }):Play()
    end)
end

--// CREATE TABS
local homeTab = CreateTab("Home")
Toggle(homeTab,"Enable Blur",function(val)
    TweenService:Create(Blur,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
        Size = val and 18 or 0
    }):Play()
end)

Slider(homeTab,"WalkSpeed",10,30,16,function(val)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = val
    end
end)

Dropdown(homeTab,"Mode",{"Legit","Semi","Rage"},function(val)
    print("Selected Mode:", val)
end)

local settingsTab = CreateTab("Settings")
Toggle(settingsTab,"UI Animations",function(val)
    print("Animations:", val)
end)

local testTab1 = CreateTab("Player")
local testTab2 = CreateTab("Combat")
local testTab3 = CreateTab("Visual")
local testTab4 = CreateTab("Misc")

--// BOTTOM PROFILE
local bottomFrame = Instance.new("Frame")
bottomFrame.Name = "BottomProfile"
bottomFrame.Size = UDim2.new(1,0,0,80)
bottomFrame.Position = UDim2.new(0,0,1,-80)
bottomFrame.BackgroundTransparency = 1
bottomFrame.ZIndex = 10
bottomFrame.Parent = Sidebar

local pfp = Instance.new("ImageLabel")
pfp.Size = UDim2.new(0,32,0,32)
pfp.Position = UDim2.new(0.5,-16,0,10)
pfp.BackgroundTransparency = 1
Instance.new("UICorner",pfp).CornerRadius = UDim.new(1,0)
pfp.Parent = bottomFrame

task.spawn(function()
    local success, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(
            Player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)
    if success then
        pfp.Image = thumb
    end
end)

local branding = Instance.new("TextLabel")
branding.Size = UDim2.new(1,0,0,18)
branding.Position = UDim2.new(0,0,0,50)
branding.BackgroundTransparency = 1
branding.Text = "Sike Hub | Da Hood"
branding.Font = Enum.Font.GothamBlack
branding.TextSize = 12
branding.TextColor3 = Theme.Accent
branding.Parent = bottomFrame
