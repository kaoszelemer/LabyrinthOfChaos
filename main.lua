Camera = require("lib.humpcamera")
mainMap = require("map2")
signTable = require("signs")
nextSign = 0
gameStart = true

love.graphics.setDefaultFilter( 'nearest', 'nearest' )
width= 800
height= 800

white = {1,1,1}
black = {0,0,0}
red = {1, 0, 0}
yellow = {1,1, 0}

font = love.graphics.newFont(8)
bigFont = love.graphics.newFont(32)

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
	tiles.liltree = love.graphics.newQuad(8, 0, tileW, tileH, tileSetAtlas:getWidth(), tileSetAtlas:getHeight())
	tiles.bigtree = love.graphics.newQuad(16, 0, tileW, tileH, tileSetAtlas:getWidth(), tileSetAtlas:getHeight())
	tiles.sign = love.graphics.newQuad(32, 0, tileW, tileH, tileSetAtlas:getWidth(), tileSetAtlas:getHeight())

end

local function testMapForCollision(x, y)
	if (player.y / 8 + y > 0 and player.y / 8 + y <= 100) and (player.x / 8 + x > 0 and player.x / 8 + x <= 100) then
	

		if mainMap[(player.y / 8 + y)][player.x / 8 + x] > 0 then
			return false
		end
		return true
	end
end

local function testMapForUse(x, y)
	if (player.y / 8 + y > 0 and player.y / 8 + y <= 100) and (player.x / 8 + x > 0 and player.x / 8 + x <= 100) then

		if mainMap[(player.y / 8) + y][(player.x / 8) + x] == 5 then
		return true
		end
		return false
	end
end




function love.load()
	love.graphics.setFont(font)
	player.x = 34 * tileW
	player.y = 94 * tileH
	player.actx = 34 * tileW
	player.acty = 94 * tileH
	player.speed = 10
	love.graphics.setDefaultFilter( 'nearest', 'nearest' ) -- for camera
	loadQuads()
    camera = Camera(player.actx, player.acty, 6)
 
end

function love.update(dt)
	
	local dx,dy = player.x - camera.x, player.y - camera.y
    camera:move(dx/2, dy/2)
	player.acty = player.acty - ((player.acty - player.y) * player.speed * dt)
	player.actx = player.actx - ((player.actx - player.x) * player.speed * dt)


end

function love.draw()
   camera:attach()
        -- draw camera stuff here
    love.graphics.draw(tileSetAtlas, player.quad, player.actx, player.acty)

	
		

	
    for x = 1, #mainMap do
		for y = 1, #mainMap[x] do

			if mainMap[y][x] == 4 then
			love.graphics.draw(tileSetAtlas, tiles.wall, x * tileW, y * tileH)

			end
			if mainMap[y][x] == 2 then
			love.graphics.draw(tileSetAtlas, tiles.liltree, x * tileW, y * tileH)

			end
			if mainMap[y][x] == 3 then
			love.graphics.draw(tileSetAtlas, tiles.bigtree, x * tileW, y * tileH)

			end
			if mainMap[y][x] == 5 then
			love.graphics.draw(tileSetAtlas, tiles.sign, x * tileW, y * tileH)

			end
		end
	end

	if gameStart then
		love.graphics.setColor(red)
		love.graphics.rectangle("fill", player.x - tileW * 2, player.y - tileH * 2, tileW * 8, tileH)
		love.graphics.setColor(white)
		love.graphics.setFont(font)
		love.graphics.print("FIND ALL SIGNS", player.x - tileW * 2, player.y - tileH * 2) 
	end

	for i = 1, #signTable do
		if signTable[i].drawSign then
			
				love.graphics.setColor(red)
				love.graphics.rectangle("fill", player.x - tileW * 2, player.y - tileH * 2, tileW * 8, tileH)
				love.graphics.setColor(white)
				love.graphics.setFont(font)
				love.graphics.print(signTable[i], player.x - tileW * 2, player.y - tileH * 2)
			
		end
	end

	if drawCantDo then
		love.graphics.setColor(black)
		love.graphics.rectangle("fill", player.x - tileW * 2, player.y - tileH * 2, tileW * 15, tileH)
		love.graphics.setColor(white)
		love.graphics.setFont(font)
		love.graphics.print("nothing to use here", player.x - tileW * 2, player.y - tileH * 2) 
	end

	love.graphics.setColor(black)
	love.graphics.rectangle("fill", player.x + 5 * tileW, player.y + 5 * tileW, tileW * 5, tileH)
	love.graphics.setColor(white)
	love.graphics.setFont(font)
	love.graphics.print("22/"..#signTable, player.x + 5 * tileW, player.y + 5 * tileW)


	camera:detach()
end

   

function love.keypressed(key)	
		
	if key == "a" then
		if testMapForUse(0, -1) or testMapForUse(0, 1) or testMapForUse(-1, 0) or testMapForUse(1, 0) then
			for k,sign in ipairs(signTable) do
				for i = 1, #sign do
				print(sign[i].x)
					if player.x == sign.x - 1 or player.x == sign.x + 1 or player.y == sign.y - 1 or player.y == sign.y + 1 then
						
						sign.drawSign = true
					end
				end
			end
		
	end
			
			
			
	else
		drawCantDo = true
		
	end




	if key == ("up") then
		for k,sign in ipairs(signTable) do
			for i = 1, #sign do

			sign[i].drawSign = false
			end
		end
			drawCantDo = false
			gameStart = false
			if testMapForCollision(0, -1) then 
			player.y = player.y - tileW
			end
	end

	if key == ("down") then
		for k,sign in ipairs(signTable) do
			for i = 1, #sign do

					sign[i].drawSign = false
			end
		end
	
		drawCantDo = false
		gameStart = false
	
		if testMapForCollision(0, 1) then
			player.y = player.y + tileH
		end
	end

	if key == ("left") then
		for k,sign in ipairs(signTable) do
			for i = 1, #sign do

			sign[i].drawSign = false
			end
		end
	
		drawCantDo = false
		gameStart = false

		if testMapForCollision(-1,0) then
			player.x = player.x - tileW
		end
	end

	if key == ("right") then
		for k,sign in ipairs(signTable) do
			for i = 1, #sign do

			sign[i].drawSign = false
			end
		end
	
		drawCantDo = false
		gameStart = false

		if testMapForCollision(1,0) then
			player.x = player.x + tileH
		end
	end



end