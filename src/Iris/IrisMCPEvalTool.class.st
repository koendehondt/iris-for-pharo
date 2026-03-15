Class {
	#name : 'IrisMCPEvalTool',
	#superclass : 'IrisMCPTool',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPEvalTool >> description [

	^ 'Evaluates a Smalltalk expression in the Pharo image and returns the printString of the result.'
]

{ #category : 'executing' }
IrisMCPEvalTool >> execute: args [

	| expression result |
	expression := args at: 'expression' ifAbsent: [ nil ].
	expression ifNil: [ ^ self errorResult: 'Missing required argument: expression' ].
	expression := expression copyReplaceAll: (String with: Character lf) with: (String with: Character cr).
	result := [ OpalCompiler new source: expression; evaluate ]
		on: Error
		do: [ :e | ^ self errorResult: e messageText ].
	^ self textResult: result printString
]

{ #category : 'accessing' }
IrisMCPEvalTool >> inputSchema [

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'expression' put: (Dictionary new
				at: 'type' put: 'string';
				at: 'description' put: 'The Smalltalk expression to evaluate';
				yourself);
			yourself);
		at: 'required' put: #('expression');
		yourself
]

{ #category : 'accessing' }
IrisMCPEvalTool >> name [

	^ 'eval'
]
