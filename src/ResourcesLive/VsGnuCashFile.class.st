Class {
	#name : 'VsGnuCashFile',
	#superclass : 'RlResource',
	#category : 'ResourcesLive',
	#package : 'ResourcesLive'
}

{ #category : 'accessing' }
VsGnuCashFile class >> fileExtensions [
	^ #('gnucash')
]

{ #category : 'accessing' }
VsGnuCashFile >> uncompress [

	| target |
	target := Tempfile withSuffix: '.xml'.
	SuGenericUnixCommand new
		template: '/usr/bin/gunzip -c {source} > {target}';
		argumentAt: #source put: self file;
		argumentAt: #target put: target;
		run.
	^ target
]
