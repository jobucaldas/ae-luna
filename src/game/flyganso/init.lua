--[[Pong main file]]--
-- Makes itself an object --
local init = {}

-- Calls --

local player = require("game.flyganso.player")
local world = require("game.flyganso.world")
local goose = require("game.flyganso.goose")

-- Initializer --
function init.initialize(screenObj, audioObj, inputObj, loaderObj,nof)
  -- Loads called objects --
  loader = loaderObj
  screen = screenObj
  audio = audioObj
  input = inputObj
  audio.startBGM("game/text_txt/bgm/main.xm")

  player.initialize(screenObj, world, audio, input, goose, nof)
  world.initialize(screenObj, player, input, goose)
  goose.initialize(screenObj, player,world)
  player.score2=10

  treeImg = love.graphics.newImage("game/sprites/tree1.png")
  screen.parseAnimation("game/sprites/cloud.png", 512, 512, 4)
  screen.parseAnimation("game/sprites/sun.png", 96, 96, 6)
end

-- Drawer --
function init.draw()
  world.draw()
  player.draw()
  goose.draw()
  love.graphics.setColor( 0,255,0,255)
  love.graphics.rectangle("fill",(800/2)/2-10-30-90, 30, 20*(player.score1), 20)
  love.graphics.setColor( 255,0,0,255)
  love.graphics.rectangle( "fill", (800/2)+((800/2)/2)+50, 30, 10*(player.score2), 20 )
  love.graphics.setColor( 255,255,255,255)
end

-- Pong Updater --
function init.update(dt)
  
  --print(player.score1,player.score2)
  if player.score2 == 0 or love.keyboard.isDown('l') then
  --  loader.changeGame("text_txt", 2)
  loader.changeGame("text_txt",2)
  elseif player.score1 == 0 or love.keyboard.isDown('k') then
    player.score1 = 0
    loader.gameover()
  end
  goose.update(dt)
  player.update(dt)
  world.update(dt)

end

-- Returns itself --
return init
