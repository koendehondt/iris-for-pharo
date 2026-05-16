Class {
	#name : 'IrisTestResult',
	#superclass : 'TestResult',
	#instVars : [
		'failureMessages',
		'errorMessages'
	],
	#category : 'Iris-Tools',
	#package : 'Iris',
	#tag : 'Tools'
}

{ #category : 'accessing' }
IrisTestResult >> errorMessages [
	"Answer an OrderedCollection with Association instances.
	 Each Association maps a TestCase instance on a String error message."

	^ errorMessages
]

{ #category : 'accessing' }
IrisTestResult >> failureMessages [
	"Answer an OrderedCollection with Association instances.
	 Each Association maps a TestCase instance on a String failure message."

	^ failureMessages
]

{ #category : 'initialization' }
IrisTestResult >> initialize [

	super initialize.
	failureMessages := OrderedCollection new.
	errorMessages := OrderedCollection new
]

{ #category : 'running' }
IrisTestResult >> runCase: aTestCase [

	| testBlock |
	testBlock := [
		aTestCase announce: TestCaseStarted withResult: self.
		aTestCase runCaseManaged.
		aTestCase announce: TestCaseEnded withResult: self.
		self addPass: aTestCase ].
	testBlock
		on: self class failure , self class skip , self class warning , self class error
		do: [ :ex |
			(ex isKindOf: self class failure)
				ifTrue: [ failureMessages add: aTestCase selector -> ex messageText ]
				ifFalse: [ errorMessages add: aTestCase selector -> ex messageText ].
			ex sunitAnnounce: aTestCase toResult: self ]
]
