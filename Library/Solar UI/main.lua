local Solar = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Solar.Folder = Instance.new("ScreenGui")
Solar.Folder.Name = "SolarUI_Lib"
Solar.Folder.Parent = game:GetService("CoreGui")
Solar.Folder.ResetOnSpawn = false

Solar.Blur = Instance.new("BlurEffect")
Solar.Blur.Size = 0
Solar.Blur.Parent = game:GetService("Lighting")

Solar.NotifyQueue = {}
Solar.IsShowingNotify = false
Solar.NotificationsEnabled = true
Solar.Tabs = {}
Solar.Pages = {}

function Solar:Notify(text, duration)
    if not Solar.NotificationsEnabled then return end

    table.insert(Solar.NotifyQueue, {text = text, duration = duration or 2})
    
    if Solar.IsShowingNotify then return end
    
    local function showNext()
        if #Solar.NotifyQueue == 0 then
            Solar.IsShowingNotify = false
            return
        end
        
        Solar.IsShowingNotify = true
        local data = table.remove(Solar.NotifyQueue, 1)
        
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 0, 0, 0)
        notif.Position = UDim2.new(0.5, 0, 0.1, 0)
        notif.AnchorPoint = Vector2.new(0.5, 0.5)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        notif.BorderSizePixel = 0
        notif.BackgroundTransparency = 1
        notif.Parent = Solar.Folder
        
        local notifCorner = Instance.new("UICorner", notif)
        notifCorner.CornerRadius = UDim.new(0, 16)
        
        local notifStroke = Instance.new("UIStroke", notif)
        notifStroke.Color = Color3.fromRGB(80, 80, 80)
        notifStroke.Thickness = 1
        notifStroke.Transparency = 1
        
        local notifText = Instance.new("TextLabel")
        notifText.Text = data.text
        notifText.Font = Enum.Font.GothamBold
        notifText.TextSize = 15
        notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
        notifText.BackgroundTransparency = 1
        notifText.BorderSizePixel = 0
        notifText.Size = UDim2.new(1, -32, 1, 0)
        notifText.Position = UDim2.new(0, 16, 0, 0)
        notifText.TextXAlignment = Enum.TextXAlignment.Center
        notifText.TextTransparency = 1
        notifText.Parent = notif
        
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 280, 0, 50),
            BackgroundTransparency = 0.1
        }):Play()
        
        TweenService:Create(notifStroke, TweenInfo.new(0.4), {
            Transparency = 0.3
        }):Play()
        
        TweenService:Create(notifText, TweenInfo.new(0.4), {
            TextTransparency = 0
        }):Play()
        
        wait(data.duration)
        
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(notifStroke, TweenInfo.new(0.3), {
            Transparency = 1
        }):Play()
        
        TweenService:Create(notifText, TweenInfo.new(0.3), {
            TextTransparency = 1
        }):Play()
        
        wait(0.4)
        notif:Destroy()
        showNext()
    end
    
    if not Solar.IsShowingNotify then
        showNext()
    end
end

function Solar:Window(name)
    local Window = {}
    local isOpen = true

    local splash = Instance.new("Frame")
    splash.Size = UDim2.new(1, 0, 1, 0)
    splash.BackgroundTransparency = 1
    splash.BorderSizePixel = 0
    splash.Parent = Solar.Folder

    local splashText = Instance.new("TextLabel")
    splashText.Text = name
    splashText.Font = Enum.Font.GothamBold
    splashText.TextSize = 96
    splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
    splashText.BackgroundTransparency = 1
    splashText.BorderSizePixel = 0
    splashText.Size = UDim2.new(1, 0, 1, 0)
    splashText.TextTransparency = 1
    splashText.Parent = splash

    TweenService:Create(Solar.Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 24
    }):Play()

    TweenService:Create(splashText, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    wait(1.8)

    TweenService:Create(splashText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(Solar.Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = 0
    }):Play()

    wait(0.7)
    splash:Destroy()

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 700, 0, 540)
    main.Position = UDim2.new(0.5, -350, 0.5, -270)
    main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    main.BorderSizePixel = 0
    main.BackgroundTransparency = 0
    main.Parent = Solar.Folder
    main.ClipsDescendants = false

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

    local topCorner = Instance.new("UICorner", top)
    topCorner.CornerRadius = UDim.new(0, 20)

    local topMask = Instance.new("Frame")
    topMask.Size = UDim2.new(1, 0, 0.5, 0)
    topMask.Position = UDim2.new(0, 0, 0.5, 0)
    topMask.BackgroundColor3 = top.BackgroundColor3
    topMask.BorderSizePixel = 0
    topMask.Parent = top

    local title = Instance.new("TextLabel")
    title.Text = name
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 0
    title.Size = UDim2.new(0, 100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local function circle(color, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 14, 0, 14)
        b.Position = UDim2.new(1, x, 0.5, -7)
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = top
        
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(1, 0)
        
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 16, 0, 16)
            }):Play()
        end)
        
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 14, 0, 14)
            }):Play()
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
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 200, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sidePad = Instance.new("UIPadding", sidebar)
    sidePad.PaddingTop = UDim.new(0, 18)
    sidePad.PaddingLeft = UDim.new(0, 18)
    sidePad.PaddingRight = UDim.new(0, 18)
    sidePad.PaddingBottom = UDim.new(0, 18)

    local sideList = Instance.new("UIListLayout", sidebar)
    sideList.Padding = UDim.new(0, 12)
    sideList.VerticalAlignment = Enum.VerticalAlignment.Top

    local currentTabLabel = Instance.new("TextLabel")
    currentTabLabel.Text = "Home"
    currentTabLabel.Font = Enum.Font.GothamBold
    currentTabLabel.TextSize = 13
    currentTabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    currentTabLabel.BackgroundTransparency = 1
    currentTabLabel.BorderSizePixel = 0
    currentTabLabel.Size = UDim2.new(0, 200, 0, 30)
    currentTabLabel.Position = UDim2.new(0, 0, 1, -30)
    currentTabLabel.TextXAlignment = Enum.TextXAlignment.Center
    currentTabLabel.Parent = main

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, -220, 1, -80)
    pages.Position = UDim2.new(0, 220, 0, 70)
    pages.BackgroundTransparency = 1
    pages.BorderSizePixel = 0
    pages.Parent = main

    local pageList = Instance.new("UIListLayout", pages)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder

    local function toggleUI()
        isOpen = not isOpen
        if isOpen then
            main.Visible = true
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.35), {
                Transparency = 0.5
            }):Play()
            Solar:Notify(name .. " Opened", 1.5)
        else
            TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.35), {
                Transparency = 1
            }):Play()
            wait(0.36)
            main.Visible = false
            Solar:Notify(name .. " Closed", 1.5)
        end
    end

    green.MouseButton1Click:Connect(toggleUI)
    yellow.MouseButton1Click:Connect(toggleUI)

    red.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.3), {
            Transparency = 1
        }):Play()
        wait(1.32)
        Solar:Notify(name .. " Destroyed", 1.5)
        wait(1.5)
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
        page.LayoutOrder = #Solar.Pages + 1

        local pad = Instance.new("UIPadding", page)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local list = Instance.new("UIListLayout", page)
        list.Padding = UDim.new(0, 14)

        table.insert(Solar.Pages, page)

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 46)
        b.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = sidebar
        
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(0, 14)

        local ic = Instance.new("ImageLabel")
        ic.Image = icon
        ic.Size = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 14, 0.5, -9)
        ic.BackgroundTransparency = 1
        ic.BorderSizePixel = 0
        ic.Parent = b

        local label = Instance.new("TextLabel")
        label.Text = name
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Position = UDim2.new(0, 44, 0, 0)
        label.Size = UDim2.new(1, -44, 1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = b

        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            }):Play()
        end)
        
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            }):Play()
        end)

        b.MouseButton1Click:Connect(function()
            for _, v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then
                    TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, -30, 0, 0)
                    }):Play()
                    wait(0.1)
                    v.Visible = false
                end
            end
            
            page.Visible = true
            page.Position = UDim2.new(0, 30, 0, 0)
            TweenService:Create(page, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            currentTabLabel.Text = name
            
            wait(1)
            Solar:Notify("Switched to " .. name, 1.5)
        end)

        function Tab:Toggle(text, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            
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
                    TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                    }):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(1, -26, 0.5, -12)
                    }):Play()
                else
                    TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    }):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, 2, 0.5, -12)
                    }):Play()
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
            optionFrame.ZIndex = 20
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
                optBtn.ZIndex = 21
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
                    wait(0.2)
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
                    wait(0.2)
                    optionFrame.Visible = false
                end
            end)
        end

        function Tab:Expander(text, callback)
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 0, 58)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
            box.BorderSizePixel = 0
            box.Parent = page
            
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
            circleBtn.ZIndex = 2
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
                if centerX > sizeX / 2 then
                    newState = true
                else
                    newState = false
                end
                
                if newState ~= isOn then
                    isOn = newState
                    if isOn then
                        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 1, 0)
                        }):Play()
                        TweenService:Create(circleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Position = UDim2.new(1, -10, 0.5, -10)
                        }):Play()
                    else
                        TweenService:Create(fill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, 0, 1, 0)
                        }):Play()
                        TweenService:Create(circleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0, -10, 0.5, -10)
                        }):Play()
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

    Window.Main = main
    Window.Sidebar = sidebar
    return Window
end

return Solar
