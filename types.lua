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
export type Metamethods = {
	__index: ((any, any) -> any)?,
	__newindex: ((any, any, any) -> ())?,
	__call: ((any, ...any) -> ...any)?,
	__concat: ((any, any) -> string)?,
	__unm: ((any) -> any)?,
	__add: ((any, any) -> any)?,
	__sub: ((any, any) -> any)?,
	__mul: ((any, any) -> any)?,
	__div: ((any, any) -> any)?,
	__idiv: ((any, any) -> any)?,
	__mod: ((any, any) -> any)?,
	__pow: ((any, any) -> any)?,
	__tostring: ((any) -> string)?,
	__metatable: (any)?,
	__eq: ((any, any) -> boolean)?,
	__lt: ((any, any) -> boolean)?,
	__le: ((any, any) -> boolean)?,
	__mode: (string)?,
	__len: ((any) -> number)?,
	__iter: ((any) -> any)?,
	[string]: any,
}

return {}
