--// External stuff
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Chat-Translator-55452"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// UI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Sike Hub | Ultimate",
    Folder = "SikeHub",
    Icon = "solar:folder-2-bold-duotone",
    NewElements = true,
    OpenButton = {
        Title = "Open UI",
        Enabled = true,
        Draggable = true,
        Scale = 0.5,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    }
})

--// Player values
local flying = false
local flySpeed = 50
local flyDir = {f=0,b=0,l=0,r=0,u=0,d=0}
local gyro, vel

local noclip = false
local noclipConn

local autoJump = false
local autoJumpConn

local autoSprint = false
local sprintConn

local autoPunch = false
local punchConn

local hitboxOn = false
local hitboxSize = 20
local hitboxConn

local bringAll = false
local bringConn

local espOn = false
local spinbot = false
local spinConn

local ghost = false
local ghostConn

local invis = false
local invisSeat

local antiDie = false
local antiDieConn

--// Helpers
local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

--// Player tab
do
    local tab = Window:Tab({
        Title = "Player",
        Icon = "solar:user-bold",
        Border = true
    })

    local stats = tab:Section({Title = "Stats"})

    stats:Slider({
        Title = "Walk Speed",
        Value = {Min = 16, Max = 200, Default = 16},
        Callback = function(v)
            local h = getHumanoid()
            if h then h.WalkSpeed = v end
        end
    })

    stats:Slider({
        Title = "Jump Power",
        Value = {Min = 50, Max = 300, Default = 50},
        Callback = function(v)
            local h = getHumanoid()
            if h then h.JumpPower = v end
        end
    })

    stats:Toggle({
        Title = "Auto Sprint",
        Callback = function(state)
            autoSprint = state
            if state then
                sprintConn = RunService.RenderStepped:Connect(function()
                    local h = getHumanoid()
                    if h then h.WalkSpeed = 18 end
                end)
            else
                if sprintConn then sprintConn:Disconnect() end
                local h = getHumanoid()
                if h then h.WalkSpeed = 16 end
            end
        end
    })

    local move = tab:Section({Title = "Movement"})

    move:Toggle({
        Title = "Noclip",
        Callback = function(state)
            noclip = state
            if state then
                noclipConn = RunService.Stepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _,v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if noclipConn then noclipConn:Disconnect() end
            end
        end
    })

    move:Toggle({
        Title = "Auto Jump",
        Callback = function(state)
            autoJump = state
            if state then
                autoJumpConn = RunService.RenderStepped:Connect(function()
                    local h = getHumanoid()
                    if h and h:GetState() ~= Enum.HumanoidStateType.Freefall then
                        h:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if autoJumpConn then autoJumpConn:Disconnect() end
            end
        end
    })

    local function startFly()
        local root = getRoot()
        local hum = getHumanoid()
        if not root or not hum then return end

        flying = true
        hum.PlatformStand = true

        gyro = Instance.new("BodyGyro", root)
        gyro.P = 9e4
        gyro.MaxTorque = Vector3.new(9e9,9e9,9e9)

        vel = Instance.new("BodyVelocity", root)
        vel.MaxForce = Vector3.new(9e9,9e9,9e9)

        while flying do
            RunService.RenderStepped:Wait()
            local dir = Vector3.zero
            dir += Camera.CFrame.LookVector * (flyDir.f + flyDir.b)
            dir += Camera.CFrame.RightVector * (flyDir.l + flyDir.r)
            dir += Vector3.new(0,1,0) * (flyDir.u + flyDir.d)

            if dir.Magnitude > 0 then
                vel.Velocity = dir.Unit * flySpeed
            else
                vel.Velocity = Vector3.zero
            end

            gyro.CFrame = Camera.CFrame
        end

        gyro:Destroy()
        vel:Destroy()
        hum.PlatformStand = false
    end

    move:Toggle({
        Title = "Fly",
        Callback = function(state)
            if state then
                startFly()
            else
                flying = false
            end
        end
    })

    move:Slider({
        Title = "Fly Speed",
        Value = {Min = 1, Max = 200, Default = 50},
        Callback = function(v)
            flySpeed = v
        end
    })
end

--// Combat
do
    local tab = Window:Tab({
        Title = "Combat",
        Icon = "solar:sword-bold",
        Border = true
    })

    tab:Toggle({
        Title = "Auto Punch",
        Callback = function(state)
            autoPunch = state
            if state then
                punchConn = RunService.RenderStepped:Connect(function()
                    VirtualUser:Button1Down(Vector2.new(), Camera.CFrame)
                end)
            else
                if punchConn then punchConn:Disconnect() end
            end
        end
    })

    tab:Toggle({
        Title = "Hitbox Expander",
        Callback = function(state)
            hitboxOn = state
            if state then
                hitboxConn = RunService.RenderStepped:Connect(function()
                    for _,p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.Size = Vector3.new(hitboxSize,hitboxSize,hitboxSize)
                                hrp.CanCollide = false
                                hrp.Transparency = 0.7
                            end
                        end
                    end
                end)
            else
                if hitboxConn then hitboxConn:Disconnect() end
            end
        end
    })

    tab:Slider({
        Title = "Hitbox Size",
        Value = {Min = 5, Max = 50, Default = 20},
        Callback = function(v)
            hitboxSize = v
        end
    })
end

--// Fly controls
UserInputService.InputBegan:Connect(function(i,gp)
    if gp or not flying then return end
    if i.KeyCode == Enum.KeyCode.W then flyDir.f = 1 end
    if i.KeyCode == Enum.KeyCode.S then flyDir.b = -1 end
    if i.KeyCode == Enum.KeyCode.A then flyDir.l = -1 end
    if i.KeyCode == Enum.KeyCode.D then flyDir.r = 1 end
    if i.KeyCode == Enum.KeyCode.Space then flyDir.u = 1 end
    if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d = -1 end
end)

UserInputService.InputEnded:Connect(function(i,gp)
    if gp or not flying then return end
    if i.KeyCode == Enum.KeyCode.W then flyDir.f = 0 end
    if i.KeyCode == Enum.KeyCode.S then flyDir.b = 0 end
    if i.KeyCode == Enum.KeyCode.A then flyDir.l = 0 end
    if i.KeyCode == Enum.KeyCode.D then flyDir.r = 0 end
    if i.KeyCode == Enum.KeyCode.Space then flyDir.u = 0 end
    if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d = 0 end
end)
