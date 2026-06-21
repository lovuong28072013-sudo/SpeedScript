-- [[ SCRIPT KHÓA TỐC ĐỘ SIMULATOR - CHẶN GAME TỰ RESET ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Biến lưu trữ tốc độ bạn muốn ép buộc
local forcedSpeed = nil 

-- ====================================================
-- BẢO VỆ CHỈ SỐ: CHẶN GAME GHI ĐÈ WALKSPEED CỦA BẠN
-- ====================================================
local mt = getrawmetatable(game)
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

mt.__newindex = newcclosure(function(t, k, v)
    -- Nếu hệ thống game cố tình thay đổi WalkSpeed của bạn
    if forcedSpeed and t:IsA("Humanoid") and k == "WalkSpeed" then
        -- Ép buộc game phải sử dụng số tốc độ bạn đã nhập trong UI
        return oldNewIndex(t, k, forcedSpeed)
    end
    return oldNewIndex(t, k, v)
end)

setreadonly(mt, true)

-- ====================================================
-- PHẦN TẠO GIAO DIỆN (UI) TRÊN ĐIỆN THOẠI
-- ====================================================
local function setupSpeedControl(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if not humanoid then return end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not PlayerGui then return end

	local oldSpeedGui = PlayerGui:FindFirstChild("SpeedControlGui")
	if oldSpeedGui then oldSpeedGui:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpeedControlGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = PlayerGui

	local speedBox = Instance.new("TextBox")
	speedBox.Name = "SpeedBox"
	speedBox.Size = UDim2.new(0, 150, 0, 40)
	speedBox.Position = UDim2.new(0, 20, 0.7, 0)
	speedBox.PlaceholderText = "Nhập tốc độ ép buộc..."
	speedBox.Text = forcedSpeed and tostring(forcedSpeed) or ""
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	speedBox.BorderColor3 = Color3.fromRGB(255, 150, 0) -- Viền cam nổi bật
	speedBox.TextSize = 15
	speedBox.Font = Enum.Font.SourceSansBold
	speedBox.ClipsDescendants = true
	speedBox.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = speedBox

	-- Xử lý khi bạn nhập số xong
	speedBox.FocusLost:Connect(function(enterPressed)
		local text = speedBox.Text
		local newSpeed = tonumber(text)
		
		if newSpeed and newSpeed >= 0 then
			forcedSpeed = newSpeed
			humanoid.WalkSpeed = newSpeed -- Đổi ngay lập tức
			speedBox.Text = tostring(newSpeed)
		else
			forcedSpeed = nil -- Tắt tính năng khóa, trả về mặc định của game
			speedBox.Text = ""
		end
	end)

	-- Tự cập nhật lại tốc độ mỗi khi hồi sinh
	if forcedSpeed then
		humanoid.WalkSpeed = forcedSpeed
	end

	humanoid.Died:Connect(function()
		screenGui:Destroy()
	end)
end

-- Kích hoạt hệ thống
if LocalPlayer.Character then
	task.spawn(setupSpeedControl, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	setupSpeedControl(newCharacter)
end)
