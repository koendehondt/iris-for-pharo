Class {
	#name : 'IrisExampleTest',
	#superclass : 'TestCase',
	#category : 'Iris-TestSupport',
	#package : 'Iris-TestSupport'
}

{ #category : 'tests' }
IrisExampleTest >> testError [

	self error: 'This test signals an error.'
]

{ #category : 'tests' }
IrisExampleTest >> testFailWithDescription [

	self assert: false description: 'This test fails.'
]

{ #category : 'tests' }
IrisExampleTest >> testFailWithoutDescription [

	self assert: false
]

{ #category : 'tests' }
IrisExampleTest >> testPass [

	self assert: true
]
