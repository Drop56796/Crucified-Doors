-- 创建UI界面和按钮来控制ESP功能
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local mainGui = Instance.new("ScreenGui", playerGui)
local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 0

-- 为框架添加圆角
local uICorner = Instance.new("UICorner", frame)
uICorner.CornerRadius = UDim.new(0, 10)

-- 创建开关按钮
local function createToggleButton(text, position, action)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 280, 0, 30)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    button.BorderSizePixel = 0

    -- 为按钮添加圆角
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 5)

    -- 按钮点击事件
    button.MouseButton1Click:Connect(function()
        if button.Text == text .. " On" then
            button.Text = text .. " Off"
            action(false)  -- 关闭功能
        else
            button.Text = text .. " On"
            action(true)   -- 开启功能
        end
    end)
end

-- 创建ESP和移除功能
local itemESPActive = false
local rushMovingESPActive = false
local doorESPActive = false
local removeESPActive = false

-- 定义ESP和移除功能的行为
local function itemESPFunction(state)
    itemESPActive = state
    function createItemESP(itemNames)
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("MeshPart") then
            for _, validName in ipairs(itemNames) do
                if item.Name == validName then
                    -- 创建ESP GUI
                    local espGui = Instance.new("BillboardGui")
                    espGui.Adornee = item
                    espGui.Size = UDim2.new(0, 100, 0, 50)
                    espGui.AlwaysOnTop = true

                    -- 创建文本标签以显示物品名称
                    local nameLabel = Instance.new("TextLabel", espGui)
                    nameLabel.Text = item.Name
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- 白色文字
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.Font = Enum.Font.Code  -- 使用Code字体
                    nameLabel.TextScaled = true

                    -- 将ESP GUI附加到物品
                    espGui.Parent = item
                    break  -- 找到匹配的物品后停止检查
                end
            end
        end
    end
end

-- 使用函数为'Flashlight'和'Lighter'物品创建ESP
createItemESP({"Flashlight", "Lighter"})
end

local function rushMovingESPFunction(state)
    rushMovingESPActive = state
    function createEntityESP(entityName, aliasName, alertText, textColor, circleColor)
    -- 检查是否在客户端运行
    if not game.Players.LocalPlayer then return end

    for _, entity in pairs(workspace:GetDescendants()) do
        if entity:IsA("MeshPart") and entity.Name == entityName then
            -- 使用pcall来捕获可能的错误
            local success, err = pcall(function()
                -- 创建ESP GUI
                local espGui = Instance.new("BillboardGui")
                espGui.Adornee = entity
                espGui.Size = UDim2.new(0, 200, 0, 50)
                espGui.AlwaysOnTop = true

                -- 创建文本标签以显示名称和别名
                local nameLabel = Instance.new("TextLabel", espGui)
                nameLabel.Text = "Name: " .. aliasName  -- 显示格式为: Name: Rush Entity
                nameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = textColor
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Font = Enum.Font.Code
                nameLabel.TextScaled = true

                -- 创建圆形图标
                local circleFrame = Instance.new("Frame", espGui)
                circleFrame.Size = UDim2.new(0, 30, 0, 30)
                circleFrame.Position = UDim2.new(0.5, -15, 0, -40)
                circleFrame.BackgroundColor3 = circleColor
                circleFrame.BorderSizePixel = 0
                circleFrame.ZIndex = 2

                -- 使框架成圆形
                local uICorner = Instance.new("UICorner", circleFrame)
                uICorner.CornerRadius = UDim.new(1, 0)

                -- 将ESP GUI附加到实体
                espGui.Parent = entity

                -- 创建UI提示并在三秒后关闭
                local uiTip = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
                local tipFrame = Instance.new("Frame", uiTip)
                tipFrame.Size = UDim2.new(0, 200, 0, 100)
                tipFrame.Position = UDim2.new(1, -210, 1, -110)  -- 右下角位置
                tipFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- 黑色背景

                local tipTextLabel = Instance.new("TextLabel", tipFrame)
                tipTextLabel.Size = UDim2.new(1, 0, 1, 0)
                tipTextLabel.BackgroundTransparency = 1
                tipTextLabel.TextColor3 = textColor
                tipTextLabel.Text = alertText
                tipTextLabel.Font = Enum.Font.SourceSans
                tipTextLabel.TextSize = 24

                -- 播放声音
                local sound = Instance.new("Sound", uiTip)
                sound.SoundId = "rbxassetid://150258076"  -- '叮'的声音效果
                sound:Play()

                -- 定时器关闭UI提示
                wait(3)
                uiTip:Destroy()
            end)

            -- 如果pcall捕获到错误，打印错误信息
            if not success then
                warn("创建ESP时出错: " .. err)
            end
        end
    end
end

-- 使用函数为'RushMoving'实体创建ESP并显示UI提示
createEntityESP("RushMoving", "Rush Entity", "警告: 移动中!", Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 165, 0))
end

local function doorESPFunction(state)
    doorESPActive = state
    function createDoorESP()
    for _, door in pairs(workspace:GetDescendants()) do
        if door:IsA("MeshPart") and (door.Name == "Door" or door.Name == "ClosetDupe") then
            local espGui = Instance.new("BillboardGui")
            espGui.Adornee = door
            espGui.Size = UDim2.new(0, 200, 0, 50)
            espGui.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel", espGui)
            nameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Font = Enum.Font.Code
            nameLabel.TextScaled = true

            local circleFrame = Instance.new("Frame", espGui)
            circleFrame.Size = UDim2.new(0, 30, 0, 30)
            circleFrame.Position = UDim2.new(0.5, -15, 0, -40)
            circleFrame.BorderSizePixel = 0
            circleFrame.ZIndex = 2

            local uICorner = Instance.new("UICorner", circleFrame)
            uICorner.CornerRadius = UDim.new(1, 0)

            -- 检查门是否为正确的门或者是假门
            if door.Name == "Door" then
                nameLabel.Text = "Door"
                nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- 绿色
                circleFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- 绿色
            elseif door.Name == "ClosetDupe" then
                nameLabel.Text = "FakeDoor"
                nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- 红色
                circleFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- 红色
            end

            espGui.Parent = door
        end
    end
end

-- 调用函数以创建门的ESP
createDoorESP()
end

local function removeESPFunction(state)
    removeESPActive = state
    function removeScreech()
    for _, entity in pairs(workspace:GetDescendants()) do
        if entity:IsA("MeshPart") and entity.Name == "Screech" then
            entity:Destroy()  -- 移除Screech实体
        end
    end
end

-- 调用函数来检测并移除Screech实体
removeScreech()
end

-- 创建按钮
createToggleButton("Item ESP", UDim2.new(0, 10, 0, 10), itemESPFunction)
createToggleButton("RushMoving ESP", UDim2.new(0, 10, 0, 50), rushMovingESPFunction)
createToggleButton("Door ESP", UDim2.new(0, 10, 0, 90), doorESPFunction)
createToggleButton("Remove Screech", UDim2.new(0, 10, 0, 130), removeESPFunction)

-- 持续检查状态并执行相应功能
while true do
    if itemESPActive then
        function createItemESP(itemNames)
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("MeshPart") then
            for _, validName in ipairs(itemNames) do
                if item.Name == validName then
                    -- 创建ESP GUI
                    local espGui = Instance.new("BillboardGui")
                    espGui.Adornee = item
                    espGui.Size = UDim2.new(0, 100, 0, 50)
                    espGui.AlwaysOnTop = true

                    -- 创建文本标签以显示物品名称
                    local nameLabel = Instance.new("TextLabel", espGui)
                    nameLabel.Text = item.Name
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- 白色文字
                    nameLabel.TextStrokeTransparency = 0
                    nameLabel.Font = Enum.Font.Code  -- 使用Code字体
                    nameLabel.TextScaled = true

                    -- 将ESP GUI附加到物品
                    espGui.Parent = item
                    break  -- 找到匹配的物品后停止检查
                end
            end
        end
    end
end

-- 使用函数为'Flashlight'和'Lighter'物品创建ESP
createItemESP({"Flashlight", "Lighter"})
    end
    if rushMovingESPActive then
        function createEntityESP(entityName, aliasName, alertText, textColor, circleColor)
    -- 检查是否在客户端运行
    if not game.Players.LocalPlayer then return end

    for _, entity in pairs(workspace:GetDescendants()) do
        if entity:IsA("MeshPart") and entity.Name == entityName then
            -- 使用pcall来捕获可能的错误
            local success, err = pcall(function()
                -- 创建ESP GUI
                local espGui = Instance.new("BillboardGui")
                espGui.Adornee = entity
                espGui.Size = UDim2.new(0, 200, 0, 50)
                espGui.AlwaysOnTop = true

                -- 创建文本标签以显示名称和别名
                local nameLabel = Instance.new("TextLabel", espGui)
                nameLabel.Text = "Name: " .. aliasName  -- 显示格式为: Name: Rush Entity
                nameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = textColor
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Font = Enum.Font.Code
                nameLabel.TextScaled = true

                -- 创建圆形图标
                local circleFrame = Instance.new("Frame", espGui)
                circleFrame.Size = UDim2.new(0, 30, 0, 30)
                circleFrame.Position = UDim2.new(0.5, -15, 0, -40)
                circleFrame.BackgroundColor3 = circleColor
                circleFrame.BorderSizePixel = 0
                circleFrame.ZIndex = 2

                -- 使框架成圆形
                local uICorner = Instance.new("UICorner", circleFrame)
                uICorner.CornerRadius = UDim.new(1, 0)

                -- 将ESP GUI附加到实体
                espGui.Parent = entity

                -- 创建UI提示并在三秒后关闭
                local uiTip = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
                local tipFrame = Instance.new("Frame", uiTip)
                tipFrame.Size = UDim2.new(0, 200, 0, 100)
                tipFrame.Position = UDim2.new(1, -210, 1, -110)  -- 右下角位置
                tipFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- 黑色背景

                local tipTextLabel = Instance.new("TextLabel", tipFrame)
                tipTextLabel.Size = UDim2.new(1, 0, 1, 0)
                tipTextLabel.BackgroundTransparency = 1
                tipTextLabel.TextColor3 = textColor
                tipTextLabel.Text = alertText
                tipTextLabel.Font = Enum.Font.SourceSans
                tipTextLabel.TextSize = 24

                -- 播放声音
                local sound = Instance.new("Sound", uiTip)
                sound.SoundId = "rbxassetid://150258076"  -- '叮'的声音效果
                sound:Play()

                -- 定时器关闭UI提示
                wait(3)
                uiTip:Destroy()
            end)

            -- 如果pcall捕获到错误，打印错误信息
            if not success then
                warn("创建ESP时出错: " .. err)
            end
        end
    end
end

-- 使用函数为'RushMoving'实体创建ESP并显示UI提示
createEntityESP("RushMoving", "Rush Entity", "警告: 移动中!", Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 165, 0))
    end
    if doorESPActive then
        function createDoorESP()
    for _, door in pairs(workspace:GetDescendants()) do
        if door:IsA("MeshPart") and (door.Name == "Door" or door.Name == "ClosetDupe") then
            local espGui = Instance.new("BillboardGui")
            espGui.Adornee = door
            espGui.Size = UDim2.new(0, 200, 0, 50)
            espGui.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel", espGui)
            nameLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Font = Enum.Font.Code
            nameLabel.TextScaled = true

            local circleFrame = Instance.new("Frame", espGui)
            circleFrame.Size = UDim2.new(0, 30, 0, 30)
            circleFrame.Position = UDim2.new(0.5, -15, 0, -40)
            circleFrame.BorderSizePixel = 0
            circleFrame.ZIndex = 2

            local uICorner = Instance.new("UICorner", circleFrame)
            uICorner.CornerRadius = UDim.new(1, 0)

            -- 检查门是否为正确的门或者是假门
            if door.Name == "Door" then
                nameLabel.Text = "Door"
                nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- 绿色
                circleFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- 绿色
            elseif door.Name == "ClosetDupe" then
                nameLabel.Text = "FakeDoor"
                nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- 红色
                circleFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- 红色
            end

            espGui.Parent = door
        end
    end
end

-- 调用函数以创建门的ESP
createDoorESP()
    end
    if removeESPActive then
        function removeScreech()
    for _, entity in pairs(workspace:GetDescendants()) do
        if entity:IsA("MeshPart") and entity.Name == "Screech" then
            entity:Destroy()  -- 移除Screech实体
        end
    end
end

-- 调用函数来检测并移除Screech实体
removeScreech()
    end
    wait(0.25)
end
