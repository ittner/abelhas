--- PSO - A Lua module for particle swarm optmization.
--- (c) 2005-2012 Alexandre Erwin Ittner <alexandre@ittner.com.br>
--- For more information, see: http://ittner.github.com/abelhas/
---
---
--- Permission is hereby granted, free of charge, to any person obtaining
--- a copy of this software and associated documentation files (the
--- "Software"), to deal in the Software without restriction, including
--- without limitation the rights to use, copy, modify, merge, publish,
--- distribute, sublicense, and/or sell copies of the Software, and to
--- permit persons to whom the Software is furnished to do so, subject to
--- the following conditions:
---
--- The above copyright notice and this permission notice shall be
--- included in all copies or substantial portions of the Software.
---
--- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--- IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY
--- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
---
--- If you use this package in a product, an acknowledgment in the product
--- documentation would be greatly appreciated (but it is not required).
---
---


local M = { }
local MT = { }

M.VERSION = "1.1"
M.TERM_CONVERGED = 1
M.TERM_MAX_ITERATIONS = 2
M.TERM_MAX_STAGNATION = 3

local unpack = unpack or table.unpack



---
--- pso.new(dimensions)
---
--- Constructor. Returns a new swarm with the given number of dimensions.
---

function M.new(dims)
    local sw = {
        fitfunc = nil,      -- Fitness function
        dims = dims,        -- Number of dimensions
        prec = {},          -- Precision (decimal places, per dimension)
        minp = {},          -- Minimum value, per dimension
        maxp = {},          -- Maximum value, per dimension
        maxs = {},          -- Maximum particle speed, per dimension
        c1 = 0.5,           -- c1, cognitive factor
        c2 = 0.5,           -- c2, social factor
        nparts = 20,        -- Number of particles
        repl = 0,           -- Particle replacement.
        fitr = nil,         -- Fitness rounding
        maxfit = nil,       -- Maximum fitness
        maxiter = nil,      -- Maximum iterations
        maxstag = nil,      -- Maximum fitness stagnation
        gbest = nil,        -- Index of the best particle in the swarm
        parts = {},         -- Particles
        nbhoook = nil,      -- New best hook
        replhook = nil,     -- Replacement hook
        iterhook = nil      -- Iteration hook
    }

    setmetatable(sw, { __index = MT })
    return sw
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- Rounds the number 'n' to 'p' decimal places.
local math_floor, math_ceil = math.floor, math.ceil
local function round(n, p)
    if not p then
        return n
    end
    local m = 10.0 ^ p
    if (m*n - math_floor(m*n)) >= 0.5 then
        return math_ceil(m*n)/m
    end
    return math_floor(m*n)/m
end


-- Returns the number 'b' if it is within the range [a,c]; otherwise, 
-- returns a or c
local math_max, math_min = math.max, math.min
local function range(a, b, c)
    return math_max(a, math_min(b, c))
end


-- Implements a continuous and closed space between 'min' and 'max'
local function cspace(min, x, max)
    if (min <= x) and (x <= max) then
        return x
    else
        return min + (x % max)
    end
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


---
--- sw:setPrecision(decs)
---
--- Sets the precision for all dimensions (in number of decimal places). 
--- 'nil' disables this feature and allows the values to assume the maximum
--- precision allowed by the Lua numbers.
---
function MT.setPrecision(self, decs)
    for i = 1, self.dims do
        self:setPrecisionDim(i, decs)
    end
end


---
--- sw:setPrecisionDim(dim, decs)
---
--- Sets the precision for the dimension 'dim', for 'decs' decimal places.
--- 'nil' disables this feature and allows the values to assume the maximum
--- precision allowed by the Lua numbers.
---
function MT.setPrecisionDim(self, dim, decs)
    assert(not decs or decs >= 0, "Bad number of decimal places.")
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    self.prec[dim] = decs
end


---
--- sw:getPrecisionDim(dim)
---
--- Returns the precision for the dimension 'dim', as the number of decimal
--- places.
---
function MT.getPrecisionDim(self, dim)
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    return self.prec[dim]
end


---
--- sw:setC1(c)
---
--- Sets the cognitive factor (number, 0 or greater).
---
function MT.setC1(self, c)
    -- assert(c >= 0 and c <= 1, "Value out of range")
    assert(c >= 0, "Value out of range")
    self.c1 = c
end


---
--- sw:getC1()
---
--- Returns the cognitive factor (number, 0 or greater).
---
function MT.getC1(self)
    return self.c1
end


---
--- sw:setC2(c)
---
--- Sets the social factor (number, 0 or greater).
---
function MT.setC2(self, c)
    -- assert(c >= 0 and c <= 1, "Value out of range")
    assert(c >= 0, "Value out of range")
    self.c2 = c
end


---
--- sw:getC2()
---
--- Returns the social factor (number, 0 or greater).
---
function MT.getC2(self)
    return self.c2
end


---
--- sw:setMaxSpeedDim(dimension, speed)
---
--- Sets the maximum speed for a particle in the given dimension
---
function MT.setMaxSpeedDim(self, dim, spd)
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    self.maxs[dim] = spd
end


---
--- sw:getMaxSpeed(dimension, speed)
---
--- Returns the maximum speed for a particle in the given dimension.
---
function MT.getMaxSpeedDim(self, dim)
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    return self.maxs[dim]
end


---
--- sw:setMaxSpeed(speed)
---
--- Sets the maximum speed for all dimensions.
---
function MT.setMaxSpeed(self, spd)
    for dim = 1, self.dims do
        self:setMaxSpeedDim(dim, spd)
    end
end


---
--- sw:setReplacementProb(prob)
---
--- Sets the probability of a particle being replaced by another, randomly
--- generated, one. This feature tries to avoid local optima by the simulation
--- of the death and replacement of a particle. The probability must be a
--- number between 0 and 1. The best particle in the swarm is never replaced.
---
function MT.setReplacementProb(self, prob)
    assert(0 <= prob and prob <= 1, "Bad replacement probability")
    self.repl = prob
end


---
--- sw:getReplacementProb(prob)
---
--- Gets the probability of a particle being replaced by another.
---
function MT.getReplacementProb(self)
    return self.repl
end


---
--- sw:setParticles(number)
---
--- Sets the number of particles.
---
function MT.setParticles(self, n)
    assert(n > 0, "Bad number of particles")
    self.nparts = n
end


---
--- sw:getParticles()
---
--- Returns the number of particles.
---
function MT.getParticles(self)
    return self.nparts
end


---
--- sw:setFitnessFunction(function (...)  .... end)
---
--- Sets the fitness function. The particle position will be passed as an
--- argument for each dimension.  The fitness function must return the
--- fitness of the given particle as a number with higher values for better
--- solutions.
---
function MT.setFitnessFunction(self, func)
    if type(func) ~= "function" then
        error("Bad function")
    end
    self.fitfunc = func
end


---
--- sw:setLimitsDim(dimension, min, max)
---
--- Sets the limits for the given dimension.
---
function MT.setLimitsDim(self, dim, min, max)
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    self.minp[dim] = min
    self.maxp[dim] = max
end    


---
--- sw:getLimitsDim(dimension)
---
--- Returns the minimum and maximum values for the given dimension.
---
function MT.getLimitsDim(self, dim)
    assert(dim > 0 and dim <= self.dims, "Bad dimension")
    return self.minp[dim], self.maxp[dim]
end



--- sw:setLimits(min, max)
---
--- Sets the limits for all dimensions.
---
function MT.setLimits(self, min, max)
    for dim = 1, self.dims do
        self:setLimitsDim(dim, min, max)
    end
end


---
--- sw:setFitnessRounding(decs)
---
--- Makes the solver round up the fitness to 'decs' decimal places. The value
--- must be a positive integer or 'nil' to disable this feature.
---
function MT.setFitnessRounding(self, decs)
    assert(not decs or decs >= 0, "Bad number of decimal places.")
    self.fitr = decs
end


---
--- sw:getFitnessRounding()
---
--- Returns the number of decimal places used to round up the fitness values,
--- or 'nil' if this feature is not used. 
---
function MT.setFitnessRouding(self, decs)
    assert(decs > 0, "Bad number of decimal places.")
    self.fitr = decs
end


---
--- sw:setMaxFitness(maxf)
---
--- Sets the maximum fitness as a termination criterium. Fitness must be a
--- number or 'nil' to disable its use as termination criterium.
---
function MT.setMaxFitness(self, max)
    self.maxfit = max
end


---
--- sw:getMaxFitness()
---
--- Returns the maximum fitness, or 'nil' if it is not used as termination
--- criteria.
---
function MT.getMaxFitness(self)
    return self.maxfit
end


---
--- sw:setMaxIterations(maxi)
---
--- Sets the maximum number of iterations as a termination criterium. This
--- must be a integer greater than zero or 'nil' to disable its use as
--- termination criterium.
---
function MT.setMaxIterations(self, max)
    assert(max > 0, "Bad number of iterations")
    self.maxiter = max
end


---
--- sw:getMaxIterations()
---
--- Returns the maximum number of iterations, or 'nil' if it is not used as
--- termination criteria.
---
function MT.getMaxIterations(self)
    return self.maxiter
end


---
--- sw:setMaxStagnation(maxs)
---
--- Sets the maximum number of stagnated iterations as a termination
--- criterium. This must be a integer greater than zero or 'nil' to disable
--- its use as termination criterium.
---
function MT.setMaxStagnation(self, max)
    assert(max > 0, "Bad number of iterations")
    self.maxstag = max
end


---
--- sw:getMaxStagnation()
---
--- Returns the maximum number of stagnated iterations, or 'nil' if it is not
--- used as termination criteria.
---
function MT.getMaxStagnation(self)
    return self.maxstag
end


---
--- sw:setNewBestHook(function(...) end)
---
--- Sets a function to be called when a new best particle if found. The
--- function will receive the particle position, an per dimension. Passing
--- 'nil' disables this feature.
---
function MT.setNewBestHook(self, func)
    if func and type(func) ~= "function" then
        error("Bad function")
    end
    self.nbhook = func
end


---
--- sw:setReplacementHook(function(...) end)
---
--- Sets a function to be called when a particle is replaced. The function
--- will receive the position of the dead particle, an per dimension. Passing
--- 'nil' disables this feature.
---
function MT.setReplacementHook(self, func)
    if func and type(func) ~= "function" then
        error("Bad function")
    end
    self.replhook = func
end


---
--- sw:setIterationHook(function(parts, iter) ... end)
---
--- Sets a function to be called for each iteration of the optimizer. The
--- function will receive a array of particles as first argument and the
--- number of the current iteration as second argument.  Each particle in
--- the particle array is a table with the following fields:
--- 
---   fit  the fitness value for the best position (number);
---   x    particle's position in the n-dimensional space (array of numbers);
---   b    particle's best position (array of numbers);
---   v    particle's velocity (array of numbers).
--- 
--- these values may be read, but SHOULD NOT be changed or redefined.
--- Passing 'nil' disables this feature.
---
--- Warning: Abuse of this feature may slow the algorithm down!
---
function MT.setIterationHook(self, func)
    if func and type(func) ~= "function" then
        error("Bad function")
    end
    self.iterhook = func
end


-- Evaluates a particle. 
local function evalpart(self, p)
    local fit = round(self.fitfunc(unpack(p.x)), self.fitr)
    if p.fit then
        if fit > p.fit then    -- New particle's best found.
            p.fit = fit
            for i = 1, self.dims do
                p.b[i] = p.x[i]
            end
        end
    else
        p.fit = fit
    end
end


-- Makes a new random particle or randomizes an existing one.
local function randomizeParticle(self, p)
    p = p or {}
    p.fit = nil -- 'nil' is the worst possible fitness.
    p.x = {}    -- particle's position
    p.b = {}    -- particle's best position (pbest)
    p.v = {}    -- particle's velocity
    for i = 1, self.dims do
        p.x[i] = (self.maxp[i] - self.minp[i]) * math.random() + self.minp[i]
        p.b[i] = p.x[i]
        p.v[i] = 2 * self.maxs[i] * (math.random() - 0.5)
    end
    evalpart(self, p)
    return p
end


-- Updates the velocity and positonf of a particle.
local function updateParticle(self, i)
    local p = self.parts[i]
    local b = self.parts[self.gbest]
    local prec = self.prec  -- Optimization
    local rnd = math.random

    for i = 1, self.dims do
        p.v[i] = range(
                -self.maxs[i],
                self.c1 * rnd() * (p.b[i] - p.x[i]) +  -- Cognitive
                self.c2 * rnd() * (b.b[i] - p.x[i]),   -- Social
                self.maxs[i])
        local x = p.x[i] + p.v[i]
        if prec[i] then     -- Position rounding
            x = round(x, prec[i])
        end
        p.x[i] = cspace(self.minp[i], x, self.maxp[i])
    end
end


---
--- sw:run()
---
--- Runs the algorithm and returns a array with the position of the particle,
--- the fitness, the reason of termination (pso.TERM_CONVERGED,
--- pso.TERM_MAX_ITERATIONS, or pso.TERM_MAX_STAGNATION) and the total of
--- iterations.
---
function MT.run(self)
    local iter = 0
    local stag = 0
    local p

    assert(self.fitfunc, "No fitness function defined.")
    assert(self.maxfit or self.maxiter or self.maxstag,
        "No termination criteria defined.")

    for i = 1, self.dims do
        assert(self.maxs[i], "Required value for maximum speed not given.")
        assert(self.maxp[i], "Required value for maximum position not given.")
        assert(self.minp[i], "Required value for minimum position not given.")
    end

    for i = 1, self.nparts do
        self.parts[i] = randomizeParticle(self)
    end

    while true do

        for i = 1, self.nparts do
            -- Particle replacement.
            if i ~= self.gbest and math.random() < self.repl then
                if self.replhook then
                    self.replhook(unpack(self.parts[i].b))
                end
                randomizeParticle(self, self.parts[i])
            end

            evalpart(self, self.parts[i])
            if self.gbest then
                if self.parts[i].fit > self.parts[self.gbest].fit then
                    stag = 0
                    self.gbest = i
                    if self.nbhook then
                        self.nbhook(unpack(self.parts[self.gbest].b))
                    end
                end
            else
                -- The new best hook is never called for the first best.
                self.gbest = i
                stag = 0
            end

        end

        if self.maxfit and (self.parts[self.gbest].fit >= self.maxfit) then
            return self.parts[self.gbest].b, self.parts[self.gbest].fit,
                M.TERM_CONVERGED, iter
        end

        iter = iter + 1        
        if self.iterhook then
           self.iterhook(self.parts, iter)
        end 

        if self.maxiter and (iter > self.maxiter) then
            return self.parts[self.gbest].b, self.parts[self.gbest].fit,
                M.TERM_MAX_ITERATIONS, iter
        end

        stag = stag + 1
        if self.maxstag and (stag > self.maxstag) then
            return self.parts[self.gbest].b, self.parts[self.gbest].fit,
                M.TERM_MAX_STAGNATION, iter
        end

        for i = 1, self.nparts do
            updateParticle(self, i)
        end

    end

    return nil
end


-- Debug utilities:
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function printParticles(self)
    for i = 1, self.nparts do
        print(unpack(self.parts[i].b))
    end
end


return M
