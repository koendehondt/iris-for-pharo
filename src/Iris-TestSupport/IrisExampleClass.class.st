"
Example class for testing.
"
Class {
	#name : 'IrisExampleClass',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Iris-TestSupport',
	#package : 'Iris-TestSupport'
}

{ #category : 'instance creation' }
IrisExampleClass class >> named: aString [

	^ self new name: aString
]

{ #category : 'accessing' }
IrisExampleClass >> name [

	^ name
]

{ #category : 'accessing' }
IrisExampleClass >> name: aString [

	name := aString
]
