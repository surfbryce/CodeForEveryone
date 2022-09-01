-- Wait for our game to load
if game:IsLoaded() == false then
	game.Loaded:Wait()
end

-- Services
local Workspace = game:GetService("Workspace")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")

-- Player Constants
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Workspace Constants
local ScreenPart: Part = nil
local SurfaceGUI: SurfaceGui = nil

do
	-- Create our part
	ScreenPart = Instance.new("Part")

	ScreenPart.Name = "SurfacePart"

	ScreenPart.Anchored = true
	ScreenPart.CanCollide = false
	ScreenPart.CanQuery = false
	ScreenPart.CanTouch = false

	ScreenPart.Transparency = 1

	ScreenPart.Parent = Camera

	-- Now create our ScreenGui
	SurfaceGUI = Instance.new("SurfaceGui")

	SurfaceGUI.Face = Enum.NormalId.Back
	SurfaceGUI.Adornee = ScreenPart

	SurfaceGUI.Parent = Player.PlayerGui
end

-- Screen Methods
local function GetScreenInWorldSpace(depth: number): (vector, CFrame, Vector2)
	-- Gather components related to the Camera
	local fov = math.rad(Camera.FieldOfView)

	local viewportSize = Camera.ViewportSize
	local viewportAspectRatio = (viewportSize.X / viewportSize.Y)

	local ya = (2 * math.tan(fov / 2))
	local xa = (ya * viewportAspectRatio)

	return Vector3.new(
		(xa * depth),
		(ya * depth),
		depth
	), (Camera.CFrame * CFrame.new(0, 0, -(depth + 0.5))), viewportSize
end

-- Runner
Run.RenderStepped:Connect(function()
	-- Calculate our WorldScreenSize, WorldScreenCFrame, and the Virtual-Screen size of our ScreenGUI
	local worldScreenSize, worldScreenCFrame, virtualScreenSize = GetScreenInWorldSpace(1)

	-- Now update our ScreenPart
	ScreenPart.Size, ScreenPart.CFrame = worldScreenSize, worldScreenCFrame
	
	-- Then update the SurfaceGUI while accounting for the non-existance of the top-bar
	SurfaceGUI.CanvasSize = Vector2.new(
		virtualScreenSize.X,
		(virtualScreenSize.Y - 36)
	)
end)
