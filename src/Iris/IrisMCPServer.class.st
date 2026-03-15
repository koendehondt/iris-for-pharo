Class {
	#name : 'IrisMCPServer',
	#superclass : 'Object',
	#instVars : [
		'port',
		'server',
		'dispatcher'
	],
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'instance creation' }
IrisMCPServer class >> onPort: anInteger [

	^ self new
		port: anInteger;
		yourself
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
		ifFalse: [ ^ self methodNotAllowedResponse ].
	(aZnRequest uri path = 'mcp')
		ifFalse: [ ^ self notFoundResponse ].
	^ self processJsonRpc: aZnRequest
]

{ #category : 'initialization' }
IrisMCPServer >> initialize [

	super initialize.
	port := 9999.
	dispatcher := IrisMCPDispatcher new.
	dispatcher registerDefaultTools
]

{ #category : 'responses' }
IrisMCPServer >> methodNotAllowedResponse [

	^ ZnResponse methodNotAllowed: #POST
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

	| body rpcRequest rpcResponse json |
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
	^ self okResponseWith: rpcResponse asJson
]

{ #category : 'start/stop' }
IrisMCPServer >> start [

	server := ZnServer on: port.
	server onRequestRespond: [ :request | self handleRequest: request ].
	server start
]

{ #category : 'start/stop' }
IrisMCPServer >> stop [

	server ifNotNil: [ server stop ]
]

{ #category : 'request handling' }
IrisMCPServer >> value: aZnRequest [

	"Zinc delegate protocol - called for every incoming request."
	^ self handleRequest: aZnRequest
]
