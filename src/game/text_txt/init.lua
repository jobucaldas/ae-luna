--[[The visual novel based part of the game]]--
-- Makes itself an object --
local vn = {}

-- Calls opbjects --
local reader = require("game.text_txt.reader")


-- Initializer function --
function vn.initialize(screenObj, audioObj, inputObj, loaderObj, file)
  -- Loads called objects --
  screen = screenObj
  audio = audioObj
  input = inputObj
  loader = loaderObj
  -- Properties variables --
  alpha = 0       -- Alpha value
  fadeInTime = 0  -- Fade in timer

  textbox = love.graphics.newImage("game/text_txt/bg/textbox.jpg")

  -- Song initializer
  audio.startBGM("game/text_txt/bgm/main.xm")

  scene = 1
  if love.filesystem.getInfo("game/text_txt/va/"..file.."/"..scene..".ogg") then
    audio.playSFX("game/text_txt/va/"..file.."/"..scene..".ogg")
  end

  -- Initializes script reader --
  reader.initialize(file)
end

-- VN's draw function --
function vn.draw()
  -- Blue sky --
  love.graphics.setColor( 0,255,230,255)
  love.graphics.rectangle("fill", 0, 0, 800, 600)

  -- Normal colors --
  love.graphics.setColor( 255,255,255,255)

  --[[ Draws characters ]]--
  -- Draw Chars --
  if not(char1 == nil) then
    love.graphics.draw(char1, 800/2/2/2/2 , 600/2/2/2, 0, 0.3)
  end
  if not(char2 == nil) then
    love.graphics.draw(char2, 800/2/2/2*2+800/2/2/2/2 , 600/2/2/2, 0, 0.3)
  end

  -- Draw textbox --
  love.graphics.draw(textbox, 800*0.05, 600/2/2*3-30, 0, 1)

  -- Draws vn text --
  if not (reader.scriptNames[scene] == "nil") then
    love.graphics.print({{255, 0, 0,alpha},reader.scriptNames[scene]}, 800*0.075, 600/2/2*3-10, 0, 0.3)
  end
  love.graphics.printf({{0, 0, 0,alpha}, reader.scriptText[scene]}, 800*0.25, 600/2/2*3-10, 1400, "center", 0, 0.3)
  vn.fadeIn()

  -- Draws text space and prints text asking for input --
  love.graphics.print({{0, 255, 0, 1},"<Press Return>"}, 800-185, 600-80, 0, 0.3)
end

-- Fades text --
function vn.fadeIn()
  if love.timer.getTime() <= fadeInTime+0.35 then
    alpha = alpha+0.05
  else
    fadeInTime = love.timer.getTime()
  end
end

-- VN's update function --
function vn.update()
  -- Action to go to next scene with delay --
  if input.getKey("return") or input.getClick() or input.toggle("lctrl") then
    -- Ends game when script ends, else goes to next scene --
    if (scene == #reader.scriptImg-1) then
      input.toggled = false
      audio.stopBGM()
      action = loadstring(reader.scriptImg[scene+1])
      action()
    elseif input.pressed == true then
      scene = reader.nextScene()    -- Goes to next scene
      alpha = 0             -- Resets alpha value

      if love.filesystem.getInfo("game/text_txt/va/"..file.."/"..scene..".ogg") then
        audio.playSFX("game/text_txt/va/"..file.."/"..scene..".ogg")
      end
      
      -- Parse chars --
      pos = string.find(reader.scriptImg[scene], ",", 1, true)
      if not(string.sub(reader.scriptImg[scene], 1, pos-1) == "nil") then
        char1 = love.graphics.newImage("game/text_txt/chars/" .. string.sub(reader.scriptImg[scene], 1, pos-1).. ".png")
      else
        char1 = nil
      end
      if not(string.sub(reader.scriptImg[scene], pos+1) == "nil") then
        char2 = love.graphics.newImage("game/text_txt/chars/" .. string.sub(reader.scriptImg[scene], pos+1).. ".png")
      else
        char2 = nil
      end
    end
  end
end

-- Returns itself --
return vn