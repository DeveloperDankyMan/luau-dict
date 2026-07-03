--!strict
--[[
	Dictionary Library for Luau
	A comprehensive, type-safe dictionary utility library supporting typed dictionaries,
	metatables, and plain key-value tables with utilities for common operations.
	
	Main entry point that aggregates all modules.
]]

export type Dict<K, V> = { [K]: V }
export type AnyDict = Dict<string, any>

-- Import all modules
local Creation = require(script.creation)
local Query = require(script.query)
local Iteration = require(script.iteration)
local Inspection = require(script.inspection)
local Utilities = require(script.utilities)
local Meta = require(script.meta)

-- Main dictionary module that re-exports all functionality
local Dict = {}

--[[
	===== CREATION & TRANSFORMATION =====
]]
Dict.new = Creation.new
Dict.clone = Creation.clone
Dict.deepClone = Creation.deepClone
Dict.merge = Creation.merge
Dict.deepMerge = Creation.deepMerge

--[[
	===== QUERYING & RETRIEVAL =====
]]
Dict.get = Query.get
Dict.getPath = Query.getPath
Dict.set = Query.set
Dict.setPath = Query.setPath
Dict.has = Query.has
Dict.hasPath = Query.hasPath
Dict.delete = Query.delete
Dict.deletePath = Query.deletePath

--[[
	===== ITERATION & COLLECTION =====
]]
Dict.keys = Iteration.keys
Dict.values = Iteration.values
Dict.entries = Iteration.entries
Dict.map = Iteration.map
Dict.filter = Iteration.filter
Dict.reduce = Iteration.reduce
Dict.invert = Iteration.invert
Dict.groupBy = Iteration.groupBy

--[[
	===== INSPECTION =====
]]
Dict.size = Inspection.size
Dict.isEmpty = Inspection.isEmpty
Dict.containsValue = Inspection.containsValue
Dict.findKey = Inspection.findKey
Dict.find = Inspection.find
Dict.every = Inspection.every
Dict.some = Inspection.some

--[[
	===== UTILITIES =====
]]
Dict.forEach = Utilities.forEach
Dict.pick = Utilities.pick
Dict.omit = Utilities.omit
Dict.toString = Utilities.toString
Dict.validate = Utilities.validate

--[[
	===== METATYPE SUPPORT =====
]]
Dict.setMeta = Meta.setMeta
Dict.getMeta = Meta.getMeta
Dict.newMeta = Meta.newMeta

return Dict
