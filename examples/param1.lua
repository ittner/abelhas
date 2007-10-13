--
-- Maximizes the function:  sin(x^2 + y^2) / (x^2 + y^2)
-- Search space: -3.0 -- 3.0
-- Max fitness: 1.0
--
-- \frac {\sin \left(x^2 + y^2\right)} {\left(x^2 + y^2\right)}
--
--
-- This function converges quickly to a near-best and slowy to the best.
-- Try 'gnuplot.lua' for a plotting version.
--

require "pso"

local swarm = pso.new(2)
swarm:setLimits(-3.0, 3.0)      -- Search space
swarm:setParticles(10)          -- 10 particles
swarm:setC1(1.0)                -- Cognitive factor
swarm:setC2(2.0)                -- Social factor
swarm:setMaxSpeed(1.0)          -- Maximum speed
swarm:setReplacementProb(0.05)  -- 5% of the particles die each iteration
swarm:setMaxFitness(1.0)        -- Stops when the exact solution is found
swarm:setMaxStagnation(100)     -- Surrenders after fight so much...

swarm:setFitnessFunction(function (x, y)
    return math.sin(x^2 + y^2)/(x^2 + y^2)
end)

local ret, fit, reason, iter = swarm:run()
print("Done", ret[1], ret[1], fit, reason, iter)

