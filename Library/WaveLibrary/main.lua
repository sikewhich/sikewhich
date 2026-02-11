-- 43341

local WaveLibrary = {}
WaveLibrary.__index = WaveLibrary

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local Player = Players.LocalPlayer

-- State
local isRainbow = false
local rainbowConnection = nil

-- Helper to create the specific WaveHub style
local function StyleUI(frame)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 0
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
    return stroke
end

--- Creates a new Window
function WaveLibrary.new(opts)
    local self = setmetatable({}, WaveLibrary)
    
    -- Defaults
    self.Name = opts.Name or "WaveHub"
    self.Size = opts.Size or UDim2.new(0, 480, 0, 340)
    
    -- Setup ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name .. "_Gui"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    self.Gui = ScreenGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = self.Size
    MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    self.MainFrame = MainFrame
    
    self.MainStroke = StyleUI(MainFrame)
    self.Strokes = {self.MainStroke}
    self.Toggles = {}

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.Size = UDim2.new(0, 130, 1, 0) -- Slightly wider for PFP
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 15)
    SidebarCorner.Parent = Sidebar

    -- Logo
    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.Text = self.Name:sub(1,4):upper()
    Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
    Logo.TextSize = 22
    Logo.Font = Enum.Font.GothamBlack
    Logo.BackgroundTransparency = 1
    Logo.Parent = Sidebar
    self.Logo = Logo

    -- TAB LAYOUT (Top)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -130) -- Leave space for PFP at bottom (50 logo + 80 PFP)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.Padding = UDim.new(0, 8) -- SPACE BETWEEN TABS
    TabLayout.Parent = TabContainer

    -- PFP FRAME (Bottom)
    local PFPHolder = Instance.new("Frame")
    PFPHolder.Name = "PFPHolder"
    PFPHolder.Size = UDim2.new(0, 80, 0, 80)
    PFPHolder.Position = UDim2.new(0.5, -40, 1, -90) -- Positioned at bottom
    PFPHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PFPHolder.Parent = Sidebar
    
    local PFPCorner = Instance.new("UICorner")
    PFPCorner.CornerRadius = UDim.new(1, 0) -- Fully rounded
    PFPCorner.Parent = PFPHolder
    
    local PFPImg = Instance.new("ImageLabel")
    PFPImg.Name = "PFPImage"
    PFPImg.Size = UDim2.new(1, 0, 1, 0)
    PFPImg.BackgroundTransparency = 1
    PFPImg.ScaleType = Enum.ScaleType.Crop
    PFPImg.Parent = PFPHolder
    
    -- Load PFP
    local userId = Player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    PFPImg.Image = content

    -- Page Container
    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Name = "ContainerHolder"
    ContainerHolder.Position = UDim2.new(0, 140, 0, 15) -- Adjusted for wider sidebar
    ContainerHolder.Size = UDim2.new(1, -155, 1, -30)
    ContainerHolder.BackgroundTransparency = 1
    ContainerHolder.Parent = MainFrame

    self.TabButtons = {}
    self.Pages = {}
    self.Sliders = {}

    return self
end

--- Creates a new Tab
function WaveLibrary:AddTab(Name)
    -- Create Tab Button in Sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = Name
    TabBtn.Size = UDim2.new(0, 110, 0, 35) -- Adjusted size for spacing
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = Name
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.Parent = self.MainFrame.Sidebar.TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabBtn

    -- Create Page Container
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.Parent = self.MainFrame.ContainerHolder
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = Page

    self.TabButtons[Name] = TabBtn
    self.Pages[Name] = Page

    TabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(Name)
    end)

    if #self.TabButtons == 1 then
        self:SelectTab(Name)
    end

    return {
        AddToggle = function(text, callback, default)
            self:AddToggleToPage(Page, text, callback, default)
        end,
        AddSlider = function(text, min, max, default, callback)
            self:AddSliderToPage(Page, text, min, max, default, callback)
        end
    }
end

function WaveLibrary:SelectTab(Name)
    for tabName, btn in pairs(self.TabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        self.Pages[tabName].Visible = false
    end
    
    local selectedBtn = self.TabButtons[Name]
    if not isRainbow then
        selectedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    else
        selectedBtn.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
    self.Pages[Name].Visible = true
end

function WaveLibrary:AddToggleToPage(parent, text, callback, startState)
    startState = startState or false
    
    local TF = Instance.new("Frame")
    TF.Size = UDim2.new(1, 0, 0, 40)
    TF.BackgroundTransparency = 1
    TF.Parent = parent

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
    local SwCorner = Instance.new("UICorner", Sw)
    SwCorner.CornerRadius = UDim.new(1, 0)

    local Circ = Instance.new("Frame", Sw)
    Circ.Size = UDim2.new(0, 20, 0, 20)
    Circ.Position = startState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Circ.BackgroundColor3 = Color3.new(1, 1, 1)
    local CircCorner = Instance.new("UICorner", Circ)
    CircCorner.CornerRadius = UDim.new(1, 0)

    local act = startState
    if act then self.Toggles[Sw] = true end

    Sw.MouseButton1Click:Connect(function()
        act = not act
        local goal = {}
        goal.Position = act and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Circ, tweenInfo, goal)
        tween:Play()
        
        if act then
            self.Toggles[Sw] = true
            if not isRainbow then Sw.BackgroundColor3 = Color3.fromRGB(76, 217, 100) end
        else
            self.Toggles[Sw] = nil
            Sw.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        if callback then callback(act) end
    end)
end

function WaveLibrary:AddSliderToPage(parent, name, min, max, startVal, callback)
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
    local BCorner = Instance.new("UICorner", B)
    BCorner.Parent = B
    
    local Fill = Instance.new("Frame", B)
    local startPct = math.clamp((startVal - min) / (max - min), 0, 1)
    Fill.Size = UDim2.new(startPct, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.Parent = Fill
    
    table.insert(self.Sliders, Fill)

    B.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation().X
            local pct = math.clamp((mousePos - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pct)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            L.Text = name .. ": " .. val
            if callback then callback(val) end
        end)
        local rel
        rel = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                move:Disconnect() 
                rel:Disconnect() 
            end
        end)
    end)
end

function WaveLibrary:ToggleRainbow(enabled)
    isRainbow = enabled
    if enabled then
        if not rainbowConnection then
            rainbowConnection = RunService.RenderStepped:Connect(function()
                local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                self.Logo.TextColor3 = c
                for _, str in pairs(self.Strokes) do str.Color = c end
                for _, sl in pairs(self.Sliders) do sl.BackgroundColor3 = c end
                for name, btn in pairs(self.TabButtons) do 
                    if self.Pages[name].Visible then btn.BackgroundColor3 = c end 
                end
                for toggleBtn, _ in pairs(self.Toggles) do toggleBtn.BackgroundColor3 = c end
            end)
        end
    else
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        self.Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
        for _, str in pairs(self.Strokes) do str.Color = Color3.fromRGB(0, 170, 255) end
        for _, sl in pairs(self.Sliders) do sl.BackgroundColor3 = Color3.fromRGB(0, 170, 255) end
        for name, btn in pairs(self.TabButtons) do 
            if self.Pages[name].Visible then btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) end 
        end
        for toggleBtn, _ in pairs(self.Toggles) do toggleBtn.BackgroundColor3 = Color3.fromRGB(76, 217, 100) end
    end
end

function WaveLibrary:ToggleUI()
    self.MainFrame.Visible = not self.MainFrame.Visible
end

return WaveLibrary
