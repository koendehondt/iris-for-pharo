Class {
	#name : 'IrisMCPGetMethodTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPGetMethodTool >> description [

	^ 'Returns the source of a single method. Provide class_name and selector. Optionally set class_side to true for class-side methods.'
]

{ #category : 'executing' }
IrisMCPGetMethodTool >> execute: args [

	| className selector classSide class side method stream |
	className := args at: 'class_name' ifAbsent: [ nil ].
	selector  := args at: 'selector'   ifAbsent: [ nil ].
	classSide := args at: 'class_side' ifAbsent: [ false ].
	className ifNil: [ ^ self errorResult: 'Missing required argument: class_name' ].
	selector  ifNil: [ ^ self errorResult: 'Missing required argument: selector' ].
	class := Smalltalk at: className asSymbol ifAbsent: [ nil ].
	class ifNil: [ ^ self errorResult: 'Class not found: ' , className ].
	(class isKindOf: Class) ifFalse: [ ^ self errorResult: className , ' is not a class' ].
	side := classSide ifTrue: [ class classSide ] ifFalse: [ class ].
	method := side compiledMethodAt: selector asSymbol ifAbsent: [ nil ].
	method ifNil: [ ^ self errorResult: 'Method not found: ' , className , ' >> ' , selector ].
	stream := WriteStream on: String new.
	stream
		nextPutAll: 'Class: '; nextPutAll: className; cr;
		nextPutAll: 'Selector: '; nextPutAll: selector; cr;
		nextPutAll: 'Protocol: '; nextPutAll: method protocol name; cr;
		nextPutAll: 'Side: '; nextPutAll: (classSide ifTrue: ['class'] ifFalse: ['instance']); cr;
		cr;
		nextPutAll: method sourceCode.
	^ self textResult: stream contents
]

{ #category : 'accessing' }
IrisMCPGetMethodTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'class_name' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The name of the Pharo class';
				yourself);
			at: 'selector' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The method selector';
				yourself);
			at: 'class_side' put: (Dictionary new
				at: 'type' put: 'boolean';
				at: 'description' put: 'If true, look up the method on the class side. Defaults to false.';
				yourself);
			yourself);
		at: 'required' put: #('class_name' 'selector');
		yourself
]

{ #category : 'accessing' }
IrisMCPGetMethodTool >> name [

	^ 'get_method'
]
