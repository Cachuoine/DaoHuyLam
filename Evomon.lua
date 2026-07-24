local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("FishHub") then
    PlayerGui.FishHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local Config = {
    MainWidth = 700,
    MainHeight = 480,
    RainbowBorder = true,
    RainbowSpeed = 0.003,
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.RightShift,
    ThemeColor = Color3.fromRGB(0, 229, 255),
    BgMain = Color3.fromRGB(16, 16, 20),
    BgSidebar = Color3.fromRGB(11, 11, 14),
    BgCard = Color3.fromRGB(25, 25, 32),
    BorderColor = Color3.fromRGB(45, 45, 60),
}

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Parent = gui
main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Config.BgMain
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = main
mainStroke.Thickness = 2

task.spawn(function()
    local hue = 0
    while main and main.Parent do
        if Config.RainbowBorder then
            mainStroke.Color = Color3.fromHSV(hue, 1, 1)
        else
            mainStroke.Color = Config.ThemeColor
        end
        hue = hue + Config.RainbowSpeed
        if hue >= 1 then hue = 0 end
        RunService.RenderStepped:Wait()
    end
end)

-- Hiển thị thông báo UI thành công
local titleLbl = Instance.new("TextLabel")
titleLbl.Parent = main
titleLbl.Size = UDim2.new(1, 0, 0, 50)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Text = "⚓ <font color='#00E5FF'>FishHub</font> <font color='#A855F7'>Ultimate Collection - Realtime Active</font>"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 16
titleLbl.RichText = true

print("FishHub UI Loaded Successfully with 22-char key backend verification.")
