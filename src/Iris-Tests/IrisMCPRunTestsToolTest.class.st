Class {
	#name : 'IrisMCPRunTestsToolTest',
	#superclass : 'IrisMCPTestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testMissingClassNameReturnsError [

	| result |
	result := self tool execute: Dictionary new.
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Missing required argument: class_name or package'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testName [

	self assert: self tool name equals: 'run_tests'
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testNonTestCaseClassReturnsError [

	| result |
	result := self tool execute: (Dictionary with: 'class_name' -> 'IrisMCPServer').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'IrisMCPServer is not a TestCase subclass'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testRunsPackage [

	| result |
	result := self tool execute: (Dictionary with: 'package' -> 'Iris-TestSupport').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Ran 4 tests in Iris-TestSupport
1 passed
2 failed
1 errored

--- Failures ---
testFailWithDescription
This test fails.

testFailWithoutDescription
Assertion failed

--- Errors ---
testError
This test signals an error.
' })
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testRunsSingleErrorTest [

	| result |
	result := self tool execute: (Dictionary 
		with: 'class_name' -> 'IrisExampleTest'
		with: 'selector' -> 'testError').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Ran IrisExampleTest >> testError
0 passed
0 failed
1 errored

--- Errors ---
testError
This test signals an error.
' })
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testRunsSingleFailingTest [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'IrisExampleTest'
		with: 'selector' -> 'testFailWithDescription').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Ran IrisExampleTest >> testFailWithDescription
0 passed
1 failed
0 errored

--- Failures ---
testFailWithDescription
This test fails.
' })
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testRunsSinglePassingTest [

	| result |
	result := self tool execute: (Dictionary
		with: 'class_name' -> 'IrisExampleTest'
		with: 'selector' -> 'testPass').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Ran IrisExampleTest >> testPass
1 passed
0 failed
0 errored
' })
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testRunsTestClass [

	| result |
	result := self tool execute: (Dictionary with: 'class_name' -> 'IrisExampleTest').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'type' -> 'text'
			with: 'text' -> 'Ran 4 tests in IrisExampleTest
1 passed
2 failed
1 errored

--- Failures ---
testFailWithDescription
This test fails.

testFailWithoutDescription
Assertion failed

--- Errors ---
testError
This test signals an error.
' })
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testSchemaHasRequiredFields [

	self assert: self tool schema equals: (Dictionary
		with: 'name' -> 'run_tests'
		with: 'description' -> 'Runs a TestCase class (or a single test method) and returns a summary of results including pass/fail/error counts and failure messages. Alternatively, runs all TestCase subclasses in a package.'
		with: 'inputSchema' -> (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'class_name' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the TestCase subclass to run. Optional if package is provided.')
				with: 'selector' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'Optional single test method selector to run. If omitted, all tests in the class are run.')
				with: 'package' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the package whose TestCase subclasses to run. If provided, class_name is ignored.'))
			with: 'required' -> { }))
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testUnknownClassReturnsError [

	| result |
	result := self tool execute: (Dictionary with: 'class_name' -> 'NoSuchClassXYZ').
	self assert: result equals: (Dictionary
		with: 'content' -> { Dictionary
			with: 'text' -> 'Class not found: NoSuchClassXYZ'
			with: 'type' -> 'text' }
		with: 'isError' -> true)
]

{ #category : 'tests' }
IrisMCPRunTestsToolTest >> testUnknownPackageReturnsError [

	| result |
	result := self tool execute: (Dictionary new
		at: 'package' put: 'NoSuchPackage';
		yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'NoSuchPackage')
]

{ #category : 'helpers' }
IrisMCPRunTestsToolTest >> tool [

	^ IrisMCPRunTestsTool new
]
