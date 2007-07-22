
-- Tries to write "Lua is Cool"

require "pso"

local ar = { }
local str = "Lua"-- is cool"
for i = 1, #str do
    ar[i] = str:sub(i, i):byte()
end

function objfunc(...)
    local args = { ... }
    local fit = 0
    for i = 1, #args do
        fit = fit - math.abs(args[i] - ar[i])
    end    
    return fit
end

math.randomseed(os.time())

swarm = pso.new(#str)
swarm:setObjfunc(objfunc)
swarm:setParticles(40)
swarm:setC1(1.5)
swarm:setC2(1.5)
swarm:setLimits(0, 256)
swarm:setPrecision(0)
swarm:setMaxSpeed(10.0)
swarm:setFitnessRounding(0)
swarm:setMaxFitness(-1)
swarm:setMaxStagnation(100)

local ret, fit, reason, iter = swarm:run()

local nstr = ""
for i = 1, #ret do
    nstr = nstr .. string.char(ret[i])
end

print(nstr, fit, reason, iter)

swarm:printParticles()

