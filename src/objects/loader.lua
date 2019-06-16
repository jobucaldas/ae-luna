--[[Game and objects loader]]--
-- Makes itself an object --
local loader = {}

-- Initializer function --
function loader.initialize(screenObj, audioObj, inputObj)
  -- Loads main objects for the game --
  screen = screenObj
  audio = audioObj
  input = inputObj

  if love.filesystem.getInfo("settings") then
    settings = love.filesystem.read("settings")
    volPos = string.find(settings, "volume=", 1, true)
    fullscreenPos = string.find(settings, "fullscreen=", 1, true)
    audio.volume = tonumber(string.sub(settings, volPos+7, fullscreenPos-1))
    if string.sub(settings, fullscreenPos+11) == "true" then
      screen.toggleFullscreen()
    end
  end

  -- Starts the menu at the start --
  loader.changeGame("menu")
end

-- Returns if there is a save file --
function loader.hasSave()
  return love.filesystem.getInfo("save")
end

-- Loads game from save --
function loader.loadGame()
  if loader.hasSave() then
    audio.stopBGM()
    save = love.filesystem.read("save")
    gamePos  = string.find(save, "game=", 1, true)
    nofPos   = string.find(save, "nof=", 1, true)
    scenePos = string.find(save, "scene=", 1, true)
    game  = string.sub(save, gamePos+5, nofPos-2)
    nof   = string.sub(save, nofPos+4, scenePos-2)
    scene = string.sub(save, scenePos+6, save:len()-1)
    --[[if nof == "nil" then
      loader.changeGame(game)
    elseif scene == "nil"  then
      loader.changeGame(game, nof)
    else]]
      --print(nof)
      loader.changeGame(game, nof, scene)
    --end
  end
end

-- Saves settings --
function loader.saveSettings()
  love.filesystem.write("settings", "volume=" .. audio.volume .. "\nfullscreen=" .. tostring(screen.isFullscreen()))
end

-- Returns game path --
function loader.gamePath()
  return "game." .. loader.game .. ".init"
end

-- Gameover screen --
function loader.gameover()
  if not (audio.bgm == nil) then
    audio.stopBGM()
  end 
  loader.game = "text_txt"
  game = require(loader.gamePath())

  game.initialize(screen, audio, input, loader, "0")
end

-- Saves game --
function loader.saveGame(name, nof, scene)
  if not(name == "menu") then
    if nof == nil or nof == "0" then
      if not(nof == "0") then
        love.filesystem.write("save", "game=" .. name .. "\nnof=nil" .. "\nscene=nil")
      end
    elseif scene == nil then 
      love.filesystem.write("save", "game=" .. name .. "\nnof=" .. nof .. "\nscene=nil")
    else
      love.filesystem.write("save", "game=" .. name .. "\nnof=" .. nof .. "\nscene=" .. scene)
    end
  end
end

-- Changes game object --
function loader.changeGame(name, nof, scene)
  if not (audio.bgm == nil) then
    audio.stopBGM()
  end  
  loader.game = name
  game = require(loader.gamePath())
  --[[if scene == nil then
    loader.saveGame(name,nof)
    game.initialize(screen, audio, input, loader, nof)
  elseif nof == nil then
    loader.saveGame(name)
    game.initialize(screen, audio, input, loader)
  else]]
    loader.saveGame(name,nof,scene)
    game.initialize(screen, audio, input, loader, nof, scene)
  --end
end

-- Game's draw function --
function loader.draw()
  game.draw()
end

-- Game's update function --
function loader.update(dt)
  game.update(dt)
end

-- Returns itself --
return loader
