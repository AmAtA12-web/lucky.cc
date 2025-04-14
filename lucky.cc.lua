local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Цветовая схема
local COLORS = {
    background = Color3.fromRGB(40, 40, 40),
    header = Color3.fromRGB(76, 118, 186),
    accent = Color3.fromRGB(76, 118, 186),
    text = Color3.fromRGB(255, 255, 255),
    disabled = Color3.fromRGB(100, 100, 100),
    tab_selected = Color3.fromRGB(60, 60, 60),
    tab_unselected = Color3.fromRGB(30, 30, 30)
}

local player = Players.LocalPlayer
local bubbleRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote")
local pickupRemote = nil

-- Конфиг окна
local config = {
    width = 600,
    height = 425,
    cornerRadius = 12
}

-- Проверка ремоута для автофарма
local function checkPickupRemote()
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup", 5)
    end)
    if success and remote then
        pickupRemote = remote
        print("Pickup remote found")
        return true
    else
        warn("Pickup remote not found!")
        return false
    end
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckyCC"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, config.width, 0, config.height)
MainFrame.Position = UDim2.new(0.5, -config.width / 2, 0.5, -config.height / 2)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, config.cornerRadius)
UICorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = COLORS.header
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, config.cornerRadius)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Text = "lucky.cc"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = COLORS.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопки управления
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -61, 0.5, -12)
MinimizeButton.BackgroundColor3 = COLORS.accent
MinimizeButton.TextColor3 = COLORS.text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

local MinimizeButtonCorner = Instance.new("UICorner")
MinimizeButtonCorner.CornerRadius = UDim.new(0, 6)
MinimizeButtonCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "×"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -31, 0.5, -12)
CloseButton.BackgroundColor3 = COLORS.accent
CloseButton.TextColor3 = COLORS.text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

-- Боковая панель
local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 50, 1, -30)
TabPanel.Position = UDim2.new(0, 0, 0, 30)
TabPanel.BackgroundColor3 = COLORS.tab_unselected
TabPanel.Parent = MainFrame

local TabPanelCorner = Instance.new("UICorner")
TabPanelCorner.CornerRadius = UDim.new(0, config.cornerRadius)
TabPanelCorner.Parent = TabPanel

-- Контейнер вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -50, 1, -30)
ContentFrame.Position = UDim2.new(0, 50, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Вкладки
local HomeTab = Instance.new("Frame")
HomeTab.Size = UDim2.new(1, 0, 1, 0)
HomeTab.BackgroundTransparency = 1
HomeTab.Visible = true
HomeTab.Parent = ContentFrame

local FarmTab = Instance.new("Frame")
FarmTab.Size = UDim2.new(1, 0, 1, 0)
FarmTab.BackgroundTransparency = 1
FarmTab.Visible = false
FarmTab.Parent = ContentFrame

local MiscTab = Instance.new("Frame")
MiscTab.Size = UDim2.new(1, 0, 1, 0)
MiscTab.BackgroundTransparency = 1
MiscTab.Visible = false
MiscTab.Parent = ContentFrame

local TeleportTab = Instance.new("Frame")
TeleportTab.Size = UDim2.new(1, 0, 1, 0)
TeleportTab.BackgroundTransparency = 1
TeleportTab.Visible = false
TeleportTab.Parent = ContentFrame

local FPSTab = Instance.new("Frame")
FPSTab.Size = UDim2.new(1, 0, 1, 0)
FPSTab.BackgroundTransparency = 1
FPSTab.Visible = false
FPSTab.Parent = ContentFrame

-- Кнопки вкладок
local HomeTabButton = Instance.new("TextButton")
HomeTabButton.Size = UDim2.new(1, 0, 0, 25)
HomeTabButton.Position = UDim2.new(0, 0, 0, 30)
HomeTabButton.BackgroundColor3 = COLORS.tab_selected
HomeTabButton.Text = "Home"
HomeTabButton.TextColor3 = COLORS.text
HomeTabButton.Font = Enum.Font.GothamBold
HomeTabButton.TextSize = 12
HomeTabButton.Parent = TabPanel

local HomeTabIndicator = Instance.new("Frame")
HomeTabIndicator.Size = UDim2.new(0, 4, 1, 0)
HomeTabIndicator.Position = UDim2.new(0, 0, 0, 0)
HomeTabIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
HomeTabIndicator.BorderSizePixel = 0
HomeTabIndicator.Visible = true
HomeTabIndicator.Parent = HomeTabButton

local FarmTabButton = Instance.new("TextButton")
FarmTabButton.Size = UDim2.new(1, 0, 0, 25)
FarmTabButton.Position = UDim2.new(0, 0, 0, 55)
FarmTabButton.BackgroundColor3 = COLORS.tab_unselected
FarmTabButton.Text = "Farm"
FarmTabButton.TextColor3 = COLORS.text
FarmTabButton.Font = Enum.Font.GothamBold
FarmTabButton.TextSize = 12
FarmTabButton.Parent = TabPanel

local FarmTabIndicator = Instance.new("Frame")
FarmTabIndicator.Size = UDim2.new(0, 4, 1, 0)
FarmTabIndicator.Position = UDim2.new(0, 0, 0, 0)
FarmTabIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FarmTabIndicator.BorderSizePixel = 0
FarmTabIndicator.Visible = false
FarmTabIndicator.Parent = FarmTabButton

local MiscTabButton = Instance.new("TextButton")
MiscTabButton.Size = UDim2.new(1, 0, 0, 25)
MiscTabButton.Position = UDim2.new(0, 0, 0, 80)
MiscTabButton.BackgroundColor3 = COLORS.tab_unselected
MiscTabButton.Text = "Misc"
MiscTabButton.TextColor3 = COLORS.text
MiscTabButton.Font = Enum.Font.GothamBold
MiscTabButton.TextSize = 12
MiscTabButton.Parent = TabPanel

local MiscTabIndicator = Instance.new("Frame")
MiscTabIndicator.Size = UDim2.new(0, 4, 1, 0)
MiscTabIndicator.Position = UDim2.new(0, 0, 0, 0)
MiscTabIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MiscTabIndicator.BorderSizePixel = 0
MiscTabIndicator.Visible = false
MiscTabIndicator.Parent = MiscTabButton

local TeleportTabButton = Instance.new("TextButton")
TeleportTabButton.Size = UDim2.new(1, 0, 0, 25)
TeleportTabButton.Position = UDim2.new(0, 0, 0, 105)
TeleportTabButton.BackgroundColor3 = COLORS.tab_unselected
TeleportTabButton.Text = "Teleport"
TeleportTabButton.TextColor3 = COLORS.text
TeleportTabButton.Font = Enum.Font.GothamBold
TeleportTabButton.TextSize = 12
TeleportTabButton.Parent = TabPanel

local TeleportTabIndicator = Instance.new("Frame")
TeleportTabIndicator.Size = UDim2.new(0, 4, 1, 0)
TeleportTabIndicator.Position = UDim2.new(0, 0, 0, 0)
TeleportTabIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TeleportTabIndicator.BorderSizePixel = 0
TeleportTabIndicator.Visible = false
TeleportTabIndicator.Parent = TeleportTabButton

local FPSTabButton = Instance.new("TextButton")
FPSTabButton.Size = UDim2.new(1, 0, 0, 25)
FPSTabButton.Position = UDim2.new(0, 0, 0, 130)
FPSTabButton.BackgroundColor3 = COLORS.tab_unselected
FPSTabButton.Text = "FPS"
FPSTabButton.TextColor3 = COLORS.text
FPSTabButton.Font = Enum.Font.GothamBold
FPSTabButton.TextSize = 12
FPSTabButton.Parent = TabPanel

local FPSTabIndicator = Instance.new("Frame")
FPSTabIndicator.Size = UDim2.new(0, 4, 1, 0)
FPSTabIndicator.Position = UDim2.new(0, 0, 0, 0)
FPSTabIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FPSTabIndicator.BorderSizePixel = 0
FPSTabIndicator.Visible = false
FPSTabIndicator.Parent = FPSTabButton

-- Вкладка Home: WalkSpeed Slider
local WalkSpeedFrame = Instance.new("Frame")
WalkSpeedFrame.Size = UDim2.new(1, -20, 0, 50)
WalkSpeedFrame.Position = UDim2.new(0, 10, 0, 10)
WalkSpeedFrame.BackgroundTransparency = 1
WalkSpeedFrame.Parent = HomeTab

local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Text = "WalkSpeed: 16"
WalkSpeedLabel.Size = UDim2.new(1, 0, 0, 20)
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.TextColor3 = COLORS.text
WalkSpeedLabel.Font = Enum.Font.Gotham
WalkSpeedLabel.TextSize = 14
WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
WalkSpeedLabel.Parent = WalkSpeedFrame

local WalkSpeedSliderTrack = Instance.new("TextButton")
WalkSpeedSliderTrack.Size = UDim2.new(1, 0, 0, 6)
WalkSpeedSliderTrack.Position = UDim2.new(0, 0, 0, 30)
WalkSpeedSliderTrack.BackgroundColor3 = COLORS.disabled
WalkSpeedSliderTrack.Text = ""
WalkSpeedSliderTrack.Parent = WalkSpeedFrame

local WalkSpeedTrackCorner = Instance.new("UICorner")
WalkSpeedTrackCorner.CornerRadius = UDim.new(1, 0)
WalkSpeedTrackCorner.Parent = WalkSpeedSliderTrack

local WalkSpeedSliderFill = Instance.new("Frame")
WalkSpeedSliderFill.Size = UDim2.new(0.032, 0, 1, 0)
WalkSpeedSliderFill.BackgroundColor3 = COLORS.accent
WalkSpeedSliderFill.Parent = WalkSpeedSliderTrack

local WalkSpeedFillCorner = Instance.new("UICorner")
WalkSpeedFillCorner.CornerRadius = UDim.new(1, 0)
WalkSpeedFillCorner.Parent = WalkSpeedSliderFill

local WalkSpeedSliderButton = Instance.new("TextButton")
WalkSpeedSliderButton.Size = UDim2.new(0, 16, 0, 16)
WalkSpeedSliderButton.Position = UDim2.new(0.032, -8, 0.5, -8)
WalkSpeedSliderButton.BackgroundColor3 = COLORS.text
WalkSpeedSliderButton.Text = ""
WalkSpeedSliderButton.Parent = WalkSpeedSliderTrack

local WalkSpeedSliderButtonCorner = Instance.new("UICorner")
WalkSpeedSliderButtonCorner.CornerRadius = UDim.new(1, 0)
WalkSpeedSliderButtonCorner.Parent = WalkSpeedSliderButton

-- Вкладка Home: Infinite Jump Toggle
local InfiniteJumpFrame = Instance.new("Frame")
InfiniteJumpFrame.Size = UDim2.new(1, -20, 0, 30)
InfiniteJumpFrame.Position = UDim2.new(0, 10, 0, 70)
InfiniteJumpFrame.BackgroundTransparency = 1
InfiniteJumpFrame.Parent = HomeTab

local InfiniteJumpToggle = Instance.new("TextButton")
InfiniteJumpToggle.Size = UDim2.new(0, 22, 0, 22)
InfiniteJumpToggle.Position = UDim2.new(0, 0, 0.5, -11)
InfiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
InfiniteJumpToggle.Text = ""
InfiniteJumpToggle.Parent = InfiniteJumpFrame

local InfiniteJumpLabel = Instance.new("TextLabel")
InfiniteJumpLabel.Text = "Infinite Jump"
InfiniteJumpLabel.Size = UDim2.new(1, -30, 1, 0)
InfiniteJumpLabel.Position = UDim2.new(0, 30, 0, 0)
InfiniteJumpLabel.BackgroundTransparency = 1
InfiniteJumpLabel.TextColor3 = COLORS.text
InfiniteJumpLabel.Font = Enum.Font.Gotham
InfiniteJumpLabel.TextSize = 14
InfiniteJumpLabel.TextXAlignment = Enum.TextXAlignment.Left
InfiniteJumpLabel.Parent = InfiniteJumpFrame

-- Вкладка Farm: Auto Blow Bubble
local AutoBubbleFrame = Instance.new("Frame")
AutoBubbleFrame.Size = UDim2.new(1, -20, 0, 30)
AutoBubbleFrame.Position = UDim2.new(0, 10, 0, 10)
AutoBubbleFrame.BackgroundTransparency = 1
AutoBubbleFrame.Parent = FarmTab

local AutoBubbleToggle = Instance.new("TextButton")
AutoBubbleToggle.Size = UDim2.new(0, 22, 0, 22)
AutoBubbleToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoBubbleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoBubbleToggle.Text = ""
AutoBubbleToggle.Parent = AutoBubbleFrame

local AutoBubbleLabel = Instance.new("TextLabel")
AutoBubbleLabel.Text = "Auto Blow Bubble"
AutoBubbleLabel.Size = UDim2.new(1, -30, 1, 0)
AutoBubbleLabel.Position = UDim2.new(0, 30, 0, 0)
AutoBubbleLabel.BackgroundTransparency = 1
AutoBubbleLabel.TextColor3 = COLORS.text
AutoBubbleLabel.Font = Enum.Font.Gotham
AutoBubbleLabel.TextSize = 14
AutoBubbleLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoBubbleLabel.Parent = AutoBubbleFrame

-- Вкладка Farm: Frequency Slider
local FrequencyFrame = Instance.new("Frame")
FrequencyFrame.Size = UDim2.new(1, -20, 0, 50)
FrequencyFrame.Position = UDim2.new(0, 10, 0, 50)
FrequencyFrame.BackgroundTransparency = 1
FrequencyFrame.Parent = FarmTab

local FrequencyLabel = Instance.new("TextLabel")
FrequencyLabel.Text = "Frequency: 0.5s"
FrequencyLabel.Size = UDim2.new(1, 0, 0, 20)
FrequencyLabel.BackgroundTransparency = 1
FrequencyLabel.TextColor3 = COLORS.text
FrequencyLabel.Font = Enum.Font.Gotham
FrequencyLabel.TextSize = 14
FrequencyLabel.TextXAlignment = Enum.TextXAlignment.Left
FrequencyLabel.Parent = FrequencyFrame

local SliderTrack = Instance.new("TextButton")
SliderTrack.Size = UDim2.new(1, 0, 0, 6)
SliderTrack.Position = UDim2.new(0, 0, 0, 30)
SliderTrack.BackgroundColor3 = COLORS.disabled
SliderTrack.Text = ""
SliderTrack.Parent = FrequencyFrame

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = COLORS.accent
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Position = UDim2.new(0.5, -8, 0.5, -8)
SliderButton.BackgroundColor3 = COLORS.text
SliderButton.Text = ""
SliderButton.Parent = SliderTrack

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(1, 0)
SliderButtonCorner.Parent = SliderButton

-- Вкладка Farm: Auto Sell Bubble
local AutoSellFrame = Instance.new("Frame")
AutoSellFrame.Size = UDim2.new(1, -20, 0, 30)
AutoSellFrame.Position = UDim2.new(0, 10, 0, 110)
AutoSellFrame.BackgroundTransparency = 1
AutoSellFrame.Parent = FarmTab

local AutoSellToggle = Instance.new("TextButton")
AutoSellToggle.Size = UDim2.new(0, 22, 0, 22)
AutoSellToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoSellToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoSellToggle.Text = ""
AutoSellToggle.Parent = AutoSellFrame

local AutoSellLabel = Instance.new("TextLabel")
AutoSellLabel.Text = "Auto Sell Bubble"
AutoSellLabel.Size = UDim2.new(1, -30, 1, 0)
AutoSellLabel.Position = UDim2.new(0, 30, 0, 0)
AutoSellLabel.BackgroundTransparency = 1
AutoSellLabel.TextColor3 = COLORS.text
AutoSellLabel.Font = Enum.Font.Gotham
AutoSellLabel.TextSize = 14
AutoSellLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoSellLabel.Parent = AutoSellFrame

-- Вкладка Farm: Auto Farm Toggle
local AutoFarmFrame = Instance.new("Frame")
AutoFarmFrame.Size = UDim2.new(1, -20, 0, 30)
AutoFarmFrame.Position = UDim2.new(0, 10, 0, 150)
AutoFarmFrame.BackgroundTransparency = 1
AutoFarmFrame.Parent = FarmTab

local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 22, 0, 22)
AutoFarmToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoFarmToggle.Text = ""
AutoFarmToggle.Parent = AutoFarmFrame

local AutoFarmLabel = Instance.new("TextLabel")
AutoFarmLabel.Text = "Auto Farm"
AutoFarmLabel.Size = UDim2.new(1, -30, 1, 0)
AutoFarmLabel.Position = UDim2.new(0, 30, 0, 0)
AutoFarmLabel.BackgroundTransparency = 1
AutoFarmLabel.TextColor3 = COLORS.text
AutoFarmLabel.Font = Enum.Font.Gotham
AutoFarmLabel.TextSize = 14
AutoFarmLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoFarmLabel.Parent = AutoFarmFrame

-- Вкладка Farm: Collect Delay Slider
local CollectDelayFrame = Instance.new("Frame")
CollectDelayFrame.Size = UDim2.new(1, -20, 0, 50)
CollectDelayFrame.Position = UDim2.new(0, 10, 0, 190)
CollectDelayFrame.BackgroundTransparency = 1
CollectDelayFrame.Parent = FarmTab

local CollectDelayLabel = Instance.new("TextLabel")
CollectDelayLabel.Text = "Collect Delay: 0.1s"
CollectDelayLabel.Size = UDim2.new(1, 0, 0, 20)
CollectDelayLabel.BackgroundTransparency = 1
CollectDelayLabel.TextColor3 = COLORS.text
CollectDelayLabel.Font = Enum.Font.Gotham
CollectDelayLabel.TextSize = 14
CollectDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
CollectDelayLabel.Parent = CollectDelayFrame

local CollectDelaySliderTrack = Instance.new("TextButton")
CollectDelaySliderTrack.Size = UDim2.new(1, 0, 0, 6)
CollectDelaySliderTrack.Position = UDim2.new(0, 0, 0, 30)
CollectDelaySliderTrack.BackgroundColor3 = COLORS.disabled
CollectDelaySliderTrack.Text = ""
CollectDelaySliderTrack.Parent = CollectDelayFrame

local CollectDelayTrackCorner = Instance.new("UICorner")
CollectDelayTrackCorner.CornerRadius = UDim.new(1, 0)
CollectDelayTrackCorner.Parent = CollectDelaySliderTrack

local CollectDelaySliderFill = Instance.new("Frame")
CollectDelaySliderFill.Size = UDim2.new(0, 0, 1, 0)
CollectDelaySliderFill.BackgroundColor3 = COLORS.accent
CollectDelaySliderFill.Parent = CollectDelaySliderTrack

local CollectDelayFillCorner = Instance.new("UICorner")
CollectDelayFillCorner.CornerRadius = UDim.new(1, 0)
CollectDelayFillCorner.Parent = CollectDelaySliderFill

local CollectDelaySliderButton = Instance.new("TextButton")
CollectDelaySliderButton.Size = UDim2.new(0, 16, 0, 16)
CollectDelaySliderButton.Position = UDim2.new(0, -8, 0.5, -8)
CollectDelaySliderButton.BackgroundColor3 = COLORS.text
CollectDelaySliderButton.Text = ""
CollectDelaySliderButton.Parent = CollectDelaySliderTrack

local CollectDelaySliderButtonCorner = Instance.new("UICorner")
CollectDelaySliderButtonCorner.CornerRadius = UDim.new(1, 0)
CollectDelaySliderButtonCorner.Parent = CollectDelaySliderButton

-- Вкладка Misc: Auto Collect Playtime
local AutoCollectFrame = Instance.new("Frame")
AutoCollectFrame.Size = UDim2.new(1, -20, 0, 30)
AutoCollectFrame.Position = UDim2.new(0, 10, 0, 10)
AutoCollectFrame.BackgroundTransparency = 1
AutoCollectFrame.Parent = MiscTab

local AutoCollectToggle = Instance.new("TextButton")
AutoCollectToggle.Size = UDim2.new(0, 22, 0, 22)
AutoCollectToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoCollectToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoCollectToggle.Text = ""
AutoCollectToggle.Parent = AutoCollectFrame

local AutoCollectLabel = Instance.new("TextLabel")
AutoCollectLabel.Text = "Auto Collect Playtime"
AutoCollectLabel.Size = UDim2.new(1, -30, 1, 0)
AutoCollectLabel.Position = UDim2.new(0, 30, 0, 0)
AutoCollectLabel.BackgroundTransparency = 1
AutoCollectLabel.TextColor3 = COLORS.text
AutoCollectLabel.Font = Enum.Font.Gotham
AutoCollectLabel.TextSize = 14
AutoCollectLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoCollectLabel.Parent = AutoCollectFrame

-- Вкладка Misc: Golden Chest Highlight
local GoldenChestHighlightFrame = Instance.new("Frame")
GoldenChestHighlightFrame.Size = UDim2.new(1, -20, 0, 30)
GoldenChestHighlightFrame.Position = UDim2.new(0, 10, 0, 50)
GoldenChestHighlightFrame.BackgroundTransparency = 1
GoldenChestHighlightFrame.Parent = MiscTab

local GoldenChestHighlightToggle = Instance.new("TextButton")
GoldenChestHighlightToggle.Size = UDim2.new(0, 22, 0, 22)
GoldenChestHighlightToggle.Position = UDim2.new(0, 0, 0.5, -11)
GoldenChestHighlightToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GoldenChestHighlightToggle.Text = ""
GoldenChestHighlightToggle.Parent = GoldenChestHighlightFrame

local GoldenChestHighlightLabel = Instance.new("TextLabel")
GoldenChestHighlightLabel.Text = "Golden Chest Highlight"
GoldenChestHighlightLabel.Size = UDim2.new(1, -30, 1, 0)
GoldenChestHighlightLabel.Position = UDim2.new(0, 30, 0, 0)
GoldenChestHighlightLabel.BackgroundTransparency = 1
GoldenChestHighlightLabel.TextColor3 = COLORS.text
GoldenChestHighlightLabel.Font = Enum.Font.Gotham
GoldenChestHighlightLabel.TextSize = 14
GoldenChestHighlightLabel.TextXAlignment = Enum.TextXAlignment.Left
GoldenChestHighlightLabel.Parent = GoldenChestHighlightFrame

-- Вкладка Misc: Alien-Shop
local AlienShopFrame = Instance.new("Frame")
AlienShopFrame.Size = UDim2.new(1, -20, 0, 30)
AlienShopFrame.Position = UDim2.new(0, 10, 0, 90)
AlienShopFrame.BackgroundTransparency = 1
AlienShopFrame.Parent = MiscTab

local AlienShopToggle = Instance.new("TextButton")
AlienShopToggle.Size = UDim2.new(0, 22, 0, 22)
AlienShopToggle.Position = UDim2.new(0, 0, 0.5, -11)
AlienShopToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AlienShopToggle.Text = ""
AlienShopToggle.Parent = AlienShopFrame

local AlienShopLabel = Instance.new("TextLabel")
AlienShopLabel.Text = "Alien-Shop (Need Mastery)"
AlienShopLabel.Size = UDim2.new(1, -30, 1, 0)
AlienShopLabel.Position = UDim2.new(0, 30, 0, 0)
AlienShopLabel.BackgroundTransparency = 1
AlienShopLabel.TextColor3 = COLORS.text
AlienShopLabel.Font = Enum.Font.Gotham
AlienShopLabel.TextSize = 14
AlienShopLabel.TextXAlignment = Enum.TextXAlignment.Left
AlienShopLabel.Parent = AlienShopFrame

-- Вкладка Misc: Black-Market
local BlackMarketFrame = Instance.new("Frame")
BlackMarketFrame.Size = UDim2.new(1, -20, 0, 30)
BlackMarketFrame.Position = UDim2.new(0, 10, 0, 130)
BlackMarketFrame.BackgroundTransparency = 1
BlackMarketFrame.Parent = MiscTab

local BlackMarketToggle = Instance.new("TextButton")
BlackMarketToggle.Size = UDim2.new(0, 22, 0, 22)
BlackMarketToggle.Position = UDim2.new(0, 0, 0.5, -11)
BlackMarketToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BlackMarketToggle.Text = ""
BlackMarketToggle.Parent = BlackMarketFrame

local BlackMarketLabel = Instance.new("TextLabel")
BlackMarketLabel.Text = "Black-Market (Need Mastery)"
BlackMarketLabel.Size = UDim2.new(1, -30, 1, 0)
BlackMarketLabel.Position = UDim2.new(0, 30, 0, 0)
BlackMarketLabel.BackgroundTransparency = 1
BlackMarketLabel.TextColor3 = COLORS.text
BlackMarketLabel.Font = Enum.Font.Gotham
BlackMarketLabel.TextSize = 14
BlackMarketLabel.TextXAlignment = Enum.TextXAlignment.Left
BlackMarketLabel.Parent = BlackMarketFrame

-- Вкладка Misc: Auto-Collect Wheel Tickets
local AutoWheelTicketsFrame = Instance.new("Frame")
AutoWheelTicketsFrame.Size = UDim2.new(1, -20, 0, 30)
AutoWheelTicketsFrame.Position = UDim2.new(0, 10, 0, 170)
AutoWheelTicketsFrame.BackgroundTransparency = 1
AutoWheelTicketsFrame.Parent = MiscTab

local AutoWheelTicketsToggle = Instance.new("TextButton")
AutoWheelTicketsToggle.Size = UDim2.new(0, 22, 0, 22)
AutoWheelTicketsToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoWheelTicketsToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoWheelTicketsToggle.Text = ""
AutoWheelTicketsToggle.Parent = AutoWheelTicketsFrame

local AutoWheelTicketsLabel = Instance.new("TextLabel")
AutoWheelTicketsLabel.Text = "Auto-Collect Wheel Tickets"
AutoWheelTicketsLabel.Size = UDim2.new(1, -30, 1, 0)
AutoWheelTicketsLabel.Position = UDim2.new(0, 30, 0, 0)
AutoWheelTicketsLabel.BackgroundTransparency = 1
AutoWheelTicketsLabel.TextColor3 = COLORS.text
AutoWheelTicketsLabel.Font = Enum.Font.Gotham
AutoWheelTicketsLabel.TextSize = 14
AutoWheelTicketsLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoWheelTicketsLabel.Parent = AutoWheelTicketsFrame

-- Вкладка Misc: Auto-Open Void Chest
local AutoVoidChestFrame = Instance.new("Frame")
AutoVoidChestFrame.Size = UDim2.new(1, -20, 0, 30)
AutoVoidChestFrame.Position = UDim2.new(0, 10, 0, 210)
AutoVoidChestFrame.BackgroundTransparency = 1
AutoVoidChestFrame.Parent = MiscTab

local AutoVoidChestToggle = Instance.new("TextButton")
AutoVoidChestToggle.Size = UDim2.new(0, 22, 0, 22)
AutoVoidChestToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoVoidChestToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoVoidChestToggle.Text = ""
AutoVoidChestToggle.Parent = AutoVoidChestFrame

local AutoVoidChestLabel = Instance.new("TextLabel")
AutoVoidChestLabel.Text = "Auto-Open Void Chest"
AutoVoidChestLabel.Size = UDim2.new(1, -30, 1, 0)
AutoVoidChestLabel.Position = UDim2.new(0, 30, 0, 0)
AutoVoidChestLabel.BackgroundTransparency = 1
AutoVoidChestLabel.TextColor3 = COLORS.text
AutoVoidChestLabel.Font = Enum.Font.Gotham
AutoVoidChestLabel.TextSize = 14
AutoVoidChestLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoVoidChestLabel.Parent = AutoVoidChestFrame

-- Вкладка Misc: Auto-Open Giant Chest
local AutoGiantChestFrame = Instance.new("Frame")
AutoGiantChestFrame.Size = UDim2.new(1, -20, 0, 30)
AutoGiantChestFrame.Position = UDim2.new(0, 10, 0, 250)
AutoGiantChestFrame.BackgroundTransparency = 1
AutoGiantChestFrame.Parent = MiscTab

local AutoGiantChestToggle = Instance.new("TextButton")
AutoGiantChestToggle.Size = UDim2.new(0, 22, 0, 22)
AutoGiantChestToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoGiantChestToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoGiantChestToggle.Text = ""
AutoGiantChestToggle.Parent = AutoGiantChestFrame

local AutoGiantChestLabel = Instance.new("TextLabel")
AutoGiantChestLabel.Text = "Auto-Open Giant Chest"
AutoGiantChestLabel.Size = UDim2.new(1, -30, 1, 0)
AutoGiantChestLabel.Position = UDim2.new(0, 30, 0, 0)
AutoGiantChestLabel.BackgroundTransparency = 1
AutoGiantChestLabel.TextColor3 = COLORS.text
AutoGiantChestLabel.Font = Enum.Font.Gotham
AutoGiantChestLabel.TextSize = 14
AutoGiantChestLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoGiantChestLabel.Parent = AutoGiantChestFrame

-- Вкладка Misc: Auto-Use MysteryGift
local AutoMysteryGiftFrame = Instance.new("Frame")
AutoMysteryGiftFrame.Size = UDim2.new(1, -20, 0, 30)
AutoMysteryGiftFrame.Position = UDim2.new(0, 10, 0, 290)
AutoMysteryGiftFrame.BackgroundTransparency = 1
AutoMysteryGiftFrame.Parent = MiscTab

local AutoMysteryGiftToggle = Instance.new("TextButton")
AutoMysteryGiftToggle.Size = UDim2.new(0, 22, 0, 22)
AutoMysteryGiftToggle.Position = UDim2.new(0, 0, 0.5, -11)
AutoMysteryGiftToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoMysteryGiftToggle.Text = ""
AutoMysteryGiftToggle.Parent = AutoMysteryGiftFrame

local AutoMysteryGiftLabel = Instance.new("TextLabel")
AutoMysteryGiftLabel.Text = "Auto-Use MysteryGift"
AutoMysteryGiftLabel.Size = UDim2.new(1, -30, 1, 0)
AutoMysteryGiftLabel.Position = UDim2.new(0, 30, 0, 0)
AutoMysteryGiftLabel.BackgroundTransparency = 1
AutoMysteryGiftLabel.TextColor3 = COLORS.text
AutoMysteryGiftLabel.Font = Enum.Font.Gotham
AutoMysteryGiftLabel.TextSize = 14
AutoMysteryGiftLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoMysteryGiftLabel.Parent = AutoMysteryGiftFrame

-- Вкладка Misc: MysteryGift Amount Slider
local MysteryGiftAmountFrame = Instance.new("Frame")
MysteryGiftAmountFrame.Size = UDim2.new(1, -20, 0, 50)
MysteryGiftAmountFrame.Position = UDim2.new(0, 10, 0, 330)
MysteryGiftAmountFrame.BackgroundTransparency = 1
MysteryGiftAmountFrame.Parent = MiscTab

local MysteryGiftAmountLabel = Instance.new("TextLabel")
MysteryGiftAmountLabel.Text = "MysteryGift Amount: 1"
MysteryGiftAmountLabel.Size = UDim2.new(1, 0, 0, 20)
MysteryGiftAmountLabel.BackgroundTransparency = 1
MysteryGiftAmountLabel.TextColor3 = COLORS.text
MysteryGiftAmountLabel.Font = Enum.Font.Gotham
MysteryGiftAmountLabel.TextSize = 14
MysteryGiftAmountLabel.TextXAlignment = Enum.TextXAlignment.Left
MysteryGiftAmountLabel.Parent = MysteryGiftAmountFrame

local MysteryGiftAmountSliderTrack = Instance.new("TextButton")
MysteryGiftAmountSliderTrack.Size = UDim2.new(1, 0, 0, 6)
MysteryGiftAmountSliderTrack.Position = UDim2.new(0, 0, 0, 30)
MysteryGiftAmountSliderTrack.BackgroundColor3 = COLORS.disabled
MysteryGiftAmountSliderTrack.Text = ""
MysteryGiftAmountSliderTrack.Parent = MysteryGiftAmountFrame

local MysteryGiftAmountTrackCorner = Instance.new("UICorner")
MysteryGiftAmountTrackCorner.CornerRadius = UDim.new(1, 0)
MysteryGiftAmountTrackCorner.Parent = MysteryGiftAmountSliderTrack

local MysteryGiftAmountSliderFill = Instance.new("Frame")
MysteryGiftAmountSliderFill.Size = UDim2.new(0, 0, 1, 0)
MysteryGiftAmountSliderFill.BackgroundColor3 = COLORS.accent
MysteryGiftAmountSliderFill.Parent = MysteryGiftAmountSliderTrack

local MysteryGiftAmountFillCorner = Instance.new("UICorner")
MysteryGiftAmountFillCorner.CornerRadius = UDim.new(1, 0)
MysteryGiftAmountFillCorner.Parent = MysteryGiftAmountSliderFill

local MysteryGiftAmountSliderButton = Instance.new("TextButton")
MysteryGiftAmountSliderButton.Size = UDim2.new(0, 16, 0, 16)
MysteryGiftAmountSliderButton.Position = UDim2.new(0, -8, 0.5, -8)
MysteryGiftAmountSliderButton.BackgroundColor3 = COLORS.text
MysteryGiftAmountSliderButton.Text = ""
MysteryGiftAmountSliderButton.Parent = MysteryGiftAmountSliderTrack

local MysteryGiftAmountSliderButtonCorner = Instance.new("UICorner")
MysteryGiftAmountSliderButtonCorner.CornerRadius = UDim.new(1, 0)
MysteryGiftAmountSliderButtonCorner.Parent = MysteryGiftAmountSliderButton

-- Вкладка FPS: Turn Black Screen
local BlackScreenFrame = Instance.new("Frame")
BlackScreenFrame.Size = UDim2.new(1, -20, 0, 30)
BlackScreenFrame.Position = UDim2.new(0, 10, 0, 10)
BlackScreenFrame.BackgroundTransparency = 1
BlackScreenFrame.Parent = FPSTab

local BlackScreenToggle = Instance.new("TextButton")
BlackScreenToggle.Size = UDim2.new(0, 22, 0, 22)
BlackScreenToggle.Position = UDim2.new(0, 0, 0.5, -11)
BlackScreenToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BlackScreenToggle.Text = ""
BlackScreenToggle.Parent = BlackScreenFrame

local BlackScreenLabel = Instance.new("TextLabel")
BlackScreenLabel.Text = "Turn Black Screen"
BlackScreenLabel.Size = UDim2.new(1, -30, 1, 0)
BlackScreenLabel.Position = UDim2.new(0, 30, 0, 0)
BlackScreenLabel.BackgroundTransparency = 1
BlackScreenLabel.TextColor3 = COLORS.text
BlackScreenLabel.Font = Enum.Font.Gotham
BlackScreenLabel.TextSize = 14
BlackScreenLabel.TextXAlignment = Enum.TextXAlignment.Left
BlackScreenLabel.Parent = BlackScreenFrame

-- Вкладка FPS: FPS Limit Slider
local FPSLimitFrame = Instance.new("Frame")
FPSLimitFrame.Size = UDim2.new(1, -20, 0, 50)
FPSLimitFrame.Position = UDim2.new(0, 10, 0, 50)
FPSLimitFrame.BackgroundTransparency = 1
FPSLimitFrame.Parent = FPSTab

local FPSLimitLabel = Instance.new("TextLabel")
FPSLimitLabel.Text = "FPS Limit: 60"
FPSLimitLabel.Size = UDim2.new(1, 0, 0, 20)
FPSLimitLabel.BackgroundTransparency = 1
FPSLimitLabel.TextColor3 = COLORS.text
FPSLimitLabel.Font = Enum.Font.Gotham
FPSLimitLabel.TextSize = 14
FPSLimitLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLimitLabel.Parent = FPSLimitFrame

local FPSLimitSliderTrack = Instance.new("TextButton")
FPSLimitSliderTrack.Size = UDim2.new(1, 0, 0, 6)
FPSLimitSliderTrack.Position = UDim2.new(0, 0, 0, 30)
FPSLimitSliderTrack.BackgroundColor3 = COLORS.disabled
FPSLimitSliderTrack.Text = ""
FPSLimitSliderTrack.Parent = FPSLimitFrame

local FPSLimitTrackCorner = Instance.new("UICorner")
FPSLimitTrackCorner.CornerRadius = UDim.new(1, 0)
FPSLimitTrackCorner.Parent = FPSLimitSliderTrack

local FPSLimitSliderFill = Instance.new("Frame")
FPSLimitSliderFill.Size = UDim2.new((60 - 10) / 134, 0, 1, 0)
FPSLimitSliderFill.BackgroundColor3 = COLORS.accent
FPSLimitSliderFill.Parent = FPSLimitSliderTrack

local FPSLimitFillCorner = Instance.new("UICorner")
FPSLimitFillCorner.CornerRadius = UDim.new(1, 0)
FPSLimitFillCorner.Parent = FPSLimitSliderFill

local FPSLimitSliderButton = Instance.new("TextButton")
FPSLimitSliderButton.Size = UDim2.new(0, 16, 0, 16)
FPSLimitSliderButton.Position = UDim2.new((60 - 10) / 134, -8, 0.5, -8)
FPSLimitSliderButton.BackgroundColor3 = COLORS.text
FPSLimitSliderButton.Text = ""
FPSLimitSliderButton.Parent = FPSLimitSliderTrack

local FPSLimitSliderButtonCorner = Instance.new("UICorner")
FPSLimitSliderButtonCorner.CornerRadius = UDim.new(1, 0)
FPSLimitSliderButtonCorner.Parent = FPSLimitSliderButton

-- Вкладка Teleport: Кнопки миров
local worldButtons = {}
local worldPaths = {
    "Workspace.Worlds.The Overworld.PortalSpawn",
    "Workspace.Worlds.The Overworld.Islands.Floating Island.Island.Portal.Spawn",
    "Workspace.Worlds.The Overworld.Islands.Outer Space.Island.Portal.Spawn",
    "Workspace.Worlds.The Overworld.Islands.Twilight.Island.Portal.Spawn",
    "Workspace.Worlds.The Overworld.Islands.The Void.Island.Portal.Spawn",
    "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn"
}

for i = 1, 6 do
    local WorldFrame = Instance.new("Frame")
    WorldFrame.Size = UDim2.new(1, -20, 0, 30)
    WorldFrame.Position = UDim2.new(0, 10, 0, 10 + (i-1)*40)
    WorldFrame.BackgroundTransparency = 1
    WorldFrame.Parent = TeleportTab

    local WorldButton = Instance.new("TextButton")
    WorldButton.Size = UDim2.new(1, 0, 1, 0)
    WorldButton.BackgroundColor3 = COLORS.tab_unselected
    WorldButton.Text = "World " .. i
    WorldButton.TextColor3 = COLORS.text
    WorldButton.Font = Enum.Font.Gotham
    WorldButton.TextSize = 14
    WorldButton.Parent = WorldFrame

    local WorldButtonCorner = Instance.new("UICorner")
    WorldButtonCorner.CornerRadius = UDim.new(0, 6)
    WorldButtonCorner.Parent = WorldButton

    worldButtons[i] = WorldButton
end

-- Переменные
local autoBubbleEnabled = false
local autoSellEnabled = false
local autoCollectEnabled = false
local autoFarmEnabled = false
local infiniteJumpEnabled = false
local goldenChestHighlightEnabled = false
local alienShopEnabled = false
local blackMarketEnabled = false
local autoWheelTicketsEnabled = false
local autoVoidChestEnabled = false
local autoGiantChestEnabled = false
local autoMysteryGiftEnabled = false
local blackScreenEnabled = false
local bubbleCooldown = 0.5
local collectDelay = 0.1
local walkSpeed = 16
local mysteryGiftAmount = 1
local fpsLimit = 60
local isDragging = false
local isDraggingCollect = false
local isDraggingWalkSpeed = false
local isDraggingMysteryGiftAmount = false
local isDraggingFPSLimit = false
local isMinimized = false
local isDraggingWindow = false
local dragStartMousePos = nil
local dragStartFramePos = nil
local scriptActive = true
local goldenChestHighlights = {}
local blackScreenEffect = nil
local lastUpdateTime = 0
local updateInterval = 1/60

-- Список объектов для подсветки
local goldenChestPaths = {
    "workspace.Rendered.Rifts['golden-chest'].Chest.Decoration.Bottom",
    "workspace.Rendered.Rifts['golden-chest'].Chest.Decoration.Coins",
    "workspace.Rendered.Rifts['golden-chest'].Chest.Decoration.Top",
    "workspace.Rendered.Rifts['golden-chest'].Chest['golden-chest']"
}

-- Анимации
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Инициализация ремоута
if not checkPickupRemote() then
    warn("Auto-Farm will be disabled due to missing pickup remote")
end

-- Функция переключения вкладок
local function switchTab(selectedTab)
    HomeTab.Visible = selectedTab == HomeTab
    FarmTab.Visible = selectedTab == FarmTab
    MiscTab.Visible = selectedTab == MiscTab
    TeleportTab.Visible = selectedTab == TeleportTab
    FPSTab.Visible = selectedTab == FPSTab

    HomeTabButton.BackgroundColor3 = selectedTab == HomeTab and COLORS.tab_selected or COLORS.tab_unselected
    FarmTabButton.BackgroundColor3 = selectedTab == FarmTab and COLORS.tab_selected or COLORS.tab_unselected
    MiscTabButton.BackgroundColor3 = selectedTab == MiscTab and COLORS.tab_selected or COLORS.tab_unselected
    TeleportTabButton.BackgroundColor3 = selectedTab == TeleportTab and COLORS.tab_selected or COLORS.tab_unselected
    FPSTabButton.BackgroundColor3 = selectedTab == FPSTab and COLORS.tab_selected or COLORS.tab_unselected

    HomeTabIndicator.Visible = selectedTab == HomeTab
    FarmTabIndicator.Visible = selectedTab == FarmTab
    MiscTabIndicator.Visible = selectedTab == MiscTab
    TeleportTabIndicator.Visible = selectedTab == TeleportTab
    FPSTabIndicator.Visible = selectedTab == FPSTab
end

-- Функция получения объекта по пути
local function getObjectFromPath(path)
    local success, result = pcall(function()
        local current = game
        for part in path:gmatch("[^%.%[%]]+") do
            if part:match("^%['.-'%]$") then
                local key = part:match("%['(.-)'%]")
                current = current[key]
            else
                current = current[part]
            end
        end
        return current
    end)
    if success and result and result:IsDescendantOf(game) then
        return result
    end
    return nil
end

-- Функция создания подсветки
local function createHighlight(object)
    if not object then return nil end
    local highlight = Instance.new("Highlight")
    highlight.Name = "GoldenChestHighlight"
    highlight.Adornee = object
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = object
    return highlight
end

-- Функция управления подсветкой
local function manageGoldenChestHighlight(enabled)
    for _, highlight in pairs(goldenChestHighlights) do
        if highlight and highlight.Parent then
            highlight.Enabled = enabled
        end
    end
    if not enabled then return end
    local anyObjectFound = false
    for _, path in ipairs(goldenChestPaths) do
        if not goldenChestHighlights[path] or not goldenChestHighlights[path].Parent then
            local object = getObjectFromPath(path)
            if object then
                anyObjectFound = true
                local highlight = createHighlight(object)
                if highlight then
                    goldenChestHighlights[path] = highlight
                    highlight.Enabled = true
                end
            end
        else
            anyObjectFound = true
        end
    end
    if not anyObjectFound then
        task.spawn(function()
            while scriptActive and enabled and not anyObjectFound do
                for _, path in ipairs(goldenChestPaths) do
                    if not goldenChestHighlights[path] or not goldenChestHighlights[path].Parent then
                        local object = getObjectFromPath(path)
                        if object then
                            local highlight = createHighlight(object)
                            if highlight then
                                goldenChestHighlights[path] = highlight
                                highlight.Enabled = true
                                anyObjectFound = true
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end

-- Функция управления чёрным экраном
local function manageBlackScreen(enabled)
    if enabled and not blackScreenEffect then
        blackScreenEffect = Instance.new("ColorCorrectionEffect")
        blackScreenEffect.Brightness = -1
        blackScreenEffect.Parent = Lighting
    elseif not enabled and blackScreenEffect then
        blackScreenEffect:Destroy()
        blackScreenEffect = nil
    end
end

-- Функция покупки в Alien-Shop
local function buyAlienShop()
    for i = 1, 3 do
        local success, error = pcall(function()
            local args = { [1] = "BuyShopItem", [2] = "alien-shop", [3] = i }
            bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
        end)
        if not success then
            warn("Failed to buy Alien-Shop item " .. i .. ": " .. error)
        end
        task.wait(0.1)
    end
end

-- Функция покупки в Black-Market
local function buyBlackMarket()
    for i = 1, 3 do
        local success, error = pcall(function()
            local args = { [1] = "BuyShopItem", [2] = "shard-shop", [3] = i }
            bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
        end)
        if not success then
            warn("Failed to buy Black-Market item " .. i .. ": " .. error)
        end
        task.wait(0.1)
    end
end

-- Функция надутия пузыря
local function blowBubble()
    local success, error = pcall(function()
        bubbleRemote:WaitForChild("Event"):FireServer("BlowBubble")
    end)
    if not success then
        warn("Failed to blow bubble: " .. error)
    end
end

-- Функция продажи пузыря
local function sellBubble()
    local success, error = pcall(function()
        local args = { [1] = "SellBubble" }
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to sell bubble: " .. error)
    end
end

-- Функция сбора игрового времени
local function collectPlaytime()
    for i = 1, 9 do
        local success, error = pcall(function()
            local args = { [1] = "ClaimPlaytime", [2] = i }
            bubbleRemote:WaitForChild("Function"):InvokeServer(unpack(args))
        end)
        if not success then
            warn("Failed to collect playtime " .. i .. ": " .. error)
        end
        task.wait(0.1)
    end
end

-- Функция сбора Wheel Tickets
local function collectWheelTickets()
    local success, error = pcall(function()
        local args = { [1] = "ClaimFreeWheelSpin" }
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to collect wheel tickets: " .. error)
    end
end

-- Функция открытия Void Chest
local function openVoidChest()
    local success, error = pcall(function()
        local args = { [1] = "ClaimChest", [2] = "Void Chest" }
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to open Void Chest: " .. error)
    end
end

-- Функция открытия Giant Chest
local function openGiantChest()
    local success, error = pcall(function()
        local args = { [1] = "ClaimChest", [2] = "GiantJIT Chest" }
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to open Giant Chest: " .. error)
    end
end

-- Функция Auto-Use MysteryGift
local function useMysteryGift()
    local args = {
        [1] = "UseGift",
        [2] = "Mystery Box",
        [3] = mysteryGiftAmount
    }
    local success, error = pcall(function()
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to use MysteryGift: " .. error)
    end
end

-- Функция телепортации
local function teleportToWorld(world)
    local path = worldPaths[world]
    if not path then return end
    local success, error = pcall(function()
        local args = { [1] = "Teleport", [2] = path }
        bubbleRemote:WaitForChild("Event"):FireServer(unpack(args))
    end)
    if not success then
        warn("Failed to teleport to World " .. world .. ": " .. error)
    end
end

-- Функция автофарма
local function farmCollectibles()
    while autoFarmEnabled and scriptActive do
        local success, rendered = pcall(function()
            return Workspace:WaitForChild("Rendered", 5)
        end)
        if not success or not rendered then
            warn("Workspace.Rendered not found!")
            task.wait(5)
            continue
        end
        local chunkerFolders = {}
        for _, folder in pairs(rendered:GetChildren()) do
            if folder.Name:match("Chunker") and folder:IsA("Folder") and #folder:GetChildren() > 0 then
                table.insert(chunkerFolders, folder)
            end
        end
        if #chunkerFolders == 0 then
            task.wait(5)
            continue
        end
        for _, chunker in ipairs(chunkerFolders) do
            local argsList = {}
            local itemsToRemove = {}
            for _, item in pairs(chunker:GetChildren()) do
                if item.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
                    table.insert(argsList, item.Name)
                    table.insert(itemsToRemove, item)
                end
            end
            if #argsList > 0 then
                for i, uid in ipairs(argsList) do
                    local args = { [1] = uid }
                    local success = pcall(function()
                        pickupRemote:FireServer(unpack(args))
                    end)
                    if success then
                        local item = itemsToRemove[i]
                        if item and item.Parent then
                            pcall(function()
                                item:Destroy()
                            end)
                        end
                    end
                    task.wait(collectDelay)
                end
            end
        end
        task.wait(5)
    end
end

-- Функция установки WalkSpeed
local function setWalkSpeed(value)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end

-- Функция ограничения FPS
local function setFPSLimit(value)
    fpsLimit = math.clamp(value, 10, 144)
    setfpscap(fpsLimit)
    print("FPS Limit set to: " .. fpsLimit)
end

local function restrictFPS()
    local frameTime = 1 / fpsLimit
    while scriptActive do
        local startTime = tick()
        RunService.RenderStepped:Wait()
        local elapsed = tick() - startTime
        if elapsed < frameTime then
            task.wait(frameTime - elapsed)
        end
        if tick() - lastUpdateTime >= 2 then
            print("Actual FPS: " .. math.round(1 / elapsed))
            lastUpdateTime = tick()
        end
    end
end

-- Функция для обновления лимита FPS
local function updateFPSLimit(value)
    fpsLimit = math.clamp(value, 10, 144)
    local fillAmount = (fpsLimit - 10) / 134
    local tween = TweenService:Create(FPSLimitSliderFill, tweenInfo, {Size = UDim2.new(fillAmount, 0, 1, 0)})
    local tween2 = TweenService:Create(FPSLimitSliderButton, tweenInfo, {Position = UDim2.new(fillAmount, -8, 0.5, -8)})
    tween:Play()
    tween2:Play()
    FPSLimitLabel.Text = string.format("FPS Limit: %d", fpsLimit)
    setFPSLimit(fpsLimit)
end

-- Обработчик бесконечного прыжка
local function onInfiniteJump(input, gameProcessedEvent)
    if infiniteJumpEnabled and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not gameProcessedEvent then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

-- Параллельные потоки для функций
local function manageAutoBubble()
    while scriptActive and autoBubbleEnabled do
        blowBubble()
        task.wait(bubbleCooldown)
    end
end

local function manageAutoSell()
    while scriptActive and autoSellEnabled do
        sellBubble()
        task.wait(0.5)
    end
end

local function manageAutoCollect()
    while scriptActive and autoCollectEnabled do
        collectPlaytime()
        task.wait(5)
    end
end

local function manageAlienShop()
    while scriptActive and alienShopEnabled do
        buyAlienShop()
        task.wait(5)
    end
end

local function manageBlackMarket()
    while scriptActive and blackMarketEnabled do
        buyBlackMarket()
        task.wait(5)
    end
end

local function manageAutoWheelTickets()
    while scriptActive and autoWheelTicketsEnabled do
        collectWheelTickets()
        task.wait(5)
    end
end

local function manageAutoVoidChest()
    while scriptActive and autoVoidChestEnabled do
        openVoidChest()
        task.wait(5)
    end
end

local function manageAutoGiantChest()
    while scriptActive and autoGiantChestEnabled do
        openGiantChest()
        task.wait(5)
    end
end

local function manageAutoMysteryGift()
    while scriptActive and autoMysteryGiftEnabled do
        useMysteryGift()
        task.wait(0.01)
    end
end

-- Обработчики
HomeTabButton.MouseButton1Click:Connect(function()
    switchTab(HomeTab)
end)

FarmTabButton.MouseButton1Click:Connect(function()
    switchTab(FarmTab)
end)

MiscTabButton.MouseButton1Click:Connect(function()
    switchTab(MiscTab)
end)

TeleportTabButton.MouseButton1Click:Connect(function()
    switchTab(TeleportTab)
end)

FPSTabButton.MouseButton1Click:Connect(function()
    switchTab(FPSTab)
end)

AutoBubbleToggle.MouseButton1Click:Connect(function()
    autoBubbleEnabled = not autoBubbleEnabled
    local tween = TweenService:Create(AutoBubbleToggle, tweenInfo, {
        BackgroundColor3 = autoBubbleEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoBubbleEnabled then
        task.spawn(manageAutoBubble)
    end
end)

AutoSellToggle.MouseButton1Click:Connect(function()
    autoSellEnabled = not autoSellEnabled
    local tween = TweenService:Create(AutoSellToggle, tweenInfo, {
        BackgroundColor3 = autoSellEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoSellEnabled then
        task.spawn(manageAutoSell)
    end
end)

AutoCollectToggle.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    local tween = TweenService:Create(AutoCollectToggle, tweenInfo, {
        BackgroundColor3 = autoCollectEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoCollectEnabled then
        task.spawn(manageAutoCollect)
    end
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    local tween = TweenService:Create(AutoFarmToggle, tweenInfo, {
        BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoFarmEnabled and pickupRemote then
        task.spawn(farmCollectibles)
    end
end)

InfiniteJumpToggle.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    local tween = TweenService:Create(InfiniteJumpToggle, tweenInfo, {
        BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
end)

GoldenChestHighlightToggle.MouseButton1Click:Connect(function()
    goldenChestHighlightEnabled = not goldenChestHighlightEnabled
    local tween = TweenService:Create(GoldenChestHighlightToggle, tweenInfo, {
        BackgroundColor3 = goldenChestHighlightEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    manageGoldenChestHighlight(goldenChestHighlightEnabled)
end)

AlienShopToggle.MouseButton1Click:Connect(function()
    alienShopEnabled = not alienShopEnabled
    local tween = TweenService:Create(AlienShopToggle, tweenInfo, {
        BackgroundColor3 = alienShopEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if alienShopEnabled then
        task.spawn(manageAlienShop)
    end
end)

BlackMarketToggle.MouseButton1Click:Connect(function()
    blackMarketEnabled = not blackMarketEnabled
    local tween = TweenService:Create(BlackMarketToggle, tweenInfo, {
        BackgroundColor3 = blackMarketEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if blackMarketEnabled then
        task.spawn(manageBlackMarket)
    end
end)

AutoWheelTicketsToggle.MouseButton1Click:Connect(function()
    autoWheelTicketsEnabled = not autoWheelTicketsEnabled
    local tween = TweenService:Create(AutoWheelTicketsToggle, tweenInfo, {
        BackgroundColor3 = autoWheelTicketsEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoWheelTicketsEnabled then
        task.spawn(manageAutoWheelTickets)
    end
end)

AutoVoidChestToggle.MouseButton1Click:Connect(function()
    autoVoidChestEnabled = not autoVoidChestEnabled
    local tween = TweenService:Create(AutoVoidChestToggle, tweenInfo, {
        BackgroundColor3 = autoVoidChestEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoVoidChestEnabled then
        task.spawn(manageAutoVoidChest)
    end
end)

AutoGiantChestToggle.MouseButton1Click:Connect(function()
    autoGiantChestEnabled = not autoGiantChestEnabled
    local tween = TweenService:Create(AutoGiantChestToggle, tweenInfo, {
        BackgroundColor3 = autoGiantChestEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoGiantChestEnabled then
        task.spawn(manageAutoGiantChest)
    end
end)

AutoMysteryGiftToggle.MouseButton1Click:Connect(function()
    autoMysteryGiftEnabled = not autoMysteryGiftEnabled
    local tween = TweenService:Create(AutoMysteryGiftToggle, tweenInfo, {
        BackgroundColor3 = autoMysteryGiftEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    if autoMysteryGiftEnabled then
        task.spawn(manageAutoMysteryGift)
    end
end)

BlackScreenToggle.MouseButton1Click:Connect(function()
    blackScreenEnabled = not blackScreenEnabled
    local tween = TweenService:Create(BlackScreenToggle, tweenInfo, {
        BackgroundColor3 = blackScreenEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
    })
    tween:Play()
    manageBlackScreen(blackScreenEnabled)
end)

-- Обработчик слайдера частоты
SliderButton.MouseButton1Down:Connect(function()
    isDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        isDraggingCollect = false
        isDraggingWalkSpeed = false
        isDraggingMysteryGiftAmount = false
        isDraggingFPSLimit = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackWidth = SliderTrack.AbsoluteSize.X
        local fillAmount = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        SliderFill.Size = UDim2.new(fillAmount, 0, 1, 0)
        SliderButton.Position = UDim2.new(fillAmount, -8, 0.5, -8)
        bubbleCooldown = 0.1 + (fillAmount * (2 - 0.1))
        FrequencyLabel.Text = string.format("Frequency: %.1fs", bubbleCooldown)
    end
end)

-- Обработчик слайдера задержки сбора
CollectDelaySliderButton.MouseButton1Down:Connect(function()
    isDraggingCollect = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingCollect and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local trackPos = CollectDelaySliderTrack.AbsolutePosition.X
        local trackWidth = CollectDelaySliderTrack.AbsoluteSize.X
        local fillAmount = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        CollectDelaySliderFill.Size = UDim2.new(fillAmount, 0, 1, 0)
        CollectDelaySliderButton.Position = UDim2.new(fillAmount, -8, 0.5, -8)
        collectDelay = fillAmount * 0.5
        CollectDelayLabel.Text = string.format("Collect Delay: %.1fs", collectDelay)
    end
end)

-- Обработчик слайдера WalkSpeed
WalkSpeedSliderButton.MouseButton1Down:Connect(function()
    isDraggingWalkSpeed = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingWalkSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local trackPos = WalkSpeedSliderTrack.AbsolutePosition.X
        local trackWidth = WalkSpeedSliderTrack.AbsoluteSize.X
        local fillAmount = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        WalkSpeedSliderFill.Size = UDim2.new(fillAmount, 0, 1, 0)
        WalkSpeedSliderButton.Position = UDim2.new(fillAmount, -8, 0.5, -8)
        walkSpeed = 16 + (fillAmount * (100 - 16))
        WalkSpeedLabel.Text = string.format("WalkSpeed: %d", math.floor(walkSpeed))
        setWalkSpeed(walkSpeed)
    end
end)

-- Обработчик слайдера MysteryGift Amount
MysteryGiftAmountSliderButton.MouseButton1Down:Connect(function()
    isDraggingMysteryGiftAmount = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingMysteryGiftAmount and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local trackPos = MysteryGiftAmountSliderTrack.AbsolutePosition.X
        local trackWidth = MysteryGiftAmountSliderTrack.AbsoluteSize.X
        local fillAmount = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        MysteryGiftAmountSliderFill.Size = UDim2.new(fillAmount, 0, 1, 0)
        MysteryGiftAmountSliderButton.Position = UDim2.new(fillAmount, -8, 0.5, -8)
        mysteryGiftAmount = math.floor(1 + (fillAmount * (100 - 1)))
        MysteryGiftAmountLabel.Text = string.format("MysteryGift Amount: %d", mysteryGiftAmount)
    end
end)

-- Обработчик слайдера FPS Limit
FPSLimitSliderButton.MouseButton1Down:Connect(function()
    isDraggingFPSLimit = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingFPSLimit and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local trackPos = FPSLimitSliderTrack.AbsolutePosition.X
        local trackWidth = FPSLimitSliderTrack.AbsoluteSize.X
        local fillAmount = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        local newFPS = math.floor(10 + (fillAmount * (144 - 10)))
        updateFPSLimit(newFPS)
    end
end)

-- Обработчик перетаскивания окна
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = true
        dragStartMousePos = input.Position
        dragStartFramePos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMousePos
        MainFrame.Position = UDim2.new(
            dragStartFramePos.X.Scale,
            dragStartFramePos.X.Offset + delta.X,
            dragStartFramePos.Y.Scale,
            dragStartFramePos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = false
    end
end)

-- Обработчик сворачивания окна
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local newHeight = isMinimized and 30 or config.height
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, config.width, 0, newHeight)})
    tween:Play()
    TabPanel.Visible = not isMinimized
    ContentFrame.Visible = not isMinimized
end)

-- Обработчик закрытия окна
CloseButton.MouseButton1Click:Connect(function()
    scriptActive = false
    ScreenGui:Destroy()
    if blackScreenEffect then
        blackScreenEffect:Destroy()
    end
    for _, highlight in pairs(goldenChestHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end
end)

-- Обработчики телепортации
for i = 1, 6 do
    worldButtons[i].MouseButton1Click:Connect(function()
        teleportToWorld(i)
    end)
end

-- Обработчик бесконечного прыжка
UserInputService.InputBegan:Connect(onInfiniteJump)

-- Обработчик изменения персонажа
player.CharacterAdded:Connect(function(character)
    if walkSpeed ~= 16 then
        setWalkSpeed(walkSpeed)
    end
end)

-- Инициализация
setWalkSpeed(walkSpeed)
setFPSLimit(fpsLimit)
