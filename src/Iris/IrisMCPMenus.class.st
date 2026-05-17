Class {
	#name : 'IrisMCPMenus',
	#superclass : 'Object',
	#category : 'Iris-UI',
	#package : 'Iris',
	#tag : 'UI'
}

{ #category : 'menus' }
IrisMCPMenus class >> irisMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Iris)
		order: 75;
		label: 'Iris'.
	(aBuilder item: #'MCP Server')
		parent: #Iris;
		order: 1;
		label: 'MCP Server';
		help: 'Open the Iris MCP Server window';
		action: [ IrisMCP openServer ]
]
