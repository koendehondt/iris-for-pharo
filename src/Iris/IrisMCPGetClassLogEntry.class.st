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
IrisMCPGetClassLogEntry >> printArgumentOn: aStream [

	| json className |
	json := NeoJSONReader fromString: request entity string.
	className := ((json at: 'params') at: 'arguments') at: 'class_name'.
	aStream space; nextPutAll: className
]

{ #category : 'accessing' }
IrisMCPGetClassLogEntry >> requestArgument [

	| json |
	json := NeoJSONReader fromString: request entity string.
	^ ((json at: 'params') at: 'arguments') at: 'class_name'
]
