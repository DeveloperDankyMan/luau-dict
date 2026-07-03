--!strict
--[[
	Dictionary Library for Luau
	A comprehensive, type-safe dictionary utility library supporting typed dictionaries,
	metatables, and plain key-value tables with utilities for common operations.
]]

export type Dict<K, V> = { [K]: V }
export type AnyDict = Dict<string, any>

local Dict = {}

--[[
	===== CREATION & TRANSFORMATION =====
]]

--[=[
	Creates a new empty dictionary with optional initial key-value pairs.
	
	```lua
	local dict = Dict.new { name = "John", age = 30 }
	```
]=]
function Dict.new<K, V>(initial: Dict<K, V>?): Dict<K, V>
	return if initial then table.clone(initial) else ({} :: Dict<K, V>)
end

--[=[
	Creates a shallow clone of a dictionary.
	
	```lua
	local original = { a = 1, b = { c = 2 } }
	local cloned = Dict.clone(original)
	```
]=]
function Dict.clone<K, V>(dict: Dict<K, V>): Dict<K, V>
	return table.clone(dict)
end

--[=[
	Creates a deep clone of a dictionary (recursively clones nested tables).
	
	```lua
	local original = { a = 1, b = { c = 2 } }
	local cloned = Dict.deepClone(original)
	```
]=]
function Dict.deepClone<K, V>(dict: Dict<K, V>): Dict<K, V>
	local cloned = {} :: Dict<K, V>
	for key, value in dict do
		if type(value) == "table" then
			cloned[key] = Dict.deepClone(value)
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
function Dict.merge<K, V>(...: Dict<K, V>): Dict<K, V>
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
function Dict.deepMerge<K, V>(...: Dict<K, V>): Dict<K, V>
	local result = {} :: Dict<K, V>
	for i = 1, select("#", ...) do
		local dict = select(i, ...)
		if dict then
			for key, value in dict do
				if type(value) == "table" and type(result[key]) == "table" then
					result[key] = Dict.deepMerge(result[key], value)
				else
					result[key] = value
				end
			end
		end
	end
	return result
end

--[[
	===== QUERYING & RETRIEVAL =====
]]

--[=[
	Gets a value from the dictionary, with optional default.
	
	```lua
	local value = Dict.get(dict, "key", "default")
	```
]=]
function Dict.get<K, V>(dict: Dict<K, V>, key: K, default: V?): V?
	local value = dict[key]
	return if value ~= nil then value else default
end

--[=[
	Gets a nested value using dot notation.
	Supports deep path access like "user.profile.name".
	
	```lua
	local name = Dict.getPath(data, "user.profile.name", "Unknown")
	```
]=]
function Dict.getPath(dict: AnyDict, path: string, default: any?): any
	local current = dict
	for part in path:gmatch("[^.]+") do
		if type(current) == "table" and current[part] ~= nil then
			current = current[part]
		else
			return default
		end
	end
	return current
end

--[=[
	Sets a value in the dictionary.
	
	```lua
	Dict.set(dict, "key", value)
	```
]=]
function Dict.set<K, V>(dict: Dict<K, V>, key: K, value: V)
	dict[key] = value
end

--[=[
	Sets a nested value using dot notation, creating intermediate tables as needed.
	
	```lua
	Dict.setPath(data, "user.profile.name", "John")
	```
]=]
function Dict.setPath(dict: AnyDict, path: string, value: any)
	local parts = {}
	for part in path:gmatch("[^.]+") do
		table.insert(parts, part)
	end
	
	local current = dict
	for i = 1, #parts - 1 do
		local part = parts[i]
		if type(current[part]) ~= "table" then
			current[part] = {}
		end
		current = current[part]
	end
	
	current[parts[#parts]] = value
end

--[=[
	Checks if a key exists in the dictionary.
	
	```lua
	if Dict.has(dict, "key") then ... end
	```
]=]
function Dict.has<K, V>(dict: Dict<K, V>, key: K): boolean
	return dict[key] ~= nil
end

--[=[
	Checks if a nested path exists using dot notation.
	
	```lua
	if Dict.hasPath(data, "user.profile.name") then ... end
	```
]=]
function Dict.hasPath(dict: AnyDict, path: string): boolean
	return Dict.getPath(dict, path) ~= nil
end

--[=[
	Deletes a key from the dictionary.
	
	```lua
	Dict.delete(dict, "key")
	```
]=]
function Dict.delete<K, V>(dict: Dict<K, V>, key: K)
	dict[key] = nil
end

--[=[
	Deletes a nested path using dot notation.
	
	```lua
	Dict.deletePath(data, "user.profile.name")
	```
]=]
function Dict.deletePath(dict: AnyDict, path: string)
	local parts = {}
	for part in path:gmatch("[^.]+") do
		table.insert(parts, part)
	end
	
	local current = dict
	for i = 1, #parts - 1 do
		local part = parts[i]
		if type(current[part]) ~= "table" then
			return
		end
		current = current[part]
	end
	
	current[parts[#parts]] = nil
end

--[[
	===== ITERATION & COLLECTION =====
]]

--[=[
	Returns an array of all keys in the dictionary.
	
	```lua
	local keys = Dict.keys(dict)
	```
]=]
function Dict.keys<K, V>(dict: Dict<K, V>): { K }
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
function Dict.values<K, V>(dict: Dict<K, V>): { V }
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
function Dict.entries<K, V>(dict: Dict<K, V>): { { K, V } }
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
function Dict.map<K, V, R>(dict: Dict<K, V>, fn: (V, K) -> R): Dict<K, R>
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
function Dict.filter<K, V>(dict: Dict<K, V>, predicate: (V, K) -> boolean): Dict<K, V>
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
function Dict.reduce<K, V, R>(dict: Dict<K, V>, initial: R, fn: (R, V, K) -> R): R
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
function Dict.invert<K, V>(dict: Dict<K, V>): Dict<V, K>
	local result = {} :: Dict<V, K>
	for key, value in dict do
		result[value] = key
	end
	return result
end

--[[
	===== INSPECTION =====
]]

--[=[
	Returns the number of key-value pairs in the dictionary.
	
	```lua
	local size = Dict.size(dict)
	```
]=]
function Dict.size<K, V>(dict: Dict<K, V>): number
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
function Dict.isEmpty<K, V>(dict: Dict<K, V>): boolean
	return next(dict) == nil
end

--[=[
	Checks if the dictionary contains a value.
	
	```lua
	if Dict.containsValue(dict, searchValue) then ... end
	```
]=]
function Dict.containsValue<K, V>(dict: Dict<K, V>, value: V): boolean
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
function Dict.findKey<K, V>(dict: Dict<K, V>, predicate: (V, K) -> boolean): K?
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
function Dict.find<K, V>(dict: Dict<K, V>, predicate: (V, K) -> boolean): V?
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
function Dict.every<K, V>(dict: Dict<K, V>, predicate: (V, K) -> boolean): boolean
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
function Dict.some<K, V>(dict: Dict<K, V>, predicate: (V, K) -> boolean): boolean
	for key, value in dict do
		if predicate(value, key) then
			return true
		end
	end
	return false
end

--[[
	===== UTILITIES =====
]]

--[=[
	Applies a function to each entry in the dictionary (for side effects).
	
	```lua
	Dict.forEach(people, function(person, name)
		print(name, person.age)
	end)
	```
]=]
function Dict.forEach<K, V>(dict: Dict<K, V>, fn: (V, K) -> ())
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
function Dict.pick<K, V>(dict: Dict<K, V>, ...: K): Dict<K, V>
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
function Dict.omit<K, V>(dict: Dict<K, V>, ...: K): Dict<K, V>
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
	Groups dictionary entries by the result of a function.
	
	```lua
	local grouped = Dict.groupBy(people, function(person)
		return person.department
	end)
	```
]=]
function Dict.groupBy<K, V, G>(dict: Dict<K, V>, fn: (V, K) -> G): Dict<G, { V }>
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

--[=[
	Converts the dictionary to a string representation.
	Useful for debugging.
	
	```lua
	print(Dict.toString(dict))
	```
]=]
function Dict.toString<K, V>(dict: Dict<K, V>, depth: number?): string
	depth = depth or 0
	local indent = string.rep("  ", depth)
	local nextIndent = string.rep("  ", depth + 1)
	
	if Dict.isEmpty(dict) then
		return "{}"
	end
	
	local parts = {}
	table.insert(parts, "{")
	
	for key, value in dict do
		local keyStr = if type(key) == "string" then key else tostring(key)
		local valueStr = if type(value) == "table" then Dict.toString(value, depth + 1) else tostring(value)
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
function Dict.validate<K, V>(dict: Dict<K, V>, schema: Dict<K, (V) -> boolean>): (boolean, { string }?)
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

--[[
	===== METATYPE SUPPORT =====
]]

--[=[
	Sets a metatable on the dictionary with optional metamethods.
	
	```lua
	Dict.setMeta(dict, {
		__tostring = function(t) return Dict.toString(t) end,
		__len = function(t) return Dict.size(t) end,
	})
	```
]=]
function Dict.setMeta<K, V>(dict: Dict<K, V>, meta: { [string]: any }?)
	if meta then
		setmetatable(dict, meta)
	end
	return dict
end

--[=[
	Gets the metatable of the dictionary.
	
	```lua
	local meta = Dict.getMeta(dict)
	```
]=]
function Dict.getMeta<K, V>(dict: Dict<K, V>): { [string]: any }?
	return getmetatable(dict)
end

--[=[
	Creates a metatype dictionary with common metamethods (length, tostring).
	
	```lua
	local dict = Dict.newMeta { a = 1, b = 2 }
	print(#dict)  -- 2
	print(dict)   -- { a = 1, b = 2 }
	```
]=]
function Dict.newMeta<K, V>(initial: Dict<K, V>?): Dict<K, V>
	local dict = Dict.new(initial)
	return Dict.setMeta(dict, {
		__len = function(t)
			return Dict.size(t)
		end,
		__tostring = function(t)
			return Dict.toString(t)
		end,
	})
end

--[[
	===== EXPORT =====
]]

return Dict
