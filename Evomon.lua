-- FishHub UI System - Complete UI.lua
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Config mẫu cho giao diện
local Config = {
    BgCard = Color3.fromRGB(24, 24, 32),
    BorderColor = Color3.fromRGB(45, 45, 60),
    ShowDebug = true
}

-- Hàm dịch thuật đơn giản (nếu có hệ thống localization)
local function L(key)
    local dict = {
        CatSystem = "Hệ thống",
        DebugToggle = "Hiện Debug Sidebar",
        DebugDesc = "Hiển thị thông tin trạng thái debug và key bên cạnh"
    }
    return dict[key] or key
end

-- Tạo ScreenGui chính
local gui = Instance.new("ScreenGui")
gui.Name = "FishHubUI"
gui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = CoreGui
elseif CoreGui:FindFirstChild("CoreGui") then
    gui.Parent = CoreGui.CoreGui
else
    gui.Parent = CoreGui
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 580, 0, 380)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = mainFrame
mainStroke.Thickness = 1
mainStroke.Color = Config.BorderColor

----------------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Parent = mainFrame
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
sidebar.BorderSizePixel = 0

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

----------------------------------------------------------------------
-- KEY STATUS (Sidebar)
----------------------------------------------------------------------
local keyStatusSidebarFrame = Instance.new("Frame")
keyStatusSidebarFrame.Name = "KeyStatusSidebar"
keyStatusSidebarFrame.Parent = sidebar
keyStatusSidebarFrame.Size = UDim2.new(1, -16, 0, 54)
keyStatusSidebarFrame.Position = UDim2.new(0, 8, 1, -120)
keyStatusSidebarFrame.BackgroundColor3 = Config.BgCard
keyStatusSidebarFrame.BackgroundTransparency = 0
keyStatusSidebarFrame.BorderSizePixel = 0
keyStatusSidebarFrame.Visible = Config.ShowDebug

Instance.new("UICorner", keyStatusSidebarFrame).CornerRadius = UDim.new(0, 8)

local keyStatusStroke = Instance.new("UIStroke")
keyStatusStroke.Parent = keyStatusSidebarFrame
keyStatusStroke.Thickness = 1
keyStatusStroke.Color = Config.BorderColor

local keyStatusTitle = Instance.new("TextLabel")
keyStatusTitle.Parent = keyStatusSidebarFrame
keyStatusTitle.Size = UDim2.new(1, -12, 0, 16)
keyStatusTitle.Position = UDim2.new(0, 8, 0, 4)
keyStatusTitle.BackgroundTransparency = 1
keyStatusTitle.Font = Enum.Font.GothamBold
keyStatusTitle.TextSize = 10
keyStatusTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
keyStatusTitle.Text = "KEY STATUS"
keyStatusTitle.TextXAlignment = Enum.TextXAlignment.Left

local keyInnerCard = Instance.new("Frame")
keyInnerCard.Parent = keyStatusSidebarFrame
keyInnerCard.Size = UDim2.new(1, -12, 0, 26)
keyInnerCard.Position = UDim2.new(0, 6, 0, 22)
keyInnerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
keyInnerCard.BorderSizePixel = 0
Instance.new("UICorner", keyInnerCard).CornerRadius = UDim.new(0, 6)

local greenDotKey = Instance.new("Frame")
greenDotKey.Parent = keyInnerCard
greenDotKey.Size = UDim2.new(0, 8, 0, 8)
greenDotKey.Position = UDim2.new(0, 8, 0.5, -4)
greenDotKey.BackgroundColor3 = Color3.fromRGB(50, 230, 80)
greenDotKey.BorderSizePixel = 0
Instance.new("UICorner", greenDotKey).CornerRadius = UDim.new(1, 0)

local keyNameLabel = Instance.new("TextLabel")
keyNameLabel.Parent = keyInnerCard
keyNameLabel.Size = UDim2.new(0, 80, 1, 0)
keyNameLabel.Position = UDim2.new(0, 22, 0, 0)
keyNameLabel.BackgroundTransparency = 1
keyNameLabel.Font = Enum.Font.GothamBold
keyNameLabel.TextSize = 11
keyNameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
keyNameLabel.Text = "RightShift"
keyNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyActiveLabel = Instance.new("TextLabel")
keyActiveLabel.Parent = keyInnerCard
keyActiveLabel.Size = UDim2.new(1, -100, 1, 0)
keyActiveLabel.Position = UDim2.new(0, 95, 0, 0)
keyActiveLabel.BackgroundTransparency = 1
keyActiveLabel.Font = Enum.Font.GothamBold
keyActiveLabel.TextSize = 11
keyActiveLabel.TextColor3 = Color3.fromRGB(50, 230, 80)
keyActiveLabel.Text = "ACTIVE"
keyActiveLabel.TextXAlignment = Enum.TextXAlignment.Right

----------------------------------------------------------------------
-- KEY EXP (THỜI GIAN HIỆU LỰC 24H)
----------------------------------------------------------------------
local keyExpSidebarFrame = Instance.new("Frame")
keyExpSidebarFrame.Name = "KeyExpSidebar"
keyExpSidebarFrame.Parent = sidebar
keyExpSidebarFrame.Size = UDim2.new(1, -16, 0, 54)
keyExpSidebarFrame.Position = UDim2.new(0, 8, 1, -62)
keyExpSidebarFrame.BackgroundColor3 = Config.BgCard
keyExpSidebarFrame.BackgroundTransparency = 0
keyExpSidebarFrame.BorderSizePixel = 0
keyExpSidebarFrame.Visible = Config.ShowDebug

Instance.new("UICorner", keyExpSidebarFrame).CornerRadius = UDim.new(0, 8)

local keyExpStroke = Instance.new("UIStroke")
keyExpStroke.Parent = keyExpSidebarFrame
keyExpStroke.Thickness = 1
keyExpStroke.Color = Config.BorderColor

local keyExpTitle = Instance.new("TextLabel")
keyExpTitle.Parent = keyExpSidebarFrame
keyExpTitle.Size = UDim2.new(1, -12, 0, 16)
keyExpTitle.Position = UDim2.new(0, 8, 0, 4)
keyExpTitle.BackgroundTransparency = 1
keyExpTitle.Font = Enum.Font.GothamBold
keyExpTitle.TextSize = 10
keyExpTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
keyExpTitle.Text = "KEY EXP (24H)"
keyExpTitle.TextXAlignment = Enum.TextXAlignment.Left

local keyExpInnerCard = Instance.new("Frame")
keyExpInnerCard.Parent = keyExpSidebarFrame
keyExpInnerCard.Size = UDim2.new(1, -12, 0, 26)
keyExpInnerCard.Position = UDim2.new(0, 6, 0, 22)
keyExpInnerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
keyExpInnerCard.BorderSizePixel = 0
Instance.new("UICorner", keyExpInnerCard).CornerRadius = UDim.new(0, 6)

local expDot = Instance.new("Frame")
expDot.Parent = keyExpInnerCard
expDot.Size = UDim2.new(0, 8, 0, 8)
expDot.Position = UDim2.new(0, 8, 0.5, -4)
expDot.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
expDot.BorderSizePixel = 0
Instance.new("UICorner", expDot).CornerRadius = UDim.new(1, 0)

local keyExpTimerLabel = Instance.new("TextLabel")
keyExpTimerLabel.Parent = keyExpInnerCard
keyExpTimerLabel.Size = UDim2.new(1, -22, 1, 0)
keyExpTimerLabel.Position = UDim2.new(0, 22, 0, 0)
keyExpTimerLabel.BackgroundTransparency = 1
keyExpTimerLabel.Font = Enum.Font.GothamBold
keyExpTimerLabel.TextSize = 10.5
keyExpTimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyExpTimerLabel.Text = "23h 59m 59s"
keyExpTimerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Luồng đếm ngược thời gian 24h
task.spawn(function()
    local totalSeconds = 24 * 3600
    local startTime = os.time()
    
    while gui and gui.Parent do
        local elapsed = os.time() - startTime
        local remaining = totalSeconds - elapsed
        if remaining < 0 then remaining = 0 end
        
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        local seconds = remaining % 60
        
        keyExpTimerLabel.Text = string.format("%02dh %02dm %02ds", hours, minutes, seconds)
        
        if remaining <= 0 then
            keyExpTimerLabel.Text = "EXPIRED!"
            keyExpTimerLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            break
        end
        
        task.wait(1)
    end
end)

----------------------------------------------------------------------
-- CONTAINER CHÍNH
----------------------------------------------------------------------
local container = Instance.new("Frame")
container.Name = "Container"
container.Parent = mainFrame
container.Size = UDim2.new(1, -160, 1, 0)
container.Position = UDim2.new(0, 160, 0, 0)
container.BackgroundTransparency = 1

return gui
