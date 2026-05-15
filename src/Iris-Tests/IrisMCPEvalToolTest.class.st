Class {
	#name : 'IrisMCPEvalToolTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPEvalToolTest >> testEvaluatesExpression [

	| result |
	result := self tool execute: (Dictionary new
		at: 'expression' put: '6 * 7';
		yourself).
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> '42' })
]

{ #category : 'tests' }
IrisMCPEvalToolTest >> testMissingExpressionReturnsError [

	| result |
	result := self tool execute: Dictionary new.
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Missing required argument: expression'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPEvalToolTest >> testName [

	self assert: self tool name equals: 'eval'
]

{ #category : 'tests' }
IrisMCPEvalToolTest >> testReturnsErrorOnInvalidExpression [

	| result |
	result := self tool execute: (Dictionary with: 'expression' -> 'thisIsNotValid ++++').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Variable or expression expected'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPEvalToolTest >> testSchemaHasRequiredFields [

	self assert: self tool schema equals: (Dictionary
		with: 'name' -> 'eval'
		with: 'description' -> 'Evaluates a Smalltalk expression in the Pharo image and returns the printString of the result.'
		with: 'inputSchema' -> (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'expression' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The Smalltalk expression to evaluate'))
			with: 'required' -> { 'expression' }))
]

{ #category : 'helpers' }
IrisMCPEvalToolTest >> tool [

	^ IrisMCPEvalTool new
]
