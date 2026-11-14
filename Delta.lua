--[[
    =========================================
    Delta UI Library v4.0.0 (Ultimate Edition)
    Author: ibrahimkhacef5-del
    GitHub: https://github.com/ibrahimkhacef5-del/Detla-lib-op
    Description: Feature-rich UI Library with Key System, Loading Screen, Auto-Save, and Advanced Elements.
    =========================================
]]

local Delta = {}
Delta.__index = Delta

if _G.DeltaUI_v4_Loaded then return _G.DeltaUI_v4_Loaded end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- =========================================
-- إعدادات الألوان (Theme)
-- =========================================
Delta.Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(24, 24, 24),
    SurfaceLight = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 255, 136),
    Danger = Color3.fromRGB(255, 85, 85),
    Info = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(45, 45, 45)
}

-- =========================================
-- دوال مساعدة (Helpers)
-- =========================================
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

-- =========================================
-- نظام الحفظ التلقائي المتقدم (Auto-Save System)
-- =========================================
local ConfigFile = "DeltaUI_v4_Config.json"
local SavedConfig = {}

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and type(data) == "table" then SavedConfig = data end
    end
end

local function SaveConfig()
    if writefile then
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(SavedConfig)) end)
    end
end

LoadConfig()

-- =========================================
-- نظام الحماية (Key System)
-- =========================================
function Delta:LoadKeySystem(validKeys, onSuccess)
    local KeyGui = Create("ScreenGui", {Name = "DeltaKeySystem", ResetOnSpawn = false, Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    
    local MainKeyFrame = Create("Frame", {
        Size = UDim2.new(0, 350, 0, 250), Position = UDim2.new(0.5, -175, 0.5, -125),
        BackgroundColor3 = Delta.Theme.Background, Parent = KeyGui
    })
    Corner(MainKeyFrame, 12); Stroke(MainKeyFrame, Delta.Theme.Border, 1)

    Create("TextLabel", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Text = "Delta Key System", TextColor3 = Delta.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 20, Parent = MainKeyFrame})
    Create("TextLabel", {Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 60), BackgroundTransparency = 1, Text = "Please enter your access key below:", TextColor3 = Delta.Theme.SubText, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = MainKeyFrame})

    local KeyBox = Create("TextBox", {
        Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 20, 0, 90),
        BackgroundColor3 = Delta.Theme.Surface, Text = "", PlaceholderText = "Paste your key here...",
        TextColor3 = Delta.Theme.Text, PlaceholderColor3 = Delta.Theme.SubText, Font = Enum.Font.Code, TextSize = 14, Parent = MainKeyFrame
    })
    Corner(KeyBox, 6); Stroke(KeyBox, Delta.Theme.Border, 1)

    local StatusLabel = Create("TextLabel", {Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 140), BackgroundTransparency = 1, Text = "", TextColor3 = Delta.Theme.Danger, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = MainKeyFrame})

    local SubmitBtn = Create("TextButton", {
        Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 20, 0, 180),
        BackgroundColor3 = Delta.Theme.Accent, Text = "Verify Key", TextColor3 = Color3.new(0,0,0),
        Font = Enum.Font.GothamBold, TextSize = 14, Parent = MainKeyFrame
    })
    Corner(SubmitBtn, 6)

    SubmitBtn.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        local isValid = false
        for _, v in ipairs(validKeys) do
            if key == v then isValid = true break end
        end

        if isValid then
            StatusLabel.Text = "Key Valid! Loading..."; StatusLabel.TextColor3 = Delta.Theme.Accent
            task.wait(1)
            KeyGui:Destroy()
            if onSuccess then onSuccess() end
        else
            StatusLabel.Text = "Invalid Key. Try again."; StatusLabel.TextColor3 = Delta.Theme.Danger
            TweenService:Create(KeyBox, TweenInfo.new(0.1), {Position = UDim2.new(0, 25, 0, 90)}):Play()
            task.wait(0.1)
            TweenService:Create(KeyBox, TweenInfo.new(0.1), {Position = UDim2.new(0, 20, 0, 90)}):Play()
        end
    end)
end

-- =========================================
-- شاشة التحميل (Loading Screen)
-- =========================================
function Delta:LoadLoadingScreen(text)
    local LoadGui = Create("ScreenGui", {Name = "DeltaLoading", ResetOnSpawn = false, Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    local LoadFrame = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Delta.Theme.Background, Parent = LoadGui})
    
    Create("TextLabel", {Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 0.4, 0), BackgroundTransparency = 1, Text = text or "Loading Delta UI...", TextColor3 = Delta.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 24, Parent = LoadFrame})
    
    local SpinFrame = Create("Frame", {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0.5, -20, 0.5, 0), BackgroundTransparency = 1, Parent = LoadFrame})
    local Spinner = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = SpinFrame})
    local SpinStroke = Create("UIStroke", {Color = Delta.Theme.Accent, Thickness = 4, Parent = Spinner})
    local SpinCorner = Corner(Spinner, 20)
    SpinStroke.LineJoinMode = Enum.LineJoinMode.Round
    
    local spinTween = TweenService:Create(Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    spinTween:Play()
    
    task.wait(2) -- وقت وهمي للتحميل
    TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SpinStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    task.wait(0.5)
    LoadGui:Destroy()
end

-- =========================================
-- 1. إنشاء النافذة (Window)
-- =========================================
function Delta:CreateWindow(config)
    local Window = setmetatable({}, {__index = self})
    local title = config.Title or "Delta UI v4"
    local size = config.Size or UDim2.new(0, 520, 0, 380)
    
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    local guiName = "DeltaUI_" .. tostring(math.random(1000, 9999))
    local ScreenGui = Create("ScreenGui", {Name = guiName, ResetOnSpawn = false, Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")})
    Window.ScreenGui = ScreenGui
    
    local Main = Create("Frame", {Name = "Main", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), BackgroundColor3 = Delta.Theme.Background, BorderSizePixel = 0, Parent = ScreenGui})
    Corner(Main, 12); Stroke(Main, Delta.Theme.Border, 1)
    Window.MainFrame = Main
    
    -- الشريط العلوي
    local TopBar = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Delta.Theme.Surface, BorderSizePixel = 0, Parent = Main})
    Corner(TopBar, 12)
    Create("Frame", {Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Delta.Theme.Surface, Parent = TopBar})
    
    Create("TextLabel", {Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Delta.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar})
    
    -- زر التصغير
    local MinBtn = Create("TextButton", {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -64, 0.5, -12), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = "-", TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, Parent = TopBar})
    Corner(MinBtn, 6)
    
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 520, 0, 40) or size
        TweenService:Create(Main, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end)
    
    -- زر الإغلاق
    local CloseBtn = Create("TextButton", {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -34, 0.5, -12), BackgroundColor3 = Delta.Theme.Danger, Text = "X", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, Parent = TopBar})
    Corner(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- الشريط الجانبي (Tabs)
    local Sidebar = Create("Frame", {Size = UDim2.new(0, 130, 1, -50), Position = UDim2.new(0, 10, 0, 50), BackgroundTransparency = 1, Parent = Main})
    Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Sidebar})
    
    -- حاوية المحتوى
    local ContentArea = Create("ScrollingFrame", {Size = UDim2.new(1, -150, 1, -60), Position = UDim2.new(0, 140, 0, 50), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = Delta.Theme.Border, CanvasSize = UDim2.new(0,0,0,0), Parent = Main})
    local ContentLayout = Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ContentArea})
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)

    -- السحب
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

    -- API: تغيير الحجم
    function Window:SetSize(newSize) TweenService:Create(Main, TweenInfo.new(0.3), {Size = newSize}):Play() end
    -- API: تدمير النافذة
    function Window:Destroy() ScreenGui:Destroy() end
    -- API: حفظ الإعدادات
    function Window:SaveSettings() SaveConfig() end

    -- =========================================
    -- نظام الإشعارات
    -- =========================================
    local NotifArea = Create("Frame", {Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1, Parent = ScreenGui})
    local NotifLayout = Create("UIListLayout", {Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = NotifArea})
    Create("UIPadding", {PaddingBottom = UDim.new(0, 20), PaddingRight = UDim.new(0, 10), Parent = NotifArea})

    function Window:Notify(text, duration, notifType)
        duration = duration or 3
        notifType = notifType or "info"
        local color = notifType == "success" and Delta.Theme.Accent or (notifType == "error" and Delta.Theme.Danger or Delta.Theme.Info)
        
        local notif = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Delta.Theme.Surface, Parent = NotifArea, BackgroundTransparency = 1})
        Corner(notif, 8)
        local stroke = Stroke(notif, color, 1); stroke.Transparency = 1
        local label = Create("TextLabel", {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = notif})
        
        notif.Position = UDim2.new(1, 50, 0, 0)
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
        TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        
        task.delay(duration, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.4); notif:Destroy()
        end)
    end

    -- =========================================
    -- نظام التأكيد (Confirm Dialog)
    -- =========================================
    function Window:Confirm(text, onConfirm)
        local confirmGui = Create("Frame", {Size = UDim2.new(0, 300, 0, 150), Position = UDim2.new(0.5, -150, 0.5, -75), BackgroundColor3 = Delta.Theme.Surface, Parent = ScreenGui, ZIndex = 200})
        Corner(confirmGui, 10); Stroke(confirmGui, Delta.Theme.Border, 1)
        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 60), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 14, TextWrapped = true, Parent = confirmGui})
        local btnArea = Create("Frame", {Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 1, -50), BackgroundTransparency = 1, Parent = confirmGui})
        
        local yesBtn = Create("TextButton", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Delta.Theme.Accent, Text = "Yes", TextColor3 = Color3.new(0,0,0), Font = Enum.Font.GothamBold, TextSize = 13, Parent = btnArea})
        Corner(yesBtn, 6)
        local noBtn = Create("TextButton", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundColor3 = Delta.Theme.Danger, Text = "No", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, Parent = btnArea})
        Corner(noBtn, 6)
        
        yesBtn.MouseButton1Click:Connect(function() if onConfirm then pcall(onConfirm) end; confirmGui:Destroy() end)
        noBtn.MouseButton1Click:Connect(function() confirmGui:Destroy() end)
    end

    -- =========================================
    -- إضافة التبويبات والعناصر
    -- =========================================
    function Window:AddTab(name, iconText)
        local TabBtn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Delta.Theme.SurfaceLight, BackgroundTransparency = 1, Text = "  " .. (iconText or "") .. "  " .. name, TextColor3 = Delta.Theme.SubText, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = Sidebar})
        Corner(TabBtn, 6)
        
        local TabContainer = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = ContentArea})
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabContainer})
        
        local Tab = {Button = TabBtn, Container = TabContainer}
        table.insert(Window.Tabs, Tab)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Window.Tabs) do t.Button.BackgroundTransparency = 1; t.Button.TextColor3 = Delta.Theme.SubText; t.Container.Visible = false end
            TabBtn.BackgroundTransparency = 0; TabBtn.TextColor3 = Delta.Theme.Accent; TabContainer.Visible = true
        end)
        
        if #Window.Tabs == 1 then TabBtn:Fire("MouseButton1Click") end
        local TabAPI = {}
        
        -- 1. زر عادي
        function TabAPI:AddButton(text, callback)
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, Parent = TabContainer})
            Corner(btn, 6)
            btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Delta.Theme.Border}):Play() end)
            btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Delta.Theme.SurfaceLight}):Play() end)
            btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
        end

        -- 2. نص (Label)
        function TabAPI:AddLabel(text)
            local lbl = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = TabContainer})
        end

        -- 3. زر خطر (تأكيد)
        function TabAPI:AddConfirmButton(text, callback)
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Delta.Theme.Danger, Text = "⚠ " .. text, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, Parent = TabContainer})
            Corner(btn, 6)
            btn.MouseButton1Click:Connect(function() Window:Confirm("Are you sure?", function() if callback then pcall(callback) end end) end)
        end

        -- 4. مفتاح (Toggle)
        function TabAPI:AddToggle(text, default, callback)
            local id = "Toggle_" .. text
            local isOn = SavedConfig[id] ~= nil and SavedConfig[id] or (default or false)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local bg = Create("Frame", {Size = UDim2.new(0, 50, 0, 26), Position = UDim2.new(1, -50, 0.5, -13), BackgroundColor3 = isOn and Delta.Theme.Accent or Delta.Theme.Surface, Parent = frame})
            Corner(bg, 13); Stroke(bg, isOn and Delta.Theme.Accent or Delta.Theme.Border, 1)
            local knob = Create("Frame", {Size = UDim2.new(0, 20, 0, 20), Position = isOn and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = Color3.new(1,1,1), Parent = bg})
            Corner(knob, 10)
            local click = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = frame})
            click.MouseButton1Click:Connect(function()
                isOn = not isOn; SavedConfig[id] = isOn; SaveConfig()
                local target = isOn and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                TweenService:Create(knob, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = target}):Play()
                TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and Delta.Theme.Accent or Delta.Theme.Surface}):Play()
                if callback then pcall(callback, isOn) end
            end)
        end

        -- 5. سلايدر (Slider)
        function TabAPI:AddSlider(text, min, max, default, callback)
            local id = "Slider_" .. text
            local val = SavedConfig[id] ~= nil and SavedConfig[id] or (default or min)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = TabContainer})
            local label = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text .. " : " .. tostring(val), TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local track = Create("Frame", {Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 25), BackgroundColor3 = Delta.Theme.Surface, Parent = frame})
            Corner(track, 4)
            local fill = Create("Frame", {Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = Delta.Theme.Accent, Parent = track})
            Corner(fill, 4)
            local knob = Create("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((val-min)/(max-min), 0, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1), Parent = track})
            Corner(knob, 8); Stroke(knob, Delta.Theme.Accent, 2)
            
            local dragging = false
            local function update(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val = math.floor((min + (max - min) * rel) * 100 + 0.5) / 100
                fill.Size = UDim2.new(rel, 0, 1, 0); knob.Position = UDim2.new(rel, 0, 0.5, -8); label.Text = text .. " : " .. tostring(val)
                SavedConfig[id] = val; SaveConfig()
                if callback then pcall(callback, val) end
            end
            knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 12)}):Play() end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false; TweenService:Create(knob, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 16, 0, 16)}):Play() end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end end)
        end

        -- 6. مربع نص (Textbox)
        function TabAPI:AddTextbox(text, placeholder, callback)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local box = Create("TextBox", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = Delta.Theme.Surface, Text = "", PlaceholderText = placeholder or "Type here...", TextColor3 = Delta.Theme.Text, PlaceholderColor3 = Delta.Theme.SubText, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            Corner(box, 6); Stroke(box, Delta.Theme.Border, 1)
            Create("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = box})
            box.FocusLost:Connect(function() if callback then pcall(callback, box.Text) end end)
        end

        -- 7. مربع نص كبير (Code Box)
        function TabAPI:AddBox(text, placeholder, callback)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 150), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local box = Create("TextBox", {Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0, 20), BackgroundColor3 = Delta.Theme.Surface, Text = "", PlaceholderText = placeholder or "Paste code here...", TextColor3 = Delta.Theme.Text, PlaceholderColor3 = Delta.Theme.SubText, Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, MultiLine = true, Parent = frame})
            Corner(box, 6); Stroke(box, Delta.Theme.Border, 1)
            Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 5), Parent = box})
            box.FocusLost:Connect(function() if callback then pcall(callback, box.Text) end end)
        end

        -- 8. منتقي الألوان
        function TabAPI:AddColorPicker(text, defaultColor, callback)
            local color = defaultColor or Color3.fromRGB(0, 255, 136)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local display = Create("Frame", {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -30, 0.5, -15), BackgroundColor3 = color, Parent = frame})
            Corner(display, 6); Stroke(display, Color3.new(1,1,1), 1)
            local click = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = frame})
            click.MouseButton1Click:Connect(function()
                local pickerGui = Create("Frame", {Size = UDim2.new(0, 200, 0, 150), Position = UDim2.new(0.5, -100, 0.5, -75), BackgroundColor3 = Delta.Theme.Surface, Parent = ScreenGui, ZIndex = 100})
                Corner(pickerGui, 8)
                Create("TextLabel", {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, Text = "Hue", TextColor3 = Delta.Theme.Text, Parent = pickerGui})
                local hueBar = Create("Frame", {Size = UDim2.new(0.8, 0, 0, 30), Position = UDim2.new(0.1, 0, 0, 40), Parent = pickerGui})
                Corner(hueBar, 4)
                local gradient = Instance.new("UIGradient"); local seq = {}
                for i = 0, 1, 0.1 do table.insert(seq, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1))) end
                gradient.Color = ColorSequence.new(seq); gradient.Parent = hueBar
                local indicator = Create("Frame", {Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.new(1,1,1), Parent = hueBar})
                local draggingHue = false
                local function updateHue(x)
                    local rel = math.clamp((x - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    color = Color3.fromHSV(rel, 1, 1); display.BackgroundColor3 = color; indicator.Position = UDim2.new(rel, -2, 0, 0)
                    if callback then pcall(callback, color) end
                end
                hueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = false end end)
                UserInputService.InputChanged:Connect(function(input) if draggingHue then updateHue(input.Position.X) end end)
                local closePick = Create("TextButton", {Size = UDim2.new(0.3, 0, 0, 25), Position = UDim2.new(0.35, 0, 0, 100), BackgroundColor3 = Delta.Theme.Danger, Text = "Close", TextColor3 = Color3.new(1,1,1), Parent = pickerGui})
                Corner(closePick, 4); closePick.MouseButton1Click:Connect(function() pickerGui:Destroy() end)
            end)
        end

        -- 9. قائمة منسدلة
        function TabAPI:AddDropdown(text, options, callback)
            local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = TabContainer})
            Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Delta.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            local btn = Create("TextButton", {Size = UDim2.new(0.4, 0, 0, 26), Position = UDim2.new(0.6, 0, 0.5, -13), BackgroundColor3 = Delta.Theme.SurfaceLight, Text = "Select...", TextColor3 = Delta.Theme.Text, Parent = frame})
            Corner(btn, 4)
            local list = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 35), BackgroundTransparency = 1, ClipsDescendants = true, Parent = frame})
            btn.MouseButton1Click:Connect(function()
                local open = list.Size.Y.Offset == 0
                local targetSize = open and UDim2.new(1, 0, 0, math.min(#options * 25, 100)) or UDim2.new(1, 0, 0, 0)
                TweenService:Create(list, TweenInfo.new(0.2), {Size = targetSize}):Play()
                if open then
                    for _, v in ipairs(list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for i, opt in ipairs(options) do
                        local optBtn = Create("TextButton", {Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,(i-1)*25), BackgroundTransparency = 1, Text = opt, TextColor3 = Delta.Theme.Text, Parent = list})
                        optBtn.MouseButton1Click:Connect(function()
                            btn.Text = opt; TweenService:Create(list, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,0)}):Play()
                            if callback then pcall(callback, opt) end
                        end)
                    end
                end
            end)
        end

        return TabAPI
    end

    _G.DeltaUI_v4_Loaded = Delta
    return Window
end

return Delta
