Class {
	#name : 'IrisMCPLogEntry',
	#superclass : 'Object',
	#instVars : [
		'request',
		'response'
	],
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPLogEntry class >> toolName [

	^ 'unknown'
]

{ #category : 'accessing' }
IrisMCPLogEntry >> displayToolName [

	^ self toolName
]

{ #category : 'printing' }
IrisMCPLogEntry >> printArgumentOn: aStream [

	"Do nothing."
]

{ #category : 'printing' }
IrisMCPLogEntry >> printOn: aStream [

	aStream nextPutAll: self toolName.
	self printArgumentOn: aStream
]

{ #category : 'accessing' }
IrisMCPLogEntry >> request [

	^ request
]

{ #category : 'accessing' }
IrisMCPLogEntry >> request: aRequest [

	request := aRequest
]

{ #category : 'accessing' }
IrisMCPLogEntry >> requestArgument [

	^ String new
]

{ #category : 'accessing' }
IrisMCPLogEntry >> requestJson [

	^ NeoJSONWriter toStringPretty: (NeoJSONReader fromString: request entity string)
]

{ #category : 'accessing' }
IrisMCPLogEntry >> response [

	^ response
]

{ #category : 'accessing' }
IrisMCPLogEntry >> response: aResponse [

	response := aResponse
]

{ #category : 'accessing' }
IrisMCPLogEntry >> responseJson [

	^ response ifNil: [ '' ] ifNotNil: [ 
		NeoJSONWriter toStringPretty: (NeoJSONReader fromString: response entity string) ]
]

{ #category : 'accessing' }
IrisMCPLogEntry >> responseText [

	| json result content |
	response ifNil: [ ^ String new ].
	json := NeoJSONReader fromString: response entity string.
	result := json at: 'result' ifAbsent: [ ^ String new ].
	content := result at: 'content' ifAbsent: [ ^ String new ].
	content isEmpty ifTrue: [ ^ String new ].
	^ content first at: 'text' ifAbsent: [ String new ]
]

{ #category : 'accessing' }
IrisMCPLogEntry >> toolName [

	^ self class toolName
]
