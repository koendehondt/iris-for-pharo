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
		addColumn: (((SpStringTableColumn title: 'Tool' evaluated: [ :entry | entry displayToolName ]) width: 80) displayBold: [ :entry | true ]);
		addColumn: (SpStringTableColumn title: 'Argument' evaluated: [ :entry | entry requestArgument ]);
		items: self server log.
	logEntryPresenter := self instantiate: IrisMCPLogEntryPresenter
]

{ #category : 'initialization' }
IrisMCPServerPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: self class defaultTitle.
	aWindowPresenter aboutText: IrisMCP about.
	aWindowPresenter whenOpenedDo: [
		self updateServerButton.
		self updateLoggingButton.
		self refreshLog.
		self updateTitle.
		self subscribeToAnnouncements ].
	aWindowPresenter whenClosedDo: [
		self unsubscribeFromAnnouncements ]
]

{ #category : 'test api' }
IrisMCPServerPresenter >> loggingButtonLabel [

	^ loggingButton label
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

{ #category : 'test api' }
IrisMCPServerPresenter >> serverButtonLabel [

	^ serverButton label
]

{ #category : 'actions' }
IrisMCPServerPresenter >> startLogging [

	self server startLogging
]

{ #category : 'actions' }
IrisMCPServerPresenter >> startServer [

	self server start
]

{ #category : 'actions' }
IrisMCPServerPresenter >> stopLogging [

	self server stopLogging
]

{ #category : 'actions' }
IrisMCPServerPresenter >> stopServer [

	self server stop
]

{ #category : 'announcements' }
IrisMCPServerPresenter >> subscribeToAnnouncements [

	self server announcer
		when: IrisMCPRequestLogged do: [ :ann | self refreshLog ] for: self;
		when: IrisMCPServerStarted do: [ :ann | ann server == self server ifTrue: [ self updateServerButton; updateTitle ] ] for: self;
		when: IrisMCPServerStopped do: [ :ann | ann server == self server ifTrue: [ self updateServerButton; updateTitle ] ] for: self;
		when: IrisMCPLoggingStarted do: [ :ann | ann server == self server ifTrue: [ self updateLoggingButton ] ] for: self;
		when: IrisMCPLoggingStopped do: [ :ann | ann server == self server ifTrue: [ self updateLoggingButton ] ] for: self
]

{ #category : 'announcements' }
IrisMCPServerPresenter >> unsubscribeFromAnnouncements [

	self server announcer unsubscribe: self
]

{ #category : 'actions' }
IrisMCPServerPresenter >> updateLoggingButton [

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

{ #category : 'actions' }
IrisMCPServerPresenter >> updateServerButton [

	self server isRunning
		ifTrue: [
			serverButton
				label: 'Stop server';
				action: [ self stopServer ] ]
		ifFalse: [
			serverButton
				label: 'Start server';
				action: [ self startServer ] ]
]

{ #category : 'accessing' }
IrisMCPServerPresenter >> updateTitle [

	self withWindowDo: [ :window |
		| subtitle |
		subtitle := self server isRunning
			ifTrue: [ 'running on port ' , self server port printString ]
			ifFalse: [ 'not running' ].
		window title: self class defaultTitle , ' (' , subtitle , ')' ]
]
