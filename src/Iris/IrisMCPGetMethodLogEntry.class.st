Class {
	#name : 'IrisMCPGetMethodLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPGetMethodLogEntry class >> toolName [

	^ 'get_method'
]

{ #category : 'printing' }
IrisMCPGetMethodLogEntry >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $#;
		nextPutAll: self selector
]

{ #category : 'accessing' }
IrisMCPGetMethodLogEntry >> selector [

	| json |
	json := NeoJSONReader fromString: request entity string.
	^ ((json at: 'params') at: 'arguments') at: 'selector' ifAbsent: [ '?' ]
]
