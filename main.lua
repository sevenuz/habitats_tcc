Stack = require("src/util/stack")

credits_menu = require("src/menu/credits")
main_menu = require("src/menu/mainmenu")
debug = require("src/menu/debug")

gamecontroller = require("src/game/logic/gamecontroller")
map = require("src/game/view/map")

--- resource map for all images
res = {}

VERSION = '0.0.1'

TITLE = 'Habitats TTC'
MAIN_MENU = 0
GAME = 1
SETTINGS = 2
CREDITS = 3

windowWidth = 1920
windowHeight = 1080

show_debug = false

function love.load()
	love.window.setMode(0, 0, { fullscreen = true })

	stack = Stack:new()
	stack:push(MAIN_MENU)
	credits_menu.load()
	main_menu.load()
	debug.load()

	gamecontroller.load()
	map.load()

	-- Set title
	love.window.setTitle(TITLE)
end

function love.draw()
	-- reset color for new frame
	love.graphics.setColor(255, 255, 255)
	if stack:peek() == MAIN_MENU then
		main_menu.draw()
	end

	if stack:peek() == CREDITS then
		credits_menu.draw()
	end

	if stack:peek() == GAME then
		map.draw()
	end

	if show_debug then
		debug.draw()
	end
	-- call it only once!
	suit.draw()
end

function love.update(dt)
	if stack:peek() == CREDITS then
		credits_menu.update(dt)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.update(dt)
	end
	if stack:peek() == GAME then
		map.update(dt)
	end

	if show_debug then
		debug.update(dt)
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if stack:peek() == MAIN_MENU then
		main_menu.mousepressed(x, y, button, istouch, presses)
	end
end

function love.mousereleased(x, y, button, istouch, presses) end

function love.keyreleased(key, scancode) end

function love.mousemoved(x, y, dx, dy, istouch)
	if stack:peek() == GAME then
		map.mousemoved(x, y, dx, dy, istouch)
	end
end

function love.textinput(text)
	if stack:peek() == CREDITS then
		credits_menu.textinput(text)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.textinput(text)
	end
	if stack:peek() == GAME then
		map.textinput(text)
	end

	if show_debug then
		debug.textinput(text)
	end
end

function love.wheelmoved(x, y)
	if stack:peek() == CREDITS then
		credits_menu.wheelmoved(x, y)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.wheelmoved(x, y)
	end
	if stack:peek() == GAME then
		map.wheelmoved(x, y)
	end

	if show_debug then
		debug.wheelmoved(x, y)
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
	if key == "f3" then
		show_debug = not show_debug
	end

	if stack:peek() == CREDITS then
		credits_menu.keypressed(key, scancode)
	end
	if stack:peek() == MAIN_MENU then
		main_menu.keypressed(key, scancode)
	end
	if stack:peek() == GAME then
		map.keypressed(key, scancode)
	end

	if show_debug then
		debug.keypressed(key, scancode)
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
