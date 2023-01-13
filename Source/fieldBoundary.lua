local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('FieldBoundary').extends(gfx.sprite)

function FieldBoundary:init(x, y, width, height)
	FieldBoundary.super.init(self)
	self:moveTo(x, y)
	local rectImage = gfx.image.new(width, height, gfx.kColorBlack)
	gfx.lockFocus(rectImage)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(x, y, width, height)
	gfx.unlockFocus()
	self:setImage(rect)
	self:setCollideRect(0, 0, width, height)
	-- self:setGroups(1)
	-- self:setCollidesWithGroups(2)
end

function FieldBoundary:collisionResponse(other)
	return 'bounce'
end