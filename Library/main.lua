-- Sike UI Library
-- Mobile Supported | Smooth Animations | Custom Design

local Sike = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Properties for smoothness
Sike.TweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

function Sike:Window(Name, TitleName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SikeGui"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Black/Dark Grey
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    -- Corner Rounding
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Top Bar (Draggable Area)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    -- Mask to square off bottom of top bar
    local TopMask = Instance.new("Frame")
    TopMask.Size = UDim2.new(1, 0, 0.5, 0)
    TopMask.Position = UDim2.new(0, 0, 0.5, 0)
    TopMask.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopMask.BorderSizePixel = 0
    TopMask.Parent = TopBar

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TitleName or Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Traffic Light Buttons Container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(0, 90, 1, 0)
    ButtonContainer.Position = UDim2.new(1, -95, 0, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = TopBar

    -- Helper to make circle buttons
    local function makeCircleBtn(color, pos, action)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 12, 0, 12)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = ButtonContainer
        
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(1, 0)
        bCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            action()
        end)
        return btn
    end

    -- Red (Close), Yellow (Hide), Green (Show/Reset)
    local CloseBtn = makeCircleBtn(Color3.fromRGB(255, 69, 58), UDim2.new(0, 10, 0.5, -6), function()
        ScreenGui:Destroy()
    end)
    
    local MinBtn = makeCircleBtn(Color3.fromRGB(255, 204, 0), UDim2.new(0, 35, 0.5, -6), function()
        -- Smoothly hide
        TweenService:Create(MainFrame, Sike.TweenInfo, {Size = UDim2.new(0, 500, 0, 35)}):Play()
    end)
    
    local MaxBtn = makeCircleBtn(Color3.fromRGB(52, 199, 89), UDim2.new(0, 60, 0.5, -6), function()
        -- Smoothly show
        TweenService:Create(MainFrame, Sike.TweenInfo, {Size = UDim2.new(0, 500, 0, 350)}):Play()
    end)

    -- Layout for Content
    local ContentLayout = Instance.new("Frame")
    ContentLayout.Name = "ContentLayout"
    ContentLayout.Size = UDim2.new(1, 0, 1, -35)
    ContentLayout.Position = UDim2.new(0, 0, 0, 35)
    ContentLayout.BackgroundTransparency = 1
    ContentLayout.Parent = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = ContentLayout
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = Sidebar
    -- Mask bottom of sidebar
    local SidePad = Instance.new("Frame")
    SidePad.Size = UDim2.new(1, 0, 0.2, 0)
    SidePad.Position = UDim2.new(0, 0, 0.8, 0)
    SidePad.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SidePad.BorderSizePixel = 0
    SidePad.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = Sidebar

    -- Pages Container
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -120, 1, 0)
    Pages.Position = UDim2.new(0, 120, 0, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = ContentLayout

    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Mobile / Mouse Dragging Logic
    local dragging = false
    local dragStart, startPos
    local updateInput

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
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

    RunService.Heartbeat:Connect(function()
        if dragging then
            local input = UserInputService:GetInputMoved() 
            if input then update(input) end
        end
    end)

    local Library = {}

    -- Notifications
    function Library:Notify(Text, Duration)
        Duration = Duration or 3
        local NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "SikeNotif"
        NotifGui.ResetOnSpawn = false
        NotifGui.Parent = game:GetService("CoreGui")

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 250, 0, 50)
        NotifFrame.Position = UDim2.new(1, 270, 0.8, 0) -- Start off screen
        NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NotifFrame.Parent = NotifGui
        local nCorner = Instance.new("UICorner")
        nCorner.CornerRadius = UDim.new(0, 8)
        nCorner.Parent = NotifFrame

        local NotifText = Instance.new("TextLabel")
        NotifText.Size = UDim2.new(1, 0, 1, 0)
        NotifText.BackgroundTransparency = 1
        NotifText.Text = Text
        NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifText.Font = Enum.Font.GothamSemibold
        NotifText.TextSize = 14
        NotifText.Parent = NotifFrame

        -- Slide In
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 0.8, 0)}):Play()

        task.wait(Duration)
        -- Slide Out
        local tween = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, 270, 0.8, 0)})
        tween:Play()
        tween.Completed:Wait()
        NotifGui:Destroy()
    end

    -- Tabs
    local currentTab = nil
    function Library:NewTab(Name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = Name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = Sidebar
        
        TabButton.MouseEnter:Connect(function()
            if currentTab ~= TabButton then
                TweenService:Create(TabButton, Sike.TweenInfo, {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(200,200,200)}):Play()
                            end
        end)
        TabButton.MouseLeave:Connect(function()
            if currentTab ~= TabButton then
                TweenService:Create(TabButton, Sike.TweenInfo, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150,150,150)}):Play()
            end
        end)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        Page.Parent = Pages
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        TabButton.MouseButton1Click:Connect(function()
            -- Reset others
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, Sike.TweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundTransparency = 1}):Play()
                end
            end
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end

            -- Set Active
            currentTab = TabButton
            Page.Visible = true
            -- Iphone style active bar (background color change)
            TweenService:Create(TabButton, Sike.TweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 122, 255), TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0}):Play()
        end)

        -- Auto-select first tab
        if #Pages:GetChildren() == 1 then
            TabButton:FireServer("fake") -- Triggers logic manually if needed, but let's just simulate click
            TabButton.MouseButton1Click:Fire()
            -- Fix for firing manually:
             for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                    v.BackgroundTransparency = 1
                end
            end
            currentTab = TabButton
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 0
        end

        local TabItems = {}

        -- iPhone Toggle
        function TabItems:Toggle(Label, Callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 40)
            Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Container.Parent = Page
            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 6)
            cCorner.Parent = Container

            local Txt = Instance.new("TextLabel")
            Txt.Size = UDim2.new(1, -50, 1, 0)
            Txt.Position = UDim2.new(0, 10, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = Label
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.Font = Enum.Font.Gotham
            Txt.TextSize = 14
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.Parent = Container

            -- IPhone Toggle UI
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
            ToggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Off Color (Grey)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.Parent = Container
            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(1, 0) -- Fully rounded
            tCorner.Parent = ToggleBtn

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.Position = UDim2.new(0, 2, 0.5, -9)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = ToggleBtn
            local cCircle = Instance.new("UICorner")
            cCircle.CornerRadius = UDim.new(1, 0)
            cCircle.Parent = Circle

            local Toggled = false

            local function animateToggle()
                Toggled = not Toggled
                if Toggled then
                    TweenService:Create(ToggleBtn, Sike.TweenInfo, {BackgroundColor3 = Color3.fromRGB(52, 199, 89)}):Play() -- Green
                    TweenService:Create(Circle, Sike.TweenInfo, {Position = UDim2.new(0, 20, 0.5, -9)}):Play()
                else
                    TweenService:Create(ToggleBtn, Sike.TweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play() -- Grey
                    TweenService:Create(Circle, Sike.TweenInfo, {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
                end
                Callback(Toggled)
            end

            ToggleBtn.MouseButton1Click:Connect(animateToggle)
        end

        -- Standard Button
        function TabItems:Button(Label, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- IPhone Blue
            Btn.Text = Label
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.Parent = Page
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 6)
            bCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                -- Click animation
                local t = TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 90, 200)})
                t:Play()
                t.Completed:Wait()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
                Callback()
            end)
        end

        return TabItems
    end

    return Library
end

return Sike
