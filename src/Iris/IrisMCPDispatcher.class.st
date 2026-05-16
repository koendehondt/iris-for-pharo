Class {
	#name : 'IrisMCPDispatcher',
	#superclass : 'Object',
	#instVars : [
		'registry'
	],
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'dispatching' }
IrisMCPDispatcher >> dispatch: anMCPJsonRpcRequest [

	| method |
	method := anMCPJsonRpcRequest method.
	method = 'initialize' ifTrue: [ ^ self handleInitialize: anMCPJsonRpcRequest ].
	method = 'tools/list' ifTrue: [ ^ self handleToolsList: anMCPJsonRpcRequest ].
	method = 'tools/call' ifTrue: [ ^ self handleToolsCall: anMCPJsonRpcRequest ].
	^ IrisMCPJsonRpcResponse
		errorFor: anMCPJsonRpcRequest id
		code: -32601
		message: 'Method not found: ' , method printString
]

{ #category : 'dispatching' }
IrisMCPDispatcher >> handleInitialize: aRequest [

	| result clientVersion |
	clientVersion := aRequest params at: 'protocolVersion' ifAbsent: [ '2025-03-26' ].
	result := Dictionary
		with: 'protocolVersion' -> clientVersion
		with: 'serverInfo' -> (Dictionary
			with: 'name' -> 'pharo-mcp-server'
			with: 'version' -> '0.1.0')
		with: 'capabilities' -> (Dictionary
			with: 'tools' -> (Dictionary with: 'listChanged' -> false)).
	^ IrisMCPJsonRpcResponse resultFor: aRequest id value: result
]

{ #category : 'dispatching' }
IrisMCPDispatcher >> handleToolsCall: aRequest [

	| params toolName args tool callResult |
	params := aRequest params.
	toolName := params at: 'name' ifAbsent: [ nil ].
	toolName ifNil: [
		^ IrisMCPJsonRpcResponse
			errorFor: aRequest id
			code: -32602
			message: 'Missing tool name' ].
	tool := registry toolNamed: toolName.
	tool ifNil: [
		^ IrisMCPJsonRpcResponse
			errorFor: aRequest id
			code: -32602
			message: 'Unknown tool: ' , toolName ].
	args := params at: 'arguments' ifAbsent: [ Dictionary new ].
	callResult := tool execute: args.
	^ IrisMCPJsonRpcResponse resultFor: aRequest id value: callResult
]

{ #category : 'dispatching' }
IrisMCPDispatcher >> handleToolsList: aRequest [

	| tools result |
	tools := registry allTools collect: [ :tool | tool schema ].
	result := Dictionary with: 'tools' -> tools.
	^ IrisMCPJsonRpcResponse resultFor: aRequest id value: result
]

{ #category : 'initialization' }
IrisMCPDispatcher >> initialize [

	super initialize.
	registry := IrisMCPToolRegistry new
]

{ #category : 'registration' }
IrisMCPDispatcher >> register: anMCPTool [

	registry register: anMCPTool
]

{ #category : 'initialization' }
IrisMCPDispatcher >> registerDefaultTools [

	self register: IrisMCPGetClassTool new.
	self register: IrisMCPListClassesTool new.
	self register: IrisMCPGetMethodTool new.
	self register: IrisMCPEvalTool new.
	self register: IrisMCPRunTestsTool new
]
