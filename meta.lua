--!strict
--[[
	Metatype Support module for Dictionary Library
]]

local types = require(script.Parent.types)
type Dict<K, V> = types.Dict<K, V>

local Inspection = require(script.Parent.inspection)
local Utilities = require(script.Parent.utilities)

local Meta = {}

--[=[
	Sets a metatable on the dictionary with optional metamethods.
	
	```lua
	Dict.setMeta(dict, {
		__tostring = function(t) return Dict.toString(t) end,
		__len = function(t) return Dict.size(t) end,
	})
	```
]=]
function Meta.setMeta<K, V>(dict: Dict<K, V>, meta: { [string]: any }?): Dict<K, V>
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
function Meta.getMeta<K, V>(dict: Dict<K, V>): { [string]: any }?
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
function Meta.newMeta<K, V>(initial: Dict<K, V>?): Dict<K, V>
	local dict = if initial then table.clone(initial) else ({} :: Dict<K, V>)
	return Meta.setMeta(dict, {
		__len = function(t)
			return Inspection.size(t)
		end,
		__tostring = function(t)
			return Utilities.toString(t)
		end,
	})
end

return Meta
