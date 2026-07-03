--!strict
--[[
	Utilities module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>
type AnyDict = types.AnyDict
type Validator<V> = types.Validator<V>

local Inspection = require(script.Parent.inspection)

local Utilities = {}

--[=[
	Applies a function to each entry in the dictionary (for side effects).
	
	```lua
	Dict.forEach(people, function(person, name)
		print(name, person.age)
	end)
	```
]=]
function Utilities.forEach<K, V>(dict: Dict<K, V>, fn: (V, K) -> ())
	for key, value in dict do
		fn(value, key)
	end
end

--[=[
	Picks only the specified keys from the dictionary.
	
	```lua
	local subset = Dict.pick(user, "name", "email")
	-- Result: { name = "John", email = "john@example.com" }
	```
]=]
function Utilities.pick<K, V>(dict: Dict<K, V>, ...: K): Dict<K, V>
	local result = {} :: Dict<K, V>
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if dict[key] ~= nil then
			result[key] = dict[key]
		end
	end
	return result
end

--[=[
	Omits the specified keys from the dictionary.
	
	```lua
	local filtered = Dict.omit(user, "password", "secret")
	```
]=]
function Utilities.omit<K, V>(dict: Dict<K, V>, ...: K): Dict<K, V>
	local toOmit = {} :: { [K]: boolean }
	for i = 1, select("#", ...) do
		toOmit[select(i, ...)] = true
	end
	
	local result = {} :: Dict<K, V>
	for key, value in dict do
		if not toOmit[key] then
			result[key] = value
		end
	end
	return result
end

--[=[
	Converts the dictionary to a string representation.
	Useful for debugging.
	
	```lua
	print(Dict.toString(dict))
	```
]=]
function Utilities.toString<K, V>(dict: Dict<K, V>, depth: number?): string
	depth = depth or 0
	local indent = string.rep("  ", depth)
	local nextIndent = string.rep("  ", depth + 1)
	
	if Inspection.isEmpty(dict) then
		return "{}"
	end
	
	local parts = {}
	table.insert(parts, "{")
	
	for key, value in dict do
		local keyStr = if type(key) == "string" then key else tostring(key)
		local valueStr = if type(value) == "table" then Utilities.toString(value, depth + 1) else tostring(value)
		table.insert(parts, nextIndent .. keyStr .. " = " .. valueStr)
	end
	
	table.insert(parts, indent .. "}")
	return table.concat(parts, "\n")
end

--[=[
	Validates the dictionary against a schema.
	Schema is a dictionary where keys are field names and values are validation functions.
	
	```lua
	local schema = {
		name = function(v) return type(v) == "string" end,
		age = function(v) return type(v) == "number" and v >= 0 end,
	}
	
	local isValid, errors = Dict.validate(user, schema)
	```
]=]
function Utilities.validate<K, V>(dict: Dict<K, V>, schema: Dict<K, Validator<V>>): (boolean, { string }?)
	local errors = {}
	for key, validator in schema do
		if dict[key] == nil then
			table.insert(errors, "Missing required field: " .. tostring(key))
		elseif not validator(dict[key]) then
			table.insert(errors, "Validation failed for field: " .. tostring(key))
		end
	end
	return if #errors == 0 then (true, nil) else (false, errors)
end

return Utilities
