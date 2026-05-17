Class {
	#name : 'IrisMCPVersionTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPVersionTest >> testEquals [

	self assert: (IrisMCPVersion major: 1 minor: 2 patch: 3) equals: (IrisMCPVersion major: 1 minor: 2 patch: 3)
]

{ #category : 'tests' }
IrisMCPVersionTest >> testPrintString [

	self assert: IrisMCP version printString equals: 'Iris MCP 0.1.0'
]
