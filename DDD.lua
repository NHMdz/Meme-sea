local module = {
  NextAttack = 0,
  Distance = 55,
  attackMobs = true,
  attackPlayers = true
}

local Player = game:GetService("Players")

function module:GetBladeHits()
  local BladeHits = {}
  
  
  
  
  for _, Enemy in game:GetService("Workspace").Enemies:GetChildren() do
    
      table.insert(BladeHits, Enemy.HumanoidRootPart)
    
  end
  
  return BladeHits
end

function module:attack()
  local BladeHits = self:GetBladeHits()
  
  game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterAttack"):FireServer(0)
  
  for _, Hit in BladeHits do
    game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterHit"):FireServer(Hit)
  end
end

spawn(function()
while wait() do
module:attack()
end
end)