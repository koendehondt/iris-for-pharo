Class {
	#name : 'IrisMCPTestCase',
	#superclass : 'TestCase',
	#category : 'Iris-Tests',
	#package : 'Iris-Tests'
}

{ #category : 'helpers' }
IrisMCPTestCase >> makeRequest: aMethod params: aDict [

	^ IrisMCPJsonRpcRequest fromDictionary: (Dictionary
		with: 'jsonrpc' -> '2.0'
		with: 'id' -> 1
		with: 'method' -> aMethod
		with: 'params' -> aDict)
]

{ #category : 'helpers' }
IrisMCPTestCase >> restoreCurrentServerAfter: aBlock [

	| oldServer oldServerWasRunning |
	oldServer := IrisMCPServer current.
	oldServerWasRunning := oldServer isRunning.
	[ aBlock cull: oldServer ] ensure: [
		IrisMCPServer current: oldServer.
		oldServerWasRunning ifTrue: [ oldServer start ] ]
]
