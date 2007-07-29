
-- Tries to write "Lua is cool!" by swapping bytes. Discrete search
-- space of 256^12 possibilities (96 bits).

require "pso"

local ar = { }
local str = "Lua is cool!"
for i = 1, #str do
    ar[i] = str:sub(i, i):byte()
end

function arconcat(ar)
    local nstr = ""
    for i = 1, #ar do
        nstr = nstr .. string.char(ar[i])
    end
    return nstr
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
swarm:setReplacementProb(0.05)  -- 5% of the particles die each iteration.
swarm:setMaxFitness(0)          -- Stops when the exact solution is found.
swarm:setMaxStagnation(100)     -- Surrenders after fight so much...

-- Shows when a new best is found.
-- swarm:setNewBestHook(function(...) print(arconcat({...})) end)

local ret, fit, reason, iter = swarm:run()
print(arconcat(ret), fit, reason, iter)

