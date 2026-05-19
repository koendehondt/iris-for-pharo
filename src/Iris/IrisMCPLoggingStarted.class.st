Class {
	#name : 'IrisMCPLoggingStarted',
	#superclass : 'Announcement',
	#instVars : [
		'server'
	],
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'instance creation' }
IrisMCPLoggingStarted class >> on: aServer [

	^ self new
		server: aServer;
		yourself
]

{ #category : 'accessing' }
IrisMCPLoggingStarted >> server [

	^ server
]

{ #category : 'accessing' }
IrisMCPLoggingStarted >> server: aServer [

	server := aServer
]
