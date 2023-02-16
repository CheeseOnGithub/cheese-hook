local players = game:GetService("Players")
local lplr = players.LocalPlayer
local runservice = game:GetService("RunService")
local TextService = game:GetService("TextService")
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local window = lib.new({
    text = "project delta penis update",
    size = Vector2.new(500, 550),
    rounding = 1
})
window.open()


-- anticheat bypasses
for i, v in pairs(getconnections(lplr.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"))) do
    v:Disable()
end


local namecall;namecall = hookmetamethod(game,'__namecall', function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and tostring(self) == "ProjectileInflict" and getcallingscript().Name == "CharacterController" then
        return wait(9e9)
    end

    return namecall(self, ...)
end)

-- i store tabs in a table because its easier to use
local ui = {
    toggles = {},
    sliders = {}
}

local drawings = {
    boxes = {},
    boxoutlines = {},
    healthbars = {},
    healthbaroutlines = {}
}

local tabs = {
    player = window.new({
        text = "player"
    }),
    visuals = window.new({
        text = "visuals"
    })
}

--#region ui
ui.toggles.walkspeed = tabs.player.new("switch", {
    text = "walkspeed"
})

ui.sliders.walkspeed = tabs.player.new("slider", {
    text = "speed speed",
    min = 16,
    max = 25,
    value = 16,
    rounding = 1,
})

ui.toggles.nojumpcooldown = tabs.player.new("switch", {
    text = "no jump cooldown"
})

ui.toggles.bhop = tabs.player.new("switch", {
    text = "bhop"
})

ui.toggles.boxesp = tabs.visuals.new("switch", {
    text = "box esp"
})

ui.toggles.thirdperson = tabs.visuals.new("switch", {
    text = "third person"
})
--#endregion ui

ui.toggles.thirdperson.event:Connect(function(val)
    if val then
        lplr.CameraMaxZoomDistance = 1000
        lplr.CameraMaxZoomDistance = 10
        lplr.CameraMode = Enum.CameraMode.Classic
        lplr.DevEnableMouseLock = true
    else
        lplr.CameraMaxZoomDistance = 0.5
        lplr.CameraMaxZoomDistance = 0.5
        lplr.CameraMode = Enum.CameraMode.LockFirstPerson
        lplr.DevEnableMouseLock = false
    end
end)

for i,v in pairs(players:GetPlayers()) do
    if v ~= lplr and not drawings.boxes[v] then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        box.ZIndex = 50
        box.Color = Color3.new(0.4, 0.035294, 0.701960)
        drawings.boxes[v] = box

        local boxoutline = Drawing.new("Square")
        boxoutline.Visible = false
        boxoutline.Thickness = 2
        boxoutline.Filled = false
        boxoutline.ZIndex = 1
        drawings.boxoutlines[v] = boxoutline

        local healthbaroutline = Drawing.new("Square")
        healthbaroutline.Visible = false
        healthbaroutline.Filled = true
        healthbaroutline.Thickness = 2
        healthbaroutline.ZIndex = 1
        drawings.healthbaroutlines[v] = healthbaroutline

        local healthbar = Drawing.new("Square")
        healthbar.Visible = false
        healthbar.Filled = true
        healthbar.ZIndex = 50
        drawings.healthbars[v] = healthbar
    end
end

players.PlayerRemoving:Connect(function(v)
    if drawings.boxes[v] then
        drawings.boxes[v]:Remove()
        drawings.boxes[v] = nil
    end
end)

players.PlayerAdded:Connect(function(v)
    if v ~= lplr and not drawings.boxes[v] then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        drawings.boxes[v] = box
    end
end)


ui.toggles.walkspeed.event:Connect(function(val)
    if not val then
        lplr.Character.Humanoid.WalkSpeed = 16
    end
end)

runservice.Stepped:Connect(function(time, deltaTime)
    if ui.toggles.walkspeed.on then
        lplr.Character.Humanoid.WalkSpeed = ui.sliders.walkspeed.value
    end

    if ui.toggles.nojumpcooldown.on then
        lplr.Character.Humanoid:SetAttribute("JumpCooldown", 0)
    end

    if ui.toggles.bhop.on then
        local params = RaycastParams.new()
        local filter = {lplr.Character, workspace.CurrentCamera}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.IgnoreWater = true
        params.FilterDescendantsInstances = filter
        local hrp = lplr.Character.HumanoidRootPart


        local res = workspace:Raycast(hrp.Position, Vector3.new(0, -3.5, 0), params)

        if res and res.Instance then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 25, hrp.Velocity.Z)
        end
    end

    if ui.toggles.boxesp.on then
        for i,v in pairs(players:GetPlayers()) do
            if v ~= lplr and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local hrp, visible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local head, headvisible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position + Vector3.new(0, 1, 0))
                local leg, legvisible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position - Vector3.new(0,3,0))
                local X = 2000 / hrp.Z
                local Y = head.Y - leg.Y
                drawings.boxes[v].Visible = visible
                drawings.boxoutlines[v].Visible = visible
                drawings.healthbars[v].Visible = visible
                drawings.healthbaroutlines[v].Visible = visible
    
                if visible then
                    drawings.boxes[v].Position = Vector2.new(hrp.X - drawings.boxes[v].Size.X / 2, hrp.Y - drawings.boxes[v].Size.Y / 2)
                    drawings.boxes[v].Size = Vector2.new(X, Y)
                    drawings.boxoutlines[v].Position = Vector2.new(hrp.X - drawings.boxes[v].Size.X / 2, hrp.Y - drawings.boxes[v].Size.Y / 2)
                    drawings.boxoutlines[v].Size = Vector2.new(X, Y)
                    drawings.healthbaroutlines[v].Size = Vector2.new(3, Y)
                    drawings.healthbaroutlines[v].Position = Vector2.new(hrp.X - drawings.boxes[v].Size.X / 2, hrp.Y - drawings.boxes[v].Size.Y / 2) - Vector2.new(6, 0)
                    drawings.healthbars[v].Color = Color3.fromRGB(173, 0, 0):Lerp(Color3.fromRGB(0, 160, 0), v.Character:FindFirstChild("Humanoid").Health/v.Character:FindFirstChild("Humanoid").MaxHealth)
                    drawings.healthbars[v].Size = Vector2.new(2, (-drawings.healthbaroutlines[v].Size.Y - 2) * (v.Character:FindFirstChild("Humanoid").Health/v.Character:FindFirstChild("Humanoid").MaxHealth))
                    drawings.healthbars[v].Position = drawings.healthbaroutlines[v].Position + Vector2.new(1, -1 + drawings.healthbaroutlines[v].Size.Y)
                end
            else
                if v ~= lplr then
                    drawings.boxes[v].Visible = false
                    drawings.boxoutlines[v].Visible = false
                    drawings.healthbars[v].Visible = false
                    drawings.healthbaroutlines[v].Visible = false
                end
            end
        end
    else
        for i,v in pairs(drawings.boxes) do
            v.Visible = false
        end
        for i,v in pairs(drawings.boxoutlines) do
            v.Visible = false
        end
        for i,v in pairs(drawings.healthbars) do
            v.Visible = false
        end
        for i,v in pairs(drawings.healthbaroutlines) do
            v.Visible = false
        end
    end
end)