Class {
	#name : 'IrisMCPGetClassToolTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPGetClassToolTest >> testMissingClassNameReturnsError [

	| result |
	result := self tool execute: Dictionary new.
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Missing required argument: class_name'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPGetClassToolTest >> testName [

	self assert: self tool name equals: 'get_class'
]

{ #category : 'tests' }
IrisMCPGetClassToolTest >> testReturnsClassDefinition [

	| result |
	result := self tool execute: (Dictionary with: 'class_name' -> 'IrisExampleClass').
	
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Class: IrisExampleClass
Superclass: Object
Instance variables: name
Class variables: 
Package: Iris-TestSupport

=== Instance Methods ===

accessing >> name
name

	^ name

accessing >> name:
name: aString

	name := aString

=== Class Methods ===

instance creation >> named:
named: aString

	^ self new name: aString
' })
]

{ #category : 'tests' }
IrisMCPGetClassToolTest >> testSchemaHasRequiredFields [

	self assert: self tool schema equals: (Dictionary
		with: 'name' -> 'get_class'
		with: 'description' -> 'Returns the definition and all method sources for a named Pharo class, including both instance-side and class-side methods.'
		with: 'inputSchema' -> (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'class_name' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the Pharo class to retrieve'))
			with: 'required' -> { 'class_name' }))
]

{ #category : 'tests' }
IrisMCPGetClassToolTest >> testUnknownClassReturnsError [

	| result |
	result := self tool execute: (Dictionary with: 'class_name' -> 'NoSuchClassXYZ').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Class not found: NoSuchClassXYZ'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'helpers' }
IrisMCPGetClassToolTest >> tool [

	^ IrisMCPGetClassTool new
]
