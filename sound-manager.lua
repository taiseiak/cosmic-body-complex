local SoundManager = {}
SoundManager.__index = SoundManager

local instance = nil

local function new()
    return setmetatable({
        sounds = {},
        playing = {}
    }, SoundManager)
end

function SoundManager:getInstance()
    if not instance then
        instance = new()
    end
    return instance
end

function SoundManager:playSound(soundKey)
    assert(self.sounds[soundKey], soundKey .. " doesn't exist in sounds")
    local sound = self.sounds[soundKey]:play()
    -- Make sure to not play sounds that loop here.
    -- Loops are only supported in playMusic
    sound.loop = false
end

function SoundManager:playMusic(soundKey)
    assert(self.sounds[soundKey], soundKey .. " doesn't exist in sounds")
    if self.playing[soundKey] then
        return
    end
    self.playing[soundKey] = self.sounds[soundKey]:play()
end

return SoundManager
