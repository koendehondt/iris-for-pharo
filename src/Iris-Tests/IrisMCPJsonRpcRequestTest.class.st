Class {
	#name : 'IrisMCPJsonRpcRequestTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPJsonRpcRequestTest >> testFromDictionaryUsesDefaults [

	| req |
	req := IrisMCPJsonRpcRequest fromDictionary: Dictionary new.
	self assert: req jsonrpc equals: '2.0'.
	self assert: req id isNil.
	self assert: req method isNil.
	self assert: req params equals: Dictionary new
]

{ #category : 'tests' }
IrisMCPJsonRpcRequestTest >> testFromDictionaryWithAllFields [

	| dict req |
	dict := Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 42
		with: 'method' -> 'tools/list'
		with: 'params' -> (Dictionary with: 'foo' -> 'bar').
	req := IrisMCPJsonRpcRequest fromDictionary: dict.
	self assert: req jsonrpc equals: '2.0'.
	self assert: req id equals: 42.
	self assert: req method equals: 'tools/list'.
	self assert: (req params at: 'foo') equals: 'bar'
]
