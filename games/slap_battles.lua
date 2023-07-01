local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local isInArena =  Character:FindFirstChild("isInArena")

-- ac bypass
for i,v in pairs(getconnections(Character.Humanoid.StateChanged)) do
    if getfenv(v.Function).script.Name == "MusicLoaderI" then
        hookfunction(v.Function, function()
            return
        end)
    end
end

-- no cooldown
connection = isInArena:GetPropertyChangedSignal("Value"):Connect(function()
    if isInArena.Value == true then
        for i, v in pairs(getgc(true)) do
            if type(v) ~= "table" then continue end
        
            if rawget(v, "Cooldown") and type(v.Cooldown) == "function" and getfenv(v.Cooldown).script.Parent.Name == "ReplicatedStorage" then
                print("cooldown function found in script " .. getfenv(v.Cooldown).script.Name)
                hookfunction(v.Cooldown, function(...)
                    local args = {...}
        
                    return
                end)
            end
        end

        connection:Disconnect()
    end
end)


local mHook
mHook = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller() and method == "FireServer" and tostring(self) == "AdminGUI" then
        return wait(9e9)
    end

    return mHook(self, ...)
end)