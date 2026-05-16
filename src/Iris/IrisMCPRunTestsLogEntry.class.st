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
IrisMCPRunTestsLogEntry >> printOn: aStream [

	| json arguments |
	json := NeoJSONReader fromString: request entity string.
	arguments := (json at: 'params') at: 'arguments'.
	super printOn: aStream.
	(arguments at: 'package' ifAbsent: [ nil ]) ifNotNil: [ :pkg |
		aStream space; nextPutAll: pkg ].
	(arguments at: 'class_name' ifAbsent: [ nil ]) ifNotNil: [ :cls |
		aStream space; nextPutAll: cls ].
	(arguments at: 'selector' ifAbsent: [ nil ]) ifNotNil: [ :sel |
		aStream space; nextPut: $#; nextPutAll: sel ]
]
