Class {
	#name : 'IrisMCPNoLogger',
	#superclass : 'Object',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'testing' }
IrisMCPNoLogger >> isLogging [

	^ false
]

{ #category : 'accessing' }
IrisMCPNoLogger >> log [

	^ OrderedCollection new
]

{ #category : 'logging' }
IrisMCPNoLogger >> logRequest: aRequest response: aResponse announceTo: anAnnouncer [

	"Do nothing."
]
