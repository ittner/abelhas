#!/usr/bin/env lua

require "pso"

-- Minimize: |x-200| + |y-200|
function objfunc(x, y)
  return -(math.abs(x-200) + math.abs(y-200))
end

math.randomseed(os.time())

swarm = pso.new(2)
swarm:setLimits(-5000.0, 5000.0)
swarm:setObjfunc(objfunc)
swarm:setParticles(100)
swarm:setFitnessRounding(3)
swarm:setC1(1.5)
swarm:setC2(1.5)
swarm:setMaxSpeed(50.0)
swarm:setMaxFitness(0)
swarm:setMaxStagnation(30)

local ret, fit, reason, iter = swarm:run()
print(ret[1], ret[2], fit, reason, iter)

