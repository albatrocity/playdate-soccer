local sound <const> = playdate.sound
local math <const> = playdate.math
local filterFreq <const> = 1000

Sounds = {}

local impactTri = sound.synth.new(sound.kWaveTriangle)
impactTri:setADSR(0, 0.03, 0, 0)
impactTri:setVolume(0.4)

local noise = sound.synth.new(sound.kWaveNoise)
noise:setADSR(0, 0.008, 0, 0)

local impactEnv = sound.envelope.new(0, 0.03, 0, 0)
local impactPitch <const> = 100
local impactPitchMult <const> = 10
impactTri:setFrequencyMod(impactEnv)

function Sounds:impact(impactSpeed)
	local note = impactPitch + impactSpeed * impactPitchMult
	impactTri:playNote(note)
	noise:playNote(note)
end