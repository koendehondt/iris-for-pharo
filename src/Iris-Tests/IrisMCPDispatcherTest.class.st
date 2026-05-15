Class {
	#name : 'IrisMCPDispatcherTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'helpers' }
IrisMCPDispatcherTest >> dispatcher [

	^ IrisMCPDispatcher new registerDefaultTools; yourself
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchInitialize [

	| req resp result |
	req := self makeRequest: 'initialize' params: (Dictionary new
		at: 'protocolVersion' put: '2025-03-26';
		yourself).
	resp := self dispatcher dispatch: req.
	result := resp result.
	self assert: (result at: 'protocolVersion') equals: '2025-03-26'.
	self assert: ((result at: 'serverInfo') at: 'name') equals: 'pharo-mcp-server'.
	self assert: (result includesKey: 'capabilities')
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchToolsCall [

	| req resp content |
	req := self makeRequest: 'tools/call' params: (Dictionary new
		at: 'name' put: 'eval';
		at: 'arguments' put: (Dictionary new
			at: 'expression' put: '3 + 4';
			yourself);
		yourself).
	resp := self dispatcher dispatch: req.
	self assert: resp error isNil.
	content := (resp result at: 'content') first.
	self assert: (content at: 'text') equals: '7'
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchToolsCallMissingToolName [

	| req resp |
	req := self makeRequest: 'tools/call' params: Dictionary new.
	resp := self dispatcher dispatch: req.
	self assert: resp error isNil not.
	self assert: (resp error at: 'code') equals: -32602
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchToolsCallUnknownTool [

	| req resp |
	req := self makeRequest: 'tools/call' params: (Dictionary new
		at: 'name' put: 'no_such_tool';
		at: 'arguments' put: Dictionary new;
		yourself).
	resp := self dispatcher dispatch: req.
	self assert: resp error isNil not.
	self assert: (resp error at: 'code') equals: -32602
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchToolsList [

	| req resp toolNames |
	req := self makeRequest: 'tools/list' params: Dictionary new.
	resp := self dispatcher dispatch: req.
	toolNames := ((resp result at: 'tools') collect: [ :each | each at: 'name']) sorted.
	self assert: toolNames equals: {
		'eval' .
		'get_class' .
		'get_method' .
		'list_classes' .
		'run_tests'}
]

{ #category : 'tests' }
IrisMCPDispatcherTest >> testDispatchUnknownMethod [

	| req resp |
	req := self makeRequest: 'unknown/method' params: Dictionary new.
	resp := self dispatcher dispatch: req.
	self assert: resp result isNil.
	self assert: resp error isNil not.
	self assert: (resp error at: 'code') equals: -32601
]
