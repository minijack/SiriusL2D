local SettingsMenu = Class("SettingsMenu")

function SettingsMenu:Create()
  local state = Engine.State
  Engine.SetState("SettingsMenu")

  self.Slider = Ui.Slider(200, 200, 200, 20)
  self.Slider:SetRange(0, 100)
  self.TextBox = Ui.TextBox(200, 250)

  Engine.Add(self, "SettingsMenu")
  Engine.SetState(state)
end

function SettingsMenu:Debug()
  love.graphics.print(self.Slider.Value, 430, 200)
end

function SettingsMenu:KeyPressed(key)
  if key == "escape" then Engine.SetState("MainMenu") end
end
return SettingsMenu