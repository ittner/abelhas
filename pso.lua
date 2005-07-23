#!/usr/bin/env lua

-- $Id$

module "pso"
require "math"

TERM_CONVERGED = 1
TERM_MAX_ITERATIONS = 2
TERM_MAX_STAGNATION = 3

function new(p)
  local sw = {
    objfunc = nil,  -- Objective function
    dims = 0,       -- Dimensions
    decs = 14,      -- Decimal places
    mins = {},      -- Minimum value, per dimension
    maxs = {},      -- Maximum value, per dimension
    c1 = 0.5,       -- 'c1' factor
    c2 = 0.5,       -- 'c2' factor
    nparts = 0,     -- Number of particles
    maxfit = nil,   -- Maximum fitness
    maxiter = nil,  -- Maximum iterations
    maxstag = nil,  -- Maximum fitness stagnation
    maxspeed = 3,   -- Maximum particle speed
    gbest = nil,    -- Index of the best particle in the swarm
    parts = {},     -- Particles
    iter = 0,       -- Iteration count
    stag = 0        -- Stagnation count
  }

  setmetatable(sw, _M)
  return sw
end


local function round(n, p)
  local m = 10.0 ^ (p or 0)
  if (m*n - math.floor(m*n)) > 0.4 then
    return math.ceil(m*n)/m
  end
  return math.floor(m*n)/m
end


local function range(a, b, c)
  return math.max(a, math.min(b, c))
end


function setDimensions(self, dims)
  self.dims = dims
  return dims
end


function setDecimals(self, decs)
  self.decs = decs
  return decs
end


function setParticles(self, n)
  self.nparts = n
  return n
end


function setObjfunc(self, func)
  if type(objfunc) ~= "function" then
    error("bad function")
  end
  self.objfunc = objfunc
  return n
end



-- swarm:setLimits(1, -200, 200) - Set first dimension's limits
-- swarm:setLimits(-200, 200)    - Set all dimensions limits
function setLimits(self, dim, min, max)
  if max == nil then
    min = dim
    max = min
    local k
    for k = 1, self.dims do
      self.mins[k] = min
      self.maxs[k] = max
    end
  else
    self.min[dim] = min
    self.max[dim] = max
  end
  return min, max
end


function setMaxFitness(self, max)
  self.maxfit = max
  return maxf
end


function setMaxIterations(self, max)
  self.maxiter = max
  return maxf
end


local function makeRandomPart(self)
  local i
  local p = {
    fit = nil,        -- 'nil' is the worst possible fitness.
    x = {},
    p = {},
    v = {}
  }
  for i = 1, self.dims do
    p.x[i] = math.random(self.mins[i], self.maxs[i])
    p.p[i] = math.random(self.mins[i], self.maxs[i])
    p.v[i] = math.random(self.mins[i], self.maxs[i])
  end
  return p
end


local function evalpart(self, i)
  local p = self.parts[i]
  local fit = round(self.objfunc(p.p), self.decs)
  if p.fit then
    if fit > p.fit then
      p.fit = fit
      local i
      for i = 1, self.dims do
        p.p = p.x[i]
      end
    end
  else
    p.fit = fit
  end
  return fit
end


local function adjspeed(self, i)
  local r1 = math.random()
  local r2 = math.random()
  local p = self.parts[i]
  local b = self.parts[self.gbest]
  local i
  for i = 1, self.dims do
    p.v[i] = range(
        self.mins[i],
        self.c1 * r1 * (p.p[i] - p.x[i]) + self.c2 * r2 * (b.p[i] - p.x[i]),
        self.maxs[i])
  end
end


local function adjpos(self, i)
  local p = self.parts[i]
  local i
  for i = 1, self.dims do
    p.x[i] = range(p.mins[i], p.x[i] + p.v[i], p.maxs[i])
  end
end


function run(self)
  local iter = 0
  local stag = 0
  local i, p, lastbest

  assert(self.objfunc, "No objective function defined.")
  assert(self.maxfit or self.maxiter or self.maxstag,
    "No termination criteria defined.")

  for i = 1, self.nparts do
    self.parts[i] = makeRandomPart()
  end

  while true do

    for i = 1, self.nparts do
      evalpart(self, self.parts[i])
      if self.gbest then
        if self.parts[i].fit > self.parts[self.gbest].fit then
          self.gbest = i
        end
      else
        self.gbest = i
      end
    end

    if self.maxfit and (self.parts[self.gbest].fit >= self.maxfit) then
      return self.parts[self.gbest].p, self.parts[self.gbest].fit,
            TERM_CONVERGED
    end

    iter = iter + 1
    if self.maxiter and (iter > self.maxiter) then
      return self.parts[self.gbest].p, self.parts[self.gbest].fit,
        TERM_MAX_ITERATIONS
    end

    if lastbest then
      if lastbest > self.parts[self.gbest].fit then
        stag = 0
      end
    end

    stag = stag + 1
    if self.maxstag and (stag > self.maxstag) then
      return self.parts[self.gbest].p, self.parts[self.gbest].fit,
        TERM_MAX_STAGNATION
    end

    for i = 1, self.nparts do
      adjspeed(self, i)
      adjpos(self, i)
    end

  end

  return nil
end


