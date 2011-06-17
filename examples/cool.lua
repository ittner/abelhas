
-- cool.lua - a example for PSO. 
--
-- This program tries to write "Lua is cool!" by swapping bytes; It features
-- a discrete search in a space of 256^12 possibilities (96 bits) and was
-- inspired by the weasel example by Richard Dawkins in The Blind Watchmaker.
--

local pso = require("pso")

local str = "Lua is cool!"                      -- The string
-- local str = "As I said before, Lua is cool!" -- A harder example (248 bits)
-- local str = "Methinks it is like a weasel"   -- As Dawkins used before ;)

local ar = { }                  -- Converts the string into a array.
for i = 1, #str do
    ar[i] = str:sub(i, i):byte()
end


local function arconcat(ar)
    local nstr = ""
    for i = 1, #ar do
        nstr = nstr .. string.char(ar[i])
    end
    return nstr
end


-- Fitness function. Calculates the distance between a solution and the
-- phrase. Smaller distances are better.

local function objfunc(...)
    local args = { ... }
    local fit = 0
    for i = 1, #args do
        fit = fit - math.abs(args[i] - ar[i])
    end
    return fit
end


math.randomseed(os.time())

local swarm = pso.new(#str)
swarm:setFitnessFunction(objfunc)
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
swarm:setNewBestHook(function(...) print(arconcat({...})) end)

local ret, fit, reason, iter = swarm:run()
print("Done:", arconcat(ret), fit, reason, iter)

