#!/usr/bin/env lua

require "pso"

-- Minimize: |x-200| + |y-200|
function objfunc(ar)
  return 0-(math.abs(ar[1]-200) + math.abs(ar[2]-200))
end

math.randomseed(os.time())
swarm = pso.new()
swarm:setDimensions(2)
swarm:setLimits(-5000.0, 5000.0)
swarm:setObjfunc(objfunc)
swarm:setParticles(50)
swarm:setDecimals(3)
swarm:setC1(1.5)
swarm:setC2(1.5)
swarm:setMaxSpeed(50.0)
swarm:setMaxFitness(0)
swarm:setMaxStagnation(50)

local ret, fit, reason, iter = swarm:run()
print(ret[1], ret[2], fit, reason, iter)

