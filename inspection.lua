--!strict
--[[
	Inspection & Checking module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>
type Predicate<V> = types.Predicate<V>

local Inspection = {}

--[=[
	Returns the number of key-value pairs in the dictionary.
	
	```lua
	local size = Dict.size(dict)
	```
]=]
function Inspection.size<K, V>(dict: Dict<K, V>): number
	local count = 0
	for _ in dict do
		count += 1
	end
	return count
end

--[=[
	Checks if the dictionary is empty.
	
	```lua
	if Dict.isEmpty(dict) then ... end
	```
]=]
function Inspection.isEmpty<K, V>(dict: Dict<K, V>): boolean
	return next(dict) == nil
end

--[=[
	Checks if the dictionary contains a value.
	
	```lua
	if Dict.containsValue(dict, searchValue) then ... end
	```
]=]
function Inspection.containsValue<K, V>(dict: Dict<K, V>, value: V): boolean
	for _, v in dict do
		if v == value then
			return true
		end
	end
	return false
end

--[=[
	Finds the first key whose value matches the predicate.
	
	```lua
	local key = Dict.findKey(people, function(person)
		return person.age == 30
	end)
	```
]=]
function Inspection.findKey<K, V>(dict: Dict<K, V>, predicate: Predicate<V>): K?
	for key, value in dict do
		if predicate(value, key) then
			return key
		end
	end
	return nil
end

--[=[
	Finds the first value that matches the predicate.
	
	```lua
	local person = Dict.find(people, function(p)
		return p.age == 30
	end)
	```
]=]
function Inspection.find<K, V>(dict: Dict<K, V>, predicate: Predicate<V>): V?
	for key, value in dict do
		if predicate(value, key) then
			return value
		end
	end
	return nil
end

--[=[
	Checks if every entry matches the predicate.
	
	```lua
	if Dict.every(people, function(p) return p.age >= 18 end) then ... end
	```
]=]
function Inspection.every<K, V>(dict: Dict<K, V>, predicate: Predicate<V>): boolean
	for key, value in dict do
		if not predicate(value, key) then
			return false
		end
	end
	return true
end

--[=[
	Checks if some entry matches the predicate.
	
	```lua
	if Dict.some(people, function(p) return p.age >= 18 end) then ... end
	```
]=]
function Inspection.some<K, V>(dict: Dict<K, V>, predicate: Predicate<V>): boolean
	for key, value in dict do
		if predicate(value, key) then
			return true
		end
	end
	return false
end

return Inspection
