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
-- DANH SÁCH GAME HỖ TRỢ THEO THỂ LOẠI (SUPPORTED GAMES BY CATEGORY)
----------------------------------------------------------------------
local SupportedCategories = {
    {
        CategoryName = "⚔️ Anime & RPG",
        Games = {
            { Name = "Evomon", PlaceIds = {134381727982611}, Icon = "rbxassetid://108029482244357" },
            { Name = "Blox Fruits", PlaceIds = {2753915549, 4442272183, 7449423635}, Icon = "rbxassetid://108029482244357" },
            { Name = "King Legacy", PlaceIds = {4520749081, 6381829480}, Icon = "rbxassetid://108029482244357" },
            { Name = "Grand Piece Online", PlaceIds = {1730877819}, Icon = "rbxassetid://108029482244357" },
            { Name = "Anime Adventures", PlaceIds = {8304191830}, Icon = "rbxassetid://108029482244357" },
        }
    },
    {
        CategoryName = "🎣 Adventure & Casual",
        Games = {
            { Name = "Fisch", PlaceIds = {16732694052}, Icon = "rbxassetid://108029482244357" },
            { Name = "Adopt Me!", PlaceIds = {920587237}, Icon = "rbxassetid://108029482244357" },
            { Name = "Brookhaven RP", PlaceIds = {4924922222}, Icon = "rbxassetid://108029482244357" },
        }
    },
    {
        CategoryName = "🎯 Action & Shooter",
        Games = {
            { Name = "Rivals", PlaceIds = {17625359962}, Icon = "rbxassetid://108029482244357" },
            { Name = "Arsenal", PlaceIds = {286090429}, Icon = "rbxassetid://108029482244357" },
            { Name = "Murder Mystery 2", PlaceIds = {142823291}, Icon = "rbxassetid://108029482244357" },
        }
    },
    {
        CategoryName = "🚜 Simulator & Farming",
        Games = {
            { Name = "Pet Simulator 99", PlaceIds = {8737899170, 16498369169}, Icon = "rbxassetid://108029482244357" },
            { Name = "Bee Swarm Simulator", PlaceIds = {1537690962}, Icon = "rbxassetid://108029482244357" },
        }
    }
}

local CurrentPlaceId = game.PlaceId

----------------------------------------------------------------------
-- ĐỌC DỮ LIỆU KEY TỪ PHẦN GETKEY (FishHub_Key.json)
----------------------------------------------------------------------
local SavedKey = ""
local KeyExpirationTimestamp = 0

if readfile and isfile and isfile("FishHub_Key.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile("FishHub_Key.json"))
        if data then
            SavedKey = data.key or ""
            KeyExpirationTimestamp = data.expiry or 0
        end
    end)
end

----------------------------------------------------------------------
-- CẤU HÌNH & CONFIG UI
----------------------------------------------------------------------
local Config = {
    MainWidth = 700,
    MainHeight = 480,
    MaxWidth = 1000,
    MaxHeight = 650,
    RainbowBorder = true,
    RainbowSpeed = 0.003,
    GUIAnimation = true,
    Language = "EN",
    ToggleKey = Enum.KeyCode.RightShift,
    
    ThemeColor = Color3.fromRGB(0, 229, 255),       -- Cyan Neon mặc định
    BgMain = Color3.fromRGB(16, 16, 20),           
    BgSidebar = Color3.fromRGB(11, 11, 14),        
    BgSidebarBtn = Color3.fromRGB(20, 20, 26),     
    BgSidebarBtnHover = Color3.fromRGB(30, 30, 40),
    BgCard = Color3.fromRGB(25, 25, 32),           
    BgCategory = Color3.fromRGB(20, 20, 26),       
    BorderColor = Color3.fromRGB(45, 45, 60),      
    
    ShowDebug = true
}

local Translations = {
    EN = {
        Title = "Script Collection",
        Home = "Home",
        Support = "Support Games",
        Setting = "Setting",
        SettingTitle = "Hub Settings",
        SupportTitle = "🎮 Supported Games List",
        
        CatAppearance = "🎨 Visual & Theme",
        CatSystem = "⚙️ System & Controls",
        CatActions = "⚡ Quick Utilities",

        RainbowToggle = "🌈 Rainbow Border",
        RainbowDesc = "Enable/Disable continuous rainbow border effect.",
        SpeedToggle = "⚡ Rainbow Speed",
        SpeedDesc = "Cycle rainbow effect speed (Slow / Medium / Fast).",
        AnimToggle = "🎬 GUI Animation",
        AnimDesc = "Smooth open/close window transitions.",
        LangToggle = "🌐 Language",
        LangDesc = "Switch interface language.",
        KeybindTitle = "⌨️ Toggle Hotkey",
        KeybindDesc = "Click to set a new toggle hotkey.",
        ThemeTitle = "🎨 GUI Theme Color",
        ThemeDesc = "Click to open theme selector and choose colors.",
        DebugToggle = "📊 Debug Overlay",
        DebugDesc = "Display FPS, Ping, Time (24h) and Key Status.",
        
        RejoinBtn = "🔄 Rejoin Game",
        HopBtn = "🌐 Server Hop",
        CopyDiscordBtn = "📋 Copy Discord Link",
        RefreshUIBtn = "🧹 Clean & Reload UI",
        
        PressKey = "Press Key...",
        CloseConfirm = "Do you want to close FishHub?",
        Yes = "Yes",
        No = "No"
    },
    VN = {
        Title = "Bộ Sưu Tập Script",
        Home = "Trang Chủ",
        Support = "Game Hỗ Trợ",
        Setting = "Cài Đặt",
        SettingTitle = "Cài Đặt Bảng Điều Khiển",
        SupportTitle = "🎮 Danh Sách Game Hỗ Trợ",

        CatAppearance = "🎨 Giao Diện & Theme",
        CatSystem = "⚙️ Hệ Thống & Phím Tắt",
        CatActions = "⚡ Công Cụ Nhanh",

        RainbowToggle = "🌈 Viền Cầu Vồng",
        RainbowDesc = "Bật/Tắt hiệu ứng chuyển màu viền liên tục.",
        SpeedToggle = "⚡ Tốc Độ Cầu Vồng",
        SpeedDesc = "Thay đổi tốc độ đổi màu (Chậm / Vừa / Nhanh).",
        AnimToggle = "🎬 Hiệu Ứng Mở/Đóng",
        AnimDesc = "Hiệu ứng thu phóng mượt mà khi bật/tắt UI.",
        LangToggle = "🌐 Ngôn Ngữ",
        LangDesc = "Chuyển đổi Tiếng Anh / Tiếng Việt.",
        KeybindTitle = "⌨️ Phím Tắt Ẩn/Hiện",
        KeybindDesc = "Nhấn để đổi phím mở giao diện.",
        ThemeTitle = "🎨 Màu Theme Giao Diện",
        ThemeDesc = "Nhấn để mở bảng chọn màu phong cách.",
        DebugToggle = "📊 Bảng Debug Thông Số",
        DebugDesc = "Hiển thị FPS, Ping, Giờ (24h) và Thời hạn Key.",

        RejoinBtn = "🔄 Vào Lại Server",
        HopBtn = "🌐 Chuyển Server",
        CopyDiscordBtn = "📋 Copy Link Discord",
        RefreshUIBtn = "🧹 Tải Lại Giao Diện",

        PressKey = "Nhấn phím...",
        CloseConfirm = "Bạn có chắc muốn tắt FishHub không?",
        Yes = "Có",
        No = "Không"
    }
}

local function L(key)
    local lang = Config.Language
    if Translations[lang] and Translations[lang][key] then
        return Translations[lang][key]
    end
    return Translations["EN"][key] or key
end

local CurrentButton
local OpenHome, OpenSupport, OpenSettings
local OpenGUI, CloseGUI, ToggleMain
local RefreshUI

local gui = Instance.new("ScreenGui")
gui.Name = "FishHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

----------------------------------------------------------------------
-- DEBUG OVERLAY
----------------------------------------------------------------------
local debugFrame = Instance.new("Frame")
debugFrame.Name = "DebugOverlay"
debugFrame.Parent = gui
debugFrame.Size = UDim2.new(0, 215, 0, 78)
debugFrame.Position = UDim2.new(0.5, 0, 0, 15)
debugFrame.AnchorPoint = Vector2.new(0.5, 0)
debugFrame.BackgroundColor3 = Config.BgMain
debugFrame.BackgroundTransparency = 0.15
debugFrame.BorderSizePixel = 0
debugFrame.Visible = Config.ShowDebug

Instance.new("UICorner", debugFrame).CornerRadius = UDim.new(0, 8)

local debugStroke = Instance.new("UIStroke")
debugStroke.Parent = debugFrame
debugStroke.Thickness = 1
debugStroke.Color = Config.BorderColor

local debugText = Instance.new("TextLabel")
debugText.Parent = debugFrame
debugText.Size = UDim2.new(1, -12, 1, -8)
debugText.Position = UDim2.new(0, 8, 0, 4)
debugText.BackgroundTransparency = 1
debugText.Font = Enum.Font.Code
debugText.TextSize = 11
debugText.TextColor3 = Color3.fromRGB(240, 240, 240)
debugText.TextXAlignment = Enum.TextXAlignment.Left
debugText.TextYAlignment = Enum.TextYAlignment.Top
debugText.RichText = true

local debugDragging, debugDragStart, debugStartPos
debugFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        debugDragging = true
        debugDragStart = input.Position
        debugStartPos = debugFrame.AbsolutePosition
        
        debugFrame.AnchorPoint = Vector2.new(0, 0)
        debugFrame.Position = UDim2.new(0, debugStartPos.X, 0, debugStartPos.Y)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                debugDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and debugDragging then
        local delta = input.Position - debugDragStart
        debugFrame.Position = UDim2.new(0, debugStartPos.X + delta.X, 0, debugStartPos.Y + delta.Y)
    end
end)

local frameCount = 0
local lastFpsUpdate = os.clock()
local currentFps = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = os.clock()
    if now - lastFpsUpdate >= 1 then
        currentFps = math.floor(frameCount / (now - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = now
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        if Config.ShowDebug then
            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            local time24h = os.date("%H:%M:%S")
            local keyStatus = ""
            local isAdmin = false

            if SavedKey == "DaoHuyLam22052009" or SavedKey == "DaoHuyHoang19102006" then
                keyStatus = "<font color='#FFDF00'>👑 Admin (Permanent)</font>"
                isAdmin = true
            elseif KeyExpirationTimestamp == 0 then
                keyStatus = "<font color='#AAAAAA'>No Key Saved</font>"
            else
                local remainingSeconds = KeyExpirationTimestamp - os.time()
                if remainingSeconds <= 0 then
                    keyStatus = "<font color='#FF4B4B'>Expired (00h 00m 00s)</font>"
                else
                    local hours = math.floor(remainingSeconds / 3600)
                    local mins = math.floor((remainingSeconds % 3600) / 60)
                    local secs = remainingSeconds % 60
                    keyStatus = string.format("<font color='#50D74B'>%02dh %02dm %02ds</font>", hours, mins, secs)
                end
            end

            if isAdmin then
                debugFrame.Size = UDim2.new(0, 200, 0, 92)
                debugText.Text = string.format(
                    "⚡ <b>FPS:</b> %d\n" ..
                    "📶 <b>PING:</b> %d ms\n" ..
                    "🕒 <b>TIME:</b> %s\n" ..
                    "🔑 <b>KEY EXP:</b>\n   └ %s",
                    currentFps, ping, time24h, keyStatus
                )
            else
                debugFrame.Size = UDim2.new(0, 215, 0, 78)
                debugText.Text = string.format(
                    "⚡ <b>FPS:</b> %d\n" ..
                    "📶 <b>PING:</b> %d ms\n" ..
                    "🕒 <b>TIME:</b> %s\n" ..
                    "🔑 <b>KEY EXP:</b> %s",
                    currentFps, ping, time24h, keyStatus
                )
            end
        end
        task.wait(0.5)
    end
end)

----------------------------------------------------------------------
-- MAIN HUB UI
----------------------------------------------------------------------
local openLine = Instance.new("Frame")
openLine.Parent = gui
openLine.Size = UDim2.new(0, 550, 0, 6)
openLine.Position = UDim2.new(0.5, 0, 0, 3)
openLine.AnchorPoint = Vector2.new(0.5, 0)
openLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
openLine.BorderSizePixel = 0

Instance.new("UICorner", openLine).CornerRadius = UDim.new(1, 0)
local lineStroke = Instance.new("UIStroke")
lineStroke.Parent = openLine
lineStroke.Thickness = 2

task.spawn(function()
    local hue = 0
    while openLine and openLine.Parent do
        if Config.RainbowBorder then
            lineStroke.Color = Color3.fromHSV(hue, 1, 1)
        else
            lineStroke.Color = Config.ThemeColor
        end
        hue = hue + Config.RainbowSpeed
        if hue >= 1 then hue = 0 end
        RunService.RenderStepped:Wait()
    end
end)

local lineButton = Instance.new("TextButton")
lineButton.Parent = openLine
lineButton.Size = UDim2.fromScale(1, 1)
lineButton.BackgroundTransparency = 1
lineButton.Text = ""
lineButton.AutoButtonColor = false

lineButton.MouseButton1Click:Connect(function()
    ToggleMain()
end)

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Parent = gui
main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Config.BgMain
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Visible = false

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

local currentTween = nil
OpenGUI = function()
    if currentTween then currentTween:Cancel() end
    if not Config.GUIAnimation then
        main.Visible = true
        main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
        main.BackgroundTransparency = 0.05
        return
    end
    
    main.Visible = true
    main.Size = UDim2.new(0, 580, 0, 400)
    main.BackgroundTransparency = 1
    
    currentTween = TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight),
        BackgroundTransparency = 0.05
    })
    currentTween:Play()
end

CloseGUI = function()
    if currentTween then currentTween:Cancel() end
    if not Config.GUIAnimation then
        main.Visible = false
        return
    end
    
    currentTween = TweenService:Create(main, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 580, 0, 400),
        BackgroundTransparency = 1
    })
    currentTween:Play()
    
    task.delay(0.15, function()
        if main and main.BackgroundTransparency >= 0.9 then
            main.Visible = false
            main.Size = UDim2.new(0, Config.MainWidth, 0, Config.MainHeight)
        end
    end)
end

ToggleMain = function()
    if main.Visible and main.BackgroundTransparency < 0.9 then
        CloseGUI()
    else
        OpenGUI()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Config.ToggleKey then
        ToggleMain()
    end
end)

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 1, 0)
title.RichText = true
title.Text = "⚓ <font color='#E0E0E0'>FishHub</font> <font color='#808090'>┆ Script Collection</font>"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Center

local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 45)
line.BackgroundColor3 = Config.BorderColor
line.BorderSizePixel = 0

local content = Instance.new("Frame")
content.Parent = main
content.Position = UDim2.new(0, 0, 0, 47)
content.Size = UDim2.new(1, 0, 1, -90)
content.BackgroundTransparency = 1

local discordBox = Instance.new("Frame")
discordBox.Parent = main
discordBox.Position = UDim2.new(0, 10, 1, -40)
discordBox.Size = UDim2.new(1, -20, 0, 35)
discordBox.BackgroundTransparency = 1
discordBox.ClipsDescendants = true

local avatar = Instance.new("ImageLabel")
avatar.Parent = discordBox
avatar.Size = UDim2.new(0, 26, 0, 26)
avatar.Position = UDim2.new(0, 6, 0.5, -13)
avatar.BackgroundTransparency = 1
avatar.ScaleType = Enum.ScaleType.Fit

task.spawn(function()
    pcall(function()
        if Player and Player.UserId then
            avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end
    end)
end)

local discordText = Instance.new("TextLabel")
discordText.Parent = discordBox
discordText.Size = UDim2.new(0, 900, 1, 0)
discordText.Position = UDim2.new(0, 42, 0, 0)
discordText.BackgroundTransparency = 1
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 13
discordText.TextColor3 = Color3.fromRGB(200, 200, 200)
discordText.RichText = true
discordText.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then executor = identifyexecutor() end
    end)
    local username = Player and Player.Name or "User"
    while gui and gui.Parent do
        discordText.Text = string.format("<font color='#AAAAAA'>⚓ USER:</font> %s  ┆  <font color='#AAAAAA'>⚡ EXECUTOR:</font> %s  ┆  <font color='#AAAAAA'>👑 CRE:</font> DaoHuyLam", username, executor)
        discordText.Position = UDim2.new(1, 10, 0, 0)
        local tween = TweenService:Create(discordText, TweenInfo.new(16, Enum.EasingStyle.Linear), {Position = UDim2.new(0, -700, 0, 0)})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.5)
    end
end)

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Parent = content
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.Size = UDim2.new(0, 190, 1, 0)
sidebar.BackgroundColor3 = Config.BgSidebar
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Parent = sidebar
sidebarStroke.Color = Config.BorderColor
sidebarStroke.Thickness = 1

local pageContainer = Instance.new("Frame")
pageContainer.Parent = content
pageContainer.Position = UDim2.new(0, 195, 0, 0)
pageContainer.Size = UDim2.new(1, -195, 1, 0)
pageContainer.BackgroundTransparency = 1

local Indicator = Instance.new("Frame")
Indicator.Parent = sidebar
Indicator.Size = UDim2.new(0, 3, 0, 38)
Indicator.Position = UDim2.new(0, 2, 0, 20)
Indicator.BackgroundColor3 = Config.ThemeColor
Indicator.BorderSizePixel = 0
Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

local function ClearContent()
    for _, v in ipairs(pageContainer:GetChildren()) do
        v:Destroy()
    end
end

OpenHome = function() ClearContent() end

----------------------------------------------------------------------
-- PHẦN SUPPORT GAME
----------------------------------------------------------------------
OpenSupport = function()
    ClearContent()

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = pageContainer
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 10)
    titleLbl.Size = UDim2.new(1, -30, 0, 25)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = L("SupportTitle")
    titleLbl.TextSize = 18
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local scrollHolder = Instance.new("ScrollingFrame")
    scrollHolder.Parent = pageContainer
    scrollHolder.Position = UDim2.new(0, 15, 0, 40)
    scrollHolder.Size = UDim2.new(1, -25, 1, -50)
    scrollHolder.BackgroundTransparency = 1
    scrollHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollHolder.ScrollBarThickness = 3
    scrollHolder.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = scrollHolder
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 12)

    for _, catData in ipairs(SupportedCategories) do
        local catFrame = Instance.new("Frame")
        catFrame.Parent = scrollHolder
        catFrame.Size = UDim2.new(1, -10, 0, 0)
        catFrame.AutomaticSize = Enum.AutomaticSize.Y
        catFrame.BackgroundColor3 = Config.BgCategory
        catFrame.BorderSizePixel = 0
        Instance.new("UICorner", catFrame).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = catFrame
        stroke.Color = Config.BorderColor
        stroke.Thickness = 1

        local catTitle = Instance.new("TextLabel")
        catTitle.Parent = catFrame
        catTitle.Position = UDim2.new(0, 12, 0, 8)
        catTitle.Size = UDim2.new(1, -24, 0, 20)
        catTitle.BackgroundTransparency = 1
        catTitle.Font = Enum.Font.GothamBold
        catTitle.Text = catData.CategoryName
        catTitle.TextSize = 13
        catTitle.TextColor3 = Config.ThemeColor
        catTitle.TextXAlignment = Enum.TextXAlignment.Left

        local catList = Instance.new("UIListLayout")
        catList.Parent = catFrame
        catList.SortOrder = Enum.SortOrder.LayoutOrder
        catList.Padding = UDim.new(0, 6)

        local pad = Instance.new("UIPadding")
        pad.Parent = catFrame
        pad.PaddingTop = UDim.new(0, 32)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)

        for _, gameData in ipairs(catData.Games) do
            local isCurrentGame = false
            for _, id in ipairs(gameData.PlaceIds) do
                if id == CurrentPlaceId then
                    isCurrentGame = true
                    break
                end
            end

            local isEvomon = (gameData.Name == "Evomon")

            local card = Instance.new("Frame")
            card.Parent = catFrame
            card.Size = UDim2.new(1, 0, 0, 42)
            card.BackgroundColor3 = isCurrentGame and Color3.fromRGB(28, 40, 55) or Config.BgCard
            card.BorderSizePixel = 0
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Parent = card
            cardStroke.Thickness = isCurrentGame and 2 or 1

            if isCurrentGame then
                cardStroke.Color = Config.ThemeColor
                task.spawn(function()
                    local hue = 0
                    while card and card.Parent do
                        if Config.RainbowBorder then
                            cardStroke.Color = Color3.fromHSV(hue, 0.8, 1)
                        else
                            cardStroke.Color = Config.ThemeColor
                        end
                        hue = hue + 0.01
                        if hue >= 1 then hue = 0 end
                        task.wait(0.03)
                    end
                end)
            else
                cardStroke.Color = Config.BorderColor
            end

            local icon = Instance.new("ImageLabel")
            icon.Parent = card
            icon.Size = UDim2.new(0, 26, 0, 26)
            icon.Position = UDim2.new(0, 8, 0.5, -13)
            icon.BackgroundTransparency = 1
            icon.Image = gameData.Icon
            icon.ScaleType = Enum.ScaleType.Fit

            local gameTitle = Instance.new("TextLabel")
            gameTitle.Parent = card
            gameTitle.Position = UDim2.new(0, 42, 0, 0)
            gameTitle.Size = UDim2.new(1, -145, 1, 0)
            gameTitle.BackgroundTransparency = 1
            gameTitle.Font = Enum.Font.GothamBold
            gameTitle.Text = gameData.Name
            gameTitle.TextSize = 13
            gameTitle.TextColor3 = isCurrentGame and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)
            gameTitle.TextXAlignment = Enum.TextXAlignment.Left

            local badgeWidth = isEvomon and 100 or 112
            local badge = Instance.new("Frame")
            badge.Parent = card
            badge.Size = UDim2.new(0, badgeWidth, 0, 22)
            badge.Position = UDim2.new(1, -badgeWidth - 8, 0.5, -11)
            badge.BackgroundColor3 = isEvomon and Color3.fromRGB(20, 60, 35) or Color3.fromRGB(60, 20, 20)
            badge.BorderSizePixel = 0
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

            local circleGreenRed = Instance.new("Frame")
            circleGreenRed.Parent = badge
            circleGreenRed.Size = UDim2.new(0, 8, 0, 8)
            circleGreenRed.Position = UDim2.new(0, 8, 0.5, -4)
            circleGreenRed.BackgroundColor3 = isEvomon and Color3.fromRGB(50, 230, 80) or Color3.fromRGB(230, 50, 50)
            circleGreenRed.BorderSizePixel = 0
            Instance.new("UICorner", circleGreenRed).CornerRadius = UDim.new(1, 0)

            local badgeText = Instance.new("TextLabel")
            badgeText.Parent = badge
            badgeText.Size = UDim2.new(1, -20, 1, 0)
            badgeText.Position = UDim2.new(0, 18, 0, 0)
            badgeText.BackgroundTransparency = 1
            badgeText.Font = Enum.Font.GothamBold
            badgeText.Text = isEvomon and "WORKING" or "NOT WORKING"
            badgeText.TextSize = 9
            badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
            badgeText.TextXAlignment = Enum.TextXAlignment.Center

            task.spawn(function()
                while badge and badge.Parent do
                    TweenService:Create(circleGreenRed, TweenInfo.new(0.6), {BackgroundTransparency = 0.2}):Play()
                    task.wait(0.6)
                    TweenService:Create(circleGreenRed, TweenInfo.new(0.6), {BackgroundTransparency = 0.8}):Play()
                    task.wait(0.6)
                end
            end)
        end
    end
end

----------------------------------------------------------------------
-- CỬA SỔ SETTINGS (BỔ SUNG THÊM NHIỀU MÀU THEME PHONG PHÚ)
----------------------------------------------------------------------
OpenSettings = function()
    ClearContent()

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = pageContainer
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 10)
    titleLbl.Size = UDim2.new(1, -30, 0, 25)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = L("SettingTitle")
    titleLbl.TextSize = 18
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local settingsHolder = Instance.new("ScrollingFrame")
    settingsHolder.Parent = pageContainer
    settingsHolder.Position = UDim2.new(0, 15, 0, 40)
    settingsHolder.Size = UDim2.new(1, -25, 1, -50)
    settingsHolder.BackgroundTransparency = 1
    settingsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsHolder.ScrollBarThickness = 3
    settingsHolder.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = settingsHolder
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 12)

    local function CreateCategory(categoryTitle)
        local categoryFrame = Instance.new("Frame")
        categoryFrame.Parent = settingsHolder
        categoryFrame.Size = UDim2.new(1, -10, 0, 0)
        categoryFrame.AutomaticSize = Enum.AutomaticSize.Y
        categoryFrame.BackgroundColor3 = Config.BgCategory
        categoryFrame.BorderSizePixel = 0
        Instance.new("UICorner", categoryFrame).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke")
        stroke.Parent = categoryFrame
        stroke.Color = Config.BorderColor
        stroke.Thickness = 1

        local catLabel = Instance.new("TextLabel")
        catLabel.Parent = categoryFrame
        catLabel.Position = UDim2.new(0, 12, 0, 8)
        catLabel.Size = UDim2.new(1, -24, 0, 20)
        catLabel.BackgroundTransparency = 1
        catLabel.Font = Enum.Font.GothamBold
        catLabel.Text = categoryTitle
        catLabel.TextSize = 13
        catLabel.TextColor3 = Config.ThemeColor
        catLabel.TextXAlignment = Enum.TextXAlignment.Left

        local catList = Instance.new("UIListLayout")
        catList.Parent = categoryFrame
        catList.SortOrder = Enum.SortOrder.LayoutOrder
        catList.Padding = UDim.new(0, 8)

        local pad = Instance.new("UIPadding")
        pad.Parent = categoryFrame
        pad.PaddingTop = UDim.new(0, 32)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        return categoryFrame
    end

    local function CreateSettingToggle(parent, name, desc, configKey, callback)
        local card = Instance.new("Frame")
        card.Parent = parent
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Config.BgCard
        card.BorderSizePixel = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Parent = card
        nameLbl.Position = UDim2.new(0, 10, 0, 6)
        nameLbl.Size = UDim2.new(1, -85, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = name
        nameLbl.TextSize = 12
        nameLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel")
        descLbl.Parent = card
        descLbl.Position = UDim2.new(0, 10, 0, 24)
        descLbl.Size = UDim2.new(1, -85, 0, 18)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = Enum.Font.Gotham
        descLbl.Text = desc
        descLbl.TextSize = 10
        descLbl.TextColor3 = Color3.fromRGB(140, 140, 150)
        descLbl.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = card
        toggleBtn.Size = UDim2.new(0, 65, 0, 28)
        toggleBtn.Position = UDim2.new(1, -75, 0.5, -14)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        toggleBtn.Text = ""
        toggleBtn.AutoButtonColor = false
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

        local toggleStroke = Instance.new("UIStroke")
        toggleStroke.Parent = toggleBtn
        toggleStroke.Color = Config.BorderColor
        toggleStroke.Thickness = 1

        local dot = Instance.new("Frame")
        dot.Parent = toggleBtn
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 8, 0.5, -4)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local statusText = Instance.new("TextLabel")
        statusText.Parent = toggleBtn
        statusText.Size = UDim2.new(1, -20, 1, 0)
        statusText.Position = UDim2.new(0, 18, 0, 0)
        statusText.BackgroundTransparency = 1
        statusText.Font = Enum.Font.GothamBold
        statusText.TextSize = 10
        statusText.TextXAlignment = Enum.TextXAlignment.Center

        local function updateVisual(isActive)
            if isActive then
                statusText.Text = "ON"
                statusText.TextColor3 = Color3.fromRGB(50, 230, 80)
            else
                statusText.Text = "OFF"
                statusText.TextColor3 = Color3.fromRGB(230, 50, 50)
            end
        end

        updateVisual(Config[configKey])

        task.spawn(function()
            while dot and dot.Parent do
                local active = Config[configKey]
                local targetColor = active and Color3.fromRGB(50, 230, 80) or Color3.fromRGB(230, 50, 50)
                
                TweenService:Create(dot, TweenInfo.new(0.5), {
                    BackgroundColor3 = targetColor,
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 8, 0.5, -5)
                }):Play()
                task.wait(0.5)

                TweenService:Create(dot, TweenInfo.new(0.5), {
                    BackgroundColor3 = active and Color3.fromRGB(20, 140, 50) or Color3.fromRGB(140, 20, 20),
                    Size = UDim2.new(0, 7, 0, 7),
                    Position = UDim2.new(0, 9.5, 0.5, -3.5)
                }):Play()
                task.wait(0.5)
            end
        end)

        toggleBtn.MouseButton1Click:Connect(function()
            Config[configKey] = not Config[configKey]
            updateVisual(Config[configKey])
            if callback then callback(Config[configKey]) end
        end)
    end

    local appearanceCat = CreateCategory(L("CatAppearance"))
    CreateSettingToggle(appearanceCat, L("RainbowToggle"), L("RainbowDesc"), "RainbowBorder")

    ----------------------------------------------------------------------
    -- BẢNG CHỌN THEME ĐÃ BỔ SUNG THÊM NHIỀU MÀU MỚI
    ----------------------------------------------------------------------
    local themeCard = Instance.new("Frame")
    themeCard.Parent = appearanceCat
    themeCard.Size = UDim2.new(1, 0, 0, 48)
    themeCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", themeCard).CornerRadius = UDim.new(0, 8)

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Parent = themeCard
    themeLbl.Position = UDim2.new(0, 10, 0, 6)
    themeLbl.Size = UDim2.new(1, -120, 0, 18)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Font = Enum.Font.GothamBold
    themeLbl.Text = L("ThemeTitle")
    themeLbl.TextSize = 12
    themeLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left

    local themeDesc = Instance.new("TextLabel")
    themeDesc.Parent = themeCard
    themeDesc.Position = UDim2.new(0, 10, 0, 24)
    themeDesc.Size = UDim2.new(1, -120, 0, 18)
    themeDesc.BackgroundTransparency = 1
    themeDesc.Font = Enum.Font.Gotham
    themeDesc.Text = L("ThemeDesc")
    themeDesc.TextSize = 10
    themeDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    themeDesc.TextXAlignment = Enum.TextXAlignment.Left

    local themeToggleBtn = Instance.new("TextButton")
    themeToggleBtn.Parent = themeCard
    themeToggleBtn.Size = UDim2.new(0, 100, 0, 28)
    themeToggleBtn.Position = UDim2.new(1, -110, 0.5, -14)
    themeToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    themeToggleBtn.Text = "🎨 Select Color"
    themeToggleBtn.Font = Enum.Font.GothamBold
    themeToggleBtn.TextSize = 10
    themeToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", themeToggleBtn).CornerRadius = UDim.new(0, 6)

    local themeToggleStroke = Instance.new("UIStroke")
    themeToggleStroke.Parent = themeToggleBtn
    themeToggleStroke.Color = Config.BorderColor
    themeToggleStroke.Thickness = 1

    local themeDropdown = Instance.new("Frame")
    themeDropdown.Parent = appearanceCat
    themeDropdown.Size = UDim2.new(1, 0, 0, 0)
    themeDropdown.AutomaticSize = Enum.AutomaticSize.Y
    themeDropdown.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    themeDropdown.Visible = false
    Instance.new("UICorner", themeDropdown).CornerRadius = UDim.new(0, 8)

    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Parent = themeDropdown
    dropdownStroke.Color = Config.BorderColor
    dropdownStroke.Thickness = 1

    local dropdownGrid = Instance.new("UIGridLayout")
    dropdownGrid.Parent = themeDropdown
    dropdownGrid.CellSize = UDim2.new(0, 70, 0, 52)
    dropdownGrid.CellPadding = UDim2.new(0, 8, 0, 8)
    dropdownGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local dropdownPad = Instance.new("UIPadding")
    dropdownPad.Parent = themeDropdown
    dropdownPad.PaddingTop = UDim.new(0, 10)
    dropdownPad.PaddingBottom = UDim.new(0, 10)
    dropdownPad.PaddingLeft = UDim.new(0, 10)
    dropdownPad.PaddingRight = UDim.new(0, 10)

    -- Đã mở rộng danh sách thêm nhiều màu theme sắc nét khác nhau tại đây
    local themeList = {
        { Name = "Cyan Neon", Color = Color3.fromRGB(0, 229, 255) },
        { Name = "Royal Blue", Color = Color3.fromRGB(0, 150, 255) },
        { Name = "Deep Ocean", Color = Color3.fromRGB(10, 80, 200) },
        { Name = "Emerald", Color = Color3.fromRGB(50, 215, 75) },
        { Name = "Mint Green", Color = Color3.fromRGB(74, 222, 128) },
        { Name = "Purple", Color = Color3.fromRGB(168, 85, 247) },
        { Name = "Lavender", Color = Color3.fromRGB(192, 132, 252) },
        { Name = "Pink Neon", Color = Color3.fromRGB(236, 72, 153) },
        { Name = "Rose Pink", Color = Color3.fromRGB(251, 113, 133) },
        { Name = "Ruby Red", Color = Color3.fromRGB(255, 75, 75) },
        { Name = "Fire Orange", Color = Color3.fromRGB(255, 159, 10) },
        { Name = "Sunset Orange", Color = Color3.fromRGB(249, 115, 22) },
        { Name = "Gold Yellow", Color = Color3.fromRGB(255, 215, 0) },
        { Name = "Cyber Yellow", Color = Color3.fromRGB(234, 179, 8) },
        { Name = "Pure White", Color = Color3.fromRGB(255, 255, 255) },
        { Name = "Silver Gray", Color = Color3.fromRGB(156, 163, 175) }
    }

    for _, item in ipairs(themeList) do
        local colorItemFrame = Instance.new("Frame")
        colorItemFrame.Parent = themeDropdown
        colorItemFrame.BackgroundTransparency = 1
        colorItemFrame.Size = UDim2.new(0, 70, 0, 52)

        local colBtn = Instance.new("TextButton")
        colBtn.Parent = colorItemFrame
        colBtn.Size = UDim2.new(0, 32, 0, 32)
        colBtn.Position = UDim2.new(0.5, -16, 0, 0)
        colBtn.BackgroundColor3 = item.Color
        colBtn.Text = ""
        colBtn.AutoButtonColor = false
        Instance.new("UICorner", colBtn).CornerRadius = UDim.new(1, 0)

        local nameText = Instance.new("TextLabel")
        nameText.Parent = colorItemFrame
        nameText.Size = UDim2.new(1, 0, 0, 16)
        nameText.Position = UDim2.new(0, 0, 0, 34)
        nameText.BackgroundTransparency = 1
        nameText.Font = Enum.Font.GothamBold
        nameText.Text = item.Name
        nameText.TextSize = 9
        nameText.TextColor3 = Color3.fromRGB(180, 180, 190)
        nameText.TextXAlignment = Enum.TextXAlignment.Center

        colBtn.MouseButton1Click:Connect(function()
            Config.ThemeColor = item.Color
            themeDropdown.Visible = false
            RefreshUI()
        end)
    end

    themeToggleBtn.MouseButton1Click:Connect(function()
        themeDropdown.Visible = not themeDropdown.Visible
    end)

    CreateSettingToggle(appearanceCat, L("AnimToggle"), L("AnimDesc"), "GUIAnimation")

    local systemCat = CreateCategory(L("CatSystem"))
    CreateSettingToggle(systemCat, L("DebugToggle"), L("DebugDesc"), "ShowDebug", function(val)
        debugFrame.Visible = val
    end)

    local keyCard = Instance.new("Frame")
    keyCard.Parent = systemCat
    keyCard.Size = UDim2.new(1, 0, 0, 48)
    keyCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 8)

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Parent = keyCard
    keyLbl.Position = UDim2.new(0, 10, 0, 6)
    keyLbl.Size = UDim2.new(1, -110, 0, 18)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.Text = L("KeybindTitle")
    keyLbl.TextSize = 12
    keyLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyDesc = Instance.new("TextLabel")
    keyDesc.Parent = keyCard
    keyDesc.Position = UDim2.new(0, 10, 0, 24)
    keyDesc.Size = UDim2.new(1, -110, 0, 18)
    keyDesc.BackgroundTransparency = 1
    keyDesc.Font = Enum.Font.Gotham
    keyDesc.Text = L("KeybindDesc")
    keyDesc.TextSize = 10
    keyDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    keyDesc.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = Instance.new("TextButton")
    keyBtn.Parent = keyCard
    keyBtn.Size = UDim2.new(0, 90, 0, 24)
    keyBtn.Position = UDim2.new(1, -100, 0.5, -12)
    keyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    keyBtn.Text = Config.ToggleKey.Name
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    keyBtn.MouseButton1Click:Connect(function()
        keyBtn.Text = L("PressKey")
        keyBtn.BackgroundColor3 = Config.ThemeColor
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Config.ToggleKey = input.KeyCode
                keyBtn.Text = input.KeyCode.Name
                keyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                conn:Disconnect()
            end
        end)
    end)

    local langCard = Instance.new("Frame")
    langCard.Parent = systemCat
    langCard.Size = UDim2.new(1, 0, 0, 48)
    langCard.BackgroundColor3 = Config.BgCard
    Instance.new("UICorner", langCard).CornerRadius = UDim.new(0, 8)

    local langLbl = Instance.new("TextLabel")
    langLbl.Parent = langCard
    langLbl.Position = UDim2.new(0, 10, 0, 6)
    langLbl.Size = UDim2.new(1, -110, 0, 18)
    langLbl.BackgroundTransparency = 1
    langLbl.Font = Enum.Font.GothamBold
    langLbl.Text = L("LangToggle")
    langLbl.TextSize = 12
    langLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    langLbl.TextXAlignment = Enum.TextXAlignment.Left

    local langDesc = Instance.new("TextLabel")
    langDesc.Parent = langCard
    langDesc.Position = UDim2.new(0, 10, 0, 24)
    langDesc.Size = UDim2.new(1, -110, 0, 18)
    langDesc.BackgroundTransparency = 1
    langDesc.Font = Enum.Font.Gotham
    langDesc.Text = L("LangDesc")
    langDesc.TextSize = 10
    langDesc.TextColor3 = Color3.fromRGB(140, 140, 150)
    langDesc.TextXAlignment = Enum.TextXAlignment.Left

    local langBtn = Instance.new("TextButton")
    langBtn.Parent = langCard
    langBtn.Size = UDim2.new(0, 90, 0, 24)
    langBtn.Position = UDim2.new(1, -100, 0.5, -12)
    langBtn.BackgroundColor3 = Config.ThemeColor
    langBtn.Text = Config.Language == "EN" and "ENGLISH" or "TIẾNG VIỆT"
    langBtn.Font = Enum.Font.GothamBold
    langBtn.TextSize = 10
    langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)

    langBtn.MouseButton1Click:Connect(function()
        Config.Language = (Config.Language == "EN") and "VN" or "EN"
        RefreshUI()
    end)

    local actionCat = CreateCategory(L("CatActions"))

    local gridFrame = Instance.new("Frame")
    gridFrame.Parent = actionCat
    gridFrame.Size = UDim2.new(1, 0, 0, 65)
    gridFrame.BackgroundTransparency = 1

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = gridFrame
    gridLayout.CellSize = UDim2.new(0.48, 0, 0, 28)
    gridLayout.CellPadding = UDim2.new(0.03, 0, 0, 6)

    local function CreateActionButton(btnText, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = gridFrame
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        btn.Text = btnText
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Parent = btn
        btnStroke.Color = Config.BorderColor
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(callback)
    end

    CreateActionButton(L("RejoinBtn"), function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
        end)
    end)

    CreateActionButton(L("HopBtn"), function()
        pcall(function()
            local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local body = game:GetService("HttpService"):JSONDecode(req)
            if body and body.data then
                for _, s in ipairs(body.data) do
                    if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                        break
                    end
                end
            end
        end)
    end)

    CreateActionButton(L("CopyDiscordBtn"), function()
        pcall(function()
            if setclipboard then setclipboard("https://discord.gg/2tTJxRk2ct") end
        end)
    end)

    CreateActionButton(L("RefreshUIBtn"), function()
        RefreshUI()
    end)
end

local SideButtons = {}

local function CreateSideButton(textKey, y, image)
    local btn = Instance.new("TextButton")
    btn.Parent = sidebar
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.Position = UDim2.new(0, 8, 0, y)
    btn.BackgroundColor3 = Config.BgSidebarBtn
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        if CurrentButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtnHover}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentButton ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtn}):Play()
        end
    end)

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Parent = btn
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.Position = UDim2.new(0, 8, 0.5, -2.5)
    dot.BackgroundColor3 = Config.ThemeColor
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local icon = Instance.new("ImageLabel")
    icon.Parent = btn
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 18, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = image
    icon.ImageColor3 = Color3.fromRGB(200, 200, 215)
    icon.ScaleType = Enum.ScaleType.Fit

    local lbl = Instance.new("TextLabel")
    lbl.Parent = btn
    lbl.Name = "Label"
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 42, 0, 0)
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Text = L(textKey)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11.5
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(SideButtons, {Button = btn, Key = textKey, Dot = dot, Icon = icon, Label = lbl})
    return btn
end

local HomeBtn = CreateSideButton("Home", 18, "rbxassetid://108029482244357")
local SupportBtn = CreateSideButton("Support", 64, "rbxassetid://86514728032684")
local SettingBtn = CreateSideButton("Setting", 110, "rbxassetid://99627454901549")

local function SelectButton(btn)
    if CurrentButton == btn then return end
    
    if CurrentButton then
        TweenService:Create(CurrentButton, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtn}):Play()
        for _, item in ipairs(SideButtons) do
            if item.Button == CurrentButton then
                TweenService:Create(item.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 230)}):Play()
            end
        end
    end

    CurrentButton = btn
    
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.BgSidebarBtnHover}):Play()
    for _, item in ipairs(SideButtons) do
        if item.Button == btn then
            TweenService:Create(item.Label, TweenInfo.new(0.2), {TextColor3 = Config.ThemeColor}):Play()
        end
    end

    TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0, btn.Position.Y.Offset)}):Play()
end

HomeBtn.MouseButton1Click:Connect(function() SelectButton(HomeBtn); OpenHome() end)
SupportBtn.MouseButton1Click:Connect(function() SelectButton(SupportBtn); OpenSupport() end)
SettingBtn.MouseButton1Click:Connect(function() SelectButton(SettingBtn); OpenSettings() end)

RefreshUI = function()
    Indicator.BackgroundColor3 = Config.ThemeColor
    sidebar.BackgroundColor3 = Config.BgSidebar
    sidebarStroke.Color = Config.BorderColor

    for _, item in ipairs(SideButtons) do
        item.Button.Label.Text = L(item.Key)
        if item.Dot then
            item.Dot.BackgroundColor3 = Config.ThemeColor
        end
        if CurrentButton == item.Button then
            item.Label.TextColor3 = Config.ThemeColor
        end
    end

    if CurrentButton == HomeBtn then OpenHome()
    elseif CurrentButton == SupportBtn then OpenSupport()
    elseif CurrentButton == SettingBtn then OpenSettings() end
end

local function CreateCircleButton(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Parent = main
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = UDim2.new(1, -xOffset, 0, 8)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local closeBtn = CreateCircleButton("×", 12)
local hideBtn  = CreateCircleButton("─", 44)

local confirm = Instance.new("Frame")
confirm.Parent = gui
confirm.Size = UDim2.new(0, 300, 0, 130)
confirm.Position = UDim2.new(0.5, 0, 0.5, 0)
confirm.AnchorPoint = Vector2.new(0.5, 0.5)
confirm.BackgroundColor3 = Config.BgMain
confirm.Visible = false
confirm.BorderSizePixel = 0
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)

local confirmStroke = Instance.new("UIStroke")
confirmStroke.Parent = confirm
confirmStroke.Color = Config.BorderColor
confirmStroke.Thickness = 1

local txt = Instance.new("TextLabel")
txt.Parent = confirm
txt.Size = UDim2.new(1, -20, 0, 40)
txt.Position = UDim2.new(0, 10, 0, 15)
txt.BackgroundTransparency = 1
txt.Font = Enum.Font.GothamBold
txt.TextSize = 13
txt.TextColor3 = Color3.fromRGB(240, 240, 240)
txt.TextWrapped = true

local yes = Instance.new("TextButton")
yes.Parent = confirm
yes.Size = UDim2.new(0.38, 0, 0, 30)
yes.Position = UDim2.new(0.08, 0, 1, -40)
yes.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
yes.TextColor3 = Color3.new(1, 1, 1)
yes.Font = Enum.Font.GothamBold
yes.TextSize = 12
Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 6)

local no = Instance.new("TextButton")
no.Parent = confirm
no.Size = UDim2.new(0.38, 0, 0, 30)
no.Position = UDim2.new(0.54, 0, 1, -40)
no.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
no.TextColor3 = Color3.new(1, 1, 1)
no.Font = Enum.Font.GothamBold
no.TextSize = 12
Instance.new("UICorner", no).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    txt.Text = L("CloseConfirm")
    yes.Text = L("Yes")
    no.Text = L("No")
    confirm.Visible = true
end)

yes.MouseButton1Click:Connect(function() gui:Destroy() end)
no.MouseButton1Click:Connect(function() confirm.Visible = false end)
hideBtn.MouseButton1Click:Connect(function() CloseGUI() end)

SelectButton(HomeBtn)
OpenHome()
OpenGUI()
