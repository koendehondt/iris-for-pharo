Class {
	#name : 'IrisMCPLogger',
	#superclass : 'Object',
	#instVars : [
		'log'
	],
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'initialization' }
IrisMCPLogger >> initialize [

	super initialize.
	log := OrderedCollection new
]

{ #category : 'testing' }
IrisMCPLogger >> isLogging [

	^ true
]

{ #category : 'accessing' }
IrisMCPLogger >> log [

	^ log
]

{ #category : 'logging' }
IrisMCPLogger >> logEntryFor: aRequest [

	| toolName entryClass |
	toolName := self toolNameFor: aRequest.
	entryClass := IrisMCPLogEntry allSubclasses
		detect: [ :cls | cls toolName = toolName ]
		ifNone: [ IrisMCPLogEntry ].
	^ entryClass new
		request: aRequest;
		yourself
]

{ #category : 'logging' }
IrisMCPLogger >> logRequest: aRequest response: aResponse announceTo: anAnnouncer [

	| entry |
	entry := self logEntryFor: aRequest.
	entry response: aResponse.
	log add: entry.
	anAnnouncer announce: IrisMCPRequestLogged new
]

{ #category : 'private' }
IrisMCPLogger >> toolNameFor: aRequest [

	| json params |
	json := NeoJSONReader fromString: aRequest entity string.
	params := json at: 'params' ifAbsent: [ nil ].
	^ (params isNil or: [ (params includesKey: 'name') not ])
		ifTrue: [ json at: 'method' ifAbsent: [ 'unknown' ] ]
		ifFalse: [ params at: 'name' ]
]
