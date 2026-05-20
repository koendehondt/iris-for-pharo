Class {
	#name : 'IrisMCP',
	#superclass : 'Object',
	#category : 'Iris-Core',
	#package : 'Iris',
	#tag : 'Core'
}

{ #category : 'accessing' }
IrisMCP class >> about [

	^ Text streamContents: [ :stream |
		stream
			withAttribute: TextEmphasis bold do: [ stream print: self version ];
			cr; cr;
			nextPutAll: self aboutText ]
]

{ #category : 'accessing' }
IrisMCP class >> aboutText [

	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Iris is a Model Context Protocol (MCP) server for Pharo.';
			cr;
			nextPutAll: 'It exposes Pharo tools to AI assistants such as Claude.';
			cr;
			cr;
			nextPutAll: 'Available tools: eval, get_class, get_method, list_classes, run_tests.';
			cr;
			cr;
			nextPutAll: '(c) 2025 Koen De Hondt' ]
]

{ #category : 'actions' }
IrisMCP class >> openServer [

	^ IrisMCPServerPresenter allInstances
		detect: [ :presenter | 
			presenter window notNil 
				and: [ presenter window isOpen 
				and: [ presenter server == IrisMCPServer current ] ] ]
		ifFound: [ :presenter | 
			presenter window activate.
			presenter ]
		ifNone: [ 
			| presenter |
			presenter := IrisMCPServerPresenter on: IrisMCPServer current.
			presenter open.
			presenter ]
]

{ #category : 'accessing' }
IrisMCP class >> version [
	"From https://semver.org/
		Given a version number MAJOR.MINOR.PATCH, increment the:
			MAJOR version when you make incompatible API changes
			MINOR version when you add functionality in a backward compatible manner
			PATCH version when you make backward compatible bug fixes"

	^ IrisMCPVersion major: 0 minor: 1 patch: 0
]
