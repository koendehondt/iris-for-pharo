Class {
	#name : 'IrisMCPGetClassLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPGetClassLogEntry class >> toolName [

	^ 'get_class'
]

{ #category : 'printing' }
IrisMCPGetClassLogEntry >> printOn: aStream [

	| json className |
	json := NeoJSONReader fromString: request entity string.
	className := ((json at: 'params') at: 'arguments') at: 'class_name'.
	super printOn: aStream.
	aStream
		space;
		nextPutAll: className
]
