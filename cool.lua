
-- Tries to write "Lua is Cool" by swaping letters. Combinatorial search of
-- space of 256^11 possibilities (88 bits).

require "pso"

local ar = { }
local str = "Lua is cool"
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
swarm:setParticles(50)
swarm:setC1(1.0)                -- Cognitive factor.
swarm:setC2(2.0)                -- Social factor.
swarm:setLimits(0, 255)         -- String is iso-8859-1.
swarm:setPrecision(0)           -- No decimal places.
swarm:setMaxSpeed(30.0)
swarm:setFitnessRounding(0)     -- Fitness has no decimal places.
swarm:setReplacementProb(0.05)  -- 5% of the particles dead each iteration.
swarm:setMaxFitness(0)
swarm:setMaxStagnation(1000)

local ret, fit, reason, iter = swarm:run()

local nstr = ""
for i = 1, #ret do
    nstr = nstr .. string.char(ret[i])
end

print(nstr, fit, reason, iter)

-- swarm:printParticles()


