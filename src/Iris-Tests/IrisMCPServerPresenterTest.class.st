Class {
	#name : 'IrisMCPServerPresenterTest',
	#superclass : 'IrisMCPTestCase',
	#instVars : [
		'presenter'
	],
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'running' }
IrisMCPServerPresenterTest >> tearDown [

	presenter ifNotNil: [ presenter window close ].
	super tearDown.
]

{ #category : 'tests' }
IrisMCPServerPresenterTest >> testAboutTitle [

	self assert: IrisMCPServerPresenter new aboutTitle equals: 'Iris MCP Server'
]

{ #category : 'tests' }
IrisMCPServerPresenterTest >> testStartingAndStopping [

	self restoreCurrentServerAfter: [ | mcpServer |
		mcpServer := IrisMCPServer onPort: 6666.
		IrisMCPServer current: mcpServer.
		presenter := IrisMCPServerPresenter on: mcpServer.
		presenter open.
		self assert: presenter window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter serverButtonLabel equals: 'Start server'.
		self assert: presenter loggingButtonLabel equals: 'Start logging'.
		presenter startServer.
		self assert: presenter window title equals: 'Iris MCP Server (running on port 6666)'.
		self assert: presenter serverButtonLabel equals: 'Stop server'.
		self assert: presenter loggingButtonLabel equals: 'Start logging'.
		presenter stopServer.
		self assert: presenter window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter serverButtonLabel equals: 'Start server'.
		self assert: presenter loggingButtonLabel equals: 'Start logging'.
		presenter startLogging.
		self assert: presenter window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter serverButtonLabel equals: 'Start server'.
		self assert: presenter loggingButtonLabel equals: 'Stop logging'.
		presenter stopLogging.
		self assert: presenter window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter serverButtonLabel equals: 'Start server'.
		self assert: presenter loggingButtonLabel equals: 'Start logging' ]
]
