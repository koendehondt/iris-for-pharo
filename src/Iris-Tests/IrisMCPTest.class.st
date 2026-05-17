Class {
	#name : 'IrisMCPTest',
	#superclass : 'TestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'tests' }
IrisMCPTest >> testAbout [

	| expected |
	expected := Text streamContents: [ :stream |
		stream
			withAttribute: TextEmphasis bold do: [ stream print: IrisMCP version ];
			cr; cr;
			nextPutAll: IrisMCP aboutText ].
	self assert: IrisMCP about equals: ('Iris MCP 0.1.0' asText allBold , (Text fromString: '

Iris is a Model Context Protocol (MCP) server for Pharo.
It exposes Pharo tools to AI assistants such as Claude.

Available tools: eval, get_class, get_method, list_classes, run_tests.

(c) 2025 Koen De Hondt'))
]

{ #category : 'tests' }
IrisMCPTest >> testVersion [

	| version |
	version := IrisMCP version.
	self assert: (version isKindOf: IrisMCPVersion).
	self assert: version major equals: 0.
	self assert: version minor equals: 1.
	self assert: version patch equals: 0
]
