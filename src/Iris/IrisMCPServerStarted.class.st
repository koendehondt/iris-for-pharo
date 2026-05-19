Class {
	#name : 'IrisMCPServerStarted',
	#superclass : 'Announcement',
	#instVars : [
		'server'
	],
	#category : 'Iris-Server',
	#package : 'Iris',
	#tag : 'Server'
}

{ #category : 'instance creation' }
IrisMCPServerStarted class >> on: aServer [

	^ self new
		server: aServer;
		yourself
]

{ #category : 'accessing' }
IrisMCPServerStarted >> server [

	^ server
]

{ #category : 'accessing' }
IrisMCPServerStarted >> server: aServer [

	server := aServer
]
