local module = {
  NextAttack = 0,
  Distance = 55,
  attackMobs = true,
  attackPlayers = true
}

function module:GetBladeHits()
  local BladeHits = {}
  local Client = game.Players.LocalPlayer
  local Characters = game:GetService("Workspace").Characters:GetChildren()
  
  -- Check players within distance
  for i, v in pairs(Characters) do
    local Human = v:FindFirstChildOfClass("Humanoid")
    if v.Name ~= Client.Name and Human and Human.RootPart and Human.Health > 0 then
      -- Check if within attack range
      if Client:DistanceFromCharacter(Human.RootPart.Position) < self.Distance then
        table.insert(BladeHits, Human.RootPart)
      end
    end
  end
  
  -- Check enemies within distance
  local Enemies = game:GetService("Workspace").Enemies:GetChildren()
  for i, v in pairs(Enemies) do
    local Human = v:FindFirstChildOfClass("Humanoid")
    if Human and Human.RootPart and Human.Health > 0 then
      -- Check if within attack range
      if Client:DistanceFromCharacter(Human.RootPart.Position) < self.Distance then
        table.insert(BladeHits, Human.RootPart)
      end
    end
  end
  
  return BladeHits
end

function module:attack()
  local BladeHits = self:GetBladeHits()
  
  -- If no enemies or players are within range, exit
  if #BladeHits == 0 then
    return
  end
  
  -- Register attack on the server
  game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterAttack"):FireServer(0)
  
  -- Register hits on all enemies/players in range
  for _, Hit in pairs(BladeHits) do
    game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterHit"):FireServer(Hit)
  end
end

_G.AA = true

task.spawn(function()
  while wait() do
    repeat
      task.wait()
      module:attack()
    until not _G.AA
  end
end)
