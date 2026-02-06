local FOV = 80
local Smoothness = 0.99

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Circle = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(255, 255, 255)
Circle.Thickness = 1
Circle.NumSides = 40
Circle.Radius = FOV
Circle.Filled = false
Circle.Visible = true

local Target

local function SameTeam(p)
	if not LocalPlayer.Team or not p.Team then
		return false
	end
	return p.Team == LocalPlayer.Team
end

RunService.RenderStepped:Connect(function()
	local center = Vector2.new(
		Camera.ViewportSize.X * 0.5,
		Camera.ViewportSize.Y * 0.5
	)

	Circle.Position = center

	local closest
	local distLimit = FOV

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and not SameTeam(p) then
			local c = p.Character
			local hrp = c and c:FindFirstChild("HumanoidRootPart")
			if hrp then
				local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
				if vis then
					local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
					if d < distLimit then
						distLimit = d
						closest = hrp
					end
				end
			end
		end
	end

	Target = closest
	Circle.Color = Target and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)

	if Target then
		Camera.CFrame = Camera.CFrame:Lerp(
			CFrame.new(Camera.CFrame.Position, Target.Position),
			Smoothness
		)
	end
end)
