-- A 2D Vector Library.
-- By Gordon MacPherson with the assistance of google and sir divran! :L
-- updated to support 2D for the love2D engine.
local type = type

-- Meta table.
local vector_mt = {}

-- Divran's idea.
local function new(x,y)
	return setmetatable( {x = x or 0, y = y or 0} , vector_mt) 
end

Vector2 = new

function vector_mt:__add( vector )
	return new( 
		self.x + vector.x,
		self.y + vector.y
	)
end

function vector_mt:__sub( vector )
	return new(
		self.x - vector.x,
		self.y - vector.y
	)
end

function vector_mt:__mul( vector )
	if type(vector) == "number" then
		return new(
			self.x * vector,
			self.y * vector
		)
	else
		return new(
			self.x * vector.x,
			self.y * vector.y
		)
	end
end

function vector_mt:__div( vector )
	if type(vector) == "number" then
		return new(
			self.x / vector,
			self.y / vector
		)
	else
		return new(
			self.x / vector.x,
			self.y / vector.y
		)
	end
end

--
-- Boolean operators
--

function vector_mt:__eq( vector )
	return self.x == vector.x and self.y == vector.y
end

function vector_mt:__unm()
	return new(-self.x,-self.y)
end

-- 
-- String Operators.
--

function vector_mt:__tostring()
	return "[" .. self.x .. ", " .. self.y .. "]"
end        

--
-- Vector operator functions.
--

function vector_mt:Add( vector )
	self = self + vector
end

function vector_mt:Sub( vector )
	self = self - vector
end

function vector_mt:Mul( n )
	self.x = self.x * n
	self.y = self.y * n
end

function vector_mt:Zero()
	self.x = 0
	self.y = 0
	return self
end

function vector_mt:Length()
	return ( ( self.x * self.x ) + ( self.y * self.y ) ) ^ 0.5
end

-- This should really be named get normalised copy.
function vector_mt:GetNormal()
	local length = self:Length()
	return new( self.x / length, self.y / length )
end

-- Redirect for people doing it wrong.
function vector_mt:GetNormalized()
	return self:GetNormal()
end

function vector_mt:Normalize()
	return self:GetNormal()
end

function vector_mt:DotProduct( vector )
	return (self.x  * vector.x) + (self.y * vector.y)
end

-- Redirect for people doing it wrong.
function vector_mt:Dot( vector )
	return self:DotProduct( vector )
end

-- Returns the distance between two vectors.
function vector_mt:Distance( vector )
	local vec = self - vector
	return vec:Length()
end


--[[
	To be added if I want this as a direct replacement.
	However I feel 2D vectors should be made as there own type.

	Vector:Length2D -- Will be Vector2:Length2D()
	Vector:Length2DSqr -- Not Added.
	Vector:LengthSqr -- Not Added.
	Vector:Rotate -- Should exist when angle and quaternions are done.
]]
  

