Class {
	#name : 'IrisMCPCancelledNotificationLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPCancelledNotificationLogEntry class >> toolName [

	^ 'notifications/cancelled'
]

{ #category : 'accessing' }
IrisMCPCancelledNotificationLogEntry >> displayToolName [

	^ 'cancelled'
]

{ #category : 'accessing' }
IrisMCPCancelledNotificationLogEntry >> requestArgument [

	| json |
	json := NeoJSONReader fromString: request entity string.
	^ (json at: 'params') at: 'reason' ifAbsent: [ String new ]
]
