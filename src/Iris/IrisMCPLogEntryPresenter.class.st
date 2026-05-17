Class {
	#name : 'IrisMCPLogEntryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'requestNotebook',
		'requestRawText',
		'requestArgumentText',
		'responseNotebook',
		'responseTextWidget',
		'responseRawText'
	],
	#category : 'Iris-UI',
	#package : 'Iris',
	#tag : 'UI'
}

{ #category : 'layout' }
IrisMCPLogEntryPresenter >> defaultLayout [

	^ (SpPanedLayout newVertical
		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'Request:') expand: false;
			add: requestNotebook;
			yourself);
		add: (SpBoxLayout newVertical
			spacing: 5;
			add: (self newLabel label: 'Response:') expand: false;
			add: responseNotebook;
			yourself);
		yourself)
		positionOfSlider: 0.33;
		yourself
]

{ #category : 'initialization' }
IrisMCPLogEntryPresenter >> initializePresenters [

	requestRawText := self newText.
	requestArgumentText := self newText.
	requestNotebook := self newNotebook.
	requestNotebook
		addPageTitle: 'Argument' provider: [ requestArgumentText ];
		addPageTitle: 'Raw' provider: [ requestRawText ].
	responseTextWidget := self newText.
	responseRawText := self newText.
	responseNotebook := self newNotebook.
	responseNotebook
		addPageTitle: 'Text' provider: [ responseTextWidget ];
		addPageTitle: 'Raw' provider: [ responseRawText ]
]

{ #category : 'accessing' }
IrisMCPLogEntryPresenter >> showEntry: anEntry [

	requestRawText text: anEntry requestJson.
	requestArgumentText text: anEntry requestArgument.
	responseRawText text: anEntry responseJson.
	responseTextWidget text: anEntry responseText
]
