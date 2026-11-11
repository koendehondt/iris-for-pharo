Class {
	#name : 'IrisMCPServer',
	#superclass : 'Object',
	#instVars : [
		'port',
		'dispatcher',
		'logger',
		'announcer',
		'httpServer'
	],
	#classVars : [
		'Current'
	],
	#category : 'Iris-Server',
	#package : 'Iris',
	#tag : 'Server'
}

{ #category : 'accessing' }
IrisMCPServer class >> current [

	^ Current
]

{ #category : 'accessing' }
IrisMCPServer class >> current: aServer [

	Current := aServer
]

{ #category : 'class initialization' }
IrisMCPServer class >> initialize [

	self current: self new
]

{ #category : 'instance creation' }
IrisMCPServer class >> onPort: anInteger [

	^ self new
		port: anInteger;
		yourself
]

{ #category : 'accessing' }
IrisMCPServer >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'responses' }
IrisMCPServer >> badRequestResponse: aMessage [

	^ ZnResponse serverError: aMessage
]

{ #category : 'accessing' }
IrisMCPServer >> bindingAddress [
	"Answer the address the HTTP server listens on, or nil when it is not running."

	^ self isRunning
		ifTrue: [ httpServer bindingAddress ]
]

{ #category : 'accessing' }
IrisMCPServer >> dispatcher [

	^ dispatcher
]

{ #category : 'accessing' }
IrisMCPServer >> dispatcher: anMCPDispatcher [

	dispatcher := anMCPDispatcher
]

{ #category : 'responses' }
IrisMCPServer >> forbiddenResponse [

	^ (ZnResponse statusLine: ZnStatusLine forbidden)
		entity: (ZnEntity text: 'Origin not allowed');
		yourself
]

{ #category : 'request handling' }
IrisMCPServer >> handleRequest: aZnRequest [

	(self isAllowedOrigin: aZnRequest)
		ifFalse: [ ^ self forbiddenResponse ].
	aZnRequest method = #POST
		ifFalse: [ ^ ZnResponse methodNotAllowed: aZnRequest ].
	(aZnRequest uri path = 'mcp')
		ifFalse: [ ^ self notFoundResponse ].
	^ self processJsonRpc: aZnRequest
]

{ #category : 'initialization' }
IrisMCPServer >> initialize [

	super initialize.
	port := 9999.
	dispatcher := IrisMCPDispatcher new.
	dispatcher registerDefaultTools.
	logger := IrisMCPNoLogger new
]

{ #category : 'request handling' }
IrisMCPServer >> isAllowedOrigin: aZnRequest [
	"Guard against DNS rebinding, as required by the MCP Streamable HTTP transport.
	Requests without an Origin header come from non-browser clients and are allowed.
	Browser requests are only allowed from pages served by this machine."

	| origin host |
	origin := aZnRequest headers at: 'Origin' ifAbsent: [ ^ true ].
	host := [ origin asZnUrl host ]
		on: Error
		do: [ ^ false ].
	^ self localHostNames includes: host
]

{ #category : 'testing' }
IrisMCPServer >> isLogging [

	^ logger isLogging
]

{ #category : 'testing' }
IrisMCPServer >> isRunning [

	^ httpServer notNil and: [ httpServer isRunning ]
]

{ #category : 'request handling' }
IrisMCPServer >> localHostNames [

	^ #( 'localhost' '127.0.0.1' )
]

{ #category : 'logging' }
IrisMCPServer >> log [

	^ logger log
]

{ #category : 'responses' }
IrisMCPServer >> notFoundResponse [

	^ ZnResponse notFound: '/mcp'
]

{ #category : 'responses' }
IrisMCPServer >> okResponseWith: aString [

	^ ZnResponse ok: (ZnEntity
		with: aString
		type: ZnMimeType applicationJson)
]

{ #category : 'accessing' }
IrisMCPServer >> port [

	^ port
]

{ #category : 'accessing' }
IrisMCPServer >> port: anInteger [

	port := anInteger
]

{ #category : 'printing' }
IrisMCPServer >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' on ';
		print: self port.
	self isRunning
		ifTrue: [ aStream nextPutAll: ' (running)' ]
		ifFalse: [ aStream nextPutAll: ' (not running)' ]
]

{ #category : 'request handling' }
IrisMCPServer >> processJsonRpc: aZnRequest [

	| body rpcRequest rpcResponse json znResponse |
	rpcResponse := [
		body := aZnRequest entity ifNil: [ ^ self badRequestResponse: 'Empty body' ].
		json := NeoJSONReader fromString: body string.
		rpcRequest := IrisMCPJsonRpcRequest fromDictionary: json.
		dispatcher dispatch: rpcRequest.
	] on: Error do: [ :e |
		rpcResponse := IrisMCPJsonRpcResponse
			errorFor: nil
			code: -32700
			message: 'Parse error: ' , e messageText ].
	znResponse := self okResponseWith: rpcResponse asJson.
	logger logRequest: aZnRequest response: znResponse announceTo: self announcer.
	^ znResponse
]

{ #category : 'start/stop' }
IrisMCPServer >> start [

	self isRunning ifTrue: [ ^ self ].
	httpServer := (ZnServer on: port)
		bindingAddress: NetNameResolver loopBackAddress;
		yourself.
	httpServer onRequestRespond: [ :request | self handleRequest: request ].
	httpServer start.
	self announcer announce: (IrisMCPServerStarted on: self)
]

{ #category : 'logging' }
IrisMCPServer >> startLogging [

	self isLogging ifTrue: [ ^ self ].
	logger := IrisMCPLogger new.
	self announcer announce: (IrisMCPLoggingStarted on: self)
]

{ #category : 'start/stop' }
IrisMCPServer >> stop [

	self isRunning ifFalse: [ ^ self ].
	httpServer stop.
	self announcer announce: (IrisMCPServerStopped on: self)
]

{ #category : 'logging' }
IrisMCPServer >> stopLogging [

	self isLogging ifFalse: [ ^ self ].
	logger := IrisMCPNoLogger new.
	self announcer announce: (IrisMCPLoggingStopped on: self)
]

{ #category : 'request handling' }
IrisMCPServer >> value: aZnRequest [
	"Zinc delegate protocol - called for every incoming request."

	^ self handleRequest: aZnRequest
]
