return {
	sayhello = function()
		love.graphics.setColor(0,0,255,255)
		love.graphics.rectangle("line", 16*scale, 144*scale, 224*scale, 64*scale)
		love.graphics.setColor(0,0,255,127)
		love.graphics.rectangle("fill", 16*scale, 144*scale, 224*scale, 64*scale)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(names[character.id].."! Welcome to the Test Map.", 20*scale, 136*scale)
		love.graphics.print("There's a test teleporter inside.", 20*scale, 144*scale)
	end,
}
