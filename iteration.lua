--!strict
--[[
	Iteration & Collection module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>
type Mapper<V, R> = types.Mapper<V, R>
type Predicate<V> = types.Predicate<V>
type Reducer<V, R> = types.Reducer<V, R>
type Grouper<V, G> = types.Grouper<V, G>

local Iteration = {}

--[=[
	Returns an array of all keys in the dictionary.
	
	```lua
	local keys = Dict.keys(dict)
	```
]=]
function Iteration.keys<K, V>(dict: Dict<K, V>): { K }
	local result = {}
	for key in dict do
		table.insert(result, key)
	end
	return result
end

--[=[
	Returns an array of all values in the dictionary.
	
	```lua
	local values = Dict.values(dict)
	```
]=]
function Iteration.values<K, V>(dict: Dict<K, V>): { V }
	local result = {}
	for _, value in dict do
		table.insert(result, value)
	end
	return result
end

--[=[
	Returns an array of key-value pairs as { key, value } tuples.
	
	```lua
	local pairs = Dict.entries(dict)
	for _, entry in pairs do
		print(entry[1], entry[2])
	end
	```
]=]
function Iteration.entries<K, V>(dict: Dict<K, V>): { { K, V } }
	local result = {}
	for key, value in dict do
		table.insert(result, { key, value })
	end
	return result
end

--[=[
	Maps over each key-value pair and returns a new dictionary.
	
	```lua
	local doubled = Dict.map(numbers, function(value, key)
		return value * 2
	end)
	```
]=]
function Iteration.map<K, V, R>(dict: Dict<K, V>, fn: Mapper<V, R>): Dict<K, R>
	local result = {} :: Dict<K, R>
	for key, value in dict do
		result[key] = fn(value, key)
	end
	return result
end

--[=[
	Filters the dictionary, keeping only entries where the predicate returns true.
	
	```lua
	local adults = Dict.filter(people, function(person, name)
		return person.age >= 18
	end)
	```
]=]
function Iteration.filter<K, V>(dict: Dict<K, V>, predicate: Predicate<V>): Dict<K, V>
	local result = {} :: Dict<K, V>
	for key, value in dict do
		if predicate(value, key) then
			result[key] = value
		end
	end
	return result
end

--[=[
	Reduces the dictionary to a single value by applying an accumulator function.
	
	```lua
	local sum = Dict.reduce(numbers, 0, function(acc, value)
		return acc + value
	end)
	```
]=]
function Iteration.reduce<K, V, R>(dict: Dict<K, V>, initial: R, fn: Reducer<V, R>): R
	local accumulator = initial
	for key, value in dict do
		accumulator = fn(accumulator, value, key)
	end
	return accumulator
end

--[=[
	Inverts the dictionary, swapping keys and values.
	
	```lua
	local inverted = Dict.invert({ a = 1, b = 2 })
	-- Result: { [1] = "a", [2] = "b" }
	```
]=]
function Iteration.invert<K, V>(dict: Dict<K, V>): Dict<V, K>
	local result = {} :: Dict<V, K>
	for key, value in dict do
		result[value] = key
	end
	return result
end

--[=[
	Groups dictionary entries by the result of a function.
	
	```lua
	local grouped = Dict.groupBy(people, function(person)
		return person.department
	end)
	```
]=]
function Iteration.groupBy<K, V, G>(dict: Dict<K, V>, fn: Grouper<V, G>): Dict<G, { V }>
	local result = {} :: Dict<G, { V }>
	for key, value in dict do
		local group = fn(value, key)
		if result[group] == nil then
			result[group] = {}
		end
		table.insert(result[group], value)
	end
	return result
end

return Iteration
