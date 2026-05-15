Class {
	#name : 'IrisMCPToolRegistryTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPToolRegistryTest >> testAllToolsReturnsRegistered [

	| registry |
	registry := IrisMCPToolRegistry new.
	self assert: registry allTools size equals: 0.
	registry register: IrisMCPEvalTool new.
	registry register: IrisMCPGetClassTool new.
	self assert: registry allTools size equals: 2
]

{ #category : 'tests' }
IrisMCPToolRegistryTest >> testRegisterAndRetrieve [

	| registry tool |
	registry := IrisMCPToolRegistry new.
	tool := IrisMCPEvalTool new.
	registry register: tool.
	self assert: (registry toolNamed: 'eval') equals: tool
]

{ #category : 'tests' }
IrisMCPToolRegistryTest >> testUnknownToolReturnsNil [

	| registry |
	registry := IrisMCPToolRegistry new.
	self assert: (registry toolNamed: 'nonexistent') isNil
]
