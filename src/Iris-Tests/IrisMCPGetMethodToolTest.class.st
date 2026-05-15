Class {
	#name : 'IrisMCPGetMethodToolTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testMissingArgumentsReturnError [

	| result |
	result := self tool execute: Dictionary new.
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Missing required argument: class_name'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testName [

	self assert: self tool name equals: 'get_method'
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testReturnsClassSideMethodSource [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'IrisExampleClass'
		with: 'selector' -> 'named:'
		with: 'class_side' -> true).
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Class: IrisExampleClass
Selector: named:
Protocol: instance creation
Side: class

named: aString

	^ self new name: aString' })
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testReturnsInstanceMethodSource [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'IrisExampleClass'
		with: 'selector' -> 'name:').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Class: IrisExampleClass
Selector: name:
Protocol: accessing
Side: instance

name: aString

	name := aString' })
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testSchemaHasRequiredFields [

	self assert: self tool schema equals: (Dictionary
		with: 'name' -> 'get_method'
		with: 'description' -> 'Returns the source of a single method. Provide class_name and selector. Optionally set class_side to true for class-side methods.'
		with: 'inputSchema' -> (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'class_name' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the Pharo class')
				with: 'selector' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The method selector')
				with: 'class_side' -> (Dictionary
					with: 'type' -> 'boolean'
					with: 'description' -> 'If true, look up the method on the class side. Defaults to false.'))
			with: 'required' -> { 'class_name' . 'selector' }))
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testUnknownClassReturnsError [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'NoSuchClassXYZ'
		with: 'selector' -> 'name').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Class not found: NoSuchClassXYZ'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPGetMethodToolTest >> testUnknownMethodReturnsError [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'IrisMCPEvalTool'
		with: 'selector' -> 'noSuchMethod').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Method not found: IrisMCPEvalTool >> noSuchMethod'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'helpers' }
IrisMCPGetMethodToolTest >> tool [

	^ IrisMCPGetMethodTool new
]
