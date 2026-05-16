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

{ #category : 'printing' }
IrisMCPLogEntry >> printOn: aStream [

	aStream nextPutAll: self toolName
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
IrisMCPLogEntry >> response [

	^ response
]

{ #category : 'accessing' }
IrisMCPLogEntry >> response: aResponse [

	response := aResponse
]

{ #category : 'accessing' }
IrisMCPLogEntry >> toolName [

	^ self class toolName
]
