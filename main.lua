--[[
Zarmina Demo
Sprites by DJ Omnimaga & Juju
Engine by Juju
--]]

-- characters.png notes:
-- Eljin, Merix, Zormy, Guil, Ji, Manu pi Kyra
-- de gauche a droite pi de haut en bas

function love.load()
	loader = require("AdvTiledLoader.Loader")
	loader.path = "maps/"
	map = loader.load("testmap.tmx")
	layer = map.tl["ground"]
	objlayer = map.ol["objects"]
	scale = 2
	gametime = 0
	gamestate = "introcredits"
	omnilogo = love.graphics.newImage("omnimaga_logo.gif")
	characters = love.graphics.newImage("characters.png")
	characters:setFilter("nearest", "linear")
	character = {}
	character.x = 100
	character.y = 100
	character.id = 7
	character.orientation = 2
	character.state = 1
	names = {[0]="Eljin", "Merix", "Zormy", "Guil", "Ji", "Manu", "Kyra", "Miyuki"}
	min_dt = 1/60
	next_time = love.timer.getMicroTime()
	isNight = true
	light = 6
--[[	
	tilesImage = love.graphics.newImage("tiles.png")
	tilesImage:setFilter("nearest", "linear")

	tilemap = {
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1},
	{1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},
	{1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	}

	tilemapX = #tilemap[1]
	tilemapY = #tilemap
	tilebg = love.graphics.newSpriteBatch(tilesImage, tilemapX*tilemapY*256)
--]]

	mapX = 0
	mapY = 0

	deffont = love.graphics.newFont("FFI.ttf", 24)
	gamefont = love.graphics.newFont("FFI.ttf", 24*scale)
	love.graphics.setFont(gamefont)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setCaption("Zarmina Engine Demo (Night Side of Zarmina)")
	love.graphics.setMode(256*scale, 224*scale, false)
	love.graphics.scale(scale, scale)
end

function love.keypressed(key)
	if gamestate == "introcredits" then
		if love.keyboard.isDown("return") then
			gamestate = "menu"
		end
	elseif gamestate == "menu" then
		if key == "return" then
			gamestate = "game"
		elseif key == "escape" then
			love.event.push("quit")
		end
	elseif gamestate == "game" then
		if key == "escape" then
			gamestate = "menu"
		end
		if key == "p" then
			character.id = character.id+1
			if character.id >= 8 then
				character.id = 0
			end
		--[[
		elseif key == "o" then
			if scale == 1 then scale = 2 else scale = 1 end
			love.graphics.setMode(256*scale, 224*scale, false)
			love.graphics.scale(scale, scale)
		--]]
		elseif key == "l" then
			isNight = not isNight
		end
	end
end

function love.keyreleased(key)
	if gamestate == "game" then
		if key == "left" then
			-- Stop the sound
		end
	end
end

function love.update(dt)
	gametime = gametime+dt;
	next_time = next_time + min_dt
	if gamestate == "introcredits" then
		if gametime >= 4 then
			gamestate = "menu"
		end
	elseif gamestate == "menu" then
		-- Nothing happens here.
	elseif gamestate == "game" then
		character.state = 1
		if love.keyboard.isDown("left") then
			if not detectCollision(character.x+mapX-8, character.y+mapY) then character.x = character.x-1 end
			character.orientation = 3
			character.state = math.floor(gametime*4)%4
		end
		if love.keyboard.isDown("right") then
			if not detectCollision(character.x+mapX+8, character.y+mapY) then character.x = character.x+1 end
			character.orientation = 1
			character.state = math.floor(gametime*4)%4
		end
		if love.keyboard.isDown("up") then
			if not detectCollision(character.x+mapX, character.y+mapY-4) then character.y = character.y-1 end
			character.orientation = 0
			character.state = math.floor(gametime*4)%4
		end
		if love.keyboard.isDown("down") then
			if not detectCollision(character.x+mapX, character.y+mapY+1) then character.y = character.y+1 end
			character.orientation = 2
			character.state = math.floor(gametime*4)%4
		end
		if character.state >= 3 then character.state = 1 end
		if character.x < 48 then
			character.x = 48
			mapX = mapX-1
		end
		if character.x > 256-48 then
			character.x = 256-48
			mapX = mapX+1
		end
		if character.y < 64 then
			character.y = 64
			mapY = mapY-1
		end
		if character.y > 224-48 then
			character.y = 224-48
			mapY = mapY+1
		end
	end
end

function love.draw()	
	if gamestate == "introcredits" then -- Intro
		if gametime < 2 then
			love.graphics.setColor(gametime*127.5, gametime*127.5, gametime*127.5)
		else
			love.graphics.setColor(255-(gametime*127.5), 255-(gametime*127.5), 255-(gametime*127.5))
		end
		love.graphics.draw(omnilogo, 50*scale, 100*scale, 0, scale*0.5) -- 320*(83-gametime)
		love.graphics.setFont(gamefont)
		love.graphics.print("presents", 50*scale, 112*scale) -- 344*(83*gametime)
	elseif gamestate == "menu" then -- Draw the menu
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(gamefont)
		love.graphics.print("Zarmina Engine Demo", 65*scale, 50*scale)
		love.graphics.print("Press ENTER", 85*scale, 150*scale)
		love.graphics.print("(C) 2012 Omnimaga", 60*scale, 180*scale)
		love.graphics.setFont(deffont)		
		love.graphics.print("v0.0.2-dev", 0, 215*scale)
	elseif gamestate == "game" then -- We're in the game
		love.graphics.setFont(gamefont)
		--love.graphics.translate(mapX, mapY)
		map:autoDrawRange(-mapX, -mapY, scale, 50)
		love.graphics.push()
		love.graphics.scale(scale)
		love.graphics.translate(-mapX, -mapY)
		map:draw()
		love.graphics.pop()
--[[
		for i=1,#tilemap do
			for j=1,#tilemap[i] do
				if isNight then
					d = getDistance((mapX+character.x), (mapY+character.y), (j-1)*16+8, (i-1)*16+8)
					if d < 16*light then
						love.graphics.setColor(255-(16/light*d), 255-(16/light*d), 255-(16/light*d))
						tile = love.graphics.newQuad((tilemap[i][j]%16)*16, math.floor(tilemap[i][j]/16)*16, 16, 16, 256, 256)
						love.graphics.drawq(tilesImage, tile, ((j-1)*16-mapX)*scale, ((i-1)*16-mapY)*scale, 0, scale)
					end
				else
					love.graphics.setColor(255, 255, 255)
					tile = love.graphics.newQuad((tilemap[i][j]%16)*16, math.floor(tilemap[i][j]/16)*16, 16, 16, 256, 256)
					love.graphics.drawq(tilesImage, tile, ((j-1)*16-mapX)*scale, ((i-1)*16-mapY)*scale, 0, scale)
				end
			end
		end
--]]
		love.graphics.setColor(255, 255, 255)
		charquad = love.graphics.newQuad((character.id%4)*72+character.state*24, math.floor(character.id/4)*128+character.orientation*32, 24, 32, 288, 256)
		love.graphics.drawq(characters, charquad, (character.x-12)*scale, (character.y-32)*scale, 0, scale)
		love.graphics.setFont(deffont)
		love.graphics.print(names[character.id], 0, -3)
		love.graphics.print("("..(mapX+character.x)..","..(mapY+character.y)..")", 0, 5)
	end
	love.graphics.setFont(deffont)
	love.graphics.print("FPS "..love.timer.getFPS(), 0, -11) -- .."  GT "..gametime
	local cur_time = love.timer.getMicroTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep((next_time - cur_time))
end

function getDistance(x1, y1, x2, y2)
	return (math.abs(x1-x2)^2+math.abs(y1-y2)^2)^0.5
end

function detectCollision(x, y)
	local tile = layer.tileData(math.floor(x/16), math.floor(y/16))
	-- if tilemap[math.floor(y/16)+1][math.floor(x/16)+1] == 1
	if tile == nil then return true end
	if tile.properties.obstacle then return true end
	return false
end
