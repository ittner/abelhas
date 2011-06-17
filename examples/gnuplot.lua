--
-- Uses gnuplot to make an animated gif showing the evolution of the
-- particles in an optimization. This example requires gnuplot 4.2.0
-- with gif animation support.
--
-- Maximizes the function:  cos(x^2 + y^2) - x^2/5 - y^2/5 
-- Search space: -3.0 -- 3.0
--
-- WARNING! It should be noted that the optmization was slowed down to
-- allow a better visualization. Try 'param1.lua' for a better version.
--

local pso = require("pso")

math.randomseed(os.time())      -- Seeds the pseudo-random number generator

local swarm = pso.new(2)        -- Creates a new swarm with 2 dimensions
swarm:setLimits(-3.0, 3.0)      -- Search space
swarm:setParticles(10)          -- 10 particles
swarm:setC1(1.5)                -- Cognitive factor
swarm:setC2(2.0)                -- Social factor
swarm:setMaxSpeed(0.5)          -- Maximum speed (slowed down!)
swarm:setReplacementProb(0.05)  -- 5% of the particles die each iteration
swarm:setPrecision(6)           -- Maximum precision of 6 decimal places
swarm:setFitnessRounding(6)     -- Rounds up the fitness to 6 places
--swarm:setMaxFitness(1.0)        -- Stops when the maximum fitness is reached
swarm:setMaxStagnation(5)       -- Stops if stalled for 5 generations

-- Fitness function
swarm:setFitnessFunction(function (x, y)
    return math.cos(x^2 + y^2) - x^2/5 - y^2/5
end)

swarm:setIterationHook(function(particles, iter)
    local fname = string.format("particles_%03d.dat", iter)
    local fp = io.open(fname, "w")
    assert(fp, "Failed to open datafile.")
    for i, part in ipairs(particles) do
        fp:write(string.format("%.5f\t%.5f\t%.5f\n",
            part.b[1], part.b[2], part.fit))
    end
    fp:close()
end)


local ret, fit, reason, iter = swarm:run()

local fp = io.open("particles.gnuplot", "w")
assert(fp, "Failed to open plotfile.")

fp:write [[
# Lua Abelhas optimization example data. Generated with gnuplot.lua
set term gif animate transparent opt delay 25 size 400,300 x000000
set output 'particles.gif'
unset title
set hidden3d offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
set isosamples 40, 40
set view 60, 70, 1, 1
set xrange [ -3.0 : 3.0 ] noreverse nowriteback
set yrange [ -3.0 : 3.0 ] noreverse nowriteback
set zrange [ -5.0 : 5.0 ] noreverse nowriteback
]]

for i = 1, iter do
    fp:write(string.format("splot cos(x**2 + y**2) - x**2/5 - y**2/5, "
        .. "'particles_%03d.dat' title 'Iteration %2d' "
        .. "with points pointtype 7 pointsize 1\n", i, i))
end

fp:close()


