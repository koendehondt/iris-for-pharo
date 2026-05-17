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
IrisMCPGetMethodLogEntry >> printArgumentOn: aStream [

	aStream
		space;
		nextPut: $#;
		nextPutAll: self selector
]

{ #category : 'accessing' }
IrisMCPGetMethodLogEntry >> requestArgument [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	^ (arguments at: 'class_name') , ' >> #' , (arguments at: 'selector' ifAbsent: [ '?' ])
]

{ #category : 'accessing' }
IrisMCPGetMethodLogEntry >> selector [

	| json |
	json := NeoJSONReader fromString: request entity string.
	^ ((json at: 'params') at: 'arguments') at: 'selector' ifAbsent: [ '?' ]
]
