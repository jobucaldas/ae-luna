local bar = {}

-- Initializer --
function bar.initialize(screenObj, playerObj)
  -- Loads called objects --
  screen = screenObj
  player = playerObj
  -- Self Variables --
  -- Baston size (monitor dependant) --
  bar.height = 128
  bar.width = 46
  -- Baston x position --
  bar.pos1 = 0
  bar.pos2 = 0
  -- Player position --
  player.pos1 = (600/2-bar.height/2)
  player.pos2 = (600/2-bar.height/2)

  screen.parseAnimation("game/pong/sprites/charbar.png", 46, 128, 1) 
  screen.parseAnimation("game/pong/sprites/gansostop.png", 46,128, 3) 
end

-- Function to draw player bars --
function bar.draw()
  -- Makes coordinates for player 1 and draws him --
  bar.pos1 = 35
  screen.drawAnimation(1, bar.pos1, player.pos1)

  -- Makes coordinates for player 2 and draws him --
  bar.pos2 = 800 - (35 + bar.width)
  screen.drawAnimation(3, bar.pos2, player.pos2)
end

-- Update function within bar --
function bar.update()

end

return bar
