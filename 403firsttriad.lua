local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local WIDTH, HEIGHT = 520, 350

local Theme = {
    Background = Color3.fromRGB(15, 19, 29),
    Panel = Color3.fromRGB(24, 30, 43),
    Bar = Color3.fromRGB(29, 34, 47),
    Gold = Color3.fromRGB(210, 151, 39),
    Text = Color3.fromRGB(235, 237, 244),
    Muted = Color3.fromRGB(145, 153, 169),
    Button = Color3.fromRGB(39, 46, 61),
    White = Color3.fromRGB(255, 255, 255)
}

local guiName = "403FirstTriad"
local old = PlayerGui:FindFirstChild(guiName)
if old then old:Destroy() end

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function stroke(parent, color, thickness)
    create("UIStroke", {
        Color = color,
        Thickness = thickness or 1
    }, parent)
end

local gui = create("ScreenGui", {
    Name = guiName,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--// Main window

local root = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(WIDTH, HEIGHT),
    Position = UDim2.new(0.5, -WIDTH/2, 0.5, -HEIGHT/2),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Active = true
}, gui)

corner(root, 13)
local mainStroke = stroke(root, Theme.Gold, 1.5)

local top = create("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Theme.Bar,
    BorderSizePixel = 0,
    Active = true
}, root)

corner(top, 12)

create("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Bar,
    BorderSizePixel = 0
}, top)

create("TextLabel", {
    Size = UDim2.new(0, 210, 1, 0),
    Position = UDim2.fromOffset(14, 0),
    BackgroundTransparency = 1,
    Text = "✦  403 FIRST TRIAD",
    TextColor3 = Theme.Gold,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local content = create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -20, 1, -62),
    Position = UDim2.fromOffset(10, 55),
    BackgroundTransparency = 1
}, root)

--// Pages and tabs

local tabs = {
    {"⌂", "Home"},
    {"</>", "Scripts"},
    {"☁", "Cloud"},
    {"▣", "Tools"},
    {"⚙", "Settings"}
}

local pages = {}
local tabButtons = {}
local activeTab = "Settings"

for _, tab in ipairs(tabs) do
    local page = create("ScrollingFrame", {
        Name = tab[2],
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Gold,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = tab[2] == activeTab
    }, content)

    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0, 0, 0, layout.AbsoluteContentSize.Y + 12
        )
    end)

    pages[tab[2]] = page
end

for i, tab in ipairs(tabs) do
    local button = create("TextButton", {
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -235 + ((i-1)*35), 0, 9),
        BackgroundColor3 = tab[2] == activeTab
            and Theme.Gold or Theme.Button,
        Text = tab[1],
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        AutoButtonColor = false
    }, top)

    corner(button, 8)
    tabButtons[tab[2]] = button

    button.Activated:Connect(function()
        activeTab = tab[2]

        for name, page in pairs(pages) do
            page.Visible = name == activeTab
            tabButtons[name].BackgroundColor3 =
                name == activeTab and Theme.Gold or Theme.Button
        end
    end)
end

--// UI helpers

local function heading(page, text)
    create("TextLabel", {
        Size = UDim2.new(1, -10, 0, 25),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Gold,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)
end

local function row(page, title, subtitle, height)
    local frame = create("Frame", {
        Size = UDim2.new(1, -5, 0, height or 43),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0
    }, page)

    corner(frame, 7)

    create("TextLabel", {
        Size = UDim2.new(0.65, 0, 0, 20),
        Position = UDim2.fromOffset(12, subtitle and 3 or 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    if subtitle then
        create("TextLabel", {
            Size = UDim2.new(0.75, 0, 0, 14),
            Position = UDim2.fromOffset(12, 23),
            BackgroundTransparency = 1,
            Text = subtitle,
            TextColor3 = Theme.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left
        }, frame)
    end

    return frame
end

--// Settings page

local settings = pages.Settings

heading(settings, "APPEARANCE")

-- Primary color

local accents = {
    Color3.fromRGB(0, 160, 255),
    Color3.fromRGB(145, 80, 255),
    Color3.fromRGB(35, 190, 100),
    Color3.fromRGB(235, 65, 65),
    Color3.fromRGB(255, 130, 35),
    Color3.fromRGB(230, 165, 35),
    Color3.fromRGB(0, 180, 170),
    Color3.fromRGB(220, 55, 145)
}

local colorRow = row(settings, "Primary Color", nil, 48)

for i, color in ipairs(accents) do
    local dot = create("TextButton", {
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.new(1, -((#accents-i+1)*28), 0, 13),
        BackgroundColor3 = color,
        Text = ""
    }, colorRow)

    corner(dot, 20)

    dot.Activated:Connect(function()
        Theme.Gold = color
        mainStroke.Color = color

        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 =
                name == activeTab and color or Theme.Button
        end
    end)
end

-- Animation quality

local qualityRow = row(
    settings,
    "Animation Quality",
    "Visual preference",
    48
)

for i, name in ipairs({"Low", "Medium", "High"}) do
    local button = create("TextButton", {
        Size = UDim2.fromOffset(68, 25),
        Position = UDim2.new(1, -((4-i)*74)-5, 0, 11),
        BackgroundColor3 = i == 2 and Theme.Gold or Theme.Button,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10
    }, qualityRow)

    corner(button, 12)

    button.Activated:Connect(function()
        for _, child in ipairs(qualityRow:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Button
            end
        end
        button.BackgroundColor3 = Theme.Gold
    end)
end

-- Icon opacity slider

local opacityRow = row(
    settings,
    "Icon Opacity",
    "Adjust floating icon visibility",
    55
)

local opacityValue = 100

local opacityText = create("TextLabel", {
    Size = UDim2.fromOffset(45, 25),
    Position = UDim2.new(1, -48, 0, 3),
    BackgroundTransparency = 1,
    Text = "100%",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 11
}, opacityRow)

local track = create("Frame", {
    Size = UDim2.fromOffset(125, 6),
    Position = UDim2.new(1, -185, 0, 35),
    BackgroundColor3 = Theme.Button,
    BorderSizePixel = 0
}, opacityRow)

corner(track, 5)

local fill = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Theme.Gold,
    BorderSizePixel = 0
}, track)

corner(fill, 5)

local knob = create("TextButton", {
    Size = UDim2.fromOffset(14, 14),
    Position = UDim2.new(1, -7, 0.5, -7),
    BackgroundColor3 = Theme.White,
    Text = "",
    AutoButtonColor = false
}, track)

corner(knob, 20)

local function setOpacity(value)
    opacityValue = math.clamp(math.floor(value + 0.5), 0, 100)

    local alpha = opacityValue / 100

    opacityText.Text = opacityValue .. "%"
    fill.Size = UDim2.new(alpha, 0, 1, 0)
    knob.Position = UDim2.new(alpha, -7, 0.5, -7)

    -- Floating icon visibility only
    floating.BackgroundTransparency = 1 - alpha
    floating.TextTransparency = 1 - alpha
    floatingStroke.Transparency = 1 - alpha
end

local sliding = false

local function updateSlider(input)
    local x = math.clamp(
        (input.Position.X - track.AbsolutePosition.X) /
        track.AbsoluteSize.X,
        0,
        1
    )

    setOpacity(x * 100)
end

track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(input)
    end
end)

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if sliding and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateSlider(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

-- Language

local languageRow = row(settings, "Language", nil, 42)

local languageButton = create("TextButton", {
    Size = UDim2.fromOffset(115, 27),
    Position = UDim2.new(1, -130, 0, 7),
    BackgroundColor3 = Theme.Gold,
    Text = "English",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBold,
    TextSize = 11
}, languageRow)

corner(languageButton, 8)

languageButton.Activated:Connect(function()
    languageButton.Text =
        languageButton.Text == "English" and "Filipino" or "English"
end)

-- Performance

heading(settings, "PERFORMANCE")

local fpsRow = row(settings, "FPS Cap", nil, 43)

for i, name in ipairs({"30", "60", "120", "144", "240", "∞"}) do
    local button = create("TextButton", {
        Size = UDim2.fromOffset(36, 25),
        Position = UDim2.new(1, -((6-i)*40)-5, 0, 9),
        BackgroundColor3 = i == 2 and Theme.Gold or Theme.Button,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10
    }, fpsRow)

    corner(button, 9)

    button.Activated:Connect(function()
        for _, child in ipairs(fpsRow:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Button
            end
        end
        button.BackgroundColor3 = Theme.Gold
    end)
end

local function addToggle(title, subtitle)
    local r = row(settings, title, subtitle, 45)

    local toggle = create("TextButton", {
        Size = UDim2.fromOffset(48, 23),
        Position = UDim2.new(1, -60, 0, 11),
        BackgroundColor3 = Theme.Button,
        Text = "",
        AutoButtonColor = false
    }, r)

    corner(toggle, 15)

    local knobToggle = create("Frame", {
        Size = UDim2.fromOffset(17, 17),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0
    }, toggle)

    corner(knobToggle, 20)

    local enabled = false

    toggle.Activated:Connect(function()
        enabled = not enabled

        TweenService:Create(toggle, TweenInfo.new(0.12), {
            BackgroundColor3 = enabled and Theme.Gold or Theme.Button
        }):Play()

        TweenService:Create(knobToggle, TweenInfo.new(0.12), {
            Position = enabled
                and UDim2.new(1, -20, 0, 3)
                or UDim2.fromOffset(3, 3)
        }):Play()
    end)
end

addToggle("Anti AFK", "Visual toggle only")

heading(settings, "EDITOR")

local editorRow = row(settings, "Editor Text Size", nil, 43)
local editorSize = 8

local editorValue = create("TextLabel", {
    Size = UDim2.fromOffset(35, 30),
    Position = UDim2.new(1, -100, 0, 7),
    BackgroundTransparency = 1,
    Text = "8",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15
}, editorRow)

local function editorButton(text, x, callback)
    local button = create("TextButton", {
        Size = UDim2.fromOffset(38, 26),
        Position = UDim2.new(1, x, 0, 8),
        BackgroundColor3 = Theme.Gold,
        Text = text,
        TextColor3 = Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    }, editorRow)

    corner(button, 10)
    button.Activated:Connect(callback)
end

editorButton("-", -145, function()
    editorSize = math.max(6, editorSize - 1)
    editorValue.Text = tostring(editorSize)
end)

editorButton("+", -10, function()
    editorSize = math.min(20, editorSize + 1)
    editorValue.Text = tostring(editorSize)
end)

addToggle("Arceus Keyboard", "Visual toggle only")

heading(settings, "GENERAL")
addToggle("Disable Intro", "Visual preference only")
addToggle("Vibration", "Visual toggle only")

--// Floating reopen icon

local floating = create("TextButton", {
    Name = "FloatingIcon",
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0.85, 0, 0.5, 0),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0,
    Text = "403",
    TextColor3 = Theme.Gold,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Visible = false,
    AutoButtonColor = false,
    Active = true
}, gui)

corner(floating, 50)

local floatingStroke = stroke(floating, Theme.Gold, 2)

--// Minimize button

local minimize = create("TextButton", {
    Size = UDim2.fromOffset(27, 27),
    Position = UDim2.new(1, -66, 0, 10),
    BackgroundColor3 = Theme.Button,
    Text = "-",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBold,
    TextSize = 14
}, top)

corner(minimize, 8)

local close = create("TextButton", {
    Size = UDim2.fromOffset(27, 27),
    Position = UDim2.new(1, -34, 0, 10),
    BackgroundColor3 = Color3.fromRGB(115, 45, 55),
    Text = "X",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBold,
    TextSize = 13
}, top)

corner(close, 8)

local minimized = false

local function minimizeUI()
    minimized = true
    root.Visible = false
    floating.Visible = true
end

local function restoreUI()
    minimized = false
    floating.Visible = false
    root.Visible = true
end

minimize.Activated:Connect(minimizeUI)
close.Activated:Connect(function()
    gui:Destroy()
end)

--// Drag support for main window

local function makeDraggable(handle, target)
    local dragging = false
    local startInput
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            startInput = input.Position
            startPosition = target.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - startInput

            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(top, root)

--// Floating icon drag and tap

local floatDragging = false
local floatMoved = false
local floatStart
local floatPosition
local activeInput

floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        floatDragging = true
        floatMoved = false
        floatStart = input.Position
        floatPosition = floating.Position
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if not floatDragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - floatStart

        if delta.Magnitude > 8 then
            floatMoved = true
        end

        if floatMoved then
            floating.Position = UDim2.new(
                floatPosition.X.Scale,
                floatPosition.X.Offset + delta.X,
                floatPosition.Y.Scale,
                floatPosition.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if not floatDragging then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if not floatMoved then
            restoreUI()
        end

        floatDragging = false
        activeInput = nil
    end
end)
