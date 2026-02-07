--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ //_ /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    Modified: Solar Edition
    Style: Black / Dark Mode
    Features: Solar Icons, iPhone Toggles, Mobile Dragging
]]

local WindUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolarWindUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- --- ICON SYSTEM (Solar) ---
local Icons = {}
local IconThemeTag = "Text" -- Default theme tag for color

function WindUI.AddIcons(packName, iconTable)
    if not Icons[packName] then
        Icons[packName] = {}
    end
    for name, id in pairs(iconTable) do
        Icons[packName][name] = {
            Image = id,
            ImageRectSize = Vector2.new(0, 0),
            ImageRectOffset = Vector2.new(0, 0)
        }
    end
end

-- Add the Solar Icons you requested
WindUI.AddIcons("solar", {
    ["CheckSquareBold"] = "rbxassetid://132438947521974",
    ["CursorSquareBold"] = "rbxassetid://120306472146156",
    ["FileTextBold"] = "rbxassetid://89294979831077",
    ["FolderWithFilesBold"] = "rbxassetid://74631950400584",
    ["HamburgerMenuBold"] = "rbxassetid://134384554225463",
    ["Home2Bold"] = "rbxassetid://92190299966310",
    ["InfoSquareBold"] = "rbxassetid://119096461016615",
    ["PasswordMinimalisticInputBold"] = "rbxassetid://109919668957167",
    ["SolarSquareTransferHorizontalBold"] = "rbxassetid://125444491429160",
})

function WindUI.GetIcon(iconName, packName)
    local pack = Icons[packName] or Icons["lucide"]
    if pack and pack[iconName] then
        return pack[iconName].Image
    end
    return "" -- Fallback
end

-- --- CREATOR UTILS ---
local Creator = {}

function Creator.New(class, props, children)
    local inst = Instance.new(class)
    for prop, val in pairs(props or {}) do
        inst[prop] = val
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

function Creator.NewRoundFrame(cornerRadius, style, props, children)
    -- Simulating rounded frames using UICorner for standard Roblox
    -- If using the actual library's image assets, we would swap images here.
    -- For this standalone script, we use UICorner.
    local frame = Creator.New("Frame", props or {}, children or {})
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = frame
    
    if style == "Squircle" or style == "Square" then
        frame.BackgroundColor3 = props.ImageColor3 or Color3.new(0.1, 0.1, 0.1)
        frame.BackgroundTransparency = props.ImageTransparency or 0
    end
    
    return frame
end

function Creator.Image(iconData, name, radius, ...)
    local iconId = WindUI.GetIcon(iconData, "solar")
    if iconId == "" then iconId = WindUI.GetIcon(iconData, "lucide") end -- Fallback to Lucide if Solar missing

    return Creator.New("ImageLabel", {
        Image = iconId,
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageRectSize = Vector2.new(0,0),
        ImageRectOffset = Vector2.new(0,0)
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, radius or 4) })
    })
end

-- --- THEME (Black/Dark) ---
local Theme = {
    Background = Color3.fromRGB(10, 10, 10),
    Sidebar = Color3.fromRGB(18, 18, 18),
    Element = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(0, 122, 255), -- Blue
    Success = Color3.fromRGB(52, 199, 89), -- Green
    Border = Color3.fromRGB(40, 40, 40),
    ToggleOn = Color3.fromRGB(52, 199, 89),
    ToggleOff = Color3.fromRGB(80, 80, 80)
}

-- --- DRAGGING LOGIC ---
function Creator.Drag(target, dragObject)
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil

    dragObject.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if dragToggle then
                local delta = input.Position - dragStart
                TweenService:Create(target, TweenInfo.new(0.1), {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                }):Play()
            end
        end
    end)
end

-- --- WINDOW ---
function WindUI:Window(config)
    local Window = {
        Tabs = {},
        Elements = {}
    }

    -- Main Frame
    local MainFrame = Creator.New("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 16) }),
        Creator.New("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.5 })
    })

    -- Top Bar (Draggable)
    local TopBar = Creator.New("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 16) }),
        -- Mask to square bottom corners
        Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0.5, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        })
    })
    
    -- Setup Dragging
    Creator.Drag(MainFrame, TopBar)

    -- Title
    local Title = Creator.New("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Solar UI",
        TextColor3 = Theme.Text,
        TextSize = 18,
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    -- Traffic Light Buttons (Red/Yellow/Green)
    local ButtonFrame = Creator.New("Frame", {
        Size = UDim2.new(0, 90, 0, 50),
        Position = UDim2.new(1, -95, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    })
    
    local function makeTrafficLight(color, x, callback)
        local btn = Creator.New("TextButton", {
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(0, x, 0.5, -6),
            BackgroundColor3 = color,
            Text = "",
            AutoButtonColor = false,
            Parent = ButtonFrame
        }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        btn.MouseButton1Click:Connect(callback)
    end

    makeTrafficLight(Color3.fromRGB(255, 59, 48), 10, function() ScreenGui:Destroy() end) -- Close
    makeTrafficLight(Color3.fromRGB(255, 204, 0), 35, function() -- Minimize
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 550, 0, 50)}):Play()
    end)
    makeTrafficLight(Color3.fromRGB(52, 199, 89), 60, function() -- Maximize
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 550, 0, 400)}):Play()
    end)

    -- Layout
    local Layout = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Sidebar
    local Sidebar = Creator.New("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Layout
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 16) }),
        Creator.New("Frame", { -- Mask
            Size = UDim2.new(1, 0, 0.2, 0),
            Position = UDim2.new(0, 0, 0.8, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        })
    })
    
    local SidebarPadding = Creator.New("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = Sidebar
    })
    
    local SidebarList = Creator.New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Sidebar
    })

    -- Content Area
    local Content = Creator.New("ScrollingFrame", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 150, 0, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Border,
        Parent = Layout
    }, {
        Creator.New("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
        Creator.New("UIListLayout", { Padding = UDim.new(0, 8) })
    })

    -- Functions
    function Window:Notify(msg, duration)
        duration = duration or 3
        local notif = Creator.New("Frame", {
            Size = UDim2.new(0, 250, 0, 0),
            Position = UDim2.new(1, 270, 1, -60),
            BackgroundColor3 = Theme.Element,
            Parent = ScreenGui
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = msg,
                TextColor3 = Theme.Text,
                TextSize = 14,
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
            })
        })
        
        -- Slide In
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 1, -60), Size = UDim2.new(0, 250, 0, 40)}):Play()
        
        task.wait(duration)
        -- Slide Out
        TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(1, 270, 1, -60)}):Play()
        task.wait(0.5)
        notif:Destroy()
    end

    function Window:NewTab(tabName, icon)
        local tabBtn = Creator.New("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Text = "",
            Parent = Sidebar
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Creator.New("UIPadding", { PaddingLeft = UDim.new(0, 10) })
        })

        local iconImg = Creator.Image(icon or "HamburgerMenuBold", "icon", 0)
        iconImg.Size = UDim2.new(0, 18, 0, 18)
        iconImg.Position = UDim2.new(0, 0, 0.5, -9)
        iconImg.Parent = tabBtn

        local textLbl = Creator.New("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.SubText,
            TextSize = 14,
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })

        -- Tab Content Page
        local page = Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Parent = Content,
            Visible = false
        }, { Creator.New("UIListLayout", { Padding = UDim.new(0, 8) }) })

        -- Logic
        tabBtn.MouseButton1Click:Connect(function()
            -- Reset other tabs
            for _, t in pairs(Window.Tabs) do
                t.Button.Frame.BackgroundColor3 = Color3.new(1,1,1)
                t.Button.Frame.BackgroundTransparency = 1
                t.Button.TextLabel.TextColor3 = Theme.SubText
                t.Page.Visible = false
            end
            -- Set Active
            tabBtn.BackgroundColor3 = Theme.Accent
            tabBtn.BackgroundTransparency = 0
            textLbl.TextColor3 = Color3.new(1, 1, 1)
            page.Visible = true
        end)

        if #Window.Tabs == 0 then
            -- Select first tab automatically
            tabBtn.BackgroundColor3 = Theme.Accent
            textLbl.TextColor3 = Color3.new(1, 1, 1)
            page.Visible = true
        end

        table.insert(Window.Tabs, { Button = tabBtn, Page = page })
        Window.CurrentPage = page

        local TabAPI = {}

        function TabAPI:Toggle(name, default, callback)
            local container = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Element,
                Parent = page
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Creator.New("UIStroke", { Color = Theme.Border, Transparency = 0.5, Thickness = 1 })
            })

            local label = Creator.New("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 15,
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })

            -- iPhone Toggle
            local toggleBtn = Creator.New("TextButton", {
                Size = UDim2.new(0, 40, 0, 22),
                Position = UDim2.new(1, -50, 0.5, -11),
                BackgroundColor3 = Theme.ToggleOff,
                Text = "",
                AutoButtonColor = false,
                Parent = container
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            local toggleCircle = Creator.New("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0.5, -9),
                AnchorPoint = Vector2.new(0, 0.5),
               .BackgroundColor3 = Color3.new(1,1,1),
                Parent = toggleBtn
            }, { Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

            local state = default or false
            
            local function update()
                if state then
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOn}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 20, 0.5, -9)}):Play()
                else
                    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOff}):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
                end
                callback(state)
            end

            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                update()
            end)

            if state then update() end
        end

        function TabAPI:Button(name, callback)
            local btn = Creator.New("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Accent,
                Text = name,
                TextColor3 = Color3.new(1,1,1),
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
                TextSize = 15,
                Parent = page
            }, { Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }) })

            btn.MouseButton1Click:Connect(callback)
        end

        return TabAPI
    end

    return Window
end

return WindUI
