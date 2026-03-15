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
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec
			package: 'Iris'
			with: [ spec requires: #('NeoJSON') ] ]
]
