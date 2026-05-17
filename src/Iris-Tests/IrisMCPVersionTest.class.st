Class {
	#name : 'IrisMCPVersionTest',
	#superclass : 'TestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPVersionTest >> testPrintString [

	self assert: IrisMCP version printString equals: 'Iris MCP 0.1.0'
]
