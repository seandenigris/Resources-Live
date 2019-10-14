"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestResourcesLive,
	#superclass : #PackageManifest,
	#category : #'ResourcesLive-Manifest'
}

{ #category : #'code-critics' }
ManifestResourcesLive class >> ruleRBUsesAddRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#RlResourceLibrary #import:into:moving: #false)) #'2019-08-04T13:49:12.992229-04:00') #(#(#RGMethodDefinition #(#RlResourceLibrary #importInPlace: #false)) #'2019-08-04T13:49:23.951642-04:00') )
]
