-- [[ SCRIPT TỐI ƯU CHO DELTA EXECUTOR - CHỈNH TỐC ĐỘ CHẠY ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm xử lý thiết lập UI và logic tốc độ cho nhân vật
local function setupSpeedControl(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if not humanoid then return end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not PlayerGui then return end

	-- Xóa UI cũ nếu có để tránh trùng lặp
	local oldSpeedGui = PlayerGui:FindFirstChild("SpeedControlGui")
	if oldSpeedGui then oldSpeedGui:Destroy() end

	-- Tạo giao diện mới
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpeedControlGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = PlayerGui

	-- Tạo ô nhập số tốc độ
	local speedBox = Instance.new("TextBox")
	speedBox.Name = "SpeedBox"
	speedBox.Size = UDim2.new(0, 160, 0, 40)
	speedBox.Position = UDim2.new(0, 20, 0.75, 0) -- Góc dưới bên trái điện thoại
	speedBox.PlaceholderText = "Tốc độ (Gốc: 16)..."
	speedBox.Text = ""
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	speedBox.BorderColor3 = Color3.fromRGB(0, 255, 150) -- Viền xanh lá neon
	speedBox.TextSize = 16
	speedBox.Font = Enum.Font.SourceSansBold
	speedBox.ClipsDescendants = true
	speedBox.Parent = screenGui

	-- Bo tròn góc ô nhập
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = speedBox

	-- Xử lý sự kiện khi nhập số xong (Bấm Enter hoặc nhấn ra ngoài màn hình)
	speedBox.FocusLost:Connect(function(enterPressed)
		local text = speedBox.Text
		local newSpeed = tonumber(text)
		
		if newSpeed and newSpeed >= 0 then
			humanoid.WalkSpeed = newSpeed
			speedBox.Text = tostring(newSpeed)
		else
			humanoid.WalkSpeed = 16 
			speedBox.Text = ""
		end
	end)

	-- Tự động xóa UI này khi nhân vật chết
	humanoid.Died:Connect(function()
		screenGui:Destroy()
	end)
end

-- Chạy ngay lập tức cho nhân vật hiện tại
if LocalPlayer.Character then
	task.spawn(setupSpeedControl, LocalPlayer.Character)
end

-- Tự động chạy lại mỗi khi bạn hồi sinh (CharacterAdded)
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	setupSpeedControl(newCharacter)
end)
