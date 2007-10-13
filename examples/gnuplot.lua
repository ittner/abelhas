--
-- Uses gnuplot to make an animated gif showing the evolution of the
-- particles in a optimization. This example requires gnuplot 4.2.0
-- with gif animation.
--
-- Maximizes the function:  sin(x^2 + y^2) / (x^2 + y^2)
-- Search space: -3.0 -- 3.0
-- Max fitness: 1.0
--
-- It should be noted that the optmization was slowed down to allow a better
-- visualization. Try 'param1.lua' for a simpler/faster version.
--

require "pso"

local swarm = pso.new(2)
swarm:setLimits(-3.0, 3.0)      -- Search space
swarm:setParticles(10)          -- 10 particles
swarm:setC1(1.0)                -- Cognitive factor
swarm:setC2(2.0)                -- Social factor
swarm:setMaxSpeed(0.5)          -- Maximum speed
swarm:setReplacementProb(0.05)  -- 5% of the particles die each iteration
swarm:setPrecision(6)
swarm:setFitnessRounding(10)
swarm:setMaxStagnation(5)     -- Surrenders after fight so much...

swarm:setFitnessFunction(function (x, y)
    return math.sin(x^2 + y^2)/(x^2 + y^2)
end)

swarm:setIterationHook(function(particles, iter)
    local fname = string.format("particles_%03d.dat", iter)
    local fp = io.open(fname, "w")
    assert(fp, "Failed to open datafile.")
    for i, part in ipairs(particles) do
        fp:write(string.format("%.5f\t%.5f\t%.5f\n", part.b[1], part.b[2],  
        math.sin(part.b[1]^2 + part.b[2]^2)/(part.b[1]^2 + part.b[2]^2)))
    end
    fp:close()
end)


local ret, fit, reason, iter = swarm:run()

local fp = io.open("particles.gnuplot", "w")
assert(fp, "Failed to open plotfile.")

fp:write [[
set term gif animate transparent opt delay 50 size 400,300 x000000
set output 'particles.gif'
unset title
set hidden3d offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
set isosamples 40, 40
set view 55, 55, 1, 1
set xrange [ -3.0 : 3.0 ] noreverse nowriteback
set yrange [ -3.0 : 3.0 ] noreverse nowriteback
set zrange [ -0.5 : 1.1 ] noreverse nowriteback
]]

for i = 1, iter do
    fp:write(string.format("splot sin(x**2 + y**2)/(x**2 + y**2), "
        .. "'particles_%03d.dat' title 'Iteration %2d' "
        .. "with points pointtype 7 pointsize 1\n", i, i))
end

fp:close()


