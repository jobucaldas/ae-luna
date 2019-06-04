local text = {}

local file = {}

function text.initialize()
  scene = 1

  -- Properties variables --
  alpha = 0       -- Alpha value
  fadeInTime = 0  -- Fade in timer

  textbox = love.graphics.newImage("game/bg/textbox.jpg")
end

-- Parser --
function text.parser(string, nof, img)
  -- Reads script and inserts into table --
  file[nof] = {scriptImg = {}, scriptNames = {}, scriptText = {}}
  for line in love.filesystem.lines(string) do
    table.insert(file[nof].scriptImg, line)
  end
  
  -- Parses file --
  for i=1, #file[nof].scriptImg do
    pos = string.find(file[nof].scriptImg[i], ":", 1, true)
    if not(pos == nil) then
      table.insert(file[nof].scriptNames, string.sub(file[nof].scriptImg[i], 1, pos-1) )
      file[nof].scriptImg[i] = string.sub(file[nof].scriptImg[i], pos+1)
    end
    pos = string.find(file[nof].scriptImg[i], ":", 1, true)
    if not(pos == nil) then
      table.insert(file[nof].scriptText, string.sub(file[nof].scriptImg[i], 1, pos-1) )
      file[nof].scriptImg[i] = string.sub(file[nof].scriptImg[i], pos+1)
    end
  end
end

function text.img(nof, nof2)
  return file[nof].scriptImg[nof2]
end

function text.names(nof, nof2)
  return file[nof].scriptNames[nof2]
end

function text.textScr(nof, nof2)
  return file[nof].scriptText[nof2]
end

function text.ended(nof)
  if #file[nof].scriptImg == scene+1 then
    return true
  end
  return false
end

function text.draw(scene, nof, up)
  if up then
    pos = 0.5
  else
    pos = 3
  end

  -- Draw textbox --
  love.graphics.draw(textbox, 800*0.05, 600/2/2*pos-30, 0, 1)

  -- Draws vn text --
  if not (file[nof].scriptNames[scene] == "nil") then
    love.graphics.print({{255, 0, 0,alpha},file[nof].scriptNames[scene]}, 800*0.075, 600/2/2*pos-10, 0, 0.3)
  end
  love.graphics.printf({{0, 0, 0,alpha}, file[nof].scriptText[scene]}, 800*0.25, 600/2/2*pos-10, 1400, "center", 0, 0.3)
  text.fadeIn()
  print(file,nof,scene)
  
  -- Draws text space and prints text asking for input --
  if up then
    love.graphics.print({{0, 255, 0, 1},"<Press Return>"}, 800-185, textbox:getHeight()+10, 0, 0.3)
  else
    love.graphics.print({{0, 255, 0, 1},"<Press Return>"}, 800-185, 600-80, 0, 0.3)
  end
end

-- Goes to next scene --
function text.nextScene(scene)
  scene=scene+1         -- Goes to next scene
  alpha = 0             -- Resets alpha value
  return scene
end

-- Fades text --
function text.fadeIn()
  if love.timer.getTime() <= fadeInTime+0.35 then
    alpha = alpha+0.05
  else
    fadeInTime = love.timer.getTime()
  end
end

return text