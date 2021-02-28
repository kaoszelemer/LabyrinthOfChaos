Camera = require("lib.humpcamera")
mainMap = require("map1")
love.graphics.setDefaultFilter( 'nearest', 'nearest' )
width= 800
height= 800

white = {1,1,1}



tileSetAtlas = love.graphics.newImage("tileset.png")
player = {}
tiles = {

	wall = {},
	liltree = {},
	bigtree = {},
	sign = {},

}
tileW = 8
tileH = 8

offsetX = math.floor(width / 2 - (tileW * 10 / 2)  - tileW)
offsetY = math.floor(height / 2 - (tileH * 10 / 2) - tileH)




local function loadQuads()

	player.quad = love.graphics.newQuad(0, 0, tileW, tileH, tileSetAtlas:getWidth(), tileSetAtlas:getHeight())
	tiles.wall = love.graphics.newQuad(24, 0, tileW, tileH, tileSetAtlas:getWidth(), tileSetAtlas:getHeight())

end

local function testMapForCollision(x, y)
	if mainMap[(player.y / 8) + y][(player.x / 8) + x] > 0 then
		return false
	end
	return true
end

local function testMapForUse(x, y)
	if mainMap[(player.y / 8) + y][(player.x / 8) + x] ~= 5 then
		return false
	end
	return true
end




function love:load()
	player.x = 24
	player.y = 24
	love.graphics.setDefaultFilter( 'nearest', 'nearest' ) -- for camera
	loadQuads()
    camera = Camera(player.x, player.y, 6)
 
end

function love:update()
	local dx,dy = player.x - camera.x, player.y - camera.y
    camera:move(dx/2, dy/2)
end

function love:draw()
   camera:attach()
        -- draw camera stuff here
      love.graphics.draw(tileSetAtlas, player.quad, player.x, player.y)

	
      for x = 1, #mainMap do
		for y = 1, #mainMap[x] do
			if mainMap[y][x] == 4 then
			love.graphics.draw(tileSetAtlas, tiles.wall, x * tileW, y * tileH)

			end
		end
	end

	camera:detach()


   

function love.keypressed(key)
	if key == "up" then
		if testMapForCollision(0, -1) then 
		  player.y = player.y - tileH
		end

	elseif key == "down" then
		if testMapForCollision(0, 1) then
			player.y = player.y + tileW
		end

	elseif key == "left" then
		if testMapForCollision(-1,0) then
			player.x = player.x - tileH
		end

	elseif key == "right" then
		if testMapForCollision(1,0) then
			player.x = player.x + tileW
		end
		
	elseif key == "space" then
		if testMapForUse(0, -1) then
			love.graphics.setColor(white)
			love.graphics.print("Hello adventurer", player.x, player.y - 5) 
		else
			love.graphics.print("nothing to use here", player.x, player.y - 5) 
		end

	end
end




end