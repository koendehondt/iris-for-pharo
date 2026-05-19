Class {
	#name : 'IrisMCPLoggingStopped',
	#superclass : 'Announcement',
	#instVars : [
		'server'
	],
	#category : 'Iris-Logging',
	#package : 'Iris',
	#tag : 'Logging'
}

{ #category : 'instance creation' }
IrisMCPLoggingStopped class >> on: aServer [

	^ self new
		server: aServer;
		yourself
]

{ #category : 'accessing' }
IrisMCPLoggingStopped >> server [

	^ server
]

{ #category : 'accessing' }
IrisMCPLoggingStopped >> server: aServer [

	server := aServer
]
