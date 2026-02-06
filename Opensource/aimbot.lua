-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- settings
local Settings = {
	Enabled = false,
	FOV = 100,
	Rainbow = true,
	ESP = true,
	TeamCheck = true,
	WallCheck = true,
	AimPart = "Head"
}

-- double load check
local SCRIPT_ID = "AImbot_V2"
if _G[SCRIPT_ID] then
	_G[SCRIPT_ID]:Disconnect()
	if _G[SCRIPT_ID .. "_GUI"] then
		_G[SCRIPT_ID .. "_GUI"]:Destroy()
	end
	_G[SCRIPT_ID] = nil
	_G[SCRIPT_ID .. "_GUI"] = nil
	return
end

local function mouseLocked()
	return UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
		or UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition
end

-- gui
local gui = Instance.new("ScreenGui")
gui.Name = "AImbotGui"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")
_G[SCRIPT_ID .. "_GUI"] = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,380)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1
stroke.Color = Color3.new(1,1,1)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "AImbot + ESP V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

-- buttons
local y = 40
local function makeButton(text, state, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,30)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.Text = text .. ": " .. (state and "ON" or "OFF")
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = false
	b.Parent = frame

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)

	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = text .. ": " .. (state and "ON" or "OFF")
		b.BackgroundColor3 = state and Color3.fromRGB(0,100,0) or Color3.fromRGB(50,50,50)
		cb(state)
	end)

	y += 40
end

makeButton("Rainbow", Settings.Rainbow, function(v) Settings.Rainbow = v end)
makeButton("Aimbot", Settings.Enabled, function(v) Settings.Enabled = v end)
makeButton("Team Check", Settings.TeamCheck, function(v) Settings.TeamCheck = v end)
makeButton("Wall Check", Settings.WallCheck, function(v) Settings.WallCheck = v end)
makeButton("ESP Boxes", Settings.ESP, function(v)
	Settings.ESP = v
	if not v then
		for _,p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("BoxESP") then
				p.Character.BoxESP:Destroy()
			end
		end
	end
end)

-- fov slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1,-20,0,20)
fovLabel.Position = UDim2.new(0,10,0,y)
fovLabel.BackgroundTransparency = 1
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Text = "FOV: "..Settings.FOV
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 14
fovLabel.TextColor3 = Color3.fromRGB(200,200,200)
fovLabel.Parent = frame

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(1,-20,0,10)
slider.Position = UDim2.new(0,10,0,y+25)
slider.Text = ""
slider.AutoButtonColor = false
slider.BackgroundColor3 = Color3.fromRGB(100,100,100)
slider.Parent = frame

Instance.new("UICorner", slider).CornerRadius = UDim.new(0,4)

local fill = Instance.new("Frame")
fill.Size = UDim2.new((Settings.FOV-20)/300,0,1,0)
fill.BackgroundColor3 = Color3.new(1,1,1)
fill.Parent = slider

-- fov circle
local circle = Drawing.new("Circle")
circle.Radius = Settings.FOV
circle.Thickness = 2
circle.NumSides = 64
circle.Filled = false
circle.Visible = true
circle.Color = Color3.new(1,1,1)

-- esp
local function addESP(plr)
	if not plr.Character or plr.Character:FindFirstChild("BoxESP") then return end
	local box = Instance.new("BoxHandleAdornment")
	box.Name = "BoxESP"
	box.Adornee = plr.Character
	box.Size = Vector3.new(4,6,2)
	box.AlwaysOnTop = true
	box.Transparency = 0.7
	box.ZIndex = 10
	box.Color3 = Color3.new(1,1,1)
	box.Parent = plr.Character
end

-- wall check
local function canSee(part)
	if not Settings.WallCheck then return true end
	local origin = Camera.CFrame.Position
	local dir = part.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}

	local hit = workspace:Raycast(origin, dir, params)
	return hit and hit.Instance:IsDescendantOf(part.Parent)
end

-- target
local function getTarget()
	local best, dist = nil, Settings.FOV
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Settings.AimPart) then
			if Settings.TeamCheck and p.Team == LocalPlayer.Team then continue end
			if not canSee(p.Character[Settings.AimPart]) then continue end

			local pos, onScreen = Camera:WorldToViewportPoint(p.Character[Settings.AimPart].Position)
			if onScreen then
				local d = (Vector2.new(pos.X,pos.Y) - Camera.ViewportSize/2).Magnitude
				if d < dist then
					dist = d
					best = p.Character[Settings.AimPart]
				end
			end
		end
	end
	return best
end

-- slider logic
slider.MouseButton1Down:Connect(function()
	local move
	move = RunService.RenderStepped:Connect(function()
		local r = math.clamp(
			(Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
			0,1
		)
		fill.Size = UDim2.new(r,0,1,0)
		Settings.FOV = math.floor(r*300)+20
		fovLabel.Text = "FOV: "..Settings.FOV
		circle.Radius = Settings.FOV
	end)

	local endConn
	endConn = UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			move:Disconnect()
			endConn:Disconnect()
		end
	end)
end)

-- players
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(0.5)
		if Settings.ESP then addESP(p) end
	end)
end)

for _,p in pairs(Players:GetPlayers()) do
	p.CharacterAdded:Connect(function()
		task.wait(0.5)
		if Settings.ESP then addESP(p) end
	end)
end

-- loop
_G[SCRIPT_ID] = RunService.RenderStepped:Connect(function()
	circle.Position = Camera.ViewportSize/2

	if Settings.Rainbow then
		local c = Color3.fromHSV(tick()%5/5,1,1)
		stroke.Color = c
		circle.Color = c
		fill.BackgroundColor3 = c
	else
		stroke.Color = Color3.new(1,1,1)
		circle.Color = Color3.new(1,1,1)
		fill.BackgroundColor3 = Color3.new(1,1,1)
	end

	if Settings.ESP then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				addESP(p)
			end
		end
	end

	if Settings.Enabled and mouseLocked() then
		local t = getTarget()
		if t then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
		end
	end
end)
