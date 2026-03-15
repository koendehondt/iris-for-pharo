Class {
	#name : 'IrisMCPListClassesTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPListClassesTool >> description [

	^ 'Lists all classes in the Pharo image, optionally filtered by name prefix and/or package name.'
]

{ #category : 'executing' }
IrisMCPListClassesTool >> execute: args [

	| prefix package classes stream |
	prefix  := args at: 'prefix'  ifAbsent: [ nil ].
	package := args at: 'package' ifAbsent: [ nil ].
	classes := Smalltalk globals allClasses
		select: [ :cls |
			(prefix  isNil or: [ cls name beginsWith: prefix ])
			and: [ package isNil or: [ cls package name = package ] ] ].
	stream := WriteStream on: String new.
	(classes asSortedCollection: [ :a :b | a name < b name ])
		do: [ :cls |
			stream
				nextPutAll: cls name;
				nextPutAll: ' (';
				nextPutAll: cls package name;
				nextPutAll: ')';
				cr ].
	^ self textResult: stream contents
]

{ #category : 'accessing' }
IrisMCPListClassesTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'prefix' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'Only return classes whose name starts with this prefix (case-sensitive)';
				yourself);
			at: 'package' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'Only return classes belonging to this package name';
				yourself);
			yourself);
		at: 'required' put: #();
		yourself
]

{ #category : 'accessing' }
IrisMCPListClassesTool >> name [

	^ 'list_classes'
]
