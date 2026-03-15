Class {
	#name : 'IrisMCPJsonRpcRequest',
	#superclass : 'Object',
	#instVars : [
		'jsonrpc',
		'id',
		'method',
		'params'
	],
	#category : 'Iris',
	#package : 'Iris'
}

{ #category : 'instance creation' }
IrisMCPJsonRpcRequest class >> fromDictionary: aDictionary [

	^ self new
		jsonrpc: (aDictionary at: 'jsonrpc' ifAbsent: ['2.0']);
		id: (aDictionary at: 'id' ifAbsent: [nil]);
		method: (aDictionary at: 'method' ifAbsent: [nil]);
		params: (aDictionary at: 'params' ifAbsent: [Dictionary new]);
		yourself
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> id [

	^ id
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> jsonrpc [

	^ jsonrpc
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> jsonrpc: aString [

	jsonrpc := aString
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> method [

	^ method
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> method: aString [

	method := aString
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> params [

	^ params
]

{ #category : 'accessing' }
IrisMCPJsonRpcRequest >> params: aDictionary [

	params := aDictionary
]
