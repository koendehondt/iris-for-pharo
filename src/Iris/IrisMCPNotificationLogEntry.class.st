Class {
	#name : 'IrisMCPNotificationLogEntry',
	#superclass : 'IrisMCPLogEntry',
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'accessing' }
IrisMCPNotificationLogEntry >> displayToolName [

	^ self toolName copyReplaceAll: 'notifications/' with: ''
]
