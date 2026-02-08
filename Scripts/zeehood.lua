--[[
   _____       __           __  ______
  / ___/____  / /___ ______/ / / /  _/
  \__ \/ __ \/ / __ `/ ___/ / / // /  
 ___/ / /_/ / / /_/ / /  / /_/ // /   
/____/\____/_/\__,_/_/   \____/___/   

 Version: 1.1
 Credits : sikewhich

]]

-- Load the Library
local Solar = loadstring(game:HttpGet("https://raw.githubusercontent.com/sikewhich/sikewhich/refs/heads/main/Library/Solar%20UI/main.lua"))()

-- 1. Create a new Window
local Window = Solar:Window("Vantablade Hood V5")

--- GLOBAL CONFIGURATION
getgenv().Aimbot = {
    Status = false,
    Keybind  = 'C',
    Hitpart = 'HumanoidRootPart',
    ['Prediction'] = {
        X = 0.165,
        Y = 0.1,
    },
}

getgenv().Triggerbot = {
    Enabled = false,
    Keybind = 'O'
}

getgenv().Fly = {
    Enabled = false,
    Keybind = 'V',
    Speed = 250
}

getgenv().Noclip = {
    Enabled = false,
    Keybind = 'Z'
}

getgenv().FakeMacro = {
    Enabled = false,
    Keybind = 'U',
    SpeedMultiplier = 20
}

getgenv().LoopKill = {
    Enabled = false,
    Keybind = 'L'
}

getgenv().Tornado = {
    Enabled = false,
    Keybind = 'T'
}

getgenv().ESP = {
    Enabled = false,
    Keybind = 'B',
}

getgenv().Settings = {
    MinimizeKey = Enum.KeyCode.Y,
}

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local TargetPlayer = nil 
local SelectedPlayerForTP = nil

--- TABS SETUP ---

-- 1. Home Tab
local HomeTab = Window:Tab("Home", "rbxassetid://3944680095")
HomeTab:Label("Welcome to Vantablade Hood V5")
HomeTab:Label("Premium Edition")
HomeTab:Label("")
HomeTab:Label("Instructions:")
HomeTab:Label("1. Select a player in the Player tab")
HomeTab:Label("2. Enable exploits in Combat/Visuals tabs")
HomeTab:Label("3. Customize settings in Settings")
HomeTab:Button("Copy Discord", function()
    setclipboard("discord.gg/ERNQpp8NpE")
    Solar:Notify("Copied Discord to clipboard!", 2)
end)

-- 2. Player Tab
local PlayerTab = Window:Tab("Player", "rbxassetid://3944680095")

local PlayerList = {}
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then table.insert(PlayerList, v.DisplayName) end
end
table.insert(PlayerList, "Refresh List")

PlayerTab:Dropdown("Select Target", PlayerList, function(selected)
    if selected == "Refresh List" then
        Solar:Notify("Refreshing Player List...", 1)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.DisplayName == selected then
                SelectedPlayerForTP = p
                TargetPlayer = p
                Solar:Notify("Target set to: " .. selected, 2)
            end
        end
    end
end)

PlayerTab:Button("Teleport to Target", function()
    if SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerForTP.Character.HumanoidRootPart.CFrame
        Solar:Notify("Teleported to Target", 2)
    else
        Solar:Notify("No valid target selected", 2)
    end
end)

PlayerTab:Button("Bring Target to Me", function()
    if SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
        SelectedPlayerForTP.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        Solar:Notify("Target brought to you", 2)
    else
        Solar:Notify("No valid target selected", 2)
    end
end)

-- 3. Combat Tab
local CombatTab = Window:Tab("Combat", "rbxassetid://3944680095")

CombatTab:Toggle("Aimbot", function(state)
    getgenv().Aimbot.Status = state
    if state then
        TargetPlayer = SelectedPlayerForTP
        Solar:Notify("Aimbot Enabled", 2)
    else
        TargetPlayer = nil
        Solar:Notify("Aimbot Disabled", 2)
    end
end)

CombatTab:Toggle("Triggerbot", function(state)
    getgenv().Triggerbot.Enabled = state
    Solar:Notify("Triggerbot: " .. tostring(state), 2)
end)

CombatTab:Toggle("Loop Kill", function(state)
    getgenv().LoopKill.Enabled = state
    if state then getgenv().Tornado.Enabled = false end
    Solar:Notify("Loop Kill: " .. tostring(state), 2)
end)

CombatTab:Toggle("Tornado Mode", function(state)
    getgenv().Tornado.Enabled = state
    if state then getgenv().LoopKill.Enabled = false end
    Solar:Notify("Tornado: " .. tostring(state), 2)
end)

CombatTab:Button("Buy Armor (Auto)", function()
    local function GetArmor()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local shops = Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild("Shop")
            if shops then
                for _, v in pairs(shops:GetChildren()) do
                    if v.Name:find("Armor") and v:FindFirstChild("Head") and v:FindFirstChild("ClickDetector") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Head.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.1)
                        fireclickdetector(v.ClickDetector)
                        return
                    end
                end
            end
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-607, 21, -633)
        end
    end
    GetArmor()
    Solar:Notify("Attempted to buy armor", 2)
end)

-- 4. Visuals Tab
local VisualsTab = Window:Tab("Visuals", "rbxassetid://3944680095")

VisualsTab:Toggle("ESP", function(state)
    getgenv().ESP.Enabled = state
    Solar:Notify("ESP: " .. tostring(state), 2)
end)

VisualsTab:Toggle("Fly", function(state)
    getgenv().Fly.Enabled = state
    Solar:Notify("Fly: " .. tostring(state), 2)
end)

VisualsTab:Slider("Fly Speed", 50, 500, function(value)
    getgenv().Fly.Speed = value
end)

-- 5. Credits Tab
local CreditsTab = Window:Tab("Credits", "rbxassetid://3944679416")
CreditsTab:Label("VANTAHOOD V5 - PREMIER EDITION")
CreditsTab:Label("")
CreditsTab:Label("--- CORE TEAM ---")
CreditsTab:Label("Head Dev: Vantablade")
CreditsTab:Label("UI Design: Vantablade & Community")
CreditsTab:Label("")
CreditsTab:Label("--- SOCIALS ---")
CreditsTab:Label("YouTube: @VantabladeYT")
CreditsTab:Label("Discord: discord.gg/ERNQpp8NpE")
CreditsTab:Label("")
CreditsTab:Label("--- SPECIAL THANKS ---")
CreditsTab:Label("Testers: Vanta Elite Group")
CreditsTab:Label("Legacy Support: Jace Scripts")

-- 6. Settings Tab
local SettingsTab = Window:Tab("Settings", "rbxassetid://3944679416")

SettingsTab:Label("--- MOVEMENT ---")
SettingsTab:Toggle("Noclip", function(state)
    getgenv().Noclip.Enabled = state
end)

SettingsTab:Toggle("Fake Macro", function(state)
    getgenv().FakeMacro.Enabled = state
end)

SettingsTab:Slider("Macro Speed Multiplier", 1, 50, function(value)
    getgenv().FakeMacro.SpeedMultiplier = value
end)

SettingsTab:Label("--- KEYBINDS ---")

local function BindInput(name, keyName, callback)
    local binding = false
    SettingsTab:Input(name .. " [" .. tostring(keyName):upper() .. "]", function(text, entered)
        if entered then
            if text:lower() == "bind" then
                Solar:Notify("Press a key to bind...", 2)
                binding = true
            end
        end
    end)
    
    UIS.InputBegan:Connect(function(input)
        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
            binding = false
            local keyName = input.KeyCode.Name
            Solar:Notify(name .. " bound to " .. keyName:upper(), 2)
            callback(keyName)
        end
    end)
end

BindInput("Aimbot Key", getgenv().Aimbot.Keybind, function(k) getgenv().Aimbot.Keybind = k end)
BindInput("Triggerbot Key", getgenv().Triggerbot.Keybind, function(k) getgenv().Triggerbot.Keybind = k end)
BindInput("ESP Key", getgenv().ESP.Keybind, function(k) getgenv().ESP.Keybind = k end)
BindInput("Fly Key", getgenv().Fly.Keybind, function(k) getgenv().Fly.Keybind = k end)
BindInput("Noclip Key", getgenv().Noclip.Keybind, function(k) getgenv().Noclip.Keybind = k end)
BindInput("Macro Key", getgenv().FakeMacro.Keybind, function(k) getgenv().FakeMacro.Keybind = k end)
BindInput("Loop Kill Key", getgenv().LoopKill.Keybind, function(k) getgenv().LoopKill.Keybind = k end)
BindInput("Tornado Key", getgenv().Tornado.Keybind, function(k) getgenv().Tornado.Keybind = k end)

SettingsTab:Label("--- MISC ---")
SettingsTab:Button("Rejoin Server", function()
    Solar:Notify("Rejoining...", 1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)


--- SCRIPT LOGIC (Render Loops & Features) ---

-- Fly Logic Wrapper
local function ToggleFly()
    getgenv().Fly.Enabled = not getgenv().Fly.Enabled
    Solar:Notify("Fly: " .. tostring(getgenv().Fly.Enabled), 1)
end

-- ESP Logic
local function GetHealthColor(percent)
    if percent > 0.7 then return Color3.fromRGB(0, 255, 127) 
    elseif percent > 0.3 then return Color3.fromRGB(255, 255, 0)
    else return Color3.fromRGB(255, 60, 60) end
end

local function CreateESP(Player)
    local Box, Name = Drawing.new("Square"), Drawing.new("Text")
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if getgenv().ESP.Enabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LocalPlayer then
            local RootPart = Player.Character.HumanoidRootPart
            local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
            local Head = Player.Character:FindFirstChild("Head")
            if not Hum or not Head then return end
            local RootPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if OnScreen then
                local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
                local LegPos = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0))
                local BoxHeight = math.abs(HeadPos.Y - LegPos.Y)
                local BoxWidth = BoxHeight / 1.6
                local Color = GetHealthColor(Hum.Health / Hum.MaxHealth)
                Box.Visible = true Box.Color = Color Box.Size = Vector2.new(BoxWidth, BoxHeight)
                Box.Position = Vector2.new(RootPos.X - BoxWidth / 2, RootPos.Y - BoxHeight / 2)
                Box.Thickness = 1
                Name.Visible = true Name.Text = Player.DisplayName .. "\n" .. math.floor(Hum.Health) .. " HP"
                Name.Size = 15 Name.Center = true Name.Outline = true Name.Color = Color
                Name.Position = Vector2.new(RootPos.X, RootPos.Y - (BoxHeight / 2) - 35)
            else Box.Visible = false Name.Visible = false end
        else
            Box.Visible = false Name.Visible = false
            if not Player.Parent then Box:Remove() Name:Remove() Connection:Disconnect() end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- Input Handling (Keybinds)
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    local key = i.KeyCode
    
    if key == getgenv().Settings.MinimizeKey then
        -- Solar UI usually handles its own toggles, but we keep logic consistent
        Solar:Notify("Toggle UI Key pressed", 1)
    end
    
    local aimKey = tostring(getgenv().Aimbot.Keybind):upper()
    local trigKey = tostring(getgenv().Triggerbot.Keybind):upper()
    local espKey = tostring(getgenv().ESP.Keybind):upper()
    local flyKey = tostring(getgenv().Fly.Keybind):upper()
    local noclipKey = tostring(getgenv().Noclip.Keybind):upper()
    local macroKey = tostring(getgenv().FakeMacro.Keybind):upper()
    local loopKey = tostring(getgenv().LoopKill.Keybind):upper()
    local tornKey = tostring(getgenv().Tornado.Keybind):upper()

    if key == Enum.KeyCode[aimKey] then 
        getgenv().Aimbot.Status = not getgenv().Aimbot.Status
        if getgenv().Aimbot.Status then TargetPlayer = SelectedPlayerForTP else TargetPlayer = nil end
        Solar:Notify("Aimbot: " .. tostring(getgenv().Aimbot.Status), 1)
    elseif key == Enum.KeyCode[trigKey] then 
        getgenv().Triggerbot.Enabled = not getgenv().Triggerbot.Enabled 
        Solar:Notify("Triggerbot: " .. tostring(getgenv().Triggerbot.Enabled), 1)
    elseif key == Enum.KeyCode[espKey] then 
        getgenv().ESP.Enabled = not getgenv().ESP.Enabled 
        Solar:Notify("ESP: " .. tostring(getgenv().ESP.Enabled), 1)
    elseif key == Enum.KeyCode[flyKey] then 
        ToggleFly()
    elseif key == Enum.KeyCode[noclipKey] then 
        getgenv().Noclip.Enabled = not getgenv().Noclip.Enabled 
        Solar:Notify("Noclip: " .. tostring(getgenv().Noclip.Enabled), 1)
    elseif key == Enum.KeyCode[macroKey] then 
        getgenv().FakeMacro.Enabled = not getgenv().FakeMacro.Enabled 
        Solar:Notify("Fake Macro: " .. tostring(getgenv().FakeMacro.Enabled), 1)
    elseif key == Enum.KeyCode[loopKey] then 
        getgenv().LoopKill.Enabled = not getgenv().LoopKill.Enabled 
        if getgenv().LoopKill.Enabled then getgenv().Tornado.Enabled = false end
        Solar:Notify("Loop Kill: " .. tostring(getgenv().LoopKill.Enabled), 1)
    elseif key == Enum.KeyCode[tornKey] then 
        getgenv().Tornado.Enabled = not getgenv().Tornado.Enabled 
        if getgenv().Tornado.Enabled then getgenv().LoopKill.Enabled = false end
        Solar:Notify("Tornado: " .. tostring(getgenv().Tornado.Enabled), 1)
    end
end)

-- Main Render Loops
local tornadoAngle, LastClickTime, ClickDelay = 0, 0, 1 / 25

RunService.Heartbeat:Connect(function()
    if getgenv().Noclip.Enabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if getgenv().LoopKill.Enabled and SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayerForTP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
    end
    if getgenv().Tornado.Enabled and SelectedPlayerForTP and SelectedPlayerForTP.Character and SelectedPlayerForTP.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = SelectedPlayerForTP.Character.HumanoidRootPart
        tornadoAngle = tornadoAngle + 0.1
        local targetPos = targetRoot.Position + Vector3.new(math.cos(tornadoAngle) * 7.5, 0, math.sin(tornadoAngle) * 7.5)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos, targetRoot.Position)
    end
    if getgenv().FakeMacro.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Hum and Hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (Hum.MoveDirection * (getgenv().FakeMacro.SpeedMultiplier / 10))
        end
    end
    -- Fly Logic
    if getgenv().Fly.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BV = Root:FindFirstChild("VantaFlyBV") or Instance.new("BodyVelocity")
        BV.Name = "VantaFlyBV"
        BV.Parent = Root
        BV.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        
        local BG = Root:FindFirstChild("VantaFlyBG") or Instance.new("BodyGyro")
        BG.Name = "VantaFlyBG"
        BG.Parent = Root
        BG.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        
        local Dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
        BV.Velocity = Dir * getgenv().Fly.Speed
        BG.CFrame = Camera.CFrame
    elseif not getgenv().Fly.Enabled and LocalPlayer.Character then
        -- Cleanup fly objects if disabled
        local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local BV = Root:FindFirstChild("VantaFlyBV")
            local BG = Root:FindFirstChild("VantaFlyBG")
            if BV then BV:Destroy() end
            if BG then BG:Destroy() end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if TargetPlayer and getgenv().Aimbot.Status and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(getgenv().Aimbot.Hitpart) then
        local Part = TargetPlayer.Character[getgenv().Aimbot.Hitpart]
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Part.Position + (Part.Velocity * Vector3.new(getgenv().Aimbot.Prediction.X, getgenv().Aimbot.Prediction.Y, getgenv().Aimbot.Prediction.X)))
    end
    
    -- Triggerbot
    if getgenv().Triggerbot.Enabled then
        local MouseRay = Camera:ViewportPointToRay(Mouse.X, Mouse.Y)
        local Result = Workspace:Raycast(MouseRay.Origin, MouseRay.Direction * 1000)
        if Result and Result.Instance then
            local HitPart = Result.Instance
            local HitModel = HitPart:FindFirstAncestorOfClass("Model")
            local HitPlayer = Players:GetPlayerFromCharacter(HitModel)
            
            if HitPlayer and HitPlayer ~= LocalPlayer then
                if tick() - LastClickTime >= ClickDelay then
                    mouse1press()
                    task.wait()
                    mouse1release()
                    LastClickTime = tick()
                end
            end
        end
    end
end)

Solar:Notify("Vantablade Hood V5 Loaded Successfully!", 3)
