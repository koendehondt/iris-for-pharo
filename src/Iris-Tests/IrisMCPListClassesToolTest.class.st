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
			with: 'text' -> 'IrisMCP (Iris)
IrisMCPCancelledNotificationLogEntry (Iris)
IrisMCPDispatcher (Iris)
IrisMCPEvalLogEntry (Iris)
IrisMCPEvalTool (Iris)
IrisMCPGetClassLogEntry (Iris)
IrisMCPGetClassTool (Iris)
IrisMCPGetMethodLogEntry (Iris)
IrisMCPGetMethodTool (Iris)
IrisMCPInitializeLogEntry (Iris)
IrisMCPInitializedNotificationLogEntry (Iris)
IrisMCPJsonRpcRequest (Iris)
IrisMCPJsonRpcResponse (Iris)
IrisMCPListClassesLogEntry (Iris)
IrisMCPListClassesTool (Iris)
IrisMCPLogEntry (Iris)
IrisMCPLogEntryPresenter (Iris)
IrisMCPLogger (Iris)
IrisMCPLoggingStarted (Iris)
IrisMCPLoggingStopped (Iris)
IrisMCPMenus (Iris)
IrisMCPNoLogger (Iris)
IrisMCPNotificationLogEntry (Iris)
IrisMCPRequestLogged (Iris)
IrisMCPRunTestsLogEntry (Iris)
IrisMCPRunTestsTool (Iris)
IrisMCPServer (Iris)
IrisMCPServerPresenter (Iris)
IrisMCPServerStarted (Iris)
IrisMCPServerStopped (Iris)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
IrisMCPToolsListLogEntry (Iris)
IrisMCPVersion (Iris)
IrisTestResult (Iris)
'
			with: 'type' -> 'text' })
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testFiltersByPrefix [

	| result |
	result := self tool execute: (Dictionary with: 'prefix' -> 'IrisMCP').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'IrisMCP (Iris)
IrisMCPCancelledNotificationLogEntry (Iris)
IrisMCPDispatcher (Iris)
IrisMCPDispatcherTest (Iris-Tests)
IrisMCPEvalLogEntry (Iris)
IrisMCPEvalTool (Iris)
IrisMCPEvalToolTest (Iris-Tests)
IrisMCPGetClassLogEntry (Iris)
IrisMCPGetClassTool (Iris)
IrisMCPGetClassToolTest (Iris-Tests)
IrisMCPGetMethodLogEntry (Iris)
IrisMCPGetMethodTool (Iris)
IrisMCPGetMethodToolTest (Iris-Tests)
IrisMCPInitializeLogEntry (Iris)
IrisMCPInitializedNotificationLogEntry (Iris)
IrisMCPJsonRpcRequest (Iris)
IrisMCPJsonRpcRequestTest (Iris-Tests)
IrisMCPJsonRpcResponse (Iris)
IrisMCPJsonRpcResponseTest (Iris-Tests)
IrisMCPListClassesLogEntry (Iris)
IrisMCPListClassesTool (Iris)
IrisMCPListClassesToolTest (Iris-Tests)
IrisMCPLogEntry (Iris)
IrisMCPLogEntryPresenter (Iris)
IrisMCPLogEntryTest (Iris-Tests)
IrisMCPLogger (Iris)
IrisMCPLoggingStarted (Iris)
IrisMCPLoggingStopped (Iris)
IrisMCPMenus (Iris)
IrisMCPNoLogger (Iris)
IrisMCPNotificationLogEntry (Iris)
IrisMCPRequestLogged (Iris)
IrisMCPRunTestsLogEntry (Iris)
IrisMCPRunTestsTool (Iris)
IrisMCPRunTestsToolTest (Iris-Tests)
IrisMCPServer (Iris)
IrisMCPServerPresenter (Iris)
IrisMCPServerPresenterTest (Iris-Tests)
IrisMCPServerStarted (Iris)
IrisMCPServerStopped (Iris)
IrisMCPServerTest (Iris-Tests)
IrisMCPTest (Iris-Tests)
IrisMCPTestCase (Iris-Tests)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
IrisMCPToolRegistryTest (Iris-Tests)
IrisMCPToolsListLogEntry (Iris)
IrisMCPVersion (Iris)
IrisMCPVersionTest (Iris-Tests)
'
			with: 'type' -> 'text' })
]

{ #category : 'tests' }
IrisMCPListClassesToolTest >> testFiltersByPrefixAndPackage [

	| result |
	result := self tool execute: (Dictionary with: 'prefix' -> 'IrisMCP' with: 'package' -> 'Iris').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'IrisMCP (Iris)
IrisMCPCancelledNotificationLogEntry (Iris)
IrisMCPDispatcher (Iris)
IrisMCPEvalLogEntry (Iris)
IrisMCPEvalTool (Iris)
IrisMCPGetClassLogEntry (Iris)
IrisMCPGetClassTool (Iris)
IrisMCPGetMethodLogEntry (Iris)
IrisMCPGetMethodTool (Iris)
IrisMCPInitializeLogEntry (Iris)
IrisMCPInitializedNotificationLogEntry (Iris)
IrisMCPJsonRpcRequest (Iris)
IrisMCPJsonRpcResponse (Iris)
IrisMCPListClassesLogEntry (Iris)
IrisMCPListClassesTool (Iris)
IrisMCPLogEntry (Iris)
IrisMCPLogEntryPresenter (Iris)
IrisMCPLogger (Iris)
IrisMCPLoggingStarted (Iris)
IrisMCPLoggingStopped (Iris)
IrisMCPMenus (Iris)
IrisMCPNoLogger (Iris)
IrisMCPNotificationLogEntry (Iris)
IrisMCPRequestLogged (Iris)
IrisMCPRunTestsLogEntry (Iris)
IrisMCPRunTestsTool (Iris)
IrisMCPServer (Iris)
IrisMCPServerPresenter (Iris)
IrisMCPServerStarted (Iris)
IrisMCPServerStopped (Iris)
IrisMCPTool (Iris)
IrisMCPToolRegistry (Iris)
IrisMCPToolsListLogEntry (Iris)
IrisMCPVersion (Iris)
'
			with: 'type' -> 'text' })
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
