pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- fish game for pico-8

-- define the fish table
local fish = {
    sprite = 0, -- sprite number for fish
    x = 64, -- x position
    y = 64, -- y position
    speed = 2 -- speed of the fish
}
local num_enemies = 10
local enemies = {}

-- Initialize the enemies
function init_enemies()
    for i=1,num_enemies do
        -- Add an enemy fish with random position, direction, and speed
        add(enemies, {
            sprite=17,
            x=rnd(128), -- random x position
            y=rnd(128), -- random y position
            dx=rnd(2)-1, -- random x direction
            dy=rnd(2)-1, -- random y direction
			-- random speed between 0.5 and 1.5
            speed=max(.5, rnd(1) + 0.25)
        })
    end
end

-- initialize the game
function _init()
    cls()
	init_enemies()
end

function check_collision(a, b)
    return a.x < b.x+8 and a.x+8 > b.x and a.y < b.y+8 and a.y+8 > b.y
end

-- update game state
function _update()
    -- move the fish based on arrow key input
    if (btn(0)) then fish.x -= fish.speed end -- left
    if (btn(1)) then fish.x += fish.speed end -- right
    if (btn(2)) then fish.y -= fish.speed end -- up
    if (btn(3)) then fish.y += fish.speed end -- down

    -- keep the fish on screen
    fish.x = mid(0, fish.x, 119) -- (127 is limit but account for size of sprite)
    fish.y = mid(0, fish.y, 119)
	
    -- Update enemies
    foreach(enemies, function(e)
        -- Move the enemy
        e.x += e.dx * e.speed
        e.y += e.dy * e.speed
        
        -- Keep the enemies on screen (wrap around for x)
        if e.x < 0 then e.x = 127 end
        if e.x > 127 then e.x = 0 end
		
        if e.y < 0 then
			e.y = 0 
			e.dy *= -1
		end
        if e.y > 119 then 
			e.y = 119
			e.dy *= -1
		end
		
		-- Check for collision with the player
  if check_collision(fish, e) then
  -- TODO: check if enemy can be eaten or it eats fish, then handle those cases

			-- remove enemy
			del(enemies, e)
        end
   end)	
end

-- draw game
function _draw()
    cls() -- blue background
    map(0,0,0)
    spr(fish.sprite, fish.x, fish.y) -- draw the fish
	
	-- Draw the enemy fish
    foreach(enemies, function(e)
        spr(e.sprite, e.x, e.y)
    end)
end
