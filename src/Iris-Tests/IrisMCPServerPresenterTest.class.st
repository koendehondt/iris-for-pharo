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
IrisMCPServerPresenterTest >> testOpeningMultipleWindowsOnTheSameServer [

	| server presenter1 presenter2 |
	server := IrisMCPServer onPort: 3789.
	presenter1 := IrisMCPServerPresenter on: server.
	presenter2 := IrisMCPServerPresenter on: server.
	[
		presenter1 open.
		presenter2 open.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server start.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server startLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server stop.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server stopLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging']
		ensure: [
			server stop.
			presenter1 withWindowDo: [ :window | window close ].
			presenter2 withWindowDo: [ :window | window close ] ]
]

{ #category : 'tests' }
IrisMCPServerPresenterTest >> testOpeningWindowsOnMultipleServers [

	| presenter1 presenter2 server1 server2 |
	server1 := IrisMCPServer onPort: 3789.
	server2 := IrisMCPServer onPort: 4231.
	presenter1 := IrisMCPServerPresenter on: server1.
	presenter2 := IrisMCPServerPresenter on: server2.
	[
		presenter1 open.
		presenter2 open.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server1 start.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server1 start.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server2 start.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 4231)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server1 startLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 4231)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.
		server2 startLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (running on port 3789)'.
		self assert: presenter1 serverButtonLabel equals: 'Stop server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 4231)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server1 stop.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (running on port 4231)'.
		self assert: presenter2 serverButtonLabel equals: 'Stop server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server2 stop.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Stop logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server1 stopLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Stop logging'.
		server2 stopLogging.
		self assert: presenter1 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter1 serverButtonLabel equals: 'Start server'.
		self assert: presenter1 loggingButtonLabel equals: 'Start logging'.
		self assert: presenter2 window title equals: 'Iris MCP Server (not running)'.
		self assert: presenter2 serverButtonLabel equals: 'Start server'.
		self assert: presenter2 loggingButtonLabel equals: 'Start logging'.]
		ensure: [
			server1 stop.
			server2 stop.
			presenter1 withWindowDo: [ :window | window close ].
			presenter2 withWindowDo: [ :window | window close ] ]
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
