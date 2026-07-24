-- ==========================================
-- SCRIPT 1: LOADING & GET KEY FISHHUB (Auto-Login & Modern UI)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local FirebaseURL = "https://fishhub-35d18-default-rtdb.firebaseio.com/"
local CheckGameURL = "https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/CheckGame.lua"
local GetKeyURL = "https://fishhub-online.netlify.app/"
local AdminKey = "DHL22052009"

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("FishHubLoader") then
    CoreGui.FishHubLoader:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHubLoader"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 229, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Nút đóng UI (Dấu nhân ×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 55)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Móc neo chính giữa trang trí
local AnchorIcon = Instance.new("TextLabel")
AnchorIcon.Size = UDim2.new(0, 50, 0, 50)
AnchorIcon.Position = UDim2.new(0.5, -25, 0, 15)
AnchorIcon.BackgroundTransparency = 1
AnchorIcon.Text = "⚓"
AnchorIcon.TextColor3 = Color3.fromRGB(0, 229, 255)
AnchorIcon.TextSize = 28
AnchorIcon.Font = Enum.Font.GothamBold
AnchorIcon.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 68)
Title.BackgroundTransparency = 1
Title.Text = "FISHHUB SYSTEM"
Title.TextColor3 = Color3.fromRGB(200, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Trạng thái chữ nằm phía trên các nút
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.Position = UDim2.new(0, 0, 0, 105)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Initializing system..."
StatusText.TextColor3 = Color3.fromRGB(0, 229, 255)
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 13
StatusText.Parent = MainFrame

-- Khung Get Key
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 42)
KeyBox.Position = UDim2.new(0.075, 0, 0, 138)
KeyBox.BackgroundColor3 = Color3.fromRGB(20, 14, 38)
KeyBox.BackgroundTransparency = 0.2
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(130, 160, 200)
KeyBox.PlaceholderText = "Enter your key here..."
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Text = ""
KeyBox.Visible = false
KeyBox.Parent = MainFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Color = Color3.fromRGB(0, 180, 255)
KeyBoxStroke.Transparency = 0.3
KeyBoxStroke.Thickness = 1.5
KeyBoxStroke.Parent = KeyBox

local BtnCheck = Instance.new("TextButton")
BtnCheck.Size = UDim2.new(0.41, 0, 0, 40)
BtnCheck.Position = UDim2.new(0.075, 0, 0, 195)
BtnCheck.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
BtnCheck.BackgroundTransparency = 0.1
BtnCheck.TextColor3 = Color3.new(1,1,1)
BtnCheck.Text = "VERIFY"
BtnCheck.Font = Enum.Font.GothamBold
BtnCheck.TextSize = 14
BtnCheck.Visible = false
BtnCheck.Parent = MainFrame

local BtnCheckCorner = Instance.new("UICorner")
BtnCheckCorner.CornerRadius = UDim.new(0, 10)
BtnCheckCorner.Parent = BtnCheck

local BtnCheckStroke = Instance.new("UIStroke")
BtnCheckStroke.Color = Color3.fromRGB(100, 255, 180)
BtnCheckStroke.Transparency = 0.4
BtnCheckStroke.Thickness = 1.5
BtnCheckStroke.Parent = BtnCheck

local BtnGet = Instance.new("TextButton")
BtnGet.Size = UDim2.new(0.41, 0, 0, 40)
BtnGet.Position = UDim2.new(0.515, 0, 0, 195)
BtnGet.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
BtnGet.BackgroundTransparency = 0.1
BtnGet.TextColor3 = Color3.new(1,1,1)
BtnGet.Text = "GET KEY"
BtnGet.Font = Enum.Font.GothamBold
BtnGet.TextSize = 14
BtnGet.Visible = false
BtnGet.Parent = MainFrame

local BtnGetCorner = Instance.new("UICorner")
BtnGetCorner.CornerRadius = UDim.new(0, 10)
BtnGetCorner.Parent = BtnGet

local BtnGetStroke = Instance.new("UIStroke")
BtnGetStroke.Color = Color3.fromRGB(100, 200, 255)
BtnGetStroke.Transparency = 0.4
BtnGetStroke.Thickness = 1.5
BtnGetStroke.Parent = BtnGet

-- Hiệu ứng quay móc neo
task.spawn(function()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(AnchorIcon, tweenInfo, {Rotation = 360})
    tween:Play()
end)

-- Hàm lưu và vào game
local function SaveAndLoad(key)
    StatusText.Text = "Valid Key! Launching..."
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    local dataToSave = HttpService:JSONEncode({key = key})
    pcall(function()
        writefile("FishHub_Key.json", dataToSave)
    end)
    
    task.wait(1)
    ScreenGui:Destroy()
    loadstring(game:HttpGet(CheckGameURL))()
end

-- Kiểm tra xem đã có file key lưu từ trước hay chưa để tự động vào luôn
task.spawn(function()
    task.wait(0.8)
    StatusText.Text = "Checking saved session..."
    
    local hasValidSavedKey = false
    local savedKey = ""
    
    if pcall(readfile, "FishHub_Key.json") then
        local success, content = pcall(readfile, "FishHub_Key.json")
        if success and content ~= "" then
            local decSuccess, decData = pcall(function() return HttpService:JSONDecode(content) end)
            if decSuccess and decData and decData.key then
                savedKey = decData.key
                if savedKey == AdminKey then
                    hasValidSavedKey = true
                else
                    local checkUrl = FirebaseURL .. "keys/" .. savedKey .. ".json"
                    local getSuccess, response = pcall(function() return game:HttpGet(checkUrl) end)
                    if getSuccess and response ~= "null" then
                        local data = HttpService:JSONDecode(response)
                        local currentTime = os.time()
                        local createdAtSec = math.floor(data.createdAt / 1000)
                        if (currentTime - createdAtSec) <= 86400 then
                            hasValidSavedKey = true
                        end
                    end
                end
            end
        end
    end
    
    if hasValidSavedKey then
        SaveAndLoad(savedKey)
    else
        StatusText.Text = "Please authenticate Key!"
        KeyBox.Visible = true
        BtnCheck.Visible = true
        BtnGet.Visible = true
    end
end)

BtnGet.MouseButton1Click:Connect(function()
    setclipboard(GetKeyURL)
    StatusText.Text = "Key link copied!"
    StatusText.TextColor3 = Color3.fromRGB(255, 220, 100)
end)

BtnCheck.MouseButton1Click:Connect(function()
    local input = KeyBox.Text
    if input == "" then
        StatusText.Text = "Please enter a key!"
        StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    StatusText.Text = "Checking..."
    StatusText.TextColor3 = Color3.fromRGB(0, 229, 255)

    if input == AdminKey then
        SaveAndLoad(input)
        return
    end

    local checkUrl = FirebaseURL .. "keys/" .. input .. ".json"
    local success, response = pcall(function() return game:HttpGet(checkUrl) end)
    
    if success and response ~= "null" then
        local data = HttpService:JSONDecode(response)
        local currentTime = os.time()
        local createdAtSec = math.floor(data.createdAt / 1000)
        
        if (currentTime - createdAtSec) <= 86400 then
            SaveAndLoad(input)
        else
            StatusText.Text = "Key has expired!"
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    else
        StatusText.Text = "Key doesn't exist or incorrect!"
        StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
