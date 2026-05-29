Class {
	#name : 'IrisMCPToolsListLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPToolsListLogEntry class >> toolName [

	^ 'tools/list'
]

{ #category : 'accessing' }
IrisMCPToolsListLogEntry >> displayToolName [

	^ 'tools'
]

{ #category : 'accessing' }
IrisMCPToolsListLogEntry >> responseText [

	| json tools |
	response ifNil: [ ^ String new ].
	json := NeoJSONReader fromString: response entity string.
	tools := (json at: 'result' ifAbsent: [ ^ String new ]) at: 'tools' ifAbsent: [ ^ String new ].
	^ String streamContents: [ :stream |
		tools doWithIndex: [ :tool :i |
			i > 1 ifTrue: [ stream cr ].
			stream
				nextPutAll: (tool at: 'name');
				nextPutAll: ': ';
				nextPutAll: (tool at: 'description' ifAbsent: [ '' ]) ] ]
]
