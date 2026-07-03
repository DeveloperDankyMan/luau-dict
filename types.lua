--!strict
--[[
	Type definitions for the Dictionary Library
]]

export type Dict<K, V> = { [K]: V }
export type AnyDict = Dict<string, any>
export type Validator<V> = (V) -> boolean
export type Mapper<V, R> = (V, string) -> R
export type Predicate<V> = (V, string) -> boolean
export type Reducer<V, R> = (R, V, string) -> R
export type Grouper<V, G> = (V, string) -> G

return {}
