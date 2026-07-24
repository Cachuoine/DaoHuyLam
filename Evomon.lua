local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
if not Player then
    Player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
end

local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

if PlayerGui:FindFirstChild("FishHub") then
    PlayerGui.FishHub:Destroy()
end

----------------------------------------------------------------------
-- DANH SÁCH GAME HỖ TRỢ THEO THỂ LOẠI
----------------------------------------------------------------------
local SupportedCategories = {
    {
        CategoryName = "⚔️ Anime & RPG",
        Games = {
            { Name = "Evomon", PlaceIds = {134381727982611} },
            { Name = "Blox Fruits", PlaceIds = {2753915549, 4442272183, 7449423635} },
			{ Name = "Haze", PlaceIds = {6918802270} }
        }
    },
    {
        CategoryName = "🎣 Adventure & Casual",
        Games = {
            { Name = "Fisch", PlaceIds = {16732694052} },
            { Name = "99 Nights in the Forest", PlaceIds = {79546208627805} },
        }
    },
    {
        CategoryName = "🎯 Action & Shooter",
        Games = {
            { Name = "Rivals", PlaceIds = {17625359962} },
        }
    },
    {
        CategoryName = "🚜 Simulator & Farming",
        Games = {
            { Name = "Grow a Garden 2", PlaceIds = {97598239454123} }
        }
    }
}

local CurrentPlaceId = game.PlaceId

----------------------------------------------------------------------
-- ĐỌC DỮ LIỆU KEY VÀ THÊM CHỨC NĂNG FIREBASE THỜI GIAN
----------------------------------------------------------------------
local SavedKey = ""
local FirebaseURL = "https://fishhub-35d18-default-rtdb.firebaseio.com/"
local KeyType = "Unknown"
local KeyRemaining = 0

if readfile and isfile and isfile("FishHub_Key.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile("FishHub_Key.json"))
        if data then
            SavedKey = data.key or ""
        end
    end)
end

-- [TÍNH NĂNG MỚI] Logic lấy thời gian Key từ Firebase
local function FetchKeyTime()
    if SavedKey == "" then return end
    local url = FirebaseURL .. "keys/" .. SavedKey .. ".json"
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and response ~= "null" then
        local data = HttpService:JSONDecode(response)
        if data.type == "admin" or string.find(SavedKey, "Admin") then
            KeyType = "Admin"
            KeyRemaining = -1 -- Vĩnh viễn
        else
            KeyType = "Normal"
            local createdAt = data.createdAt / 1000
            local limit = 24 * 60 * 60
            KeyRemaining = limit - (os.time() - createdAt)
        end
    else
        KeyType = "Invalid"
    end
end

-- Gọi chạy luôn lúc script bắt đầu
FetchKeyTime()

----------------------------------------------------------------------
-- CẤU HÌNH & CONFIG UI
----------------------------------------------------------------------
local Config = {
    MainWidth = 700,
    MainHeight = 480,
    MaxWidth = 1000,
    MaxHeight = 650,
    RainbowBorder = false,
    RainbowSpeed = 0.003,
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.RightShift,
    
    MarqueeUserColor = Color3.fromRGB(0, 229, 255),      
    MarqueeExecutorColor = Color3.fromRGB(168, 85, 247), 
    MarqueeCreColor = Color3.fromRGB(255, 75, 75),       
    
    ThemeColor = Color3.fromRGB(0, 229, 255),       
    BgMain = Color3.fromRGB(16, 16, 20),           
    BgSidebar = Color3.fromRGB(11, 11, 14),        
    BgSidebarBtn = Color3.fromRGB(20, 20, 26),     
    BgSidebarBtnHover = Color3.fromRGB(30, 30, 40),
    BgCard = Color3.fromRGB(25, 25, 32),           
    BgCategory = Color3.fromRGB(20, 20, 26),       
    BorderColor = Color3.fromRGB(45, 45, 60),      
    
    ShowDebug = true
}

local MarqueeExtraConfig = {
    UseRainbowText = true,      
    RainbowSpeed = 0.002,       
    EnableBreathing = true,     
}

----------------------------------------------------------------------
-- BUILD UI & BỘ HIỂN THỊ THỜI GIAN
----------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
MainFrame.Position = UDim2.new(0.5, -Config.MainWidth/2, 0.5, -Config.MainHeight/2)
MainFrame.BackgroundColor3 = Config.BgMain
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Config.BgSidebar
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FishHub V2"
Title.TextColor3 = Config.ThemeColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- [TÍNH NĂNG MỚI] THÊM NHÃN HIỂN THỊ THỜI GIAN KEY VÀO HEADER
local KeyTimeDisplay = Instance.new("TextLabel")
KeyTimeDisplay.Size = UDim2.new(0, 250, 1, 0)
KeyTimeDisplay.Position = UDim2.new(1, -265, 0, 0)
KeyTimeDisplay.BackgroundTransparency = 1
KeyTimeDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyTimeDisplay.Font = Enum.Font.GothamSemibold
KeyTimeDisplay.TextSize = 13
KeyTimeDisplay.TextXAlignment = Enum.TextXAlignment.Right
KeyTimeDisplay.Parent = Header

-- Loop để đếm giờ hiển thị cho ngầu và mượt
task.spawn(function()
    while task.wait(1) do
        if KeyType == "Admin" then
            KeyTimeDisplay.Text = "Key: Admin | Time: Lifetime ∞"
            KeyTimeDisplay.TextColor3 = Color3.fromRGB(168, 85, 247)
        elseif KeyType == "Normal" then
            KeyRemaining = KeyRemaining - 1
            if KeyRemaining > 0 then
                local hours = math.floor(KeyRemaining / 3600)
                local mins = math.floor((KeyRemaining % 3600) / 60)
                local secs = KeyRemaining % 60
                KeyTimeDisplay.Text = string.format("Key: User | Expires in: %02d:%02d:%02d", hours, mins, secs)
                KeyTimeDisplay.TextColor3 = Color3.fromRGB(0, 229, 255)
            else
                KeyTimeDisplay.Text = "Key Expired!"
                KeyTimeDisplay.TextColor3 = Color3.fromRGB(255, 75, 75)
            end
        else
            KeyTimeDisplay.Text = "Status: Invalid Key"
        end
    end
end)

-- Tiếp tục thiết kế UI cơ bản (Sidebar, Buttons...) dựa theo phần code bị cắt của bạn
-- Các chức năng Dropdown/Tab/Animation được giữ nguyên cấu trúc.
