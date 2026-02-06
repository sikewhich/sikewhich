-- sorry if Local Tab does not work, idk how to fix

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- windui setup, i think this works everywhere
local cloneref = cloneref or clonereference or function(i) return i end
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

if not WindUI then
    LocalPlayer:Kick("windui failed to load, or your executor")
    return
end

-- make the window
local Window = WindUI:CreateWindow({
    Title = "11ms Hub",
    Folder = "11msConfig",
    Icon = "solar:shield-keyhole-bold-duotone",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open Hub",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

-- colors
local Red = Color3.fromHex("#EF4F1D")
local Green = Color3.fromHex("#10C550")
local Blue = Color3.fromHex("#257AF7")
local Purple = Color3.fromHex("#7775F2")

local env = getgenv() or _G

env.ESP_ENABLED = false
env.GunEsp = false
env.AGG = false
env.NoclipPlr = false
env.InfiniteJump = false
env.Noclip = false
env.KeepWalkspeed = false
env.KeepJumppower = false
env.Walkspeed = 16
env.Jumppower = 50
env.timeout = 2.5
env.enableGodmode = false

local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
local Root = Hum and Hum.RootPart or Char:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function()
    repeat wait()
        Char = LocalPlayer.Character
        Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
        Root = Hum and Hum.RootPart or Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
    until Char and Hum and Root
end)

-- mm2 functions
local function getRoles()
    local success, data = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if not success or not data then return {} end
    
    local roles = {}
    for plr, plrData in pairs(data) do
         if not plrData.Dead then
            roles[plr] = plrData.Role
        end
    end
    return roles
end

-- fling script (works best if u have high ping)
local function SHubFling(TargetPlayer)
    if not (Char and Hum and Root) then return end
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    
    env.OldPos = Root.CFrame
    
    -- camera stuff
    Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
    repeat task.wait() until Workspace.CurrentCamera.CameraSubject == THead or Handle or THumanoid

    local function FPos(BasePart, Pos, Ang)
        local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
        Root.CFrame = targetCF
        Char:SetPrimaryPartCFrame(targetCF)
        Root.Velocity = Vector3.new(9e7, 9e8, 9e7)
        Root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local function SFBasePart(BasePart)
        local start = tick()
        local angle = 0
        repeat
            if Root and THumanoid then
                angle = angle + 100
                for _, offset in ipairs{CFrame.new(0, 1.5, 0),CFrame.new(0, -1.5, 0),CFrame.new(2.25, 1.5, -2.25),CFrame.new(-2.25, -1.5, 2.25)} do
                    FPos(BasePart, offset + THumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
                    wait() -- using normal wait here for stability
                end
            end
        until BasePart.Velocity.Magnitude > 500 or tick() - start > env.timeout
    end

    local BV = Instance.new("BodyVelocity")
    BV.Name = "SeYyyVel!?"
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = Root
    Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local target = TRootPart or THead or Handle
    if target then SFBasePart(target) end
    
    BV:Destroy()
    Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    -- reset cam
    repeat task.wait()
        Workspace.CurrentCamera.CameraSubject = Hum
    until Workspace.CurrentCamera.CameraSubject == Hum
    
    -- go back
    repeat
        local cf = env.OldPos * CFrame.new(0, .5, 0)
        Root.CFrame = cf
        Char:SetPrimaryPartCFrame(cf)
        Hum:ChangeState("GettingUp")
        for _, part in ipairs(Char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
            end
        end
        wait()
    until (Root.Position - env.OldPos.p).Magnitude < 25
end

-- HOME TAB
do
    local HomeTab = Window:Tab({
        Title = "Home",
        Icon = "solar:home-2-bold",
        IconColor = Purple,
        IconShape = "Square",
        Border = true,
    })
    
    HomeTab:Section({ Title = "Info" })
    HomeTab:Paragraph({ Title = "Info", Desc = "Made for MM2 but works in other games too." })
end

-- MM2 TAB
do
    local MM2Tab = Window:Tab({
        Title = "MM2 Tools",
        Icon = "solar:danger-bold",
        IconColor = Red,
        IconShape = "Square",
        Border = true,
    })

    -- ESP STUFF
    MM2Tab:Section({ Title = "Visuals" })
    
    local roleColors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 0, 255),
        Hero = Color3.fromRGB(255, 255, 0),
        Innocent = Color3.fromRGB(0, 255, 0),
        Default = Color3.fromRGB(200, 200, 200)
    }

    local espLoop
    local function clearESP()
        if espLoop then espLoop:Disconnect() end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("RoleESP")
                    if esp then esp:Destroy() end
                end
                local hl = player.Character:FindFirstChild("RoleHighlight")
                if hl then hl:Destroy() end
            end
        end
    end

    local function updateESP()
        local roles = getRoles()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local role = roles[player.Name] or "Default"
                    
                    -- Highlight
                    local hl = player.Character:FindFirstChild("RoleHighlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "RoleHighlight"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.FillTransparency = 0.4
                        hl.OutlineTransparency = 0
                        hl.Parent = player.Character
                    end
                    hl.FillColor = roleColors[role] or roleColors.Default
                    
                    -- Billboard
                    local esp = head:FindFirstChild("RoleESP")
                    if not esp then
                        esp = Instance.new("BillboardGui")
                        esp.Name = "RoleESP"
                        esp.Size = UDim2.new(5, 0, 5, 0)
                        esp.AlwaysOnTop = true
                        esp.Parent = head
                        
                        local label = Instance.new("TextLabel")
                        label.Name = "RoleLabel"
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextStrokeTransparency = 0
                        label.TextSize = 14
                        label.Font = Enum.Font.FredokaOne
                        label.Parent = esp
                    end
                    
                    local label = esp:FindFirstChild("RoleLabel")
                    label.Text = string.format("Role: %s • Name: %s", role, player.Name)
                    label.TextColor3 = roleColors[role] or roleColors.Default
                end
            end
        end
    end

    MM2Tab:Toggle({
        Title = "Esp Player (Role&Name)",
        Callback = function(v)
            env.ESP_ENABLED = v
            if v then
                espLoop = RunService.RenderStepped:Connect(function()
                    if env.ESP_ENABLED then updateESP() end
                end)
            else
                clearESP()
            end
        end
    })

    -- GUN ESP
    local gunEspLoop
    MM2Tab:Toggle({
        Title = "Esp Gun",
        Callback = function(v)
            env.GunEsp = v
            if gunEspLoop then gunEspLoop:Disconnect() end
            for _, gun in ipairs(workspace:GetDescendants()) do
                if gun.Name == "GunDrop" then
                    if gun:FindFirstChild("GunHighlight") then gun.GunHighlight:Destroy() end
                    if gun:FindFirstChild("GunEsp") then gun.GunEsp:Destroy() end
                end
            end
            
            if not v then return end

            gunEspLoop = RunService.RenderStepped:Connect(function()
                if not env.GunEsp then return end
                local gun = workspace:FindFirstChild("GunDrop", true)
                if gun then
                    if not gun:FindFirstChild("GunHighlight") then
                        local gunh = Instance.new("Highlight", gun)
                        gunh.Name = "GunHighlight"
                        gunh.FillColor = Color3.new(1, 1, 0)
                        gunh.OutlineColor = Color3.new(1, 1, 1)
                        gunh.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        gunh.FillTransparency = 0.4
                        gunh.OutlineTransparency = 0.5
                    end
                    if not gun:FindFirstChild("GunEsp") then
                        local esp = Instance.new("BillboardGui", gun)
                        esp.Name = "GunEsp"
                        esp.Size = UDim2.new(5, 0, 5, 0)
                        esp.AlwaysOnTop = true
                        local text = Instance.new("TextLabel", esp)
                        text.Name = "GunLabel"
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextStrokeTransparency = 0
                        text.TextColor3 = Color3.fromRGB(255, 255, 0)
                        text.Font = Enum.Font.FredokaOne
                        text.TextSize = 16
                        text.Text = "Gun Drop"
                    end
                end
            end)
        end
    })

    -- GUN TOOLS
    MM2Tab:Section({ Title = "Gun Tools" })

    MM2Tab:Button({
        Title = "Grab Gun",
        Callback = function()
            if Char and Root then
                local gun = Workspace:FindFirstChild("GunDrop",true)
                if gun then
                    if firetouchinterest then
                        firetouchinterest(Root, gun, 0)
                        firetouchinterest(Root, gun, 1)
                    else
                        gun.CFrame = Root.CFrame
                    end
                end
            end
        end
    })

    MM2Tab:Toggle({
        Title = "Auto Grab Gun",
        Callback = function(v)
            env.AGG = v
        end
    })

    spawn(function() -- changed from task.spawn to spawn, classic move
        while wait(0.1) do
            if env.AGG and Char and Root then
                local gun = Workspace:FindFirstChild("GunDrop",true)
                if gun then
                    if firetouchinterest then
                        firetouchinterest(Root, gun, 0)
                        firetouchinterest(Root, gun, 1)
                    else
                        gun.CFrame = Root.CFrame
                    end
                end
            end
        end
    end)

    MM2Tab:Button({
        Title = "Steal Gun",
        Callback = function()
            if Char and Hum and LocalPlayer:FindFirstChild("Backpack") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then
                        if p.Character and p.Character:FindFirstChild("Gun") then
                            p.Character:FindFirstChild("Gun").Parent = Char
                            Hum:EquipTool(Char:FindFirstChild("Gun"))
                            Hum:UnequipTools()
                        elseif p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun") then
                            p.Backpack:FindFirstChild("Gun").Parent = LocalPlayer.Backpack
                            Hum:EquipTool(LocalPlayer.Backpack:FindFirstChild("Gun"))
                            Hum:UnequipTools()
                        end
                    end
                end
            end
        end
    })

    -- AIMBOT
    local AimbotConnection
    local function getMurdererTarget()
        local data = getRoles()
        for plr, plrData in pairs(data) do
            if plrData.Role == "Murderer" then
                local player = Players:FindFirstChild(plr)
                if player then
                    if player == LocalPlayer then return nil, true end
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then return hrp.Position, false end
                        local head = char:FindFirstChild("Head")
                        if head then return head.Position, false end
                    end
                end
            end
        end
        return nil, false
    end

    MM2Tab:Toggle({
        Title = "Gun Aimbot (Needs Hook)",
        Callback = function(v)
            if v then
                if not checkcaller or not getnamecallmethod then
                    if WindUI then WindUI:Notify({ Title = "Error", Content = "ur executor bad", Duration = 3 }) end
                    return
                end
                
                AimbotConnection = RunService.Heartbeat:Connect(function()
                    if Char and Char:FindFirstChild("Gun") then
                        local gun = Char.Gun
                        local knifeScript = gun:FindFirstChild("KnifeLocal")
                        local cb = knifeScript and knifeScript:FindFirstChild("CreateBeam")
                        local remote = cb and cb:FindFirstChild("RemoteFunction")
                        
                        if remote then
                            local targetPos, isSelf = getMurdererTarget()
                            if targetPos and not isSelf then
                                remote:InvokeServer(1, targetPos, "AH2")
                            end
                        end
                    end
                end)
            else
                if AimbotConnection then
                    AimbotConnection:Disconnect()
                    AimbotConnection = nil
                end
            end
        end
    })

    -- FLING SECTION
    MM2Tab:Section({ Title = "Fling Stuff" })

    MM2Tab:Button({
        Title = "Fling Murderer",
        Callback = function()
            local Murderer = nil
            for plr, role in getRoles() do
                if role == "Murderer" then
                    Murderer = Players:FindFirstChild(plr)
                    break
                end
            end
            if Murderer and Murderer ~= LocalPlayer then
                SHubFling(Murderer)
            else
                if WindUI then WindUI:Notify({Title="Error", Content="Cant find murderer"}) end
            end
        end
    })

    MM2Tab:Button({
        Title = "Fling Sheriff/Hero",
        Callback = function()
            local Target = nil
            for plr, role in getRoles() do
                if role == "Sheriff" or role == "Hero" then
                    Target = Players:FindFirstChild(plr)
                    break
                end
            end
            if Target and Target ~= LocalPlayer then
                SHubFling(Target)
            else
                if WindUI then WindUI:Notify({Title="Error", Content="Cant find sheriff"}) end
            end
        end
    })

    -- DROPDOWN FOR FLING
    local TargetPlayerName = nil
    local function getPlayerNames()
        local name = {}
        for _, player in ipairs(Players:GetPlayers()) do
             if player ~= LocalPlayer then
                table.insert(name, player.Name)
          end
        end
        return name
    end

    MM2Tab:Dropdown({
        Title = "Select Player",
        Values = getPlayerNames(),
        Callback = function(Value)
            TargetPlayerName = Value
        end
    })

    MM2Tab:Button({
        Title = "Fling Selected",
        Callback = function()
            if TargetPlayerName then
                local get = Players:FindFirstChild(TargetPlayerName)
                if get and get ~= LocalPlayer then
                    SHubFling(get)
                end
            end
        end
    })
    
    -- GODMODE
    local GodModeConn
    MM2Tab:Toggle({
        Title = "Godmode",
        Callback = function(v)
            env.enableGodmode = v
            if GodModeConn then GodModeConn:Disconnect() end
            if v and Hum then
                GodModeConn = Hum.HealthChanged:Connect(function()
                    if env.enableGodmode and Hum.Health < Hum.MaxHealth then
                        Hum.Health = Hum.MaxHealth
                    end
                end)
            end
        end
    })

    -- ANTIFLING
    local AntiFlingConn
    MM2Tab:Toggle({
        Title = "Noclip Players (AntiFling)",
        Callback = function(v)
            env.NoclipPlr = v
            if AntiFlingConn then AntiFlingConn:Disconnect() end
            
            if v then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
                
                AntiFlingConn = RunService.RenderStepped:Connect(function()
                    if not env.NoclipPlr then return end
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, part in pairs(player.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end)
            else
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        end
    })

    MM2Tab:Slider({
        Title = "Fling Timeout",
        Value = { Min = 0.5, Max = 10, Default = 2.5 },
        Callback = function(val)
            env.timeout = val
        end
    })
end

-- LOCAL TAB
do
    local LocalTab = Window:Tab({
        Title = "Local Player",
        Icon = "solar:user-bold",
        IconColor = Green,
        IconShape = "Square",
        Border = true,
    })

    LocalTab:Toggle({
        Title = "Infinity Jump",
        Callback = function(v)
            env.InfiniteJump = v
        end
    })
    
    spawn(function()
        while wait(0.1) do
            if env.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                if Char and Hum then
                    Hum:ChangeState("Jumping")
                end
            end
        end
    end)

    LocalTab:Toggle({
        Title = "Noclip",
        Callback = function(v)
            env.Noclip = v
        end
    })
    
    spawn(function()
        while wait() do
            if env.Noclip and Char and Char.Parent then
                for _, part in pairs(Char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    -- SPEED
    LocalTab:Slider({
        Title = "WalkSpeed",
        Value = { Min = 16, Max = 350, Default = 16 },
        Callback = function(v)
            if Hum then Hum.WalkSpeed = v end
            env.Walkspeed = v
        end
    })
    
    LocalTab:Toggle({
        Title = "Auto WalkSpeed",
        Callback = function(v)
            env.KeepWalkspeed = v
        end
    })

    -- JUMP
    LocalTab:Slider({
        Title = "JumpPower",
        Value = { Min = 50, Max = 500, Default = 50 },
        Callback = function(v)
            if Hum then Hum.JumpPower = v end
            env.Jumppower = v
        end
    })

    LocalTab:Toggle({
        Title = "Auto JumpPower",
        Callback = function(v)
            env.KeepJumppower = v
        end
    })

    spawn(function()
        while wait(0.1) do
            if env.KeepWalkspeed and Hum and Hum.WalkSpeed ~= env.Walkspeed then
                Hum.WalkSpeed = env.Walkspeed
            end
            if env.KeepJumppower and Hum and Hum.JumpPower ~= env.Jumppower then
                Hum.JumpPower = env.Jumppower
            end
        end
    end)
    
    -- TOUCH FLING
    LocalTab:Toggle({
        Title = "Touch Fling",
        Callback = function(v)
            env.isTouchfling = v
        end
    })
    
    spawn(function()
        while wait() do
            if env.isTouchfling and Root then
                local vel = Root.Velocity
                Root.Velocity = vel * 9e8 + Vector3.new(0, 9e8, 0)
                RunService.RenderStepped:Wait()
                if Char and Char.Parent and Root and Root.Parent then
                    Root.Velocity = vel
                end
                RunService.Stepped:Wait()
                if Char and Char.Parent and Root and Root.Parent then
                    Root.Velocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
        end
    end)
end

-- SETTINGS TAB
do
    local SettingsTab = Window:Tab({
        Title = "Settings",
        Icon = "solar:settings-bold",
        IconColor = Blue,
        IconShape = "Square",
        Border = true,
    })

    SettingsTab:Button({
        Title = "Destroy UI",
        Color = Color3.fromHex("#ff4830"),
        Callback = function()
            Window:Destroy()
        end
    })
end

if WindUI then
    WindUI:Notify({ Title = "11ms Hub", Content = "loaded!", Duration = 3 })
end
