
-- 📢 Âm thanh khởi động
local startupSound = Instance.new("Sound")
startupSound.SoundId = "rbxassetid://8594342648"
startupSound.Volume = 5
startupSound.Looped = false
startupSound.Parent = game.CoreGui
startupSound:Play()

-- 📢 Thông báo
local Notification = require(game:GetService("ReplicatedStorage").Notification)
Notification.new("<Color=Cyan>R2LX Hub <Color=/>"):Display()
wait(0.5)
Notification.new("<Color=Yellow>By R2LX Hub On Top👑<Color=/>"):Display()
wait(1)
-- 📌 R2LX HUB - Nhặt Rương Chính Xác + Đổi Server Đúng Yêu Cầu

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🖇️ Liên kết Discord
setclipboard("https://discord.gg/heSHddPs")

-- 🏴‍☠️ Tự động chọn team
local function AutoSelectTeam()
    if not getgenv().Team then
        warn("Chưa chọn team!")
        return
    end

    local teamName = getgenv().Team
    local validTeams = {"Marines", "Pirates"}

    if table.find(validTeams, teamName) then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", teamName)
        warn("✅ Đã chọn team: " .. teamName)
    else
        warn("⚠️ Team không hợp lệ: " .. teamName)
    end
end

AutoSelectTeam()
wait(2)

-- ✅ Biến kiểm soát
local autoCollectChest = true
local chestCount, chestsCollected = 0, 0
local lastChestTime = os.time()
local teleportDelay = 0.15
local collectedChestIDs = {}
local maxChests = math.random(50, 75)
local startTime = os.time()

-- 📢 Thông báo khi script khởi động
game.StarterGui:SetCore("SendNotification", {
    Title = "R2LX HUB",
    Text = "Script đang chạy... Tự động nhặt rương!",
    Duration = 5
})

-- 🚀 Teleport an toàn
local function teleportTo(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if rootPart then
        rootPart.CFrame = CFrame.new(targetPosition)
        wait(teleportDelay)
    end
end

-- 🔄 Đổi server
local function serverHop(reason)
    if not autoCollectChest then return end

    game.StarterGui:SetCore("SendNotification", {
        Title = "🔄 Server Hop",
        Text = reason,
        Duration = 5
    })

    local HttpService = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    
    for _, v in pairs(Servers) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end

-- 📦 Nhặt rương chính xác
function collectChests()
    while autoCollectChest do
        wait(0.1)

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not rootPart then return end

        -- Lấy danh sách rương
        local chests = game:GetService("CollectionService"):GetTagged("_ChestTagged")
        chestCount = 0

        for _, chest in ipairs(chests) do
            if not chest:GetAttribute("IsDisabled") and not collectedChestIDs[chest] then
                chestCount = chestCount + 1
            end
        end

        -- Tìm rương gần nhất chưa nhặt
        local closestChest, closestDist = nil, math.huge
        for _, chest in ipairs(chests) do
            if not collectedChestIDs[chest] then
                local chestPos = chest:GetPivot().Position
                local dist = (chestPos - rootPart.Position).Magnitude
                if dist < closestDist then
                    closestChest, closestDist = chest, dist
                end
            end
        end

        -- Nếu tìm thấy rương hợp lệ thì teleport & cập nhật
        if closestChest then
            teleportTo(closestChest:GetPivot().Position + Vector3.new(0, 3, 0))
            lastChestTime = os.time()
            chestsCollected = chestsCollected + 1
            collectedChestIDs[closestChest] = true

            -- 📢 Thông báo khi nhặt rương
            game.StarterGui:SetCore("SendNotification", {
                Title = "📦 Nhặt Rương",
                Text = "Đã nhặt được " .. chestsCollected .. " rương!",
                Duration = 3
            })
        end

        if chestsCollected >= maxChests then
            serverHop("Đã đạt giới hạn rương, đổi server!")
        end
    end
end

-- 🔄 Reset nhân vật mỗi 15 giây
spawn(function()
    while true do
        wait(15)
        if autoCollectChest then
            game.Players.LocalPlayer.Character:BreakJoints()
            chestsCollected, collectedChestIDs, lastChestTime = 0, {}, os.time()
            
            -- 📢 Thông báo reset nhân vật
            game.StarterGui:SetCore("SendNotification", {
                Title = "🔄 Reset Nhân Vật",
                Text = "Để chống văng game!",
                Duration = 3
            })
        end
    end
end)

-- ⏳ Cứ 90 giây đổi server
spawn(function()
    while true do
        wait(90)
        if autoCollectChest then
            serverHop("Đủ 90 giây, đổi server!")
        end
    end
end)

-- 🚨 Nếu không nhặt được rương trong 10 giây thì đổi server
spawn(function()
    while true do
        wait(10)
        if autoCollectChest and os.time() - lastChestTime > 10 then
            serverHop("Không nhặt được rương, đổi server!")
        end
    end
end)

-- 🎮 Tạo nút BẬT/TẮT
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ScreenGui)
local UICorner = Instance.new("UICorner", ToggleButton)

ToggleButton.Size = UDim2.new(0, 120, 0, 50)
ToggleButton.Position = UDim2.new(0, 50, 0, 200)
ToggleButton.Text = "ON Nhặt Rương"
ToggleButton.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
ToggleButton.TextScaled = true

ToggleButton.MouseButton1Click:Connect(function()
    autoCollectChest = not autoCollectChest
    ToggleButton.Text = autoCollectChest and "ON Nhặt Rương" or "OFF Nhặt Rương"

    if autoCollectChest then
        spawn(collectChests)
    end

    -- 📢 Thông báo bật/tắt
    game.StarterGui:SetCore("SendNotification", {
        Title = "🛠️ Trạng Thái",
        Text = autoCollectChest and "Đang nhặt rương!" or "Đã tắt nhặt rương!",
        Duration = 3
    })
end)
-- Hiệu ứng đổi màu cầu vồng cho viền chữ
spawn(function()
    local hue = 0
    while true do
        ToggleButton.TextColor3 = Color3.fromHSV(hue, 1, 1)
        hue = (hue + 0.01) % 1
        wait(0.05)
    end
end)

-- 🔥 Chạy tự động khi script khởi động
spawn(collectChests)