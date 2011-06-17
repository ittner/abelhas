
-- Optimizes the Schwefel's function 7 - Another Abelhas PSO example.
--
--          n            
-- f7(x) = sum -xi * sin(sqrt(|xi|))         -512 <= x <= 512
--         i=1
--
--  or
--
-- f_7(x) = \sum_{i=1}^n -x_i \times \sin \left(\sqrt{|x_i|}\right),\,  -512 \le x_i \le 512
--
-- Search space: -512 to +512


local pso = require("pso")

math.randomseed(os.time())

local swarm = pso.new(5)        -- Number of dimensions.

swarm:setLimits(-512.0, 512.0)  -- Search space.

-- optimization.
local sqrt = math.sqrt
local abs = math.abs
local sin = math.sin

swarm:setFitnessFunction(function(...)
    local xn = { ... }
    local fit = 0
    for i = 1, #xn do
        fit = fit - xn[i] * sin(sqrt(abs(xn[i])))
    end
    return fit
end)

swarm:setParticles(20)
swarm:setFitnessRounding(4)
swarm:setPrecision(nil)
swarm:setC1(1.5)    -- cognitive
swarm:setC2(1.5)    -- social
swarm:setReplacementProb(0.10)
swarm:setMaxSpeed(500.0)
swarm:setMaxStagnation(2000)

local ret, fit, reason, iter = swarm:run()
for i = 1, #ret do
    print(i, ret[i])
end
print(fit, reason, iter)


