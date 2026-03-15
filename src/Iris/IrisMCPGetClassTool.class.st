Class {
	#name : 'IrisMCPGetClassTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPGetClassTool >> description [

	^ 'Returns the definition and all method sources for a named Pharo class, including both instance-side and class-side methods.'
]

{ #category : 'executing' }
IrisMCPGetClassTool >> execute: args [

	| className class stream |
	className := args at: 'class_name' ifAbsent: [ nil ].
	className ifNil: [ ^ self errorResult: 'Missing required argument: class_name' ].
	class := Smalltalk at: className asSymbol ifAbsent: [ nil ].
	class ifNil: [ ^ self errorResult: 'Class not found: ' , className ].
	(class isKindOf: Class) ifFalse: [ ^ self errorResult: className , ' is not a class' ].
	stream := WriteStream on: String new.
	self writeClassDefinition: class to: stream.
	self writeInstanceMethods: class to: stream.
	self writeClassMethods: class to: stream.
	^ self textResult: stream contents
]

{ #category : 'accessing' }
IrisMCPGetClassTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'class_name' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The name of the Pharo class to retrieve';
				yourself);
			yourself);
		at: 'required' put: #('class_name');
		yourself
]

{ #category : 'accessing' }
IrisMCPGetClassTool >> name [

	^ 'get_class'
]

{ #category : 'printing' }
IrisMCPGetClassTool >> writeClassDefinition: aClass to: aStream [

	aStream
		nextPutAll: 'Class: '; nextPutAll: aClass name; cr;
		nextPutAll: 'Superclass: '; nextPutAll: aClass superclass name; cr;
		nextPutAll: 'Instance variables: ';
		nextPutAll: (' ' join: (aClass instVarNames collect: [:each | each asString])); cr;
		nextPutAll: 'Class variables: ';
		nextPutAll: (' ' join: (aClass classVarNames collect: [:each | each asString])); cr;
		nextPutAll: 'Package: '; nextPutAll: aClass package name; cr;
		cr
]

{ #category : 'printing' }
IrisMCPGetClassTool >> writeClassMethods: aClass to: aStream [

	aClass classSide methods isEmpty ifTrue: [ ^ self ].
	aStream cr; nextPutAll: '=== Class Methods ==='; cr.
	(aClass classSide methods
		asSortedCollection: [ :a :b | a selector < b selector ])
		do: [ :method |
			aStream
				cr;
				nextPutAll: method protocol name; nextPutAll: ' >> '; nextPutAll: method selector; cr;
				nextPutAll: method sourceCode; cr ]
]

{ #category : 'printing' }
IrisMCPGetClassTool >> writeInstanceMethods: aClass to: aStream [

	aClass methods isEmpty ifTrue: [ ^ self ].
	aStream nextPutAll: '=== Instance Methods ==='; cr.
	(aClass methods
		asSortedCollection: [ :a :b | a selector < b selector ])
		do: [ :method |
			aStream
				cr;
				nextPutAll: method protocol name; nextPutAll: ' >> '; nextPutAll: method selector; cr;
				nextPutAll: method sourceCode; cr ]
]
