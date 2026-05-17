Class {
	#name : 'IrisMCPServerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'serverButton',
		'loggingButton',
		'logList',
		'logEntryPresenter'
	],
	#category : 'Iris-UI',
	#package : 'Iris',
	#tag : 'UI'
}

{ #category : 'accessing' }
IrisMCPServerPresenter class >> defaultTitle [

	^ 'Iris MCP Server'
]

{ #category : 'accessing' }
IrisMCPServerPresenter >> aboutTitle [

	^ 'Iris MCP Server'
]

{ #category : 'initialization' }
IrisMCPServerPresenter >> connectPresenters [

	logList whenSelectionChangedDo: [ :selection |
		selection selectedItem ifNotNil: [ :entry |
			logEntryPresenter showEntry: entry ] ]
]

{ #category : 'layout' }
IrisMCPServerPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		spacing: 10;
		add: (SpBoxLayout newHorizontal
			spacing: 10;
			add: serverButton expand: false;
			add: loggingButton expand: false;
			yourself)
		expand: false;
		add: (SpPanedLayout newHorizontal
			add: (SpBoxLayout newVertical
				spacing: 5;
				add: (self newLabel label: 'Log:') expand: false;
				add: logList;
				yourself);
			add: logEntryPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
IrisMCPServerPresenter >> initializePresenters [

	serverButton := self newButton.
	loggingButton := self newButton.
	logList := self newTable.
	logList
		addColumn: (((SpStringTableColumn title: 'Tool' evaluated: [ :entry | entry toolName ]) width: 80) displayBold: [ :entry | true ]);
		addColumn: (SpStringTableColumn title: 'Argument' evaluated: [ :entry | entry requestArgument ]);
		items: self server log.
	logEntryPresenter := self instantiate: IrisMCPLogEntryPresenter.
	self updateButtons.
	self subscribeToAnnouncements
]

{ #category : 'initialization' }
IrisMCPServerPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle.
	aWindowPresenter aboutText: IrisMCP about.
	self updateTitle.
	aWindowPresenter whenOpenedDo: [ self refreshLog ]
]

{ #category : 'actions' }
IrisMCPServerPresenter >> refreshLog [

	logList items: self server log.
	logList selectIndex: self server log size scrollToSelection: true
]

{ #category : 'accessing' }
IrisMCPServerPresenter >> server [

	^ IrisMCPServer current
]

{ #category : 'actions' }
IrisMCPServerPresenter >> startLogging [

	self server startLogging.
	self updateButtons
]

{ #category : 'actions' }
IrisMCPServerPresenter >> startServer [

	self server start.
	self updateButtons.
	self updateTitle
]

{ #category : 'actions' }
IrisMCPServerPresenter >> stopLogging [

	self server stopLogging.
	self updateButtons
]

{ #category : 'actions' }
IrisMCPServerPresenter >> stopServer [

	self server stop.
	self updateButtons.
	self updateTitle
]

{ #category : 'announcements' }
IrisMCPServerPresenter >> subscribeToAnnouncements [

	self server announcer
		when: IrisMCPRequestLogged
		do: [ :ann | self refreshLog ]
		for: self
]

{ #category : 'announcements' }
IrisMCPServerPresenter >> unsubscribeFromAnnouncements [

	self server announcer unsubscribe: self
]

{ #category : 'actions' }
IrisMCPServerPresenter >> updateButtons [

	self server isRunning
		ifTrue: [
			serverButton
				label: 'Stop server';
				action: [ self stopServer ] ]
		ifFalse: [
			serverButton
				label: 'Start server';
				action: [ self startServer ] ].
	self server isLogging
		ifTrue: [
			loggingButton
				label: 'Stop logging';
				action: [ self stopLogging ] ]
		ifFalse: [
			loggingButton
				label: 'Start logging';
				action: [ self startLogging ] ]
]

{ #category : 'accessing' }
IrisMCPServerPresenter >> updateTitle [

	| subtitle |
	subtitle := self server isRunning
		ifTrue: [ 'running on port ' , self server port printString ]
		ifFalse: [ 'not running' ].
	self window title: self class defaultTitle , ' (' , subtitle , ')'
]
