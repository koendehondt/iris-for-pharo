Class {
	#name : 'IrisMCPJsonRpcResponseTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPJsonRpcResponseTest >> testAsJsonIncludesJsonrpcAndId [

	| resp parsed |
	resp := IrisMCPJsonRpcResponse resultFor: 7 value: 42.
	parsed := NeoJSONReader fromString: resp asJson.
	self assert: parsed equals: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 7
		with: 'result' -> 42)
]

{ #category : 'tests' }
IrisMCPJsonRpcResponseTest >> testErrorResponse [

	| resp json parsed |
	resp := IrisMCPJsonRpcResponse errorFor: 2 code: -32600 message: 'Invalid request'.
	self assert: resp jsonrpc equals: '2.0'.
	self assert: resp result isNil.
	self assert: resp error equals: (Dictionary
		with: 'code' -> -32600
		with: 'message' -> 'Invalid request').
	json := resp asJson.
	parsed := NeoJSONReader fromString: json.
	self assert: parsed equals: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 2
		with: 'error' -> (Dictionary
			with: 'code' -> -32600
			with: 'message' -> 'Invalid request'))
]

{ #category : 'tests' }
IrisMCPJsonRpcResponseTest >> testResultResponse [

	| resp json parsed |
	resp := IrisMCPJsonRpcResponse resultFor: 1 value: 'hello'.
	self assert: resp jsonrpc equals: '2.0'.
	self assert: resp id equals: 1.
	self assert: resp result equals: 'hello'.
	self assert: resp error isNil.
	json := resp asJson.
	parsed := NeoJSONReader fromString: json.	
	self assert: parsed equals: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'result' -> 'hello')
]
