--!strict
--[[
	Querying & Retrieval module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>
type AnyDict = types.AnyDict

local Query = {}

--[=[
	Gets a value from the dictionary, with optional default.
	
	```lua
	local value = Dict.get(dict, "key", "default")
	```
]=]
function Query.get<K, V>(dict: Dict<K, V>, key: K, default: V?): V?
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
function Query.getPath(dict: AnyDict, path: string, default: any?): any
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
function Query.set<K, V>(dict: Dict<K, V>, key: K, value: V)
	dict[key] = value
end

--[=[
	Sets a nested value using dot notation, creating intermediate tables as needed.
	
	```lua
	Dict.setPath(data, "user.profile.name", "John")
	```
]=]
function Query.setPath(dict: AnyDict, path: string, value: any)
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
function Query.has<K, V>(dict: Dict<K, V>, key: K): boolean
	return dict[key] ~= nil
end

--[=[
	Checks if a nested path exists using dot notation.
	
	```lua
	if Dict.hasPath(data, "user.profile.name") then ... end
	```
]=]
function Query.hasPath(dict: AnyDict, path: string): boolean
	return Query.getPath(dict, path) ~= nil
end

--[=[
	Deletes a key from the dictionary.
	
	```lua
	Dict.delete(dict, "key")
	```
]=]
function Query.delete<K, V>(dict: Dict<K, V>, key: K)
	dict[key] = nil
end

--[=[
	Deletes a nested path using dot notation.
	
	```lua
	Dict.deletePath(data, "user.profile.name")
	```
]=]
function Query.deletePath(dict: AnyDict, path: string)
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

return Query
