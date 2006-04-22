#!/usr/bin/env lua

require "pso"

-- Finds 'x' in "2*x-20=40"

function objfunc(ar)
  return 0-math.abs(2*ar[1]-20-40)
end

math.randomseed(os.time())
swarm = pso.new()
swarm:setDimensions(1)
swarm:setLimits(-5000.0, 5000.0)
swarm:setObjfunc(objfunc)
swarm:setParticles(10)
swarm:setDecimals(3)
swarm:setC1(1.5)
swarm:setC2(1.5)
swarm:setMaxSpeed(50.0)
swarm:setMaxFitness(0)
--swarm:setMaxStagnation(50)

local ret, fit, reason, iter = swarm:run()
print(ret[1], fit, reason, iter)

