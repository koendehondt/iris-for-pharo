Class {
	#name : 'IrisMCPEvalLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPEvalLogEntry class >> toolName [

	^ 'eval'
]

{ #category : 'accessing' }
IrisMCPEvalLogEntry >> expression [

	| json expr |
	json := NeoJSONReader fromString: request entity string.
	expr := ((json at: 'params') at: 'arguments') at: 'expression'.
	^ String streamContents: [ :s |
		expr do: [ :ch |
			(ch = Character lf or: [ ch = Character cr or: [ ch = Character tab ] ])
				ifTrue: [ s nextPut: Character space ]
				ifFalse: [ s nextPut: ch ] ] ]
]

{ #category : 'printing' }
IrisMCPEvalLogEntry >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPutAll: self expression
]
