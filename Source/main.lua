-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "ball"
import "field"
import "character"

local gfx <const> = playdate.graphics
local sound <const> = playdate.sound

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.

local playerSprite = nil
local ball = nil
local field = nil

-- A function to set up our game environment.
local pitchVal = 440
local filterVal = 1000
local filter = sound.twopolefilter.new(sound.kFilterLowPass)
local synth = sound.synth.new(sound.kWaveSawtooth)
local snare = sound.synth.new(sound.kWaveNoise)
local snareEnv = sound.envelope.new(0, 0.2, 0)
local audioChan = sound.channel.new(synth)
audioChan:addSource(synth)
audioChan:addEffect(filter)
snare:setADSR(0, 0.5, 0, 1)
-- snare:setFinishCallback(synth:playNote('C2')) 

function initialize()

	playerSprite = Character(200, 120, 20)
	playerSprite:add()
	
	
	ball = Ball(220, 180, 10)
	ball:add()
	
	local field = Field()
	-- We want an environment displayed behind our sprite.
	-- There are generally two ways to do this:
	-- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
	-- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
	--       and call :setZIndex() with some low number so the background stays behind
	--       your other sprites.

-- 	local backgroundImage = gfx.image.new( "Images/background" )
-- 	assert( backgroundImage )
-- 	
-- 
-- 	gfx.sprite.setBackgroundDrawingCallback(
-- 		function( x, y, width, height )
-- 			-- x,y,width,height is the updated area in sprite-local coordinates
-- 			-- The clip rect is already set to this area, so we don't need to set it ourselves
-- 			backgroundImage:draw( 0, 0 )
-- 		end
-- 	)

end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

initialize()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

	
	playerSprite:movePlayer(ball)
	
	

	-- Call the functions below in playdate.update() to draw sprites and keep
	-- timers updated. (We aren't using timers in this example, but in most
	-- average-complexity games, you will.)

	gfx.sprite.update()
	playdate.timer.updateTimers()

end