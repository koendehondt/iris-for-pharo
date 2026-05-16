Class {
	#name : 'BaselineOfIris',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfIris',
	#package : 'BaselineOfIris'
}

{ #category : 'baselines' }
BaselineOfIris >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ];
			package: 'Iris' with: [ spec requires: #('NeoJSON') ];
			package: 'Iris-TestSupport';
			package: 'Iris-Tests' with: [ spec requires: #('Iris' 'Iris-TestSupport') ] ].
	spec postLoadDoIt: #postLoad
]

{ #category : 'baselines' }
BaselineOfIris >> initializeClasses [

	IrisMCPServer current ifNotNil: [ IrisMCPServer current stop ].
	IrisMCPServer initialize
]

{ #category : 'baselines' }
BaselineOfIris >> postLoad [

	self initializeClasses
]
