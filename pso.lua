#!/usr/bin/env lua

-- $Id$

module "pso"
require "math"

TERMINATION_CONVER = 1
TERMINATION_MAX_ITERATIONS = 2
TERMINATION_FITNESS_STAGNATION = 3

function new(p)
  local sw = {
    objfunc = nil   -- Objective function
    dims = 0,       -- Dimensions
    decs = 0,       -- Decimal places
    mins = {},      -- Minimum value, per dimension
    maxs = {},      -- Maximum value, per dimension
    c1 = 0.5,       -- 'c1' factor
    c2 = 0.5,       -- 'c2' factor
    nparts = 0      -- Number of particles
    maxfit = nil,   -- Maximum fitness
    maxiter = nil,  -- Maximum iterations
    maxstag = nil,  -- Maximum fitness stagnation
    maxspeed = 3,   -- Maximum particle speed
    gbest = nil,    -- Index of the best particle in the swarm
    parts = {},     -- Particles
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


function makeRandomPart(self)
  local i
  local p = {
    fit = self.worstfit,
    pbest = self.worstfit,
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


local function evaluateParticle(self, i)
  local p = self.parts[i]
  local fit = self.objfunc(p.p)
  if fit > p.pbest then
    p.pbest = fit
    local i
    for i = 1, self.dims do
      p.p = p.x[i]
    end
  end
  return fit
end
    


-- Ajusta a velocidade de p em função de r
function adjspeed(p, r)
  local r1 = math.random()
  local r2 = math.random()
  local nv =  {
    c1 * r1 * (p.p[1] - p.x[1]) + c2 * r2 * (r.p[1] - p.x[1]),
    c1 * r1 * (p.p[2] - p.x[2]) + c2 * r2 * (r.p[2] - p.x[2])
  }
  p.v = {
    range(-vmax, p.v[1] + nv[1], vmax),
    range(-vmax, p.v[2] + nv[2], vmax)
  }
  return p.v
end

-- Ajusta a posição de p com a velocidade previamente definida
function adjpos(p)
  p.x = {
    range(minx, p.x[1] + p.v[1], maxx),
    range(miny, p.x[2] + p.v[2], maxy)
  }
  return p.x
end

-- Inicializa o enxame com partículas aleatórias.
for i = 1, nparts do
  parts[i] = makepart()
  objfunc(parts[i])
end

repeat
  for i, p in ipairs(parts) do
    objfunc(p)
    if p.pbest < parts[gbest].pbest then
      gbest = i
      print(string.format("Novo ótimo: f=%03.2f\tx=%3.2f\ty=%3.2f",
        p.pbest, p.p[1], p.p[2]))
    end
  end
  for i, p in ipairs(parts) do
    adjspeed(p, parts[gbest])
    adjpos(p)
  end
  iter = iter + 1
until (iter > maxiter) or (parts[gbest].pbest == 0)

print("Iterações: ", iter)
