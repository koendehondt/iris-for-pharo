Class {
	#name : 'IrisMCPServer',
	#superclass : 'Object',
	#instVars : [
		'port',
		'server',
		'dispatcher',
		'logger',
		'announcer'
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
IrisMCPServer >> dispatcher [

	^ dispatcher
]

{ #category : 'accessing' }
IrisMCPServer >> dispatcher: anMCPDispatcher [

	dispatcher := anMCPDispatcher
]

{ #category : 'request handling' }
IrisMCPServer >> handleRequest: aZnRequest [

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

{ #category : 'testing' }
IrisMCPServer >> isLogging [

	^ logger isLogging
]

{ #category : 'testing' }
IrisMCPServer >> isRunning [

	^ server notNil and: [ server isRunning ]
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

	| response |
	response := ZnResponse ok: (ZnEntity
		with: aString
		type: ZnMimeType applicationJson).
	response headers
		at: 'Access-Control-Allow-Origin' put: '*'.
	^ response
]

{ #category : 'accessing' }
IrisMCPServer >> port [

	^ port
]

{ #category : 'accessing' }
IrisMCPServer >> port: anInteger [

	port := anInteger
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
	server := ZnServer on: port.
	server onRequestRespond: [ :request | self handleRequest: request ].
	server start.
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
	server stop.
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
