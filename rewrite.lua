local main = {
    KACooldown = 0.2,
    silentAimHitPart = "Head",
    killSays = {
        "ez",
        "trash",
        "touch grass",
        "retard",
        "is your dad spiderman? because he far from home",
        "do you ever have problems with light users parrying your ds???",
        "how are you that bad??🤣🤣😂🤣🤣",
        "EZ EZ EZ EZ EZ",
        "dont even bother insulting me 🤣🤣😂",
        "this script was brought to you by raid shadow legends!!",
        "are you even trying to kill me???",
        "get rekt noobie",
        "imagine dying",
        "L Bozo",
        "clapped",
        "nothing personel kid",
        "haha got you!!!",
        "how are you that bad??🤣😂",
        "нуб бозо",
        "my reaction to that information 😐",
        "OmG nO wAY a hACker!!!",
        "goddamn i'm still writing -Probably ZaneIs",
        "have you ever heard the hitgame AmongUs???",
        "fr?",
        'skill issue',
        "touch grass losers",
        "*Gorilla Sounds*",
        "What's up guys it's quandale dingle here.",
        "Bro got fake Jordans 💀",
        "Caught in 4K",
        "Say goodbye to your Kneecaps"
    },
    remotes = {},
    modules = rawget(require(game.ReplicatedStorage.Framework.Nevermore), "_lookupTable")
}

setmetatable(main.remotes, {
    __call = function(table, ...)
        local args = {...}

        table[args[1]]:FireServer(args[2])
    end
})

-- get all remotes
do
    for i, v in pairs(getupvalue(getsenv(rawget(main.modules, "Network")).GetEventHandler,1)) do
        -- index is name, value is info table
        main.remotes[i] = rawget(v, "Remote")
    end
    for i, v in pairs(getupvalue(getsenv(rawget(main.modules, "Network")).GetFunctionHandler,1)) do
        -- index is name, value is info table
        main.remotes[i] = rawget(v, "Remote")
    end
end

-- anticheat bypass
do
    for i,v in pairs(getgc(true)) do
        if typeof(v) ~= 'table' then continue end

        if rawget(v, 'getIsBodyMoverCreatedByGame') then
            hookfunction(v.getIsBodyMoverCreatedByGame, function(...)
                return true
            end)
        end

        if rawget(v, 'connectCharacter') then
            hookfunction(v.connectCharacter, function(...)
                return
            end)
        end
    
        if rawget(v, "punish") then
            local hf;hf=hookfunction(v.punish, function(...)
                return
            end)
        end
    end
end

for i = 1, 25 do
    main.remotes("StartFastRespawn")
    main.remotes("CompleteFastRespawn")
    wait()
end
