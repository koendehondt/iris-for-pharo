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
	entity := ZnEntity with: aBody type: ZnMimeType applicationJson.
	req := ZnRequest post: 'http://localhost:9999/mcp'.
	req entity: entity.
	^ req
]

{ #category : 'running' }
IrisMCPServerTest >> setUp [

	server := IrisMCPServer new
]

{ #category : 'tests' }
IrisMCPServerTest >> testAnnouncerIsNotNil [

	self assert: server announcer notNil
]

{ #category : 'tests' }
IrisMCPServerTest >> testAnnouncerReturnsSameInstance [

	self assert: server announcer identicalTo: server announcer
]

{ #category : 'tests' }
IrisMCPServerTest >> testCurrentIsNotNil [

	self assert: IrisMCPServer current notNil
]

{ #category : 'tests' }
IrisMCPServerTest >> testCurrentReturnsSameInstance [

	self assert: IrisMCPServer current identicalTo: IrisMCPServer current
]

{ #category : 'tests' }
IrisMCPServerTest >> testDefaultLoggerIsNoLogger [

	self assert: server log isEmpty
]

{ #category : 'tests' }
IrisMCPServerTest >> testDefaultPort [

	self assert: IrisMCPServer new port equals: 9999
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
IrisMCPServerTest >> testIsLoggingFalseAfterStopLogging [

	server startLogging.
	server stopLogging.
	self deny: server isLogging
]

{ #category : 'tests' }
IrisMCPServerTest >> testIsLoggingFalseByDefault [

	self deny: server isLogging
]

{ #category : 'tests' }
IrisMCPServerTest >> testIsLoggingTrueAfterStartLogging [

	server startLogging.
	self assert: server isLogging
]

{ #category : 'tests' }
IrisMCPServerTest >> testLogEntryHasResponse [

	| body |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	server startLogging.
	server handleRequest: (self makePostRequest: body).
	self assert: server log first response notNil
]

{ #category : 'tests' }
IrisMCPServerTest >> testLoggingStartedAnnouncementCarriesServer [

	| announcedServer |
	announcedServer := nil.
	server announcer when: IrisMCPLoggingStarted do: [ :ann | announcedServer := ann server ] for: self.
	server startLogging.
	self assert: announcedServer identicalTo: server
]

{ #category : 'tests' }
IrisMCPServerTest >> testLoggingStoppedAnnouncementCarriesServer [

	| announcedServer |
	announcedServer := nil.
	server announcer when: IrisMCPLoggingStopped do: [ :ann | announcedServer := ann server ] for: self.
	server startLogging.
	server stopLogging.
	self assert: announcedServer identicalTo: server
]

{ #category : 'tests' }
IrisMCPServerTest >> testMultipleRequestsAreAllLogged [

	| body |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	server startLogging.
	server handleRequest: (self makePostRequest: body).
	server handleRequest: (self makePostRequest: body).
	self assert: server log size equals: 2.
	self assert: (server log allSatisfy: [ :entry | entry isKindOf: IrisMCPLogEntry ])
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
IrisMCPServerTest >> testRequestIsLoggedWhenLoggingEnabled [

	| body |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	server startLogging.
	server handleRequest: (self makePostRequest: body).
	self assert: server log size equals: 1.
	self assert: (server log first isKindOf: IrisMCPLogEntry)
]

{ #category : 'tests' }
IrisMCPServerTest >> testRequestIsNotLoggedByDefault [

	| body |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	server handleRequest: (self makePostRequest: body).
	self assert: server log isEmpty
]

{ #category : 'tests' }
IrisMCPServerTest >> testRequestLoggedAnnouncementFiredWhenLogging [

	| body announced |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	announced := false.
	server startLogging.
	server announcer when: IrisMCPRequestLogged do: [ :ann | announced := true ] for: self.
	server handleRequest: (self makePostRequest: body).
	self assert: announced
]

{ #category : 'tests' }
IrisMCPServerTest >> testRequestLoggedAnnouncementNotFiredWhenNotLogging [

	| body announced |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	announced := false.
	server announcer when: IrisMCPRequestLogged do: [ :ann | announced := true ] for: self.
	server handleRequest: (self makePostRequest: body).
	self deny: announced
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
IrisMCPServerTest >> testServerStartedAnnouncementCarriesServer [

	| announcedServer |
	announcedServer := nil.
	server port: 8181.
	server announcer when: IrisMCPServerStarted do: [ :ann | announcedServer := ann server ] for: self.
	server start.
	server stop.
	self assert: announcedServer identicalTo: server
]

{ #category : 'tests' }
IrisMCPServerTest >> testServerStoppedAnnouncementCarriesServer [

	| announcedServer |
	announcedServer := nil.
	server port: 8181.
	server announcer when: IrisMCPServerStopped do: [ :ann | announcedServer := ann server ] for: self.
	server start.
	server stop.
	self assert: announcedServer identicalTo: server
]

{ #category : 'tests' }
IrisMCPServerTest >> testSetCurrent [

	self restoreCurrentServerAfter: [ | newServer |
		newServer := IrisMCPServer onPort: 7777.
		IrisMCPServer current: newServer.
		self assert: IrisMCPServer current identicalTo: newServer.
		self deny: newServer isRunning.
		self deny: newServer isLogging ]
]

{ #category : 'tests' }
IrisMCPServerTest >> testStartIsIdempotent [

	server port: 8181.
	server start.
	server start.
	self assert: server isRunning.
	server stop
]

{ #category : 'tests' }
IrisMCPServerTest >> testStartLoggingIsIdempotent [

	server startLogging.
	server startLogging.
	self assert: server isLogging
]

{ #category : 'tests' }
IrisMCPServerTest >> testStartLoggingSwitchesToLogger [

	| body |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> 'tools/list'
		with: 'params' -> Dictionary new).
	server startLogging.
	server handleRequest: (self makePostRequest: body).
	self deny: server log isEmpty
]

{ #category : 'tests' }
IrisMCPServerTest >> testStartingAndStopping [

	server port: 8080.
	self deny: server isRunning.
	server start.
	self assert: server isRunning.
	server stop.
	self deny: server isRunning
]

{ #category : 'tests' }
IrisMCPServerTest >> testStopIsIdempotent [

	self deny: server isRunning.
	server stop.
	self deny: server isRunning
]

{ #category : 'tests' }
IrisMCPServerTest >> testStopLoggingClearsLog [

	server startLogging.
	server stopLogging.
	self assert: server log isEmpty
]

{ #category : 'tests' }
IrisMCPServerTest >> testStopLoggingIsIdempotent [

	self deny: server isLogging.
	server stopLogging.
	self deny: server isLogging
]

{ #category : 'tests' }
IrisMCPServerTest >> testStopLoggingSwitchesToNoLogger [

	server startLogging.
	server stopLogging.
	self assert: server log isEmpty
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
