--[[
    ==========================================================
    Delta UI Library v8.0.0 (Titan Edition)
    Author: ibrahimkhacef5-del
    GitHub: https://github.com/ibrahimkhacef5-del/Detla-lib-op
    Description: The Ultimate Framework (Themes, Boot Screens, Key System, Live Editor).
    ==========================================================
]]

local Delta = {}
Delta.__index = Delta

if _G.DeltaUI_v8_Loaded then return _G.DeltaUI_v8_Loaded end

-- 1. الخدمات الأساسية
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")
local LocalPlayer = Players.LocalPlayer

-- 2. الثيمات الـ 12 (من ZHAVA + إضافات)
Delta.Themes = {
    Default = {
        Bg = Color3.fromRGB(15, 15, 20), Surface = Color3.fromRGB(25, 25, 32), SurfaceLight = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 255, 136), Danger = Color3.fromRGB(255, 85, 85), Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 170), Border = Color3.fromRGB(50, 50, 65), Corner = 8
    },
    BlackShine = {
        Bg = Color3.fromRGB(5, 5, 8), Surface = Color3.fromRGB(15, 15, 20), SurfaceLight = Color3.fromRGB(25, 25, 32),
        Accent = Color3.fromRGB(255, 255, 255), Danger = Color3.fromRGB(255, 50, 50), Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(140, 140, 140), Border = Color3.fromRGB(60, 60, 70), Corner = 10
    },
    PurpleDream = {
        Bg = Color3.fromRGB(25, 10, 40), Surface = Color3.fromRGB(40, 20, 60), SurfaceLight = Color3.fromRGB(55, 30, 80),
        Accent = Color3.fromRGB(200, 100, 255), Danger = Color3.fromRGB(255, 50, 100), Text = Color3.fromRGB(250, 240, 255),
        SubText = Color3.fromRGB(180, 150, 210), Border = Color3.fromRGB(100, 60, 150), Corner = 12
    },
    Cyberpunk = {
        Bg = Color3.fromRGB(10, 5, 25), Surface = Color3.fromRGB(20, 10, 40), SurfaceLight = Color3.fromRGB(30, 15, 55),
        Accent = Color3.fromRGB(0, 255, 200), Danger = Color3.fromRGB(255, 0, 150), Text = Color3.fromRGB(220, 255, 255),
        SubText = Color3.fromRGB(150, 200, 220), Border = Color3.fromRGB(0, 200, 180), Corner = 4
    },
    Ocean = {
        Bg = Color3.fromRGB(10, 25, 40), Surface = Color3.fromRGB(20, 40, 60), SurfaceLight = Color3.fromRGB(30, 55, 80),
        Accent = Color3.fromRGB(0, 200, 255), Danger = Color3.fromRGB(255, 85, 85), Text = Color3.fromRGB(220, 240, 255),
        SubText = Color3.fromRGB(130, 180, 220), Border = Color3.fromRGB(30, 80, 120), Corner = 12
    },
    Halloween = {
        Bg = Color3.fromRGB(20, 10, 5), Surface = Color3.fromRGB(35, 15, 5), SurfaceLight = Color3.fromRGB(50, 20, 10),
        Accent = Color3.fromRGB(255, 120, 0), Danger = Color3.fromRGB(200, 0, 0), Text = Color3.fromRGB(255, 230, 200),
        SubText = Color3.fromRGB(200, 150, 100), Border = Color3.fromRGB(100, 50, 20), Corner = 10
    },
    Light = {
        Bg = Color3.fromRGB(240, 240, 240), Surface = Color3.fromRGB(255, 255, 255), SurfaceLight = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(0, 120, 255), Danger = Color3.fromRGB(255, 50, 50), Text = Color3.fromRGB(0, 0, 0),
        SubText = Color3.fromRGB(100, 100, 100), Border = Color3.fromRGB(200, 200, 200), Corner = 8
    }
}
Delta.Theme = Delta.Themes.Default
Delta.Icons = { Home = "🏠", Settings = "⚙️", Code = "💻", Player = "👤", Combat = "⚔️", Visual = "👁️", Misc = "🎲", Info = "ℹ️", Key = "🔑" }

-- 3. نظام الحفظ (Profiles)
local ConfigFile = "DeltaUI_v8_Config.json"
local SavedConfig = {}
local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and type(data) == "table" then SavedConfig = data end
    end
end
local function SaveConfig()
    if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(SavedConfig)) end) end
end
LoadConfig()

-- 4. دوال مساعدة (Helpers)
local function Create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end
local function Corner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius); c.Parent = parent; return c
end
local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = thickness; s.Parent = parent; return s
end
local function AddPadding(parent, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 0); p.PaddingRight = UDim.new(0, r or 0)
    p.PaddingTop = UDim.new(0, t or 0); p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = parent; return p
end
local function PlaySound(id, vol)
    pcall(function()
        local s = Instance.new("Sound"); s.SoundId = "rbxassetid://"..id; s.Volume = vol or 0.5; s.Parent = SoundService; s:Play()
        task.delay(2, function() s:Destroy() end)
    end)
end

-- 5. نظام الصور (Image Resolver)
function Delta:ResolveImage(input)
    if not input then return nil end
    if typeof(input) == "number" then return "rbxassetid://"..input end
    if typeof(input) == "string" then
        if input:match("^rbxthumb://") or input:match("^rbxassetid://") or input:match("^https?://") then return input end
        if input:match("^%d+$") then return "rbxassetid://"..input end
    end
    return input
end

-- 6. شاشات الإقلاع (Boot Screens)
function Delta:BootScreen(style, cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Delta UI"
    local sub = cfg.Subtitle or "Loading..."
    local accent = cfg.AccentColor or Delta.Theme.Accent
    local duration = cfg.Duration or 2.5
    local screen = Create("ScreenGui", {Name="Boot", ResetOnSpawn=false, Parent=CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    local root = Create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(10,10,15), Parent=screen})
    
    if style == "Pro" or style == "X" then
        local logo = Create("TextLabel", {Size=UDim2.new(1,0,0,100), Position=UDim2.new(0,0,0.35,0), BackgroundTransparency=1, Text=cfg.Icon or "⚡", TextColor3=accent, TextSize=72, Font=Enum.Font.GothamBold, Parent=root})
        Create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0.5,20), BackgroundTransparency=1, Text=title, TextColor3=Color3.new(1,1,1), TextSize=28, Font=Enum.Font.GothamBold, Parent=root})
        Create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0.5,55), BackgroundTransparency=1, Text=sub, TextColor3=Color3.fromRGB(180,180,200), TextSize=13, Font=Enum.Font.Gotham, Parent=root})
        local bar = Create("Frame", {Size=UDim2.new(0,300,0,4), Position=UDim2.new(0.5,-150,0.5,100), BackgroundColor3=Color3.fromRGB(40,40,50), Parent=root})
        Corner(bar, 2)
        local fill = Create("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=accent, Parent=bar})
        Corner(fill, 2)
        task.spawn(function()
            for i = 1, 30 do
                fill.Size = UDim2.new(i/30, 0, 1, 0); task.wait(duration/30)
            end
            task.wait(0.3); TweenService:Create(root, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
            for _, v in ipairs(root:GetDescendants()) do
                if v:IsA("TextLabel") then TweenService:Create(v, TweenInfo.new(0.5), {TextTransparency=1}):Play() end
                if v:IsA("Frame") then TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play() end
            end
            task.wait(0.5); screen:Destroy()
        end)
    elseif style == "Wave" then
        for i = 1, 3 do
            local wave = Create("Frame", {Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0), BackgroundColor3=accent, BackgroundTransparency=0.7, Parent=root})
            Corner(wave, 999)
            task.spawn(function()
                task.wait(i*0.2)
                TweenService:Create(wave, TweenInfo.new(1.5), {Size=UDim2.new(2,0,2,0), BackgroundTransparency=1}):Play()
            end)
        end
        Create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0.45,0), BackgroundTransparency=1, Text=title, TextColor3=accent, TextSize=28, Font=Enum.Font.GothamBold, Parent=root})
        task.spawn(function()
            task.wait(duration)
            TweenService:Create(root, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
            task.wait(0.5); screen:Destroy()
        end)
    end
    return screen
end

-- 7. نظام الحماية (Key System)
function Delta:KeySystem(cfg)
    cfg = cfg or {}
    local keys = cfg.Keys or {"Delta-VIP"}
    local fileName = cfg.FileName or "DeltaKey.txt"
    if isfile and isfile(fileName) then
        local saved = readfile(fileName)
        for _, k in ipairs(keys) do if saved == k then return true end end
    end
    local gui = Create("ScreenGui", {Name="Key", ResetOnSpawn=false, Parent=CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    local bg = Create("Frame", {Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(10,10,15), Parent=gui})
    local box = Create("Frame", {Size=UDim2.new(0,350,0,300), Position=UDim2.new(0.5,-175,0.5,-150), BackgroundColor3=Delta.Theme.Bg, Parent=bg})
    Corner(box, 12); Stroke(box, Delta.Theme.Accent, 2)
    Create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,0,20), BackgroundTransparency=1, Text="🔐 "..(cfg.Title or "Authentication"), TextColor3=Delta.Theme.Accent, TextSize=20, Font=Enum.Font.GothamBold, Parent=box})
    local input = Create("TextBox", {Size=UDim2.new(1,-40,0,40), Position=UDim2.new(0,20,0,80), BackgroundColor3=Delta.Theme.Surface, Text="", PlaceholderText="Enter Key...", TextColor3=Delta.Theme.Text, Font=Enum.Font.Code, TextSize=14, Parent=box})
    Corner(input, 6); Stroke(input, Delta.Theme.Border, 1)
    local status = Create("TextLabel", {Size=UDim2.new(1,-40,0,20), Position=UDim2.new(0,20,0,130), BackgroundTransparency=1, Text="", TextColor3=Delta.Theme.Danger, Parent=box})
    local btn = Create("TextButton", {Size=UDim2.new(1,-40,0,40), Position=UDim2.new(0,20,0,170), BackgroundColor3=Delta.Theme.Accent, Text="Verify", TextColor3=Color3.new(0,0,0), Font=Enum.Font.GothamBold, Parent=box})
    Corner(btn, 6)
    local success = false
    btn.MouseButton1Click:Connect(function()
        for _, k in ipairs(keys) do
            if input.Text == k then
                if writefile then pcall(function() writefile(fileName, k) end) end
                success = true
                TweenService:Create(box, TweenInfo.new(0.3), {Size=UDim2.new(0,350,0,0)}):Play()
                task.wait(0.3); gui:Destroy(); return
            end
        end
        status.Text = "❌ Invalid Key."
    end)
    repeat task.wait(0.1) until success
    return true
end

-- 8. محرر الثيمات (Live Theme Editor)
function Delta:OpenThemeEditor()
    local gui = Create("ScreenGui", {Name="ThemeEditor", ResetOnSpawn=false, Parent=CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    local panel = Create("Frame", {Size=UDim2.new(0,200,0,350), Position=UDim2.new(0.5,-100,0.5,-175), BackgroundColor3=Delta.Theme.Bg, Parent=gui})
    Corner(panel, 8); Stroke(panel, Delta.Theme.Accent, 1.5)
    Create("TextLabel", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Text="🎨 Theme Editor", TextColor3=Delta.Theme.Accent, Font=Enum.Font.GothamBold, Parent=panel})
    local scroll = Create("ScrollingFrame", {Size=UDim2.new(1,-10,1,-50), Position=UDim2.new(0,5,0,35), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=panel})
    Create("UIListLayout", {Padding=UDim.new(0,5), Parent=scroll})
    local keys = {"Bg", "Surface", "SurfaceLight", "Accent", "Danger", "Text", "SubText", "Border"}
    for _, key in ipairs(keys) do
        local row = Create("Frame", {Size=UDim2.new(1,0,0,25), BackgroundColor3=Delta.Theme.Surface, Parent=scroll})
        Corner(row, 4)
        Create("TextLabel", {Size=UDim2.new(0.6,0,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1, Text=key, TextColor3=Delta.Theme.Text, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
        local preview = Create("Frame", {Size=UDim2.new(0,30,0,15), Position=UDim2.new(1,-35,0.5,-7.5), BackgroundColor3=Delta.Theme[key], Parent=row})
        Corner(preview, 3); Stroke(preview, Delta.Theme.Border, 1)
        preview.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- هنا يمكن إضافة منتقي ألوان متقدم، لكن للتبسيط سنقوم بتدوير الألوان
                local c = Delta.Theme[key]
                Delta.Theme[key] = Color3.new(math.random(), math.random(), math.random())
                preview.BackgroundColor3 = Delta.Theme[key]
                if _G.DeltaUI_ApplyTheme then _G.DeltaUI_ApplyTheme() end
            end
        end)
    end
end

-- 9. نظام الإشعارات (Notifications)
function Delta:Notify(text, duration, type)
    duration = duration or 3; type = type or "info"
    local color = (type == "success" and Delta.Theme.Accent) or (type == "error" and Delta.Theme.Danger) or Color3.fromRGB(0,170,255)
    local icon = (type == "success" and "✅") or (type == "error" and "❌") or "ℹ️"
    local gui = Create("ScreenGui", {Name="Notif", ResetOnSpawn=false, Parent=CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    local notif = Create("Frame", {Size=UDim2.new(0,250,0,50), Position=UDim2.new(1,50,0,100), BackgroundColor3=Delta.Theme.Surface, Parent=gui})
    Corner(notif, 6); local stroke = Stroke(notif, color, 1)
    Create("TextLabel", {Size=UDim2.new(0,30,1,0), Position=UDim2.new(0,5,0,0), BackgroundTransparency=1, Text=icon, TextColor3=color, Font=Enum.Font.GothamBold, TextSize=16, Parent=notif})
    Create("TextLabel", {Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,35,0,0), BackgroundTransparency=1, Text=text, TextColor3=Delta.Theme.Text, Font=Enum.Font.Gotham, TextSize=12, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, Parent=notif})
    TweenService:Create(notif, TweenInfo.new(0.3), {Position=UDim2.new(1,-260,0,100)}):Play()
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {Position=UDim2.new(1,50,0,100)}):Play()
        task.wait(0.4); gui:Destroy()
    end)
end

-- 10. دالة إنشاء النافذة (CreateWindow)
function Delta:CreateWindow(config)
    local Window = setmetatable({}, {__index = self})
    local title = config.Title or "Delta v8.0.0"
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local defaultWidth = isMobile and math.min(screenSize.X - 40, 380) or 520
    local defaultHeight = isMobile and math.min(screenSize.Y - 100, 300) or 380
    
    local size = config.Size or UDim2.new(0, defaultWidth, 0, defaultHeight)
    Window.Tabs = {}
    Window.IsMinimized = false

    local ScreenGui = Create("ScreenGui", {Name = "DeltaUI_v8", ResetOnSpawn = false, Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    Window.ScreenGui = ScreenGui

    local Main = Create("Frame", {Name = "Main", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), BackgroundColor3 = Delta.Theme.Bg, BorderSizePixel = 0, Parent = ScreenGui})
    Corner(Main, 10); local mainStroke = Stroke(Main, Delta.Theme.Border, 1)
    Window.MainFrame = Main

    local TopBar = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Delta.Theme.Surface, BorderSizePixel = 0, Parent = Main})
    Corner(TopBar, 10)
    Create("Frame", {Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Delta.Theme.Surface, Parent = TopBar})
    
    local TitleLabel = Create("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Delta.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = isMobile and 12 or 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar})

    local BtnContainer = Create("Frame", {Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -65, 0, 0), BackgroundTransparency = 1, Parent = TopBar})
    local MinBtn = Create("TextButton", {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, 0, 0.5, -12.5), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = "-", TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 16, Parent = BtnContainer})
    Corner(MinBtn, 6)
    local CloseBtn = Create("TextButton", {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, 30, 0.5, -12.5), BackgroundColor3 = Delta.Theme.Danger, Text = "X", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, Parent = BtnContainer})
    Corner(CloseBtn, 6)

    local Sidebar = Create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 120, 1, -50), Position = UDim2.new(0, 10, 0, 50), BackgroundTransparency = 1, Parent = Main})
    Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sidebar})

    local ContentFrame = Create("Frame", {Name = "ContentFrame", Size = UDim2.new(1, -140, 1, -60), Position = UDim2.new(0, 130, 0, 50), BackgroundTransparency = 1, Parent = Main})
    local ContentArea = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Delta.Theme.Border, CanvasSize = UDim2.new(0,0,0,0), Parent = ContentFrame})
    local ContentLayout = Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ContentArea})
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)

    -- إصلاح مشكلة التصغير
    MinBtn.MouseButton1Click:Connect(function()
        Window.IsMinimized = not Window.IsMinimized
        PlaySound(6895079853, 0.3)
        if Window.IsMinimized then
            ContentFrame.Visible = false
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 140, 0, size.Y.Offset)}):Play()
        else
            ContentFrame.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3), {Size = size}):Play()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    function Window:SetSize(newSize) size = newSize; if not Window.IsMinimized then TweenService:Create(Main, TweenInfo.new(0.3), {Size = newSize}):Play() end end
    function Window:Destroy() ScreenGui:Destroy() end

    _G.DeltaUI_ApplyTheme = function()
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundColor3 = Delta.Theme.Bg}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color = Delta.Theme.Border}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextColor3 = Delta.Theme.Accent}):Play()
        TweenService:Create(TopBar, TweenInfo.new(0.3), {BackgroundColor3 = Delta.Theme.Surface}):Play()
        -- يمكن تحديث باقي العناصر هنا
    end

    function Window:AddTab(name, icon)
        local TabBtn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Delta.Theme.Surface, BackgroundTransparency = 1, Text = "  " .. (icon or "") .. " " .. name, TextColor3 = Delta.Theme.SubText, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Sidebar})
        Corner(TabBtn, 6)
        local TabContainer = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = ContentArea})
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabContainer})
        table.insert(Window.Tabs, {Button = TabBtn, Container = TabContainer})
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Window.Tabs) do t.Button.BackgroundTransparency = 1; t.Button.TextColor3 = Delta.Theme.SubText; t.Container.Visible = false end
            TabBtn.BackgroundTransparency = 0; TabBtn.BackgroundColor3 = Delta.Theme.SurfaceLight; TabBtn.TextColor3 = Delta.Theme.Accent; TabContainer.Visible = true
        end)
        if #Window.Tabs == 1 then TabBtn:Fire("MouseButton1Click") end
        
        local TabAPI = {}
        
        function TabAPI:AddSection(text)
            local lbl = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = TabContainer})
            Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = Delta.Theme.Border, Parent = lbl})
        end

        function TabAPI:AddParagraph(title, text)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Delta.Theme.Surface, Parent = TabContainer})
            Corner(frame, 6)
            Create("TextLabel", {Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, Text = title, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            Create("TextLabel", {Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 5, 0, 25), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.SubText, Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
        end

        function TabAPI:AddButton(text, callback)
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, Parent = TabContainer})
            Corner(btn, 6)
            btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Delta.Theme.Border}):Play() end)
            btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Delta.Theme.SurfaceLight}):Play() end)
            btn.MouseButton1Click:Connect(function() PlaySound(6895079853, 0.3); if callback then pcall(callback) end end)
        end

        function TabAPI:AddToggle(text, default, callback)
            local isOn = SavedConfig["Toggle_"..text] ~= nil and SavedConfig["Toggle_"..text] or (default or false)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local bg = Create("Frame", {Size = UDim2.new(0, 45, 0, 24), Position = UDim2.new(1, -45, 0.5, -12), BackgroundColor3 = isOn and Delta.Theme.Accent or Delta.Theme.Surface, Parent = frame})
            Corner(bg, 12); Stroke(bg, isOn and Delta.Theme.Accent or Delta.Theme.Border, 1)
            local knob = Create("Frame", {Size = UDim2.new(0, 18, 0, 18), Position = isOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1), Parent = bg})
            Corner(knob, 9)
            local click = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = frame})
            click.MouseButton1Click:Connect(function()
                isOn = not isOn; PlaySound(6895079853, 0.3)
                SavedConfig["Toggle_"..text] = isOn; SaveConfig()
                local target = isOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                TweenService:Create(knob, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = target}):Play()
                TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and Delta.Theme.Accent or Delta.Theme.Surface}):Play()
                if callback then pcall(callback, isOn) end
            end)
        end

        function TabAPI:AddSlider(text, min, max, default, callback)
            local val = SavedConfig["Slider_"..text] ~= nil and SavedConfig["Slider_"..text] or (default or min)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = TabContainer})
            local label = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text .. " : " .. tostring(val), TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local track = Create("Frame", {Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 25), BackgroundColor3 = Delta.Theme.Surface, Parent = frame})
            Corner(track, 3)
            local fill = Create("Frame", {Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = Delta.Theme.Accent, Parent = track})
            Corner(fill, 3)
            local knob = Create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((val-min)/(max-min), 0, 0.5, -7), BackgroundColor3 = Color3.new(1,1,1), Parent = track})
            Corner(knob, 7); Stroke(knob, Delta.Theme.Accent, 2)
            local dragging = false
            local function update(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val = math.floor((min + (max - min) * rel) * 100 + 0.5) / 100
                fill.Size = UDim2.new(rel, 0, 1, 0); knob.Position = UDim2.new(rel, 0, 0.5, -7); label.Text = text .. " : " .. tostring(val)
                SavedConfig["Slider_"..text] = val; SaveConfig()
                if callback then pcall(callback, val) end
            end
            knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 18, 0, 10)}):Play() end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false; TweenService:Create(knob, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 14, 0, 14)}):Play() end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end end)
        end

        function TabAPI:AddDropdown(text, options, callback)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local btn = Create("TextButton", {Size = UDim2.new(0.4, 0, 0, 26), Position = UDim2.new(0.6, 0, 0.5, -13), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = "Select...", TextColor3 = Delta.Theme.Text, Parent = frame})
            Corner(btn, 6)
            local list = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 35), BackgroundTransparency = 1, ClipsDescendants = true, Parent = frame})
            btn.MouseButton1Click:Connect(function()
                PlaySound(6895079853, 0.3)
                local open = list.Size.Y.Offset == 0
                local targetSize = open and UDim2.new(1, 0, 0, math.min(#options * 25, 100)) or UDim2.new(1, 0, 0, 0)
                TweenService:Create(list, TweenInfo.new(0.2), {Size = targetSize}):Play()
                if open then
                    for _, v in ipairs(list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for i, opt in ipairs(options) do
                        local optBtn = Create("TextButton", {Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,(i-1)*25), BackgroundTransparency = 1, Text = opt, TextColor3 = Delta.Theme.Text, Parent = list})
                        optBtn.MouseButton1Click:Connect(function()
                            btn.Text = opt; PlaySound(6895079853, 0.3)
                            TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,0)}):Play()
                            if callback then pcall(callback, opt) end
                        end)
                    end
                end
            end)
        end

        function TabAPI:AddTextbox(text, placeholder, callback)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local box = Create("TextBox", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = Delta.Theme.Surface, Text = "", PlaceholderText = placeholder or "Type here...", TextColor3 = Delta.Theme.Text, PlaceholderColor3 = Delta.Theme.SubText, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            Corner(box, 6); Stroke(box, Delta.Theme.Border, 1)
            Create("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = box})
            box.FocusLost:Connect(function() PlaySound(6895079853, 0.3); if callback then pcall(callback, box.Text) end end)
        end

        return TabAPI
    end

    _G.DeltaUI_v8_Loaded = Delta
    return Window
end

return Delta
