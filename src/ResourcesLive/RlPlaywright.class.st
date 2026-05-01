Class {
	#name : 'RlPlaywright',
	#superclass : 'Object',
	#classVars : [
		'PythonInstance'
	],
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'initialization' }
RlPlaywright class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : 'installation' }
RlPlaywright class >> install [
	| pyBridgeFolder cmdString playwrightFile vEnvFolder |
	pyBridgeFolder := FileLocator imageDirectory / 'PythonBridgeRuntime'.
	vEnvFolder := ('cd ', pyBridgeFolder suForCommand, '; ', PBPharoPipenvProcess pipenvPath suForCommand, ' --venv') asSuCommand output trimBoth asFileReference.
	playwrightFile := vEnvFolder / 'bin/playwright'.
	cmdString := 'cd "', pyBridgeFolder fullName, '"; ', playwrightFile fullName, ' install'.
	
	cmdString asSuCommand run
]

{ #category : 'initialization' }
RlPlaywright class >> shutDown: quitting [
	quitting ifFalse: [ ^ self ].

	PythonInstance ifNotNil: #stop.
	PythonInstance := nil
]

{ #category : 'accessing' }
RlPlaywright class >> start [
	| template |
	
	PythonInstance ifNotNil: [ ^ self ].
	
	template := 'from playwright.sync_api import sync_playwright'.

	PythonInstance := PBApplication uniqueInstance newCommandStringFactory
    	script: template;
	    resultExpression: 'sync_playwright().start()';
	    sendAndWait.
]

{ #category : 'accessing' }
RlPlaywright class >> stop [
	PythonInstance ifNil: [ ^ self ].
	
	[ PythonInstance send: #stop ] on: Exception do: [].
	PythonInstance := nil
]

{ #category : 'accessing' }
RlPlaywright class >> uniqueInstance [
	^ self new
]

{ #category : 'accessing' }
RlPlaywright >> gtDirFor: aView [
	<gtView>
	
	PythonInstance ifNil: [ ^ aView empty ].
	^ aView forward
		object: [ self pythonInstance ];
		view: #gtDirFor:
]

{ #category : 'accessing' }
RlPlaywright >> initialize [
	super initialize.
	self class start.
]

{ #category : 'convenience' }
RlPlaywright >> launch: browser isHeadless: aBoolean [
	"browser - e.g. firefox, chromium, webkit"
	| proxy |
	proxy:= self pythonInstance newCommandFactory
		<< (P3GCall target: self pythonInstance => browser => #launch  positionalArguments: nil keywordArguments: { #headless -> aBoolean } asDictionary);
		sendAndWait.
	^ RlPlaywrightBrowser on: proxy
]

{ #category : 'convenience' }
RlPlaywright >> pythonInstance [
	PythonInstance ifNil: [ self class start ].
	^ PythonInstance
]

{ #category : 'accessing' }
RlPlaywright >> show: media [

	| browserProxy pageProxy browser |
	browserProxy := self pythonInstance newCommandFactory
		<< (P3GCall target: self pythonInstance => #firefox => #launch keywordArguments: { #headless -> false } asDictionary);
		sendAndWait.
	pageProxy := browserProxy newCommandFactory
		<< (P3GCall target: browserProxy => #new_page);
		sendAndWait.
	pageProxy newCommandFactory
		<< (P3GCall target: pageProxy => #goto positionalArguments: { media url asString });
		sendAndWait.
	browser := RlPlaywrightBrowser on: browserProxy.
	^ RlPlaywrightPage on: pageProxy inBrowser: browser.
]
