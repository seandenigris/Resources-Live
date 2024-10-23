Class {
	#name : #RlEmailMsg,
	#superclass : #RlEmail,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlEmailMsg class >> fileExtensions [
	^ #('msg')
]

{ #category : #'as yet unclassified' }
RlEmailMsg >> asRlEmail [

	| emlFile |
	emlFile := Tempfile named: self file base, '.eml'.

	PBApplication uniqueInstance newCommandStringFactory
		addAllBindings: {
			#msgFilename -> self file fullName.
			#emlFilename -> emlFile fullName } asDictionary;
		script: 'import extract_msg
from email import policy

msg = extract_msg.openMsg(msgFilename)
with open(emlFilename, ''wb'') as eml_file:
    eml_file.write(msg.asEmailMessage().as_bytes(policy=policy.default))';
    sendAndWait.
    
    ^ RlEmail on: emlFile.
    
    "Implementation note: chose extract-msg library per SO:
    	1. https://stackoverflow.com/a/71049033
    	2. https://stackoverflow.com/a/74232256"
]

{ #category : #accessing }
RlEmailMsg >> mailMessage [
	
	self file exists ifFalse: [ ^ nil ].
	
	^ self asRlEmail mailMessage
]
