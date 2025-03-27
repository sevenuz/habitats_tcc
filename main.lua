Stack = require("src/util/stack")

credits_menu = require("src/menu/credits")
main_menu = require("src/menu/mainmenu")

game = require("src/game")

VERSION = '0.0.1'

TITLE = 'Habitats TTC'
MAIN_MENU = 0
GAME = 1
SETTINGS = 2
CREDITS = 3

windowWidth = love.graphics.getWidth()
windowHeight = love.graphics.getHeight()

function love.load()
	stack = Stack:new()
	stack:push(MAIN_MENU)
	credits_menu.load()
	main_menu.load()

	game.load()

	-- Set title
	love.window.setTitle(TITLE)
end

function love.draw()
	-- Draw background
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(backgroundImage, backgroundQuad, 0, 0)

	if stack:peek() == MAIN_MENU then
		main_menu.draw()
		return
	end

	if stack:peek() == CREDITS then
		credits_menu.draw()
		return
	end

	if stack:peek() == GAME then
		game.draw()
		return
	end
end

function love.update(dt)
	if stack:peek() == CREDITS then
		credits_menu.update(dt)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.update(dt)
	end
	if stack:peek() == GAME then
		game.update(dt)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if stack:peek() == CREDITS then
		credits_menu.mousepressed(x, y, button, istouch, presses)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.mousepressed(x, y, button, istouch, presses)
	end

	if stack:peek() == GAME then
		game.mousepressed(x, y, button, istouch, presses)
	end
end

function love.mousereleased(x, y, button, istouch, presses) end
function love.keyreleased(key, scancode) end
function love.mousemoved(x, y, dx, dy, istouch) end

function love.textinput(text)
	if stack:peek() == CREDITS then
		credits_menu.textinput(text)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.textinput(text)
	end
end

function love.wheelmoved(x, y)
	if stack:peek() == CREDITS then
		credits_menu.wheelmoved(x, y)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.wheelmoved(x, y)
	end
end

function love.keypressed(key, scancode, isrepeat)
	-- print(key)
	if key == "escape" then
		if stack:size() > 1 then
			stack:pop()
			print("main", stack:size())
		end
	end

	if stack:peek() == CREDITS then
		credits_menu.keypressed(key, scancode)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.keypressed(key, scancode)
	end
end

function love.focus(f)
	if not f then
		print("LOST FOCUS")
	else
		print("GAINED FOCUS")
	end
end

function love.quit()
	print("Thanks for playing! Come back soon!")
	-- Clean up
	main_menu.quit()
end
