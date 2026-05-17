Class {
	#name : 'IrisMCPListClassesLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPListClassesLogEntry class >> toolName [

	^ 'list_classes'
]

{ #category : 'printing' }
IrisMCPListClassesLogEntry >> printArgumentOn: aStream [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	arguments at: 'prefix' ifPresent: [ :prefix | aStream space; nextPutAll: prefix ].
	arguments at: 'package' ifPresent: [ :pkg | aStream space; nextPutAll: pkg ]
]

{ #category : 'accessing' }
IrisMCPListClassesLogEntry >> requestArgument [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	^ String streamContents: [ :stream |
		arguments at: 'prefix' ifPresent: [ :prefix | stream nextPutAll: prefix ].
		arguments at: 'package' ifPresent: [ :pkg | stream space; nextPutAll: pkg ] ]
]
