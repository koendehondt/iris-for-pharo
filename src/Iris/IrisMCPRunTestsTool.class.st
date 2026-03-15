Class {
	#name : 'IrisMCPRunTestsTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPRunTestsTool >> description [

	^ 'Runs a TestCase class (or a single test method) and returns a summary of results including pass/fail/error counts and failure messages.'
]

{ #category : 'executing' }
IrisMCPRunTestsTool >> execute: args [

	| className selector class suite result |
	className := args at: 'class_name' ifAbsent: [ nil ].
	selector  := args at: 'selector'   ifAbsent: [ nil ].
	className ifNil: [ ^ self errorResult: 'Missing required argument: class_name' ].
	class := Smalltalk at: className asSymbol ifAbsent: [ nil ].
	class ifNil: [ ^ self errorResult: 'Class not found: ' , className ].
	(class inheritsFrom: TestCase) ifFalse: [ ^ self errorResult: className , ' is not a TestCase subclass' ].
	suite := selector
		ifNil:  [ class suite ]
		ifNotNil: [ class suite select: [ :each | each selector = selector asSymbol ] ].
	result := suite run.
	^ self textResult: (self formatResult: result forClass: className selector: selector)
]

{ #category : 'printing' }
IrisMCPRunTestsTool >> formatResult: result forClass: className selector: selector [

	| stream |
	stream := WriteStream on: String new.
	stream
		nextPutAll: 'Ran ';
		print: result runCount;
		nextPutAll: ' test';
		nextPutAll: (result runCount = 1 ifTrue: [''] ifFalse: ['s']);
		nextPutAll: ' in ';
		nextPutAll: className; cr.
	selector ifNotNil: [ stream nextPutAll: ' >> '; nextPutAll: selector; cr ].
	stream
		print: result expectedPassCount; nextPutAll: ' passed'; cr;
		print: result unexpectedFailureCount; nextPutAll: ' failed'; cr;
		print: result unexpectedErrorCount; nextPutAll: ' errored'; cr.
	result unexpectedFailures isEmpty ifFalse: [
		stream cr; nextPutAll: '--- Failures ---'; cr.
		result unexpectedFailures do: [ :tc |
			stream
				nextPutAll: tc selector;
				nextPutAll: ': ';
				nextPutAll: tc description;
				cr ] ].
	result unexpectedErrors isEmpty ifFalse: [
		stream cr; nextPutAll: '--- Errors ---'; cr.
		result unexpectedErrors do: [ :tc |
			stream
				nextPutAll: tc selector;
				nextPutAll: ': ';
				nextPutAll: tc description;
				cr ] ].
	^ stream contents
]

{ #category : 'accessing' }
IrisMCPRunTestsTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'class_name' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The name of the TestCase subclass to run';
				yourself);
			at: 'selector' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'Optional single test method selector to run. If omitted, all tests in the class are run.';
				yourself);
			yourself);
		at: 'required' put: #('class_name');
		yourself
]

{ #category : 'accessing' }
IrisMCPRunTestsTool >> name [

	^ 'run_tests'
]
