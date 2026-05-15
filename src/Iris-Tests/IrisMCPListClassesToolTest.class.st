Class {
	#name : 'IrisMCPListClassesToolTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testFiltersByPackage [

	| result |
	result := self tool execute: (Dictionary with: 'package' -> 'Iris').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'IrisMCPDispatcher (Iris)
IrisMCPEvalTool (Iris)
IrisMCPGetClassTool (Iris)
IrisMCPGetMethodTool (Iris)
IrisMCPJsonRpcRequest (Iris)
IrisMCPJsonRpcResponse (Iris)
IrisMCPListClassesTool (Iris)
IrisMCPRunTestsTool (Iris)
IrisMCPServer (Iris)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
IrisTestResult (Iris)
' })
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testFiltersByPrefix [

	| result |
	result := self tool execute: (Dictionary with: 'prefix' -> 'IrisMCPT').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'IrisMCPTestCase (Iris-Tests)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
IrisMCPToolRegistryTest (Iris-Tests)
' })
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testFiltersByPrefixAndPackage [

	| result |
	result := self tool execute: (Dictionary
		with: 'prefix' -> 'IrisMCP'
		with: 'package' -> 'Iris').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'IrisMCPDispatcher (Iris)
IrisMCPEvalTool (Iris)
IrisMCPGetClassTool (Iris)
IrisMCPGetMethodTool (Iris)
IrisMCPJsonRpcRequest (Iris)
IrisMCPJsonRpcResponse (Iris)
IrisMCPListClassesTool (Iris)
IrisMCPRunTestsTool (Iris)
IrisMCPServer (Iris)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
' })
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testListsClassesWithoutFilter [

	| result text actualclassNames |
	result := self tool execute: Dictionary new.
	text := (result at: 'content') first at: 'text'.
	actualclassNames := text trim splitOn: (String with: Character cr).
	"The collection of classes is very large. just verify the size."
	self assert: actualclassNames size equals: Smalltalk globals allClasses size
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testName [

	self assert: self tool name equals: 'list_classes'
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testSchemaHasEmptyRequired [

	self assert: self tool schema equals: (Dictionary
		with: 'name' -> 'list_classes'
		with: 'description' -> 'Lists all classes in the Pharo image, optionally filtered by name prefix and/or package name.'
		with: 'inputSchema' -> (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'prefix' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'Only return classes whose name starts with this prefix (case-sensitive)')
				with: 'package' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'Only return classes belonging to this package name'))
			with: 'required' -> {}))
]

{ #category : 'helpers' }
IrisMCPListClassesToolTest >> tool [

	^ IrisMCPListClassesTool new
]
