function Create(x, y)
  X = x or 0
  Y = y or 0
end
function Draw()
  --Frame rate
  love.graphics.print("Frame rate: " .. love.timer.getFPS(), self.X, self.Y)

  --Render info
  local name, version, vendor, device = love.graphics.getRendererInfo()
  love.graphics.print(name .. " " .. version, self.X, self.Y + 15)
  love.graphics.print(vendor .. " " .. device, self.X, self.Y + 30)

  --Memory usage
  love.graphics.print('Memory used(KB): ' .. collectgarbage('count'), self.X, self.Y + 45)

  --Physics state
  if Physics.Active then love.graphics.print("Physics: playing", self.X, self.Y + 60)
  else love.graphics.print("Physics: paused", self.X, self.Y + 60) end
end