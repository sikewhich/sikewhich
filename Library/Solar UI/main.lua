-- SOLAR UI LIBRARY (UPDATED WITH SCROLLABLE SIDEBAR & FIXES)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Solar = {}
Solar.Folder = Instance.new("ScreenGui")
Solar.Folder.Name = "SolarUI_Lib"
Solar.Folder.Parent = game:GetService("CoreGui")
Solar.Folder.ResetOnSpawn = false
Solar.Folder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Solar.Blur = Instance.new("BlurEffect")
Solar.Blur.Size = 0
Solar.Blur.Parent = game:GetService("Lighting")

Solar.NotifyQueue = {}
Solar.IsShowingNotify = false
Solar.NotificationsEnabled = true
Solar.Windows = {}

function Solar.SetNotifications(bool)
    Solar.NotificationsEnabled = bool
end

function Solar:Notify(text, duration)
    if not Solar.NotificationsEnabled then return end
    table.insert(Solar.NotifyQueue, {text = text, duration = duration or 3})
    if Solar.IsShowingNotify then return end
    
    local function showNext()
        if #Solar.NotifyQueue == 0 then Solar.IsShowingNotify = false; return end
        Solar.IsShowingNotify = true
        local data = table.remove(Solar.NotifyQueue, 1)
        
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 280, 0, 50)
        notif.Position = UDim2.new(0.5, 140, 0.1, 0)
        notif.AnchorPoint = Vector2.new(0.5, 0.5)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        notif.BorderSizePixel = 0
        notif.Parent = Solar.Folder
        notif.ZIndex = 100
        
        local notifCorner = Instance.new("UICorner", notif)
        notifCorner.CornerRadius = UDim.new(0, 16)
        local notifStroke = Instance.new("UIStroke", notif)
        notifStroke.Color = Color3.fromRGB(80, 80, 80)
        notifStroke.Thickness = 1
        notifStroke.Transparency = 0.3
        
        local notifText = Instance.new("TextLabel")
        notifText.Text = data.text
        notifText.Font = Enum.Font.GothamBold
        notifText.TextSize = 15
        notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
        notifText.BackgroundTransparency = 1
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.Parent = notif
        
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.1, 0)
        }):Play()
        task.wait(data.duration)
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -140, 0.1, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notif:Destroy()
        showNext()
    end
    if not Solar.IsShowingNotify then showNext() end
end

function Solar:Window(name)
    local Window = {}
    local isOpen = true

    local splash = Instance.new("Frame")
    splash.Size = UDim2.new(1, 0, 1, 0)
    splash.BackgroundTransparency = 1
    splash.BorderSizePixel = 0
    splash.ZIndex = 100
    splash.Parent = Solar.Folder
    local splashText = Instance.new("TextLabel")
    splashText.Text = name
    splashText.Font = Enum.Font.GothamBold
    splashText.TextSize = 96
    splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
    splashText.BackgroundTransparency = 1
    splashText.Size = UDim2.new(1, 0, 1, 0)
    splashText.TextTransparency = 1
    splashText.Parent = splash
    TweenService:Create(Solar.Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24}):Play()
    TweenService:Create(splashText, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(1.8)
    TweenService:Create(splashText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(Solar.Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0}):Play()
    task.wait(0.7)
    splash:Destroy()

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 700, 0, 540)
    main.Position = UDim2.new(0.5, -350, 0.5, -270)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    main.BorderSizePixel = 0
    main.Parent = Solar.Folder
    main.ZIndex = 10
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 20)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(40, 40, 40)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    top.BorderSizePixel = 0
    top.Parent = main
    top.ZIndex = 11
    local topCorner = Instance.new("UICorner", top)
    topCorner.CornerRadius = UDim.new(0, 20)
    local topMask = Instance.new("Frame")
    topMask.Size = UDim2.new(1, 0, 0.5, 0)
    topMask.Position = UDim2.new(0, 0, 0.5, 0)
    topMask.BackgroundColor3 = top.BackgroundColor3
    topMask.BorderSizePixel = 0
    topMask.Parent = top
    topMask.ZIndex = 11
    local title = Instance.new("TextLabel")
    title.Text = name
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 12
    title.Parent = top

    local function circle(color, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 14, 0, 14)
        b.Position = UDim2.new(1, x, 0.5, -7)
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.ZIndex = 12
        b.Parent = top
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(1, 0)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 16, 0, 16)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 14, 0, 14)}):Play()
        end)
        return b
    end
    local red = circle(Color3.fromRGB(255, 80, 80), -20)
    local yellow = circle(Color3.fromRGB(255, 200, 80), -42)
    local green = circle(Color3.fromRGB(80, 255, 120), -64)

    do
        local dragging, startPos, startInput
        top.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startInput = i.Position
                startPos = main.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - startInput
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    -- CHANGE: Sidebar is now just a container
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    sidebar.ZIndex = 11

    -- CHANGE: Added ScrollingFrame
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, 0, 1, 0) -- Fills the sidebar
    sidebarScroll.Position = UDim2.new(0, 0, 0, 0)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 4
    sidebarScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50) -- Dark scrollbar
    sidebarScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    sidebarScroll.Parent = sidebar
    sidebarScroll.ZIndex = 12
    
    -- Canvas size will update automatically via UIListLayout
    local sidePad = Instance.new("UIPadding", sidebarScroll)
    sidePad.PaddingTop = UDim.new(0, 18)
    sidePad.PaddingLeft = UDim.new(0, 18)
    sidePad.PaddingRight = UDim.new(0, 18)
    sidePad.PaddingBottom = UDim.new(0, 18)
    local sideList = Instance.new("UIListLayout", sidebarScroll)
    sideList.Padding = UDim.new(0, 12)

    -- Update CanvasSize when new items are added
    sideList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sideList.AbsoluteContentSize.Y + 36) -- +36 for padding
    end)

    local currentTabLabel = Instance.new("TextLabel")
    currentTabLabel.Text = ""
    currentTabLabel.Font = Enum.Font.GothamBold
    currentTabLabel.TextSize = 13
    currentTabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    currentTabLabel.BackgroundTransparency = 1
    currentTabLabel.Size = UDim2.new(0, 200, 0, 30)
    currentTabLabel.Position = UDim2.new(0, 0, 1, -30)
    currentTabLabel.TextXAlignment = Enum.TextXAlignment.Center
    currentTabLabel.ZIndex = 12
    currentTabLabel.Parent = main

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, -220, 1, -80)
    pages.Position = UDim2.new(0, 220, 0, 70)
    pages.BackgroundTransparency = 1
    pages.BorderSizePixel = 0
    pages.Parent = main
    pages.ZIndex = 11
    local pageList = Instance.new("UIListLayout", pages)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder

    -- CHANGE: Profile Box is now inside the ScrollingFrame so it scrolls with tabs
    local profileBox = Instance.new("Frame")
    profileBox.Size = UDim2.new(1, 0, 0, 95)
    profileBox.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    profileBox.BorderSizePixel = 0
    profileBox.Parent = sidebarScroll -- Parented to scroll
    profileBox.ZIndex = 12
    profileBox.LayoutOrder = 999 -- Keep it at the bottom
    local profileCorner = Instance.new("UICorner", profileBox)
    profileCorner.CornerRadius = UDim.new(0, 14)
    local username = Instance.new("TextLabel")
    username.Text = Players.LocalPlayer.Name
    username.Font = Enum.Font.GothamBold
    username.TextSize = 14
    username.TextColor3 = Color3.fromRGB(230, 230, 230)
    username.BackgroundTransparency = 1
    username.Position = UDim2.new(0, 12, 0, 10)
    username.Size = UDim2.new(1, -70, 0, 18)
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.Parent = profileBox
    local userTitle = Instance.new("TextLabel")
    userTitle.Text = "Discord Server"
    userTitle.Font = Enum.Font.Gotham
    userTitle.TextSize = 11
    userTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    userTitle.BackgroundTransparency = 1
    userTitle.Position = UDim2.new(0, 12, 0, 30)
    userTitle.Size = UDim2.new(1, -70, 0, 16)
    userTitle.TextXAlignment = Enum.TextXAlignment.Left
    userTitle.Parent = profileBox
    local pfp = Instance.new("ImageLabel")
    pfp.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    pfp.Size = UDim2.new(0, 40, 0, 40)
    pfp.Position = UDim2.new(0, 12, 1, -48)
    pfp.BackgroundTransparency = 1
    pfp.Parent = profileBox
    local pfpCorner = Instance.new("UICorner", pfp)
    pfpCorner.CornerRadius = UDim.new(1, 0)
    local pfpPlaceholder = Instance.new("Frame")
    pfpPlaceholder.Size = UDim2.new(1, 0, 1, 0)
    pfpPlaceholder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pfpPlaceholder.BorderSizePixel = 0
    pfpPlaceholder.Visible = false
    pfpPlaceholder.Parent = pfp
    local pfpPlaceCorner = Instance.new("UICorner", pfpPlaceholder)
    pfpPlaceCorner.CornerRadius = UDim.new(1, 0)
    local privacyBtn = Instance.new("TextButton")
    privacyBtn.Size = UDim2.new(0, 40, 0, 40)
    privacyBtn.Position = UDim2.new(1, -50, 0, 8)
    privacyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    privacyBtn.BorderSizePixel = 0
    privacyBtn.Text = ""
    privacyBtn.AutoButtonColor = false
    privacyBtn.Parent = profileBox
    local privacyCorner = Instance.new("UICorner", privacyBtn)
    privacyCorner.CornerRadius = UDim.new(0, 12)
    local privacyIcon = Instance.new("ImageLabel")
    privacyIcon.Image = "rbxassetid://6031094678"
    privacyIcon.ImageColor3 = Color3.fromRGB(230, 230, 230)
    privacyIcon.Size = UDim2.new(0, 20, 0, 20)
    privacyIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
    privacyIcon.BackgroundTransparency = 1
    privacyIcon.Parent = privacyBtn
    local isPrivate = false
    local originalName = Players.LocalPlayer.Name
    privacyBtn.MouseEnter:Connect(function()
        TweenService:Create(privacyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
    privacyBtn.MouseLeave:Connect(function()
        local color = isPrivate and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(20, 20, 20)
        TweenService:Create(privacyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = color}):Play()
    end)
    privacyBtn.MouseButton1Click:Connect(function()
        isPrivate = not isPrivate
        if isPrivate then
            pfpPlaceholder.Visible = true
            username.Text = string.rep("#", #originalName)
            privacyIcon.Image = "rbxassetid://6031082533"
            TweenService:Create(privacyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        else
            pfpPlaceholder.Visible = false
            username.Text = originalName
            privacyIcon.Image = "rbxassetid://6031094678"
            TweenService:Create(privacyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)

    local function toggleWindow()
        isOpen = not isOpen
        if isOpen then
            main.Visible = true
            main.Size = UDim2.new(0, 0, 0, 0)
            main.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 700, 0, 540),
                Position = UDim2.new(0.5, -350, 0.5, -270)
            }):Play()
            Solar:Notify(name .. " Opened", 1.5)
        else
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            main.Visible = false
            Solar:Notify(name .. " Closed", 1.5)
        end
    end

    green.MouseButton1Click:Connect(toggleWindow)
    yellow.MouseButton1Click:Connect(toggleWindow)

    red.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        Solar.Blur:Destroy()
        Solar.Folder:Destroy()
    end)

    function Window:Tab(name, icon)
        local Tab = {}
        local page = Instance.new("Frame")
        page.Name = name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Visible = false
        page.Parent = pages
        page.ZIndex = 5
        page.LayoutOrder = #pages:GetChildren() + 1
        local pad = Instance.new("UIPadding", page)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        local list = Instance.new("UIListLayout", page)
        list.Padding = UDim.new(0, 14)

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 46)
        b.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = sidebarScroll -- CHANGE: Parent to scrolling frame
        b.ZIndex = 12
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(0, 14)
        local ic = Instance.new("ImageLabel")
        ic.Image = icon
        ic.Size = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 14, 0.5, -9)
        ic.BackgroundTransparency = 1
        ic.Parent = b
        local label = Instance.new("TextLabel")
        label.Text = name
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 44, 0, 0)
        label.Size = UDim2.new(1, -44, 1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = b
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(14, 14, 14)}):Play()
        end)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            page.Visible = true
            currentTabLabel.Text = name
            Solar:Notify("Switched to " .. name, 1)
        end)

        -- BUTTON
        function Tab:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.AutoButtonColor = false
            btn.Parent = page
            btn.ZIndex = 6
            
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 10)

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                if callback then callback() end
            end)
        end

        -- LABEL
        function Tab:Label(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 25)
            lbl.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            lbl.BorderSizePixel = 0
            lbl.Text = "  " .. text
            lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = page
            lbl.ZIndex = 6
            local lblCorner = Instance.new("UICorner", lbl)
            lblCorner.CornerRadius = UDim.new(0, 8)
        end

        -- INPUT
        function Tab:Input(placeholder, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 40)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local boxCorner = Instance.new("UICorner", box)
            boxCorner.CornerRadius = UDim.new(0, 10)

            local input = Instance.new("TextBox")
            input.Size = UDim2.new(1, -10, 1, 0)
            input.Position = UDim2.new(0, 5, 0, 0)
            input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            input.BorderSizePixel = 0
            input.PlaceholderText = placeholder
            input.Text = ""
            input.TextColor3 = Color3.fromRGB(255, 255, 255)
            input.Font = Enum.Font.Gotham
            input.TextSize = 14
            input.Parent = box
            local inputCorner = Instance.new("UICorner", input)
            inputCorner.CornerRadius = UDim.new(0, 8)

            input.FocusLost:Connect(function(enterPressed)
                if callback then callback(input.Text, enterPressed) end
            end)
        end

        -- KEYBIND (FIXED TYPO waitingForKey)
        function Tab:Keybind(defaultName, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 40)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local boxCorner = Instance.new("UICorner", box)
            boxCorner.CornerRadius = UDim.new(0, 10)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 1, 0)
            btn.Position = UDim2.new(1, -105, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.BorderSizePixel = 0
            btn.Text = defaultName
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.Parent = box
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 8)

            local waitingForKey = false -- FIXED: Typo was waitingByKey

            btn.MouseButton1Click:Connect(function()
                waitingForKey = true
                btn.Text = "... "
            end)

            UIS.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                -- Check both variable names just in case user is used to the old logic, 
                -- but correctly use waitingForKey for assignment.
                if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                    waitingForKey = false
                    btn.Text = input.KeyCode.Name
                    if callback then callback(input.KeyCode) end
                elseif input.KeyCode == Enum.KeyCode[btn.Text] then
                    if callback then callback(input.KeyCode) end
                end
            end)
        end

        function Tab:Toggle(text, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local corner = Instance.new("UICorner", box)
            corner.CornerRadius = UDim.new(0, 14)
            local label = Instance.new("TextLabel")
            label.Text = text
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 15
            label.Position = UDim2.new(0, 16, 0, 0)
            label.Size = UDim2.new(1, -80, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = box
            local toggleBg = Instance.new("TextButton")
            toggleBg.Size = UDim2.new(0, 50, 0, 28)
            toggleBg.Position = UDim2.new(1, -62, 0.5, -14)
            toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleBg.BorderSizePixel = 0
            toggleBg.Text = ""
            toggleBg.AutoButtonColor = false
            toggleBg.ZIndex = 7
            toggleBg.Parent = box
            local toggleCorner = Instance.new("UICorner", toggleBg)
            toggleCorner.CornerRadius = UDim.new(1, 0)
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 24, 0, 24)
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -12)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleBg
            local circleCorner = Instance.new("UICorner", toggleCircle)
            circleCorner.CornerRadius = UDim.new(1, 0)
            local isOn = false
            toggleBg.MouseButton1Click:Connect(function()
                isOn = not isOn
                if isOn then
                    TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 200, 100)}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -26, 0.5, -12)}):Play()
                else
                    TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0.5, -12)}):Play()
                end
                if callback then callback(isOn) end
            end)
        end

        function Tab:Dropdown(text, options, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local corner = Instance.new("UICorner", box)
            corner.CornerRadius = UDim.new(0, 14)
            local label = Instance.new("TextLabel")
            label.Text = text
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 15
            label.Position = UDim2.new(0, 16, 0, 0)
            label.Size = UDim2.new(1, -140, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = box
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 28)
            btn.Position = UDim2.new(1, -112, 0.5, -14)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.BorderSizePixel = 0
            btn.Text = options[1]
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.ZIndex = 10
            btn.Parent = box
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 8)
            local arrow = Instance.new("TextLabel")
            arrow.Text = "v"
            arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.ZIndex = 10
            arrow.Parent = btn
            local listOpen = false
            local optionFrame = Instance.new("Frame")
            optionFrame.Name = "DropdownList"
            optionFrame.Size = UDim2.new(0, 100, 0, 0)
            optionFrame.Position = UDim2.new(1, -112, 1, 2)
            optionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            optionFrame.BorderSizePixel = 0
            optionFrame.ClipsDescendants = true
            optionFrame.ZIndex = 50
            optionFrame.Parent = page
            local optCorner = Instance.new("UICorner", optionFrame)
            optCorner.CornerRadius = UDim.new(0, 8)
            local optLayout = Instance.new("UIListLayout", optionFrame)
            optLayout.Padding = UDim.new(0, 2)
            for i, opt in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Text = opt
                optBtn.Size = UDim2.new(1, 0, 0, 26)
                optBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                optBtn.BorderSizePixel = 0
                optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 13
                optBtn.AutoButtonColor = false
                optBtn.ZIndex = 51
                optBtn.Parent = optionFrame
                local optC = Instance.new("UICorner", optBtn)
                optC.CornerRadius = UDim.new(0, 6)
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end)
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = opt
                    listOpen = false
                    TweenService:Create(optionFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 0)}):Play()
                    task.wait(0.2)
                    optionFrame.Visible = false
                    if callback then callback(opt) end
                end)
            end
            btn.MouseButton1Click:Connect(function()
                listOpen = not listOpen
                if listOpen then
                    optionFrame.Visible = true
                    TweenService:Create(optionFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, #options * 28)}):Play()
                else
                    TweenService:Create(optionFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 0)}):Play()
                    task.wait(0.2)
                    optionFrame.Visible = false
                end
            end)
        end

        function Tab:Slider(text, min, max, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local corner = Instance.new("UICorner", box)
            corner.CornerRadius = UDim.new(0, 14)
            local label = Instance.new("TextLabel")
            label.Text = text .. ": " .. min
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 15
            label.Position = UDim2.new(0, 16, 0, 6)
            label.Size = UDim2.new(1, -32, 0, 22)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = box
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -32, 0, 6)
            sliderBg.Position = UDim2.new(0, 16, 0, 38)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = box
            local bgCorner = Instance.new("UICorner", sliderBg)
            bgCorner.CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBg
            local fillCorner = Instance.new("UICorner", fill)
            fillCorner.CornerRadius = UDim.new(1, 0)
            local circleBtn = Instance.new("TextButton")
            circleBtn.Size = UDim2.new(0, 16, 0, 16)
            circleBtn.Position = UDim2.new(0, -8, 0.5, -8)
            circleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circleBtn.BorderSizePixel = 0
            circleBtn.Text = ""
            circleBtn.ZIndex = 7
            circleBtn.AutoButtonColor = false
            circleBtn.Parent = sliderBg
            local circleCorner = Instance.new("UICorner", circleBtn)
            circleCorner.CornerRadius = UDim.new(1, 0)
            local dragging = false
            circleBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = i.Position.X
                    local sliderStart = sliderBg.AbsolutePosition.X
                    local sliderEnd = sliderBg.AbsolutePosition.X + sliderBg.AbsoluteSize.X
                    local clamped = math.clamp(mousePos - sliderStart, 0, sliderBg.AbsoluteSize.X)
                    local pct = clamped / sliderBg.AbsoluteSize.X
                    TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
                    circleBtn.Position = UDim2.new(0, clamped - 8, 0.5, -8)
                    local val = math.floor(min + (max - min) * pct)
                    label.Text = text .. ": " .. val
                    if callback then callback(val) end
                end
            end)
        end

        function Tab:Expander(text, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            box.ZIndex = 6
            local corner = Instance.new("UICorner", box)
            corner.CornerRadius = UDim.new(0, 14)
            local label = Instance.new("TextLabel")
            label.Text = text
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 15
            label.Position = UDim2.new(0, 16, 0, 0)
            label.Size = UDim2.new(1, -32, 0, 22)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = box
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -32, 0, 6)
            sliderBg.Position = UDim2.new(0, 16, 0, 36)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = box
            local bgCorner = Instance.new("UICorner", sliderBg)
            bgCorner.CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBg
            local fillCorner = Instance.new("UICorner", fill)
            fillCorner.CornerRadius = UDim.new(1, 0)
            local circleBtn = Instance.new("TextButton")
            circleBtn.Size = UDim2.new(0, 20, 0, 20)
            circleBtn.Position = UDim2.new(0, -10, 0.5, -10)
            circleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circleBtn.BorderSizePixel = 0
            circleBtn.Text = ""
            circleBtn.ZIndex = 7
            circleBtn.AutoButtonColor = false
            circleBtn.Parent = sliderBg
            local circleCorner = Instance.new("UICorner", circleBtn)
            circleCorner.CornerRadius = UDim.new(1, 0)
            local isOn = false
            local dragging = false
            local function updateToggle()
                local relativeX = circleBtn.Position.X.Offset
                local sizeX = sliderBg.AbsoluteSize.X
                local centerX = relativeX + 10
                local newState
                if centerX > sizeX / 2 then newState = true else newState = false end
                if newState ~= isOn then
                    isOn = newState
                    if isOn then
                        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
                        TweenService:Create(circleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -10, 0.5, -10)}):Play()
                    else
                        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)}):Play()
                        TweenService:Create(circleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -10, 0.5, -10)}):Play()
                    end
                    if callback then callback(isOn) end
                end
            end
            circleBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateToggle()
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    if dragging then
                        dragging = false
                        updateToggle()
                    end
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = i.Position.X
                    local sliderStart = sliderBg.AbsolutePosition.X
                    local sliderEnd = sliderBg.AbsolutePosition.X + sliderBg.AbsoluteSize.X
                    local clamped = math.clamp(mousePos - sliderStart, 0, sliderBg.AbsoluteSize.X)
                    circleBtn.Position = UDim2.new(0, clamped - 10, 0.5, -10)
                    fill.Size = UDim2.new(0, clamped, 1, 0)
                end
            end)
        end
        return Tab
    end
    return Window
end

return Solar
