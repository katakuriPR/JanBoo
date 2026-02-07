-- TODO EN UNO (LocalScript): Fly + TP + ESP
-- Fly: WASD + Space (subir) + Ctrl (bajar)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local speed = 70

-- ================= UI =================
local gui = Instance.new("ScreenGui")
gui.Name = "AllInOnePanel"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(360, 320)
main.Position = UDim2.new(0, 18, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 42)
top.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", top)
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -24, 1, 0)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Text = "Panel • Fly + TP + ESP (Local Only)"

-- Drag (opcional pero cómodo)
do
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

local body = Instance.new("Frame", main)
body.BackgroundTransparency = 1
body.Position = UDim2.fromOffset(12, 54)
body.Size = UDim2.new(1, -24, 1, -66)

local function button(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 38)
	b.Position = UDim2.new(0, 0, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	b.BorderSizePixel = 0
	b.TextColor3 = Color3.fromRGB(245,245,245)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 14
	b.Text = text
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	return b
end

local flyBtn = button("✈ Fly: OFF", 0); flyBtn.Parent = body
local espBtn = button("👁 ESP: OFF", 46); espBtn.Parent = body

local tpLabel = Instance.new("TextLabel", body)
tpLabel.BackgroundTransparency = 1
tpLabel.Position = UDim2.new(0, 0, 0, 98)
tpLabel.Size = UDim2.new(1, 0, 0, 18)
tpLabel.Font = Enum.Font.Gotham
tpLabel.TextSize = 12
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
tpLabel.TextColor3 = Color3.fromRGB(200,200,200)
tpLabel.Text = "Teleport: selecciona un jugador"

local listFrame = Instance.new("Frame", body)
listFrame.Position = UDim2.new(0, 0, 0, 120)
listFrame.Size = UDim2.new(1, 0, 0, 110)
listFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
listFrame.BorderSizePixel = 0
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 10)

local scrolling = Instance.new("ScrollingFrame", listFrame)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.Position = UDim2.fromOffset(6, 6)
scrolling.Size = UDim2.new(1, -12, 1, -12)
scrolling.ScrollBarThickness = 6
scrolling.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", scrolling)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local tpBtn = button("📍 TP al seleccionado", 238); tpBtn.Parent = body
local refreshBtn = button("🔄 Refrescar lista", 282); refreshBtn.Parent = body

local selectedName = nil
local function updateCanvas()
	task.wait()
	scrolling.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 6)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function row(name)
	local r = Instance.new("TextButton")
	r.Size = UDim2.new(1, 0, 0, 28)
	r.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	r.BorderSizePixel = 0
	r.TextColor3 = Color3.fromRGB(245,245,245)
	r.Font = Enum.Font.Gotham
	r.TextSize = 13
	r.TextXAlignment = Enum.TextXAlignment.Left
	r.Text = "   " .. name
	Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
	r.MouseButton1Click:Connect(function()
		selectedName = name
		for _, child in ipairs(scrolling:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(36,36,44)
			end
		end
		r.BackgroundColor3 = Color3.fromRGB(60, 60, 78)
	end)
	return r
end

local function refreshList()
	selectedName = nil
	for _, c in ipairs(scrolling:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp then
			row(plr.Name).Parent = scrolling
		end
	end
	updateCanvas()
end

-- ================= FLY =================
local flyOn = false
local bv, bg, flyConn
local keys = {W=false,A=false,S=false,D=false,Up=false,Down=false}

local function startFly()
	local ch = lp.Character or lp.CharacterAdded:Wait()
	local hum = ch:WaitForChild("Humanoid")
	local root = ch:WaitForChild("HumanoidRootPart")

	hum.PlatformStand = true

	bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Velocity = Vector3.zero

	bg = Instance.new("BodyGyro", root)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.P = 10000

	flyConn = RS.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if keys.W then dir += cam.CFrame.LookVector end
		if keys.S then dir -= cam.CFrame.LookVector end
		if keys.D then dir += cam.CFrame.RightVector end
		if keys.A then dir -= cam.CFrame.RightVector end
		if keys.Up then dir += Vector3.new(0,1,0) end
		if keys.Down then dir -= Vector3.new(0,1,0) end

		bv.Velocity = (dir.Magnitude > 0) and dir.Unit * speed or Vector3.zero
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	flyOn = false
	flyBtn.Text = "✈ Fly: OFF"
	if flyConn then flyConn:Disconnect(); flyConn=nil end
	if bv then bv:Destroy(); bv=nil end
	if bg then bg:Destroy(); bg=nil end
	local ch = lp.Character
	if ch then
		local hum = ch:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end

flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "✈ Fly: ON" or "✈ Fly: OFF"
	if flyOn then startFly() else stopFly() end
end)

UIS.InputBegan:Connect(function(i,gpe)
	if gpe then return end
	if i.KeyCode==Enum.KeyCode.W then keys.W=true
	elseif i.KeyCode==Enum.KeyCode.A then keys.A=true
	elseif i.KeyCode==Enum.KeyCode.S then keys.S=true
	elseif i.KeyCode==Enum.KeyCode.D then keys.D=true
	elseif i.KeyCode==Enum.KeyCode.Space then keys.Up=true
	elseif i.KeyCode==Enum.KeyCode.LeftControl then keys.Down=true end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode==Enum.KeyCode.W then keys.W=false
	elseif i.KeyCode==Enum.KeyCode.A then keys.A=false
	elseif i.KeyCode==Enum.KeyCode.S then keys.S=false
	elseif i.KeyCode==Enum.KeyCode.D then keys.D=false
	elseif i.KeyCode==Enum.KeyCode.Space then keys.Up=false
	elseif i.KeyCode==Enum.KeyCode.LeftControl then keys.Down=false end
end)

lp.CharacterAdded:Connect(function()
	stopFly()
end)

-- ================= TP =================
local function teleportTo(name)
	local target = Players:FindFirstChild(name)
	if not target or not target.Character then return end
	local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
	if not tRoot then return end

	local myChar = lp.Character or lp.CharacterAdded:Wait()
	local myRoot = myChar:WaitForChild("HumanoidRootPart")

	myRoot.CFrame = tRoot.CFrame * CFrame.new(2, 0, 2)
end

tpBtn.MouseButton1Click:Connect(function()
	if selectedName then teleportTo(selectedName) end
end)

refreshBtn.MouseButton1Click:Connect(refreshList)

-- ================= ESP =================
local espOn = false
local tracked = {} -- [player] = {hl, bb, conn}

local function getRoot(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function clearESP(plr)
	local t = tracked[plr]
	if not t then return end
	if t.conn then t.conn:Disconnect() end
	if t.bb then t.bb:Destroy() end
	if t.hl then t.hl:Destroy() end
	tracked[plr] = nil
end

local function attachESP(plr)
	if plr == lp then return end
	if tracked[plr] then return end

	local function setup(char)
		if not espOn then return end
		clearESP(plr)

		local root = getRoot(char) or char:WaitForChild("HumanoidRootPart", 5)
		if not root then return end

		local hl = Instance.new("Highlight")
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillTransparency = 0.65
		hl.OutlineTransparency = 0.1
		hl.Adornee = char
		hl.Parent = char

		local bb = Instance.new("BillboardGui")
		bb.Size = UDim2.fromOffset(190, 40)
		bb.StudsOffset = Vector3.new(0, 3.2, 0)
		bb.AlwaysOnTop = true
		bb.MaxDistance = 5000
		bb.Adornee = root
		bb.Parent = char

		local txt = Instance.new("TextLabel", bb)
		txt.BackgroundTransparency = 1
		txt.Size = UDim2.new(1, 0, 1, 0)
		txt.Font = Enum.Font.GothamSemibold
		txt.TextSize = 14
		txt.TextColor3 = Color3.fromRGB(255,255,255)
		txt.TextStrokeTransparency = 0.25

		local conn = RS.RenderStepped:Connect(function()
			if not espOn then return end
			local myRoot = getRoot(lp.Character)
			local theirRoot = getRoot(plr.Character)
			if not myRoot or not theirRoot then return end
			local d = (myRoot.Position - theirRoot.Position).Magnitude
			txt.Text = string.format("%s  [%.0f m]", plr.Name, d)
		end)

		tracked[plr] = {hl=hl, bb=bb, conn=conn}
	end

	if plr.Character then setup(plr.Character) end
	plr.CharacterAdded:Connect(setup)
end

local function enableESP()
	espOn = true
	espBtn.Text = "👁 ESP: ON"
	for _, plr in ipairs(Players:GetPlayers()) do
		attachESP(plr)
	end
end

local function disableESP()
	espOn = false
	espBtn.Text = "👁 ESP: OFF"
	for plr,_ in pairs(tracked) do
		clearESP(plr)
	end
end

espBtn.MouseButton1Click:Connect(function()
	if espOn then disableESP() else enableESP() end
end)

-- init
refreshList()
