--[[
    FishHub - Combined Script (Loading -> GetKey UI -> CheckGame)
    Theme: Blue-Purple Gradient with transparency
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("FishHub_System") then
    CoreGui.FishHub_System:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishHub_System"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game:GetService("Lighting")
TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 15}):Play()

--------------------------------------------------------------------------------
-- HÀM LOAD SCRIPT CHÍNH (SAU KHI XÁC THỰC)
--------------------------------------------------------------------------------
local function loadMainScript()
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/CheckGame.lua")
        end)
        if success and result then
            local fn, err = loadstring(result)
            if fn then
                pcall(fn)
            else
                warn("Loadstring error: " .. tostring(err))
            end
        else
            warn("Failed to fetch CheckGame.lua")
        end
    end)
end

--------------------------------------------------------------------------------
-- GIAO DIỆN GETKEY UI (NHẬP KEY ĐỂ VƯỢT QUA)
--------------------------------------------------------------------------------
local function createGetKeyUI()
    local GetKeyFrame = Instance.new("Frame")
    GetKeyFrame.Name = "GetKeyFrame"
    GetKeyFrame.Size = UDim2.new(0, 420, 0, 260)
    GetKeyFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
    GetKeyFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 45)
    GetKeyFrame.BackgroundTransparency = 0.15
    GetKeyFrame.BorderSizePixel = 0
    GetKeyFrame.Parent = ScreenGui
    
    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 16)
    GetKeyCorner.Parent = GetKeyFrame
    
    local GetKeyStroke = Instance.new("UIStroke")
    GetKeyStroke.Color = Color3.fromRGB(140, 90, 255)
    GetKeyStroke.Thickness = 2
    GetKeyStroke.Parent = GetKeyFrame

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 80)
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = GetKeyFrame
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(GetKeyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)})
        tw:Play()
        tw.Completed:Wait()
        if Blur and Blur.Parent then Blur:Destroy() end
        if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "FishHub Key Verification"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = GetKeyFrame

    local LinkBtn = Instance.new("TextButton")
    LinkBtn.Size = UDim2.new(0, 360, 0, 35)
    LinkBtn.Position = UDim2.new(0.5, -180, 0, 70)
    LinkBtn.BackgroundColor3 = Color3.fromRGB(65, 40, 120)
    LinkBtn.BackgroundTransparency = 0.2
    LinkBtn.Text = "Get Key from Website"
    LinkBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
    LinkBtn.TextSize = 14
    LinkBtn.Font = Enum.Font.GothamMedium
    LinkBtn.Parent = GetKeyFrame
    
    local LinkCorner = Instance.new("UICorner")
    LinkCorner.CornerRadius = UDim.new(0, 8)
    LinkCorner.Parent = LinkBtn
    
    LinkBtn.MouseButton1Click:Connect(function()
        setclipboard("https://fishhub-online.netlify.app/")
        LinkBtn.Text = "Copied GetKey URL to Clipboard!"
        task.wait(1.5)
        LinkBtn.Text = "Get Key from Website"
    end)

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0, 360, 0, 45)
    KeyInput.Position = UDim2.new(0.5, -180, 0, 120)
    KeyInput.BackgroundColor3 = Color3.fromRGB(35, 25, 60)
    KeyInput.BackgroundTransparency = 0.2
    KeyInput.PlaceholderText = "Paste access key here"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 130, 190)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.Parent = GetKeyFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInput

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0, 360, 0, 40)
    SubmitBtn.Position = UDim2.new(0.5, -180, 0, 185)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    SubmitBtn.BackgroundTransparency = 0.1
    SubmitBtn.Text = "Verify Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 15
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = GetKeyFrame
    
    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = SubmitBtn

    -- PHẦN XỬ LÝ KIỂM TRA KEY KHI NHẤN NÚT
    SubmitBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text
        if enteredKey == "" then
            SubmitBtn.Text = "Please enter a key!"
            task.wait(1.5)
            SubmitBtn.Text = "Verify Key"
            return
        end

        SubmitBtn.Text = "Checking..."
        
        -- Kiểm tra key trên Firebase Realtime Database
        task.spawn(function()
            local success, res = pcall(function()
                return game:HttpGet("https://fishhubnew-default-rtdb.firebaseio.com/keys/" .. enteredKey .. ".json")
            end)

            if success and res and res ~= "null" then
                SubmitBtn.Text = "Success!"
                task.wait(0.4)
                
                local tw = TweenService:Create(GetKeyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)})
                tw:Play()
                tw.Completed:Wait()
                
                if Blur and Blur.Parent then Blur:Destroy() end
                if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
                
                loadMainScript()
            else
                SubmitBtn.Text = "Invalid Key!"
                task.wait(1.5)
                SubmitBtn.Text = "Verify Key"
            end
        end)
    end)
end

--------------------------------------------------------------------------------
-- PHẦN 1: LOADING UI
--------------------------------------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 360, 0, 220)
LoadingFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
LoadingFrame.BackgroundTransparency = 0.15
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 16)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(120, 80, 220)
LoadingStroke.Thickness = 2
LoadingStroke.Parent = LoadingFrame

local AnchorIcon = Instance.new("TextLabel")
AnchorIcon.Size = UDim2.new(0, 60, 0, 60)
AnchorIcon.Position = UDim2.new(0.5, -30, 0.25, -30)
AnchorIcon.BackgroundTransparency = 1
AnchorIcon.Text = "⚓"
AnchorIcon.TextSize = 40
AnchorIcon.Parent = LoadingFrame

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, -40, 0, 40)
LoadingText.Position = UDim2.new(0, 20, 0.65, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.TextColor3 = Color3.fromRGB(220, 200, 255)
LoadingText.TextSize = 16
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "Initializing FishHub System..."
LoadingText.Parent = LoadingFrame

local function finishLoadingAndShowGetKey()
    local shrinkTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)})
    shrinkTween:Play()
    shrinkTween.Completed:Wait()
    LoadingFrame:Destroy()
    
    createGetKeyUI()
end

task.spawn(function()
    local tw = TweenService:Create(AnchorIcon, TweenInfo.new(1, Enum.EasingStyle.Linear), {Rotation = 360})
    tw:Play()
    tw.Completed:Wait()
    
    LoadingText.Text = "Loading security components..."
    task.wait(0.7)
    LoadingText.Text = "Verifying environment..."
    task.wait(0.7)
    LoadingText.Text = "Ready!"
    task.wait(0.4)
    
    finishLoadingAndShowGetKey()
end)
