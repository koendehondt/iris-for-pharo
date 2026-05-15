Class {
	#name : 'IrisMCPRunTestsTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPRunTestsTool >> description [

	^ 'Runs a TestCase class (or a single test method) and returns a summary of results including pass/fail/error counts and failure messages. Alternatively, runs all TestCase subclasses in a package.'
]

{ #category : 'executing' }
IrisMCPRunTestsTool >> execute: args [

	| className selector package |
	className := args at: 'class_name' ifAbsent: [ nil ].
	selector := args at: 'selector' ifAbsent: [ nil ].
	package := args at: 'package' ifAbsent: [ nil ].

	package ifNotNil: [ ^ self executePackage: package ].

	className ifNil: [ ^ self errorResult: 'Missing required argument: class_name or package' ].
	^ self executeClass: className selector: selector
]

{ #category : 'executing' }
IrisMCPRunTestsTool >> executeClass: className selector: selector [

	| class suite result |
	class := Smalltalk classNamed: className asSymbol.
	class ifNil: [ ^ self errorResult: 'Class not found: ' , className ].
	(class inheritsFrom: TestCase) ifFalse: [ ^ self errorResult: className , ' is not a TestCase subclass' ].
	suite := class suite.
	selector ifNotNil: [
		suite := suite class new addTests: (suite tests select: [ :each | each selector = selector asSymbol ]) ].
	result := IrisTestResult new.
	suite run: result.
	^ self textResult: (self formatResult: result forClass: className selector: selector)
]

{ #category : 'executing' }
IrisMCPRunTestsTool >> executePackage: packageName [

	| pkg classes suite result |
	pkg := Smalltalk packageOrganizer packageNamed: packageName ifAbsent: [ nil ].
	pkg ifNil: [ ^ self errorResult: 'Package not found: ' , packageName ].
	classes := pkg definedClasses select: [ :c | c inheritsFrom: TestCase ].
	classes ifEmpty: [ ^ self errorResult: 'No TestCase subclasses found in package: ' , packageName ].
	suite := TestSuite new.
	classes do: [ :c | suite addTests: c suite tests ].
	result := IrisTestResult new.
	suite run: result.
	^ self textResult: (self formatResult: result forClass: packageName selector: nil)
]

{ #category : 'printing' }
IrisMCPRunTestsTool >> formatResult: result forClass: className selector: selector [

	| failureMessages errorMessages |
	^ String streamContents: [ :stream |
		selector ifNil: [
			stream
				nextPutAll: 'Ran ';
				print: result runCount;
				nextPutAll: (' test' asPluralBasedOn: result runCount);
				nextPutAll: ' in ';
				nextPutAll: className;
				cr]
		ifNotNil: [
			stream
				nextPutAll: 'Ran ';
				nextPutAll: className;
				nextPutAll: ' >> ';
				nextPutAll: selector;
				cr ].
		stream
			print: result expectedPassCount; nextPutAll: ' passed'; cr;
			print: result unexpectedFailureCount; nextPutAll: ' failed'; cr;
			print: result unexpectedErrorCount; nextPutAll: ' errored'; cr.
		failureMessages := result failureMessages asSortedCollection: [ :some :other | some key < other key ].
		failureMessages ifNotEmpty: [
			stream cr; nextPutAll: '--- Failures ---'; cr.
			failureMessages
				do: [ :testSelectorAndMessage |
					stream
						nextPutAll: testSelectorAndMessage key;
						cr;
						nextPutAll: testSelectorAndMessage value ]
				separatedBy: [ stream cr; cr ].
			stream cr ].
		errorMessages := result errorMessages asSortedCollection: [ :some :other | some key < other key ].
		errorMessages ifNotEmpty: [
			stream cr; nextPutAll: '--- Errors ---'; cr.
			errorMessages
				do: [ :testSelectorAndMessage |
					stream
						nextPutAll: testSelectorAndMessage key;
						cr;
						nextPutAll: testSelectorAndMessage value ]
				separatedBy: [ stream cr; cr ].
			stream cr ] ]
]

{ #category : 'accessing' }
IrisMCPRunTestsTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'class_name' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The name of the TestCase subclass to run. Optional if package is provided.';
				yourself);
			at: 'selector' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'Optional single test method selector to run. If omitted, all tests in the class are run.';
				yourself);
			at: 'package' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The name of the package whose TestCase subclasses to run. If provided, class_name is ignored.';
				yourself);
			yourself);
		at: 'required' put: #();
		yourself
]

{ #category : 'accessing' }
IrisMCPRunTestsTool >> name [

	^ 'run_tests'
]
