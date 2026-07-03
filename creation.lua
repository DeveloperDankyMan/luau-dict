--!strict
--[[
	Creation & Transformation module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>

local Creation = {}

--[=[
	Creates a new empty dictionary with optional initial key-value pairs.
	
	```lua
	local dict = Dict.new { name = "John", age = 30 }
	```
]=]
function Creation.new<K, V>(initial: Dict<K, V>?): Dict<K, V>
	return if initial then table.clone(initial) else ({} :: Dict<K, V>)
end

--[=[
	Creates a shallow clone of a dictionary.
	
	```lua
	local original = { a = 1, b = { c = 2 } }
	local cloned = Dict.clone(original)
	```
]=]
function Creation.clone<K, V>(dict: Dict<K, V>): Dict<K, V>
	return table.clone(dict)
end

--[=[
	Creates a deep clone of a dictionary (recursively clones nested tables).
	
	```lua
	local original = { a = 1, b = { c = 2 } }
	local cloned = Dict.deepClone(original)
	```
]=]
function Creation.deepClone<K, V>(dict: Dict<K, V>): Dict<K, V>
	local cloned = {} :: Dict<K, V>
	for key, value in dict do
		if type(value) == "table" then
			cloned[key] = Creation.deepClone(value)
		else
			cloned[key] = value
		end
	end
	return cloned
end

--[=[
	Merges multiple dictionaries into a new dictionary.
	Later dictionaries override earlier ones.
	
	```lua
	local merged = Dict.merge({ a = 1 }, { b = 2 }, { a = 3 })
	-- Result: { a = 3, b = 2 }
	```
]=]
function Creation.merge<K, V>(...: Dict<K, V>): Dict<K, V>
	local result = {} :: Dict<K, V>
	for i = 1, select("#", ...) do
		local dict = select(i, ...)
		if dict then
			for key, value in dict do
				result[key] = value
			end
		end
	end
	return result
end

--[=[
	Deep merges multiple dictionaries recursively.
	Nested tables are merged, not replaced.
	
	```lua
	local merged = Dict.deepMerge({ a = { x = 1 } }, { a = { y = 2 } })
	-- Result: { a = { x = 1, y = 2 } }
	```
]=]
function Creation.deepMerge<K, V>(...: Dict<K, V>): Dict<K, V>
	local result = {} :: Dict<K, V>
	for i = 1, select("#", ...) do
		local dict = select(i, ...)
		if dict then
			for key, value in dict do
				if type(value) == "table" and type(result[key]) == "table" then
					result[key] = Creation.deepMerge(result[key], value)
				else
					result[key] = value
				end
			end
		end
	end
	return result
end

return Creation
