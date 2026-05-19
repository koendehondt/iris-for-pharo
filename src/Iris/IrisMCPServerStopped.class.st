Class {
	#name : 'IrisMCPServerStopped',
	#superclass : 'Announcement',
	#instVars : [
		'server'
	],
	#category : 'Iris-Server',
	#package : 'Iris',
	#tag : 'Server'
}

{ #category : 'instance creation' }
IrisMCPServerStopped class >> on: aServer [

	^ self new
		server: aServer;
		yourself
]

{ #category : 'accessing' }
IrisMCPServerStopped >> server [

	^ server
]

{ #category : 'accessing' }
IrisMCPServerStopped >> server: aServer [

	server := aServer
]
