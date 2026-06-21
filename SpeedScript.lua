-- [[ SCRIPT MỚI ĐỘC LẬP - CHỈ CHỈNH TỐC ĐỘ CHẠY TRÊN ĐIỆN THOẠI ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

-- ----------------------------------------------------
-- TỰ ĐỘNG TẠO Ô NHẬP TỐC ĐỘ Ở GÓC MÀN HÌNH
-- ----------------------------------------------------
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có để tránh lỗi trùng lặp khi hồi sinh
local oldSpeedGui = PlayerGui:FindFirstChild("SpeedControlGui")
if oldSpeedGui then oldSpeedGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedControlGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Tạo ô nhập số tốc độ
local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
-- Kích thước ô nhập (Rộng 160, Cao 40)
speedBox.Size = UDim2.new(0, 160, 0, 40)
-- Vị trí đặt ở góc dưới bên trái màn hình điện thoại (để không vướng nút nhảy)
speedBox.Position = UDim2.new(0, 20, 0.75, 0) 
speedBox.PlaceholderText = "Tốc độ (Gốc: 16)..."
speedBox.Text = ""
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu nền tối
speedBox.BorderColor3 = Color3.fromRGB(0, 255, 150)   -- Viền màu xanh lá neon nổi bật
speedBox.TextSize = 16
speedBox.Font = Enum.Font.SourceSansBold
speedBox.ClipsDescendants = true
speedBox.Parent = screenGui

-- Bo tròn góc ô nhập cho đẹp mắt
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = speedBox

-- Tự động xóa UI khi nhân vật chết để chuẩn bị tạo cái mới khi hồi sinh
humanoid.Died:Connect(function()
	screenGui:Destroy()
end)

-- ----------------------------------------------------
-- LẮNG NGHE VÀ XỬ LÝ SỰ KIỆN ĐỔI TỐC ĐỘ
-- ----------------------------------------------------
speedBox.FocusLost:Connect(function(enterPressed)
	local text = speedBox.Text
	local newSpeed = tonumber(text) -- Chuyển đổi văn bản thành số
	
	if newSpeed and newSpeed >= 0 then
		humanoid.WalkSpeed = newSpeed -- Thay đổi tốc độ chạy của bạn
		speedBox.Text = tostring(newSpeed) -- Hiển thị lại số đã nhập
	else
		-- Nếu xóa trắng hoặc nhập sai ký tự (gõ chữ), hệ thống trả về tốc độ gốc 16
		humanoid.WalkSpeed = 16 
		speedBox.Text = ""
	end
end)
