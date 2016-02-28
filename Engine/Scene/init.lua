Scene = {
  Entity = require "Engine/Scene/entity",
  State = require "Engine/Scene/state",
  Camera = require "Engine/Renderer/camera",
  Name = "",
  States = {},
  Objects = {}
}

function Scene.GetState(name)
  --Return exisiting state
  local state = Scene.States[name]
  if state then return state end

  --Create new state 
  Scene.States[name] = Scene.State()
  return Scene.States[name]
end

function Scene.SetState(name)
  local state = Scene.GetState(name)
  Scene.Name = name
  Scene.States = state.Objects
end

function Scene.Add(object, name)
  if name then
    local state = Scene.GetState(name)
    table.insert(state.Objects, object)
  else
    table.insert(Scene.Objects, object)
  end
end

function Scene.Update(dt)
  for k,v in pairs(Scene.Objects) do v:Update(dt) end
end

function Scene.Draw()
  for k,v in pairs(Scene.Objects) do v:Draw() end
end

function Scene.KeyPressed(key)
  for k,v in pairs(Scene.Objects) do v:Fire("KeyPressed", key) end
end

function Scene.KeyReleased(key)
  for k,v in pairs(Scene.Objects) do v:Fire("KeyReleased", key) end
end

function Scene.MousePressed(x, y, button, isTouch)
  for k,v in pairs(Scene.Objects) do v:Fire("MousePressed", x, y, button, isTouch) end
end

function Scene.MouseReleased(x, y, button)
  for k,v in pairs(Scene.Objects) do v:Fire("MouseReleased", x, y, button) end
end

function Scene.MouseMoved(x, y, dx, dy)
  for k,v in pairs(Scene.Objects) do v:Fire("MouseMoved", x, y, dx, dy) end
end

function Scene.TextInput(t)
  for k,v in pairs(Scene.Objects) do v:Fire("TextInput", t) end
end
Scene.SetState("default")