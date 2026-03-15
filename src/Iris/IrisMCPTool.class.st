Class {
	#name : 'IrisMCPTool',
	#superclass : 'Object',
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'accessing' }
IrisMCPTool >> description [

	^ self subclassResponsibility
]

{ #category : 'results' }
IrisMCPTool >> errorResult: aString [

	"Wrap an error in the MCP content format."
	^ Dictionary new
		at: 'content' put: (Array with: (Dictionary new
			at: 'type' put: 'text';
			at: 'text' put: aString;
			yourself));
		at: 'isError' put: true;
		yourself
]

{ #category : 'executing' }
IrisMCPTool >> execute: args [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IrisMCPTool >> inputSchema [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IrisMCPTool >> name [

	^ self subclassResponsibility
]

{ #category : 'schema' }
IrisMCPTool >> schema [

	"Return the MCP tool schema dictionary for tools/list."
	^ Dictionary new
		at: 'name' put: self name;
		at: 'description' put: self description;
		at: 'inputSchema' put: self inputSchema;
		yourself
]

{ #category : 'results' }
IrisMCPTool >> textResult: aString [

	"Wrap a plain text result in the MCP content format."
	^ Dictionary new
		at: 'content' put: (Array with: (Dictionary new
			at: 'type' put: 'text';
			at: 'text' put: aString;
			yourself));
		yourself
]
