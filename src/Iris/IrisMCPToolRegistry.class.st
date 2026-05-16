Class {
	#name : 'IrisMCPToolRegistry',
	#superclass : 'Object',
	#instVars : [
		'tools'
	],
	#category : 'Iris-Server',
	#package : 'Iris',
	#tag : 'Server'
}

{ #category : 'accessing' }
IrisMCPToolRegistry >> allTools [

	^ tools values
]

{ #category : 'initialization' }
IrisMCPToolRegistry >> initialize [

	super initialize.
	tools := Dictionary new
]

{ #category : 'registration' }
IrisMCPToolRegistry >> register: anMCPTool [

	tools at: anMCPTool name put: anMCPTool
]

{ #category : 'accessing' }
IrisMCPToolRegistry >> toolNamed: aString [

	^ tools at: aString ifAbsent: [ nil ]
]
