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
import "utils/playerControls"
import "utils/goalieControls"

local pd <const> = playdate
local gfx <const> = pd.graphics

local playerSprite = nil
local ball = nil
local field = nil
local keeper = nil


function initialize()
	local seg = pd.geometry.lineSegment.new(300, 20, 300, 220)
	local keeperAnimator = gfx.animator.new(1000, seg, pd.easingFunctions.inOutCubic)
	keeperAnimator.reverses = true
	keeperAnimator.repeatCount = -1

	playerSprite = Character(50, 100, 16, { inputControls = inputControls })
	playerSprite:add()
	keeper = Character(300, 120, 10, { inputControls = goalieControls, animator = keeperAnimator })
	keeper:setAnimator(keeperAnimator, true)
	keeper:add()


	ball = Ball(120, 100, 10)
	ball:add()

	local field = Field()
end

initialize()

function playdate.update()

	gfx.sprite.update()
	playdate.timer.updateTimers()

end