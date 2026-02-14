--[[
    Parry Hub
    discord.gg/nPJmaJ4UjS
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- stuff
local autoParry = false
local bhopOn = false
local autoPlay = false
local antiAfk = false
local antiLag = false
local speedOn = false
local jumpOn = false
local infJump = false
local noclip = false

local spdVal = 16
local jmpVal = 50
local parryDist = 10

local parryConns = {}
local bhopConn
local playConn
local spdConn
local noclipConn
local jumpConn
local afkConn

-- reapply on respawn
plr.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    if speedOn then hum.WalkSpeed = spdVal end
    if jumpOn then
        hum.JumpPower = jmpVal
        hum.UseJumpPower = true
    end
end)

local Window = Fluent:CreateWindow({
    Title = "Parry Hub",
    SubTitle = "discord.gg/nPJmaJ4UjS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Parry = Window:AddTab({ Title = "Parry", Icon = "shield" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- main tab
Tabs.Main:AddParagraph({
    Title = "Parry Hub",
    Content = "Thanks for using!\nDiscord: discord.gg/nPJmaJ4UjS"
})

Tabs.Main:AddSection("Blade Ball GUIs")

Tabs.Main:AddButton({
    Title = "#1 - Inferno Hub",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/SadlekAski/Scripts/raw/main/Blade%20Ball/Equip%20any%20ability.lua"))()
    end
})

Tabs.Main:AddButton({
    Title = "OP - W-azure Hub",
    Callback = function()
        getgenv().Mode = "AI"
        getgenv().ForceWin = false
        getgenv().AutoUseSkill = true
        getgenv().BaseVelocity = 0
        getgenv().BasePredictVelocity = 3.4
        getgenv().VisualizePath = true
        getgenv().AutoSpamClickDetect = true
        getgenv().CloseRangeAttack = true
        getgenv().AutoGetVelocity = false
        getgenv().AutoClickKeyBind = "X"
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fd07660d92cb26891e9acfab9f0c6ba4.lua"))()
    end
})

Tabs.Main:AddButton({
    Title = "NEW - Bedol Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nqxlOfc/Loaders/main/Blade_Ball.lua"))()
    end
})

Tabs.Main:AddButton({
    Title = "Yon V3 Hub",
    Callback = function()
        local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
        local w = lib.new("Blade Ball", game.Players.LocalPlayer.UserId, "NXT. Member")
        local cat = w:Category("Main", "http://www.roblox.com/asset/?id=8395621517")
        local sub = cat:Button("Combat", "http://www.roblox.com/asset/?id=8395747586")
        local sec = sub:Section("Section", "Left")
        sec:Button({Title = "Circle Parry", ButtonName = "Start", Description = "X to stop"}, function()
            getgenv().visualizer = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/main/RedCircleBlock"))()
        end)
        sec:Button({Title = "AI Parry", ButtonName = "Start", Description = "AI"}, function()
            getgenv().Mode = "AI"
            getgenv().ForceWin = false
            getgenv().AutoUseSkill = true
            getgenv().BaseVelocity = 0
            getgenv().BasePredictVelocity = 3.4
            getgenv().VisualizePath = true
            getgenv().AutoSpamClickDetect = true
            getgenv().CloseRangeAttack = true
            getgenv().AutoGetVelocity = false
            getgenv().AutoClickKeyBind = "X"
            loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fd07660d92cb26891e9acfab9f0c6ba4.lua"))()
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Nova Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Synergy-Networks/products/main/ProjectNova/loader.lua", true))()
    end
})

Tabs.Main:AddButton({
    Title = "Alienware Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/romkich09/Ball/main/Balde"))()
    end
})

Tabs.Main:AddButton({
    Title = "R3TH-PRIV Hub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/R3TH-PRIV/R3THPRIV/main/loader.lua'))()
    end
})

Tabs.Main:AddButton({
    Title = "Lightux Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zeuise0002/SSSWWW222/main/README.md"))()
    end
})

Tabs.Main:AddButton({
    Title = "Red Circle Auto Parry",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UltraStuff/scripts2/main/bladered"))()
    end
})

Tabs.Main:AddButton({
    Title = "LuaF Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UltraStuff/scripts2/main/bladelua"))()
    end
})

-- player tab
Tabs.Player:AddSection("Speed")

local speedTog = Tabs.Player:AddToggle("SpeedToggle", { Title = "Speed", Default = false })
local speedSld = Tabs.Player:AddSlider("SpeedSlider", {
    Title = "Speed Value",
    Default = 16,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Callback = function(v) spdVal = v end
})

speedTog:OnChanged(function()
    speedOn = Options.SpeedToggle.Value
    if speedOn and hum then
        hum.WalkSpeed = spdVal
    elseif hum then
        hum.WalkSpeed = 16
    end
end)

speedSld:OnChanged(function(v)
    spdVal = v
    if speedOn and hum then hum.WalkSpeed = spdVal end
end)

Tabs.Player:AddSection("Jump")

local jumpTog = Tabs.Player:AddToggle("JumpToggle", { Title = "Jump Power", Default = false })
local jumpSld = Tabs.Player:AddSlider("JumpSlider", {
    Title = "Jump Value",
    Default = 50,
    Min = 1,
    Max = 999,
    Rounding = 0,
    Callback = function(v)
        jmpVal = v
        if jumpOn and hum then hum.JumpPower = jmpVal end
    end
})

jumpTog:OnChanged(function()
    jumpOn = Options.JumpToggle.Value
    if hum then
        if jumpOn then
            hum.JumpPower = jmpVal
            hum.UseJumpPower = true
        else
            hum.JumpPower = 50
            hum.UseJumpPower = false
        end
    end
end)

Tabs.Player:AddSection("Infinite Jump")

local infJumpTog = Tabs.Player:AddToggle("InfJumpToggle", { Title = "Infinite Jump", Default = false })

infJumpTog:OnChanged(function()
    infJump = Options.InfJumpToggle.Value
    if infJump then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    elseif jumpConn then
        jumpConn:Disconnect()
        jumpConn = nil
    end
end)

Tabs.Player:AddSection("BHop")

local bhopTog = Tabs.Player:AddToggle("BHopToggle", { Title = "BHop", Default = false })

bhopTog:OnChanged(function()
    bhopOn = Options.BHopToggle.Value
    if bhopOn then
        bhopConn = RunService.Heartbeat:Connect(function()
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    elseif bhopConn then
        bhopConn:Disconnect()
        bhopConn = nil
    end
end)

Tabs.Player:AddSection("Noclip")

local noclipTog = Tabs.Player:AddToggle("NoclipToggle", { Title = "Noclip", Default = false })

noclipTog:OnChanged(function()
    noclip = Options.NoclipToggle.Value
    if noclip then
        noclipConn = RunService.Stepped:Connect(function()
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

-- parry tab
Tabs.Parry:AddSection("Auto Parry")

local parryTog = Tabs.Parry:AddToggle("AutoParryToggle", { Title = "Auto Parry", Default = false })
local parrySld = Tabs.Parry:AddSlider("ParryDistanceSlider", {
    Title = "Parry Distance",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(v) parryDist = v end
})

local function cleanupParry()
    for _, c in pairs(parryConns) do c:Disconnect() end
    table.clear(parryConns)
end

parryTog:OnChanged(function()
    autoParry = Options.AutoParryToggle.Value
    cleanupParry()
    if not autoParry then return end

    local balls = Workspace:WaitForChild("Balls")

    local function watchBall(b)
        if not b:IsA("BasePart") or not b:GetAttribute("realBall") then return end

        local lastPos = b.Position
        local lastTick = tick()

        local conn
        conn = b:GetPropertyChangedSignal("Position"):Connect(function()
            if not autoParry then conn:Disconnect() return end
            if not char:FindFirstChild("Highlight") then return end

            local dt = tick() - lastTick
            if dt <= 0 then return end

            local speed = (b.Position - lastPos).Magnitude / dt
            local dist = (b.Position - root.Position).Magnitude

            if speed > 0 and dist / speed <= parryDist then
                VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
            end

            lastPos = b.Position
            lastTick = tick()
        end)

        table.insert(parryConns, conn)
    end

    for _, ball in ipairs(balls:GetChildren()) do watchBall(ball) end
    table.insert(parryConns, balls.ChildAdded:Connect(watchBall))
end)

Tabs.Parry:AddSection("Auto Play")

local playTog = Tabs.Parry:AddToggle("AutoPlayToggle", { Title = "Auto Play", Default = false })

local function hasTool(c)
    local p = Players:GetPlayerFromCharacter(c)
    if not p then return false end
    if c:FindFirstChildOfClass("Tool") then return true end
    local bp = p:FindFirstChild("Backpack")
    return bp and bp:FindFirstChildOfClass("Tool") ~= nil
end

local rayP = RaycastParams.new()
rayP.FilterType = Enum.RaycastFilterType.Blacklist

local function blocked(dir, dist)
    rayP.FilterDescendantsInstances = { char }
    return Workspace:Raycast(root.Position, dir * dist, rayP)
end

local function getNear()
    local near, nearDist = nil, 90
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (root.Position - r.Position).Magnitude
                if d < nearDist then nearDist = d near = p.Character end
            end
        end
    end
    return near
end

local lastMove, lastStrafe, stuck, strafeBias, panic = 0, 0, 0, 1, 0

local function moveTo(pos)
    local now = os.clock()
    if now - lastMove < 0.22 then return end
    lastMove = now
    hum:MoveTo(pos)
end

playTog:OnChanged(function()
    autoPlay = Options.AutoPlayToggle.Value
    if not autoPlay then
        if playConn then playConn:Disconnect() playConn = nil end
        return
    end

    playConn = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent or hum.Health <= 0 then return end
        local target = getNear()
        if not target then moveTo(root.Position + root.CFrame.LookVector * 5) return end

        local tRoot = target:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end

        local off = tRoot.Position - root.Position
        local dist = off.Magnitude
        if dist < 0.2 then return end

        if dist < 6 then panic += 1 elseif panic > 0 then panic -= 1 end

        local armed = hasTool(char)
        local fwd = armed and off.Unit or -off.Unit

        if root.AssemblyLinearVelocity.Magnitude < 0.7 then
            if stuck == 0 then stuck = os.clock() end
        else
            stuck = 0
        end

        if stuck ~= 0 and os.clock() - stuck > 0.45 then
            local side = root.CFrame.RightVector * (math.random(0,1) == 0 and -1 or 1)
            moveTo(root.Position + side * math.random(4,7))
            return
        end

        if os.clock() - lastStrafe > math.random(40,80) * 0.01 then
            lastStrafe = os.clock()
            strafeBias = math.random() < 0.5 and -1 or 1
        end

        local sideMove = root.CFrame.RightVector * strafeBias * 0.3
        if blocked(fwd, 4) then sideMove = root.CFrame.RightVector * strafeBias end

        local spd = armed and (dist > 12 and 6 or 4) or (panic > 6 and 8 or 5.5)
        local moveDir = fwd + sideMove
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end

        if math.random() < 0.015 then hum:MoveTo(root.Position) return end
        moveTo(root.Position + moveDir * spd)
    end)
end)

-- visual tab
Tabs.Visual:AddSection("Anti Lag")

local lagTog = Tabs.Visual:AddToggle("AntiLagToggle", { Title = "Anti Lag", Default = false })

lagTog:OnChanged(function()
    antiLag = Options.AntiLagToggle.Value
    if not antiLag then return end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v:Destroy()
        end
    end
    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
            v:Destroy()
        end
    end
end)

Tabs.Visual:AddButton({
    Title = "Remove All Textures",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
    end
})

Tabs.Visual:AddButton({
    Title = "Remove All Particles",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v:Destroy()
            end
        end
    end
})

Tabs.Visual:AddButton({
    Title = "Remove Lighting Effects",
    Callback = function()
        for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                v:Destroy()
            end
        end
    end
})

Tabs.Visual:AddSection("Fullbright")

Tabs.Visual:AddButton({
    Title = "Enable Fullbright",
    Callback = function()
        local l = game:GetService("Lighting")
        l.Brightness = 2
        l.ClockTime = 14
        l.FogEnd = 100000
        l.GlobalShadows = false
    end
})

-- misc tab
Tabs.Misc:AddSection("Anti AFK")

local afkTog = Tabs.Misc:AddToggle("AntiAFKToggle", { Title = "Anti AFK", Default = false })

afkTog:OnChanged(function()
    antiAfk = Options.AntiAFKToggle.Value
    if afkConn then afkConn:Disconnect() afkConn = nil end
    if not antiAfk then return end
    afkConn = plr.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

Tabs.Misc:AddSection("Discord")

Tabs.Misc:AddButton({
    Title = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/nPJmaJ4UjS")
        Fluent:Notify({Title = "Discord", Content = "Link copied!", Duration = 5})
    end
})

Tabs.Misc:AddParagraph({Title = "Discord", Content = "discord.gg/nPJmaJ4UjS"})

-- settings tab
Tabs.Settings:AddSection("Keybinds")

Tabs.Settings:AddKeybind("ToggleUI", {Title = "Toggle UI", Mode = "Toggle", Default = "LeftControl"})

Tabs.Settings:AddSection("Reset")

Tabs.Settings:AddButton({
    Title = "Reset All Settings",
    Callback = function()
        if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
        Fluent:Notify({Title = "Reset", Content = "Done", Duration = 5})
    end
})

-- manager stuff
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("ParryHub")
SaveManager:SetFolder("ParryHub/config")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({Title = "Parry Hub", Content = "Loaded - discord.gg/nPJmaJ4UjS", Duration = 8})

SaveManager:LoadAutoloadConfig()
