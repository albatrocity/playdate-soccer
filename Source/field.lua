import "fieldBoundary"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry


class('Field').extends()

function Field:init()
	local left 	 = FieldBoundary(0, 0, 10, 240)
	local right  = FieldBoundary(390, 0, 10, 240)
	local top 	 = FieldBoundary(0, 0, 400, 10)
	local bottom = FieldBoundary(0, 230, 400, 10)
	
	left:add()
	right:add()
	top:add()
	bottom:add()
end

