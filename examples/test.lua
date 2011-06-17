
-- Minimizes |x-200| + |y-200|
-- Search space: -5000 to +5000

local pso = require("pso")

math.randomseed(os.time())

swarm = pso.new(2)
swarm:setLimits(-5000.0, 5000.0)
swarm:setFitnessFunction(function(x, y)
  return -math.abs(x-200) - math.abs(y-200)
end)
swarm:setParticles(30)
swarm:setFitnessRounding(nil)
swarm:setPrecision(nil)
swarm:setC1(1.5)
swarm:setC2(1.5)
swarm:setMaxSpeed(5000.0)
swarm:setMaxFitness(0)
swarm:setMaxStagnation(300)

local ret, fit, reason, iter = swarm:run()
print(ret[1], ret[2], fit, reason, iter)

