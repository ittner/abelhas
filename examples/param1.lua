--
-- Maximizes the function:  cos(x^2 + y^2) - x^2/5 - y^2/5 
-- Search space: -3.0 -- 3.0
--
-- \cos \left(x^2 + y^2\right) - \frac{x^2}{5} - \frac{y^2}{5}
--
--
-- This function converges quickly to a near-best and slowy to the best.
-- Try 'gnuplot.lua' for a plotting version.
--

local pso = require("pso")

math.randomseed(os.time())      -- Seeds the pseudo-random number generator

local swarm = pso.new(2)        -- Creates a new swarm with 2 dimensions
swarm:setLimits(-3.0, 3.0)      -- Search space
swarm:setParticles(10)          -- 10 particles
swarm:setC1(1.5)                -- Cognitive factor
swarm:setC2(2.0)                -- Social factor
swarm:setMaxSpeed(1.0)          -- Maximum speed
swarm:setReplacementProb(0.05)  -- 5% of the particles die each iteration
swarm:setPrecision(6)           -- Maximum precision of 6 decimal places
swarm:setFitnessRounding(6)     -- Rounds up the fitness to 6 places
swarm:setMaxFitness(1.0)        -- Stops when the maximum fitness is reached
swarm:setMaxStagnation(20)      -- Stops if stalled for 20 generations

swarm:setFitnessFunction(function (x, y)
    return math.cos(x^2 + y^2) - x^2/5 - y^2/5
end)

local ret, fit, reason, iter = swarm:run()
print("Done", ret[1], ret[2], fit, reason, iter)

