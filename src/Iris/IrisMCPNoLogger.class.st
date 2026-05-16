Class {
	#name : 'IrisMCPNoLogger',
	#superclass : 'Object',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPNoLogger >> log [

	^ OrderedCollection new
]

{ #category : 'logging' }
IrisMCPNoLogger >> logRequest: aRequest response: aResponse [

	"Do nothing."
]
