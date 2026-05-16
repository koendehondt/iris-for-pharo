Class {
	#name : 'IrisMCPJsonRpcResponse',
	#superclass : 'Object',
	#instVars : [
		'id',
		'result',
		'error'
	],
	#category : 'Iris-Server',
	#package : 'Iris',
	#tag : 'Server'
}

{ #category : 'instance creation' }
IrisMCPJsonRpcResponse class >> errorFor: anId code: anInteger message: aString [

	^ self new
		id: anId;
		error: (Dictionary new
			at: 'code' put: anInteger;
			at: 'message' put: aString;
			yourself);
		yourself
]

{ #category : 'instance creation' }
IrisMCPJsonRpcResponse class >> resultFor: anId value: anObject [

	^ self new
		id: anId;
		result: anObject;
		yourself
]

{ #category : 'converting' }
IrisMCPJsonRpcResponse >> asJson [

	| dict |
	dict := Dictionary
		with: 'jsonrpc' -> self jsonrpc
		with: 'id' -> id.
	error
		ifNil: [ dict at: 'result' put: result ]
		ifNotNil: [ dict at: 'error' put: error ].
	^ NeoJSONWriter toString: dict
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> error [

	^ error
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> error: aDictionary [

	error := aDictionary
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> id [

	^ id
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> jsonrpc [

	^ '2.0'
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> result [

	^ result
]

{ #category : 'accessing' }
IrisMCPJsonRpcResponse >> result: anObject [

	result := anObject
]
