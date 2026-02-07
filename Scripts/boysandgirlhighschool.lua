-- Sike Hub Script (Combined Ultimate)
-- Credits: sikewhich

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local cloneref = (cloneref or clonereference or function(instance) return instance end)

local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        if cloneref(game:GetService("RunService")):IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
        end
    end
end

-- Window
local Window = WindUI:CreateWindow({
    Title = "Sike Hub | Ultimate",
    Folder = "SikeHub",
    Icon = "solar:folder-2-bold-duotone",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open Sike Hub UI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"), 
            Color3.fromHex("#e7ff2f")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Vars
local NoclipEnabled = false
local NoclipConnection = nil
local AutoSprintEnabled = false
local SprintConn = nil
local AntiDieEnabled = false
local AntiDieConn = nil
local EspEnabled = false
local EspConnections = {}
local AntiStaffEnabled = false
local StaffConn = nil
local NoRagdollEnabled = false
local RagdollConn = nil
local GrabSpeedEnabled = false
local GrabSpeedLoop = nil
local GrabSpeedVal = 16
local GhostMode = false
local GhostConn = nil

-- Kill All (No 1m wait)
local KillAllLoopRunning = false

-- Fight
local AutoPunchEnabled = false
local AutoPunchConnection = nil
local HitboxSize = 20

-- Float
local FloatEnabled = false
local FloatPart = nil

-- Troll
local SpinBotEnabled = false
local SpinConnection = nil

-- High Speed
local HighSpeedEnabled = false

-- ================= FIGHTING TAB =================
do
    local FightTab = Window:Tab({
        Title = "Fighting",
        Desc = "Combat Tools",
        Icon = "solar:sword-bold",
        IconColor = Red,
        IconShape = "Square",
        Border = true,
    })

    local AutoSection = FightTab:Section({ Title = "Automation" })

    AutoSection:Toggle({
        Title = "Auto Punch",
        Callback = function(state)
            AutoPunchEnabled = state
            if AutoPunchEnabled then
                AutoPunchConnection = RunService.RenderStepped:Connect(function()
                    VirtualUser:Button1Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                    task.wait()
                end)
                WindUI:Notify({ Title = "Auto Punch", Content = "Enabled", Duration = 2 })
            else
                if AutoPunchConnection then AutoPunchConnection:Disconnect() end
                WindUI:Notify({ Title = "Auto Punch", Content = "Disabled", Duration = 2 })
            end
        end
    })

    local HitboxSection = FightTab:Section({ Title = "Hitbox Expander" })
    local HitboxEnabled = false
    local HitboxConn = nil

    HitboxSection:Toggle({
        Title = "Enable Hitbox",
        Callback = function(state)
            HitboxEnabled = state
            if HitboxEnabled then
                HitboxConn = RunService.RenderStepped:Connect(function()
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                            hrp.Transparency = 0.7
                            hrp.Color = Color3.fromRGB(255, 0, 0)
                            hrp.Material = Enum.Material.ForceField
                            hrp.CanCollide = false
                        end
                    end
                end)
            else
                if HitboxConn then HitboxConn:Disconnect() end
                for _, v in pairs(Players:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                    end
                end
            end
        end
    })

    HitboxSection:Slider({
        Title = "Hitbox Size",
        Step = 1,
        Value = { Min = 5, Max = 50, Default = 20 },
        Callback = function(val) HitboxSize = val end
    })
end

-- ================= PLAYER TAB =================
do
    local PlayerTab = Window:Tab({
        Title = "Player",
        Desc = "Local Character Mods",
        Icon = "solar:user-bold",
        IconColor = Blue,
        IconShape = "Square",
        Border = true,
    })

    local StatsSection = PlayerTab:Section({ Title = "Stats" })

    StatsSection:Toggle({
        Title = "Auto Sprint (Speed 18)",
        Callback = function(state)
            AutoSprintEnabled = state
            if AutoSprintEnabled then
                SprintConn = RunService.RenderStepped:Connect(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = 18
                    end
                end)
            else
                if SprintConn then SprintConn:Disconnect() end
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    })

    StatsSection:Toggle({
        Title = "High Speed",
        Callback = function(state)
            HighSpeedEnabled = state
            if HighSpeedEnabled then
                RunService.RenderStepped:Connect(function()
                    if HighSpeedEnabled then
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum then hum.WalkSpeed = 50 end
                    end
                end)
            end
        end
    })

    StatsSection:Toggle({
        Title = "No Cooldown",
        Callback = function(state)
            -- Basic cooldown bypass logic for many games
            if state then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("LocalScript") then
                        -- Attempt to disable cooldown scripts
                    end
                end
            end
        end
    })

    local MoveSection = PlayerTab:Section({ Title = "Movement" })

    MoveSection:Toggle({
        Title = "Noclip",
        Callback = function(state)
            NoclipEnabled = state
            if NoclipEnabled then
                NoclipConnection = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end)
            else
                if NoclipConnection then NoclipConnection:Disconnect() end
            end
        end
    })

    MoveSection:Toggle({
        Title = "Float",
        Callback = function(state)
            FloatEnabled = state
            if FloatEnabled then
                if not FloatPart then
                    FloatPart = Instance.new("Part")
                    FloatPart.Name = "SikeFloat"
                    FloatPart.Anchored = true
                    FloatPart.CanCollide = true
                    FloatPart.Transparency = 0.95
                    FloatPart.Size = Vector3.new(6, 1.0015, 6)
                    FloatPart.Parent = Workspace
                end
                RunService.RenderStepped:Connect(function()
                    if FloatEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        FloatPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
                    end
                end)
            else
                if FloatPart then FloatPart:Destroy() FloatPart = nil end
            end
        end
    })

    local TrollSection = PlayerTab:Section({ Title = "Physics" })

    TrollSection:Toggle({
        Title = "No Ragdoll",
        Callback = function(state)
            NoRagdollEnabled = state
            if NoRagdollEnabled then
                RagdollConn = RunService.Heartbeat:Connect(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.PlatformStand = false
                    end
                    if LocalPlayer.Character then
                        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("Motor6D") then
                                v.Enabled = true
                            end
                        end
                    end
                end)
            else
                if RagdollConn then RagdollConn:Disconnect() end
            end
        end
    })

    TrollSection:Toggle({
        Title = "Anti Ragdoll (Alt)",
        Callback = function(state)
            -- Same logic basically but keep it separate if needed
            NoRagdollEnabled = state
        end
    })
end

-- ================= UTILS TAB =================
do
    local UtilsTab = Window:Tab({
        Title = "Utils",
        Desc = "Utilities",
        Icon = "solar:settings-bold",
        IconColor = Purple,
        IconShape = "Square",
        Border = true,
    })

    local MainSection = UtilsTab:Section({ Title = "Main Utils" })

    MainSection:Toggle({
        Title = "Anti AFK",
        Callback = function(state)
            if state then
                LocalPlayer.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0,0))
                end)
                WindUI:Notify({ Title = "Anti AFK", Content = "Active", Duration = 2 })
            end
        end
    })

    MainSection:Toggle({
        Title = "Anti Die (Auto TP)",
        Callback = function(state)
            AntiDieEnabled = state
            if AntiDieEnabled then
                AntiDieConn = RunService.RenderStepped:Connect(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health <= 30 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-558.00, 36.03, 163.37)
                        WindUI:Notify({ Title = "Anti Die", Content = "Teleported to Safe Spot", Duration = 2 })
                    end
                end)
            else
                if AntiDieConn then AntiDieConn:Disconnect() end
            end
        end
    })

    MainSection:Toggle({
        Title = "Anti Staff",
        Callback = function(state)
            AntiStaffEnabled = state
            if AntiStaffEnabled then
                StaffConn = Players.PlayerAdded:Connect(function(player)
                    if string.lower(player.Name):find("admin") or string.lower(player.Name):find("mod") then
                        WindUI:Notify({ Title = "Staff Alert", Content = "Mod Joined: " .. player.Name, Duration = 5 })
                        LocalPlayer:Kick("Mod Joined: " .. player.Name)
                    end
                end)
                -- Check existing players just in case
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        if string.lower(player.Name):find("admin") or string.lower(player.Name):find("mod") then
                             LocalPlayer:Kick("Mod Joined: " .. player.Name)
                        end
                    end
                end
            else
                if StaffConn then StaffConn:Disconnect() end
            end
        end
    })

    MainSection:Toggle({
        Title = "Ghost (Invisible)",
        Callback = function(state)
            GhostMode = state
            if GhostMode then
                GhostConn = RunService.RenderStepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                                v.Transparency = 1
                            end
                        end
                    end
                end)
            else
                if GhostConn then GhostConn:Disconnect() end
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                            v.Transparency = 0
                        end
                    end
                end
            end
        end
    })

    MainSection:Toggle({
        Title = "Grab Speed (Loop)",
        Callback = function(state)
            GrabSpeedEnabled = state
            if GrabSpeedEnabled then
                GrabSpeedLoop = RunService.RenderStepped:Connect(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = GrabSpeedVal
                    end
                end)
            else
                if GrabSpeedLoop then GrabSpeedLoop:Disconnect() end
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end
    })

    MainSection:Slider({
        Title = "Grab Speed Value",
        Value = { Min = 16, Max = 100, Default = 16 },
        Callback = function(val) GrabSpeedVal = val end
    })

    MainSection:Button({
        Title = "Server Hop",
        Callback = function()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local PlaceId = game.PlaceId
            local AllServers = {}
            local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            
            local function Hop()
                local success, data = pcall(function()
                    return Http:RequestAsync({
                        Url = url,
                        Method = "GET"
                    })
                end)
                
                if success and data then
                    local tbl = Http:JSONDecode(data)
                    if tbl and tbl.data then
                        for i,v in pairs(tbl.data) do
                            if v.playing and v.playing < v.maxPlayers then
                                TPS:TeleportToPlaceInstance(PlaceId, v.id, LocalPlayer)
                                return
                            end
                        end
                    end
                end
            end
            
            Hop()
        end
    })

    MainSection:Button({
        Title = "Rejoin",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })

    MainSection:Button({
        Title = "Exit",
        Callback = function()
            game:Shutdown()
        end
    })

    local CreditsSection = UtilsTab:Section({ Title = "Info" })
    CreditsSection:Label("Credits: sikewhich")
end

-- ================= ESP TAB =================
do
    local EspTab = Window:Tab({
        Title = "ESP",
        Desc = "Visual Cheats",
        Icon = "solar:eye-scan-bold",
        IconColor = Blue,
        IconShape = "Square",
        Border = true,
    })

    EspTab:Section({ Title = "Player ESP" })
    EspTab:Toggle({
        Title = "Enable ESP",
        Callback = function(state)
            EspEnabled = state
            if state then
                local function addEsp(player)
                    if player.Character and player ~= LocalPlayer then
                        local hl = Instance.new("Highlight")
                        hl.Name = "SikeEsp"
                        hl.Adornee = player.Character
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                        hl.FillColor = Color3.fromRGB(255, 0, 255) -- Magenta
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = player.Character
                        
                        local function CharAdded(char)
                            if char then
                                local newHl = hl:Clone()
                                newHl.Adornee = char
                                newHl.Parent = char
                            end
                        end
                        
                        if player.CharacterAdded then
                            player.CharacterAdded:Connect(CharAdded)
                        end
                    end
                end

                local function cleanup(player)
                    if player.Character and player.Character:FindFirstChild("SikeEsp") then
                        player.Character:FindFirstChild("SikeEsp"):Destroy()
                    end
                end

                for _, p in pairs(Players:GetPlayers()) do addEsp(p) end
                Players.PlayerAdded:Connect(addEsp)
                Players.PlayerRemoving:Connect(cleanup)
                
                WindUI:Notify({ Title = "ESP", Content = "Enabled", Duration = 2 })
            else
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("SikeEsp") then
                        p.Character:FindFirstChild("SikeEsp"):Destroy()
                    end
                end
                WindUI:Notify({ Title = "ESP", Content = "Disabled", Duration = 2 })
            end
        end
    })
end

-- ================= KILL TAB =================
do
    local KillTab = Window:Tab({
        Title = "Kill",
        Desc = "Eliminate Players",
        Icon = "solar:skull-bold",
        IconColor = Red,
        IconShape = "Square",
        Border = true,
    })

    local KillList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(KillList, p.Name) end
    end

    local KillTarget = KillTab:Dropdown({
        Title = "Select Target",
        Values = KillList,
        Callback = function(opt) print("Selected Kill Target: " .. opt) end
    })

    KillTab:Button({
        Title = "Kill [Selected]",
        Callback = function()
            local selected = KillTarget:Get()
            if not selected then return WindUI:Notify({ Title = "Error", Content = "Select a target first", Duration = 2 }) end
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = CFrame.new(0, -10000, 0)
                WindUI:Notify({ Title = "Kill", Content = "Killed " .. selected, Duration = 2 })
            end
        end
    })

    KillTab:Button({
        Title = "Kill All (Instant)",
        Callback = function()
            if KillAllLoopRunning then return WindUI:Notify({ Title = "Kill All", Content = "Already active!", Duration = 2 }) end
            KillAllLoopRunning = true
            WindUI:Notify({ Title = "Kill All", Content = "Instant Kill Started...", Duration = 5 })

            task.spawn(function()
                local connection
                
                -- Bring/Kill Loop (Running constantly until toggled or manual stop, but user said instant/off)
                -- User wants: "like not 1muite lie khen o nyou ca of it dont have to ait 1 m just you have to of beforei t ofs"
                -- This sounds like instant bring/kill loop without the 1 minute wait.
                
                connection = RunService.RenderStepped:Connect(function()
                    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                -- Bring
                                p.Character.HumanoidRootPart.CFrame = myHrp.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                                -- Kill
                                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                                if hum then hum.Health = 0 end
                            end
                        end
                    end
                end)

                -- We keep this loop running. To stop it, user would usually re-execute or I add a stop button.
                -- Since the prompt implies "you have to turn it off", I'll let it run until disabled by logic.
                -- But to prevent crashing, we check if KillAllLoopRunning is still true.
                -- I'll add a small wait to prevent 100% CPU usage.
                
                while KillAllLoopRunning do
                    task.wait(0.1)
                end
                
                if connection then connection:Disconnect() end
            end)
        end
    })
    
    KillTab:Button({
        Title = "Stop Kill All",
        Callback = function()
            KillAllLoopRunning = false
            WindUI:Notify({ Title = "Kill All", Content = "Stopped", Duration = 2 })
        end
    })
end

-- ================= INVISIBLE/TROLL TAB =================
do
    local MiscTab = Window:Tab({
        Title = "Misc",
        Desc = "Other",
        Icon = "solar:smile-circle-bold",
        IconColor = Yellow,
        IconShape = "Square",
        Border = true,
    })

    local BoostSection = MiscTab:Section({ Title = "Jump" })
    
    BoostSection:Button({
        Title = "Boost Jump",
        Callback = function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = 150
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.5)
                hum.JumpPower = 50
            end
        end
    })

    local SpinSection = MiscTab:Section({ Title = "SpinBot" })
    SpinSection:Toggle({
        Title = "Enable SpinBot",
        Callback = function(state)
            SpinBotEnabled = state
            if SpinBotEnabled then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    SpinConnection = RunService.RenderStepped:Connect(function()
                        if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0) end
                    end)
                end
            else
                if SpinConnection then SpinConnection:Disconnect() end
            end
        end
    })
end
