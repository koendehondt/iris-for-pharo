Class {
	#name : 'IrisMCPVersion',
	#superclass : 'Object',
	#instVars : [
		'major',
		'minor',
		'patch'
	],
	#category : 'Iris-Core',
	#package : 'Iris',
	#tag : 'Core'
}

{ #category : 'instance creation' }
IrisMCPVersion class >> major: majorNumber minor: minorNumber patch: patchNumber [

	^ self new
		major: majorNumber;
		minor: minorNumber;
		patch: patchNumber
]

{ #category : 'comparing' }
IrisMCPVersion >> = other [

	^ self major = other major and: [ self minor = other minor and: [ self patch = other patch ] ]
]

{ #category : 'accessing' }
IrisMCPVersion >> major [

	^ major
]

{ #category : 'accessing' }
IrisMCPVersion >> major: anInteger [

	major := anInteger
]

{ #category : 'accessing' }
IrisMCPVersion >> minor [

	^ minor
]

{ #category : 'accessing' }
IrisMCPVersion >> minor: anInteger [

	minor := anInteger
]

{ #category : 'accessing' }
IrisMCPVersion >> patch [

	^ patch
]

{ #category : 'accessing' }
IrisMCPVersion >> patch: anInteger [

	patch := anInteger
]

{ #category : 'printing' }
IrisMCPVersion >> printOn: aStream [

	aStream
		nextPutAll: 'Iris MCP';
		space;
		print: self major;
		nextPut: $.;
		print: self minor;
		nextPut: $.;
		print: self patch
]
