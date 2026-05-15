Class {
	#name : 'IrisMCPServerTest',
	#superclass : 'IrisMCPTestCase',
	#instVars : [
		'server'
	],
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'helpers' }
IrisMCPServerTest >> makePostRequest: aBody [

	| req entity |
	entity := ZnEntity
		with: aBody
		type: ZnMimeType applicationJson.
	req := ZnRequest post: 'http://localhost:9999/mcp'.
	req entity: entity.
	^ req
]

{ #category : 'running' }
IrisMCPServerTest >> setUp [

	server := IrisMCPServer new
]

{ #category : 'tests' }
IrisMCPServerTest >> testDefaultPort [

	self assert: server port equals: 9999
]

{ #category : 'tests' }
IrisMCPServerTest >> testDispatcherAccessor [

	| dispatcher |
	dispatcher := IrisMCPDispatcher new.
	server dispatcher: dispatcher.
	self assert: server dispatcher equals: dispatcher
]

{ #category : 'tests' }
IrisMCPServerTest >> testEmptyBodyReturnsError [

	| req response |
	req := ZnRequest post: 'http://localhost:9999/mcp'.
	response := server handleRequest: req.
	self assert: response status equals: 500
]

{ #category : 'tests' }
IrisMCPServerTest >> testInvalidJsonReturnsParseError [

	| response parsed |
	response := server handleRequest: (self makePostRequest: 'not json at all').
	self assert: response status equals: 200.
	parsed := NeoJSONReader fromString: response entity string.
	self assert: parsed equals: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> nil
		with: 'error' -> (Dictionary
			with: 'code' -> -32700
			with: 'message' -> 'Parse error: invalid input: n'))
]

{ #category : 'tests' }
IrisMCPServerTest >> testNonPostReturns405 [

	| req response |
	req := ZnRequest get: 'http://localhost:9999/mcp'.
	response := server handleRequest: req.
	self assert: response status equals: 405
]

{ #category : 'tests' }
IrisMCPServerTest >> testOnPortConstructor [

	| s |
	s := IrisMCPServer onPort: 7777.
	self assert: s port equals: 7777
]

{ #category : 'tests' }
IrisMCPServerTest >> testPortAccessor [

	server port: 8080.
	self assert: server port equals: 8080
]

{ #category : 'tests' }
IrisMCPServerTest >> testResponseBodyIsValidJson [

	| body response parsed |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 5
		with: 'method' -> 'initialize'
		with: 'params' -> (Dictionary with: 'protocolVersion' -> '2025-03-26')).
	response := server handleRequest: (self makePostRequest: body).
	parsed := NeoJSONReader fromString: response entity string.
	self assert: parsed equals: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 5
		with: 'result' -> (Dictionary
			with: 'capabilities' -> (Dictionary
				with: 'tools' -> (Dictionary with: 'listChanged' -> false))
			with: 'protocolVersion' -> '2025-03-26'
			with: 'serverInfo' -> (Dictionary
				with: 'version' -> '0.1.0'
				with: 'name' -> 'pharo-mcp-server')))
]

{ #category : 'tests' }
IrisMCPServerTest >> testResponseHasCorsHeader [

	| body response |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	response := server handleRequest: (self makePostRequest: body).
	self assert: (response headers at: 'Access-Control-Allow-Origin') equals: '*'
]

{ #category : 'tests' }
IrisMCPServerTest >> testValidJsonRpcRequestReturns200 [

	| body response |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	response := server handleRequest: (self makePostRequest: body).
	self assert: response status equals: 200
]

{ #category : 'tests' }
IrisMCPServerTest >> testWrongPathReturns404 [

	| req |
	req := ZnRequest post: 'http://localhost:9999/wrong'.
	req entity: (ZnEntity with: '{}' type: ZnMimeType applicationJson).
	self assert: (server handleRequest: req) status equals: 404
]
