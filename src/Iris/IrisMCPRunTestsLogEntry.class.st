Class {
	#name : 'IrisMCPRunTestsLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPRunTestsLogEntry class >> toolName [

	^ 'run_tests'
]

{ #category : 'printing' }
IrisMCPRunTestsLogEntry >> printArgumentOn: aStream [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	arguments at: 'package' ifPresent: [ :pkg | aStream space; nextPutAll: pkg ].
	arguments at: 'class_name' ifPresent: [ :cls | aStream space; nextPutAll: cls ].
	arguments at: 'selector' ifPresent: [ :sel | aStream space; nextPut: $#; nextPutAll: sel ]
]

{ #category : 'accessing' }
IrisMCPRunTestsLogEntry >> requestArgument [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	^ String streamContents: [ :result |
		arguments at: 'package' ifPresent: [ :pkg | result nextPutAll: pkg ].
		arguments at: 'class_name' ifPresent: [ :cls | result nextPutAll: cls ].
		arguments at: 'selector' ifPresent: [ :sel | result nextPutAll: ' >> #'; nextPutAll: sel ] ]
]
