local T = {}

-- Đảm bảo TweenService có sẵn
local TweenService = game:GetService("TweenService")

-- Tạo ScreenGui nếu chưa có
local screenGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("NotificationGui")
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Cấu hình màu sắc
local config = {
    mainColor = Color3.fromRGB(30, 30, 30),
    textColor = Color3.fromRGB(255, 255, 255),
    accentColor = Color3.fromRGB(255, 85, 85),
    cornerRadius = UDim.new(0, 6)
}

-- Hàm tạo thông báo chính
function T.createNotification(message, duration)
    duration = duration or 3  -- Thời gian hiển thị (mặc định 3 giây)

    -- Tạo khung thông báo
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 60)
    notification.Position = UDim2.new(1, 20, 0.8, 0)
    notification.BackgroundColor3 = config.mainColor
    notification.BorderSizePixel = 0
    notification.AnchorPoint = Vector2.new(0, 0.5)
    notification.Parent = screenGui

    -- Bo góc khung thông báo
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = config.cornerRadius
    notifCorner.Parent = notification

    -- Thêm văn bản thông báo
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = config.textColor
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamBold
    notifText.TextWrapped = true
    notifText.Parent = notification

    -- Tạo đường viền màu (Accent Line)
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 4, 0.8, 0)
    accentLine.Position = UDim2.new(0, 0, 0.1, 0)
    accentLine.BackgroundColor3 = config.accentColor
    accentLine.BorderSizePixel = 0
    accentLine.Parent = notification

    -- Bo góc đường viền
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accentLine

    -- Hiệu ứng hiển thị thông báo
    notification.Position = UDim2.new(1, 20, 0.8, 0)
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -270, 0.8, 0)
    }):Play()

    -- Ẩn thông báo sau thời gian đã đặt
    task.delay(duration, function()
        if notification and notification.Parent then
            TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 20, 0.8, 0)
            }):Play()
            wait(0.6)
            if notification and notification.Parent then
                notification:Destroy()
            end
        end
    end)
end

-- ex
T.createNotification("🔔 Chào mừng bạn đến với R2LX Hub!", 10)

-- Thông báo kiểu iOS
function T.ShowNotification(text, isSuccess)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 300, 0, 60)
    Notification.Position = UDim2.new(0.5, -150, -0.3, 0)
    Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Notification.BackgroundTransparency = 0.3
    Notification.Parent = ScreenGui

    local NotificationCorner = Instance.new("UICorner", Notification)
    NotificationCorner.CornerRadius = UDim.new(0, 20)

    local NotificationStroke = Instance.new("UIStroke", Notification)
    NotificationStroke.Thickness = 1
    NotificationStroke.Color = Color3.fromRGB(200, 200, 200)

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0.05, 0, 0.1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Font = Enum.Font.SourceSansBold
    Icon.TextSize = 30
    Icon.Parent = Notification

    local Message = Instance.new("TextLabel")
    Message.Text = text
    Message.Size = UDim2.new(0.7, 0, 1, 0)
    Message.Position = UDim2.new(0.25, 0, 0, 0)
    Message.BackgroundTransparency = 1
    Message.TextColor3 = Color3.fromRGB(0, 0, 0)
    Message.Font = Enum.Font.SourceSansSemibold
    Message.TextSize = 18
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.Parent = Notification

    if isSuccess then
        Icon.Text = "✅"
        Icon.TextColor3 = Color3.fromRGB(50, 215, 75)
    else
        Icon.Text = "❌"
        Icon.TextColor3 = Color3.fromRGB(255, 59, 48)
    end

    TweenService:Create(Notification, TweenInfo.new(0.6), {Position = UDim2.new(0.5, -150, 0.05, 0)}):Play()

    local Sound = Instance.new("Sound", game.Workspace)
    Sound.SoundId = "rbxassetid://636196342"
    Sound.Volume = 2
    Sound:Play()

    wait(3)
    TweenService:Create(Notification, TweenInfo.new(0.6), {Position = UDim2.new(0.5, -150, -0.3, 0)}):Play()
    wait(0.6)
    Notification:Destroy()
end

-- Thông báo PC
function T.ShowNotificationT(message, duration)
    duration = duration or 3 -- Mặc định 3 giây

    local player = game.Players.LocalPlayer
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return end

    -- Tạo ScreenGui nếu chưa có
    local screenGui = gui:FindFirstChild("NotificationGui") or Instance.new("ScreenGui", gui)
    screenGui.Name = "NotificationGui"

    -- Tạo thông báo
    local notification = Instance.new("Frame", screenGui)
    notification.Size = UDim2.new(0, 250, 0, 50)
    notification.Position = UDim2.new(0, -260, 0, 10) -- Ẩn trước khi xuất hiện
    notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notification.BackgroundTransparency = 0.3
    notification.BorderSizePixel = 0

    -- Viền xanh lá
    local border = Instance.new("Frame", notification)
    border.Size = UDim2.new(0, 2, 1, 0)
    border.Position = UDim2.new(0, 0, 0, 0)
    border.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    -- Icon
    local icon = Instance.new("ImageLabel", notification)
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://127256058739324" -- ID ảnh có thể đổi

    -- Văn bản thông báo
    local text = Instance.new("TextLabel", notification)
    text.Size = UDim2.new(1, -50, 1, 0)
    text.Position = UDim2.new(0, 50, 0, 0)
    text.Text = message
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 16
    text.Font = Enum.Font.Gotham
    text.BackgroundTransparency = 1
    text.TextXAlignment = Enum.TextXAlignment.Left

    -- Hiệu ứng xuất hiện
    notification:TweenPosition(UDim2.new(0, 10, 0, 10), "Out", "Quad", 0.5, true)

    -- Biến mất sau thời gian đặt trước
    task.wait(duration)
    notification:TweenPosition(UDim2.new(0, -260, 0, 10), "In", "Quad", 0.5, true)
    task.wait(0.5)
    notification:Destroy()
end

-- **Cách sử dụng**: 


--- # Webhook 
local LocalizationService = game:GetService("LocalizationService")
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local le = (game:GetService("Players").LocalPlayer.Data.Level.Value)
local code = LocalizationService:GetCountryRegionForPlayerAsync(player)
local data = {
    embeds = {
        {
            title = "R2lx New Player",
            url = "https://www.roblox.com/users/" .. player.UserId,
            description = "```" .. player.DisplayName .. " (" .. player.Name .. ") ```",
            color = tonumber(0xffa500),
            author = {
                name = "Admin: R2LX and Enc and (cayngaydem)",
                url = "https://cdn.discordapp.com/attachments/1226454597724409936/1233430491953107086/Screenshot_2024-04-20-17-04-30-945_com.zing.zalo-edit.jpg?ex=662d1129&is=662bbfa9&hm=345e588812e5489a8219d6939a7b94487e79f1153c99523094d207a830f2ccee&",
                icon_url = "https://cdn.discordapp.com/attachments/1226454597724409936/1233430491953107086/Screenshot_2024-04-20-17-04-30-945_com.zing.zalo-edit.jpg?ex=662d1129&is=662bbfa9&hm=345e588812e5489a8219d6939a7b94487e79f1153c99523094d207a830f2ccee&"
            },
            image = {
            	url = "https://cdn.discordapp.com/attachments/1229077309194113094/1233391929983504394/320688412_5524593467666764_7520827848036533185_n.gif?ex=662ced3f&is=662b9bbf&hm=25bf897861b49dc4d4e1320aa246bb05f9c5ba67d2a745106b9e0ad159981a55&"
            },
            footer = {
                text = "R2lx Hub | Created by: Ari | https://discord.com/invite/E6ffTF57RG | Time: " .. os.date("%Y-%m-%d %H:%M:%S VN"),
                icon_url = "https://cdn.discordapp.com/attachments/1226454597724409936/1233424140283940924/09b1d39ef857154916c5425b203eddac.jpg?ex=662d0b3e&is=662bb9be&hm=c9a53bdf01f40ef9cd37ea93422e2ed57ae74cdb31fb2cbf7be875214cb4d7ae&"
            },
            fields = {
                {
                    name = "ᴄᴏᴜɴᴛʀʏ🌐",
                    value = "```" .. code .. "```",
                    inline = true
                },
                {
                    name = "ᴀɢᴇ📆",
                    value = "```" .. player.AccountAge .. " Days```",
                    inline = true
                },
                {
                    name = "ᴇxᴇᴄᴜᴛᴏʀ💬",
                    value = "```" .. identifyexecutor() .. "```",
                    inline = true
                },
                {
                    name = "ʟᴇᴠᴇʟ🆙:",
                    value = "```" .. le .. "```",
                    inline = true
                },
                {
                    name = "ᴊᴏʙ ɪᴅ:",
                    value = "```".. tostring(game.JobId) .."```",
                    inline = true
                },
                {
                    name = "sᴛᴀᴛᴜs❗",
                    value = "```Người Dùng Đã Dùng Script Auto Farm Blox Fruit Cảm Ơn Bạn!!!```",
                    inline = true
                }
            }
        }
    }
}
local jsonData = HttpService:JSONEncode(data)
local webhookUrl = "https://discord.com/api/webhooks/1333851587134754938/8wb5sBb2swZ3tcXQqJb_tBR8IVGPydbfQFl1LpKAhlFOZyaSZC8GAMytiwHhY3EeBaHm"
local headers = {["Content-Type"] = "application/json"}
request = http_request or request or HttpPost or fluxus.request or syn.request or Krnl.request or delta.request;
local request = http_request or request or HttpPost or syn.request
local final = {Url = webhookUrl, Body = jsonData, Method = "POST", Headers = headers}

local success, response = pcall(request, final)
if success then
    T.ShowNotification("Profile information sent to Discord.", true)
else
    T.ShowNotification("Failed to send profile information to Discord: " .. response, true)
end
    else