Class {
	#name : 'IrisMCPLogEntryTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'helpers' }
IrisMCPLogEntryTest >> requestFor: aBody [

	| entity req |
	entity := ZnEntity with: aBody type: ZnMimeType applicationJson.
	req := ZnRequest post: 'http://localhost:9999/mcp'.
	req entity: entity.
	^ req
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testCancelledNotificationLogEntryPrintString [

	| body request entry |
	body := NeoJSONWriter toString: (Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'notifications/cancelled';
		at: 'params' put: (Dictionary with: 'requestId' -> 1 with: 'reason' -> 'timeout');
		yourself).
	request := self requestFor: body.
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPCancelledNotificationLogEntry).
	self assert: entry printString equals: 'notifications/cancelled'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testCancelledNotificationRequestArgument [

	| body request entry |
	body := NeoJSONWriter toString: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'method' -> 'notifications/cancelled'
		with: 'params' -> (Dictionary with: 'requestId' -> 1 with: 'reason' -> 'timeout')).
	request := self requestFor: body.
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: 'timeout'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testDisplayToolName [

	self assert: IrisMCPLogEntry new displayToolName equals: 'unknown'.
	self assert: IrisMCPCancelledNotificationLogEntry new displayToolName equals: 'cancelled'.
	self assert: IrisMCPEvalLogEntry new displayToolName equals: 'eval'.
	self assert: IrisMCPGetClassLogEntry new displayToolName equals: 'get_class'.
	self assert: IrisMCPGetMethodLogEntry new displayToolName equals: 'get_method'.
	self assert: IrisMCPRunTestsLogEntry new displayToolName equals: 'run_tests'.
	self assert: IrisMCPListClassesLogEntry new displayToolName equals: 'list_classes'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testEvalLogEntryPrintString [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'eval' arguments: (Dictionary with: 'expression' -> '1 + 1')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPEvalLogEntry).
	self assert: entry printString equals: 'eval 1 + 1'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testEvalLogEntryStripsNewlines [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'eval' arguments: (Dictionary with: 'expression' -> ('1 +' , (String with: Character lf) , '1'))).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry printString equals: 'eval 1 + 1'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testEvalRequestArgument [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'eval' arguments: (Dictionary with: 'expression' -> '1 + 1')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: '1 + 1'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testGetClassLogEntryPrintString [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'get_class' arguments: (Dictionary with: 'class_name' -> 'Point')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPGetClassLogEntry).
	self assert: entry printString equals: 'get_class Point'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testGetClassRequestArgument [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'get_class' arguments: (Dictionary with: 'class_name' -> 'Point')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: 'Point'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testGetMethodLogEntryPrintString [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'get_method' arguments: (Dictionary
		with: 'class_name' -> 'Point'
		with: 'selector' -> 'x')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPGetMethodLogEntry).
	self assert: entry printString equals: 'get_method #x'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testGetMethodRequestArgument [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'get_method' arguments: (Dictionary
		with: 'class_name' -> 'Point'
		with: 'selector' -> 'x')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: 'Point >> #x'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testListClassesLogEntryPrintString [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'list_classes' arguments: (Dictionary
		with: 'prefix' -> 'IrisMCP'
		with: 'package' -> 'Iris')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPListClassesLogEntry).
	self assert: entry printString equals: 'list_classes IrisMCP Iris'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testListClassesRequestArgument [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'list_classes' arguments: (Dictionary
		with: 'prefix' -> 'IrisMCP'
		with: 'package' -> 'Iris')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: 'IrisMCP Iris'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testRunTestsLogEntryWithClassAndSelector [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'run_tests' arguments: (Dictionary
		with: 'class_name' -> 'IrisMCPServerTest'
		with: 'selector' -> 'testDefaultPort')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry printString equals: 'run_tests IrisMCPServerTest #testDefaultPort'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testRunTestsLogEntryWithPackage [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'run_tests' arguments: (Dictionary with: 'package' -> 'Iris-Tests')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPRunTestsLogEntry).
	self assert: entry printString equals: 'run_tests Iris-Tests'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testRunTestsRequestArgument [

	| request entry |
	request := self requestFor: (self toolsCallBody: 'run_tests' arguments: (Dictionary with: 'package' -> 'Iris-Tests')).
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: entry requestArgument equals: 'Iris-Tests'
]

{ #category : 'tests' }
IrisMCPLogEntryTest >> testUnknownLogEntryPrintString [

	| body request entry |
	body := NeoJSONWriter toString: (Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'initialize';
		yourself).
	request := self requestFor: body.
	entry := IrisMCPLogger new logEntryFor: request.
	self assert: (entry isKindOf: IrisMCPLogEntry).
	self assert: entry printString equals: 'unknown'
]

{ #category : 'helpers' }
IrisMCPLogEntryTest >> toolsCallBody: toolName arguments: anArgumentsDictionary [

	^ NeoJSONWriter toString: (Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: 1;
		at: 'method' put: 'tools/call';
		at: 'params' put: (Dictionary new
			at: 'name' put: toolName;
			at: 'arguments' put: anArgumentsDictionary;
			yourself);
		yourself)
]
