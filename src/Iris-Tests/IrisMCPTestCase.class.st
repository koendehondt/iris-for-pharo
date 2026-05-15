Class {
	#name : 'IrisMCPTestCase',
	#superclass : 'TestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'helpers' }
IrisMCPTestCase >> makeRequest: aMethod params: aDict [

	^ IrisMCPJsonRpcRequest fromDictionary: (Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: 1;
		at: 'method' put: aMethod;
		at: 'params' put: aDict;
		yourself)
]
