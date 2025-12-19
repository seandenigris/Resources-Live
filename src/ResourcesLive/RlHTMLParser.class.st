Class {
	#name : 'RlHTMLParser',
	#superclass : 'SmaCCGLRParser',
	#category : 'ResourcesLive-EPUB',
	#package : 'ResourcesLive',
	#tag : 'EPUB'
}

{ #category : 'generated' }
RlHTMLParser class >> ambiguousTransitions [
^#(
#[ 0 6 0 21] 
#[ 0 6 0 25] 
#[ 0 21 0 34] 
#[ 0 25 0 34] 
#[ 0 97 0 118] 
#[ 0 101 0 118] 
#[ 0 105 0 118] 
#[ 0 122 0 126] 
#[ 0 122 0 201] 
#[ 0 122 0 205] 
#[ 0 117 0 154] 
#[ 0 117 0 178]
	).
]

{ #category : 'generated-accessing' }
RlHTMLParser class >> cacheId [
	^'2020-10-09T22:53:00.739177-04:00'
]

{ #category : 'generated' }
RlHTMLParser class >> definitionComment [
"/*
 [The ""BSD licence""]
 Copyright (c) 2013 Tom Everett
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*lexer grammar  HTMLLexer;*/

%glr;
/*parser grammar HTMLParser;*/

/* TODO: options { tokenVocab=HTMLLexer; } */

htmlDocument
    : (scriptlet | <SEA_WS>)* xml? (scriptlet | <SEA_WS>)* dtd? (scriptlet | <SEA_WS>)* htmlElements*
    ;

htmlElements
    : htmlMisc* htmlElement htmlMisc*
    ;

htmlElement
    : <TAG_OPEN> htmlTagName htmlAttribute* <TAG_CLOSE> htmlContent <TAG_OPEN> <TAG_SLASH> htmlTagName <TAG_CLOSE>
    | <TAG_OPEN> htmlTagName htmlAttribute* <TAG_SLASH_CLOSE>
    | <TAG_OPEN> htmlTagName htmlAttribute* <TAG_CLOSE>
    | scriptlet
    | script
    | style
    ;

htmlContent
    : htmlChardata? ((htmlElement | xhtmlCDATA | htmlComment) htmlChardata?)*
    ;

htmlAttribute
    : htmlAttributeName <TAG_EQUALS> htmlAttributeValue
    | htmlAttributeName
    ;

htmlAttributeName
    : <TAG_NAME>
    ;

htmlAttributeValue
    : <ATTVALUE_VALUE>
    ;

htmlTagName
    : <TAG_NAME>
    ;

htmlChardata
    : <HTML_TEXT>
    | <SEA_WS>
    ;

htmlMisc
    : htmlComment
    | <SEA_WS>
    ;

htmlComment
    : <HTML_COMMENT>
    | <HTML_CONDITIONAL_COMMENT>
    ;

xhtmlCDATA
    : <CDATA>
    ;

dtd
    : <DTD>
    ;

xml
    : <XML_DECLARATION>
    ;

scriptlet
    : <SCRIPTLET>
    ;

script
    : <SCRIPT_OPEN> ( <SCRIPT_BODY> | <SCRIPT_SHORT_BODY>)
    ;

style
    : <STYLE_OPEN> ( <STYLE_BODY> | <STYLE_SHORT_BODY>)
    ;


<HTML_COMMENT>
    : \<\!\-\- .*/* TODO: ? */ \-\-\>
    ;

<HTML_CONDITIONAL_COMMENT>
    : \<\!\[ .*/* TODO: ? */ \]\>
    ;

<XML_DECLARATION>
    : \<\?xml .*/* TODO: ? */ \>
    ;

<CDATA>
    : \<\!\[CDATA\[ .*/* TODO: ? */ \]\]\>
    ;

<DTD>
    : \<\! .*/* TODO: ? */ \>
    ;

<SCRIPTLET>
    : \<\? .*/* TODO: ? */ \?\>
    | \<\% .*/* TODO: ? */ \%\>
    ;

<SEA_WS>
    :  (\ |\t|\r? \n)+
    ;

<SCRIPT_OPEN>
    : \<script .*/* TODO: ? */ \> /* TODO: ->pushMode(SCRIPT)*/
    ;

<STYLE_OPEN>
    : \<style .*/* TODO: ? */ \>  /* TODO: ->pushMode(STYLE)*/
    ;

<TAG_OPEN>
    : \< /* TODO: -> pushMode(TAG)*/
    ;

<HTML_TEXT>
    : [^\<]+
    ;

#
# tag declarations
#


TAG <TAG_CLOSE>
    : \> /* TODO: -> popMode*/
    ;

TAG <TAG_SLASH_CLOSE>
    : \/\> /* TODO: -> popMode*/
    ;

TAG <TAG_SLASH>
    : \/
    ;

#
# lexing mode for attribute values
#
TAG <TAG_EQUALS>
    : \= /* TODO: -> pushMode(ATTVALUE)*/
    ;

TAG <TAG_NAME>
    : <TAG_NameStartChar> <TAG_NameChar>*
    ;

TAG <TAG_WHITESPACE>
    : [\ \t\r\n] /* TODO: -> skip*/
    ;

TAG <HEXDIGIT>
    : [a-fA-F0-9]
    ;

TAG <DIGIT>
    : [0-9]
    ;

TAG <TAG_NameChar>
    : <TAG_NameStartChar>
    | \-
    | _
    | \.
    | <DIGIT>
    |   \x00B7
    |   [\x0300-\x036F]
    |   [\x203F-\x2040]
    ;

TAG <TAG_NameStartChar>
    :   [\:a-zA-Z]
    |   [\x2070-\x218F]
    |   [\x2C00-\x2FEF]
    |   [\x3001-\xD7FF]
    |   [\xF900-\xFDCF]
    |   [\xFDF0-\xFFFD]
    ;

#
# <scripts>
#


SCRIPT <SCRIPT_BODY>
    : .*/* TODO: ? */ \<\/script\> /* TODO: -> popMode*/
    ;

SCRIPT <SCRIPT_SHORT_BODY>
    : .*/* TODO: ? */ \<\/\> /* TODO: -> popMode*/
    ;

#
# <styles>
#


STYLE <STYLE_BODY>
    : .*/* TODO: ? */ \<\/style\> /* TODO: -> popMode*/
    ;

STYLE <STYLE_SHORT_BODY>
    : .*/* TODO: ? */ \<\/\> /* TODO: -> popMode*/
    ;

#
# attribute values
#


# an attribute value may have spaces b/t the '=' and the value
ATTVALUE <ATTVALUE_VALUE>
    : [\ ]* <ATTRIBUTE> /* TODO: -> popMode*/
    ;

ATTVALUE <ATTRIBUTE>
    : <DOUBLE_QUOTE_STRING>
    | <SINGLE_QUOTE_STRING>
    | <ATTCHARS>
    | <HEXCHARS>
    | <DECCHARS>
    ;

ATTVALUE <ATTCHAR>
    : \-
    | _
    | \.
    | \/
    | \+
    | \,
    | \?
    | \=
    | \:
    | \;
    | \#
    | [0-9a-zA-Z]
    ;

ATTVALUE <ATTCHARS>
    : <ATTCHAR>+ \ ?
    ;

ATTVALUE <HEXCHARS>
    : \# [0-9a-fA-F]+
    ;

ATTVALUE <DECCHARS>
    : [0-9]+ \%?
    ;

ATTVALUE <DOUBLE_QUOTE_STRING>
    : \"" [^\<\""]* \""
    ;

ATTVALUE <SINGLE_QUOTE_STRING>
    : \' [^\<\']* \'
    ;"
]

{ #category : 'generated' }
RlHTMLParser class >> reduceTable [
^#(
	#(25 0 #reduceFor: 1613825 false ) 
	#(43 1 #reduceFor: 2647041 false ) 
	#(44 1 #reduceFor: 2682881 false ) 
	#(24 1 #reduceFor: 1613826 false ) 
	#(25 2 #reduceFor: 1613826 false ) 
	#(24 1 #reduceFor: 1613825 false ) 
	#(42 1 #reduceFor: 2623489 false ) 
	#(26 0 #reduceFor: 1697793 false ) 
	#(28 0 #reduceFor: 1738753 false ) 
	#(23 4 #reduceFor: 1594369 false ) 
	#(26 2 #reduceFor: 1697794 false ) 
	#(23 5 #reduceFor: 1594370 false ) 
	#(23 5 #reduceFor: 1594371 false ) 
	#(40 1 #reduceFor: 2515969 false ) 
	#(40 1 #reduceFor: 2515970 false ) 
	#(39 1 #reduceFor: 2465794 false ) 
	#(28 2 #reduceFor: 1738754 false ) 
	#(39 1 #reduceFor: 2465793 false ) 
	#(29 1 #reduceFor: 1778692 false ) 
	#(29 1 #reduceFor: 1778693 false ) 
	#(29 1 #reduceFor: 1778694 false ) 
	#(23 6 #reduceFor: 1594372 false ) 
	#(45 2 #reduceFor: 2718721 false ) 
	#(45 2 #reduceFor: 2718722 false ) 
	#(46 2 #reduceFor: 2793473 false ) 
	#(46 2 #reduceFor: 2793474 false ) 
	#(37 1 #reduceFor: 2374657 false ) 
	#(30 0 #reduceFor: 1820673 false ) 
	#(27 3 #reduceFor: 1719297 false ) 
	#(29 4 #reduceFor: 1778691 false ) 
	#(33 0 #reduceFor: 2111489 false ) 
	#(29 4 #reduceFor: 1778690 false ) 
	#(35 1 #reduceFor: 2281473 false ) 
	#(30 2 #reduceFor: 1820674 false ) 
	#(34 1 #reduceFor: 2178050 false ) 
	#(38 1 #reduceFor: 2411522 false ) 
	#(38 1 #reduceFor: 2411521 false ) 
	#(31 1 #reduceFor: 2078721 false ) 
	#(41 1 #reduceFor: 2590721 false ) 
	#(32 1 #reduceFor: 2111489 false ) 
	#(33 2 #reduceFor: 2111490 false ) 
	#(32 1 #reduceFor: 2111493 false ) 
	#(32 1 #reduceFor: 2111491 false ) 
	#(31 2 #reduceFor: 2078722 false ) 
	#(36 1 #reduceFor: 2324481 false ) 
	#(34 3 #reduceFor: 2178049 false ) 
	#(32 2 #reduceFor: 2111490 false ) 
	#(32 2 #reduceFor: 2111494 false ) 
	#(32 2 #reduceFor: 2111492 false ) 
	#(29 9 #reduceFor: 1778689 false )
	).
]

{ #category : 'generated' }
RlHTMLParser class >> scannerClass [
	^RlHTMLScanner
]

{ #category : 'generated' }
RlHTMLParser class >> startingStateForhtmlDocument [
	^ 1
]

{ #category : 'generated' }
RlHTMLParser class >> symbolNames [
	^ #('<HTML_COMMENT>' '<HTML_CONDITIONAL_COMMENT>' '<XML_DECLARATION>' '<CDATA>' '<DTD>' '<SCRIPTLET>' '<SEA_WS>' '<SCRIPT_OPEN>' '<STYLE_OPEN>' '<TAG_OPEN>' '<HTML_TEXT>' '<TAG_CLOSE>' '<TAG_SLASH_CLOSE>' '<TAG_SLASH>' '<TAG_EQUALS>' '<TAG_NAME>' '<SCRIPT_BODY>' '<SCRIPT_SHORT_BODY>' '<STYLE_BODY>' '<STYLE_SHORT_BODY>' '<ATTVALUE_VALUE>' 'B e g i n' 'htmlDocument' '(scriptlet | <SEA_WS>)' '(scriptlet | <SEA_WS>)*' 'htmlElements*' 'htmlElements' 'htmlMisc*' 'htmlElement' 'htmlAttribute*' 'htmlContent' '((htmlElement | xhtmlCDATA | htmlComment) htmlChardata?)' '((htmlElement | xhtmlCDATA | htmlComment) htmlChardata?)*' 'htmlAttribute' 'htmlAttributeName' 'htmlAttributeValue' 'htmlTagName' 'htmlChardata' 'htmlMisc' 'htmlComment' 'xhtmlCDATA' 'dtd' 'xml' 'scriptlet' 'script' 'style' 'E O F' 'error')
]

{ #category : 'generated' }
RlHTMLParser class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 2 0 6 0 3 0 6 0 5 0 6 0 6 0 6 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 9 0 23 0 13 0 25 0 6 0 47] 
#[0 0 0 0 47] 
#[1 0 6 0 1 0 6 0 2 0 17 0 3 0 6 0 5 0 7 0 6 0 11 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 29 0 24 0 33 0 25 0 37 0 43 0 41 0 44 0 6 0 47] 
#[0 0 10 0 1 0 2 0 5 0 6 0 7 0 8 0 9 0 10 0 47] 
#[0 0 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 18 0 1 0 2 0 3 0 5 0 6 0 7 0 8 0 9 0 10 0 47] 
#[0 0 22 0 1 0 2 0 3 0 5 0 6 0 7 0 8 0 9 0 10 0 47] 
#[1 0 6 0 1 0 6 0 2 0 45 0 5 0 7 0 6 0 11 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 29 0 24 0 49 0 25 0 53 0 42 0 41 0 44 0 6 0 47] 
#[1 0 6 0 1 0 6 0 2 0 6 0 5 0 6 0 6 0 6 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 57 0 25 0 6 0 47] 
#[0 0 26 0 1 0 2 0 3 0 5 0 6 0 7 0 8 0 9 0 10 0 47] 
#[0 0 30 0 1 0 2 0 6 0 7 0 8 0 9 0 10 0 47] 
#[1 0 34 0 1 0 34 0 2 0 15 0 6 0 19 0 7 0 34 0 8 0 34 0 9 0 34 0 10 0 29 0 24 0 61 0 26 0 41 0 44 0 34 0 47] 
#[1 0 6 0 1 0 6 0 2 0 6 0 6 0 6 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 65 0 25 0 6 0 47] 
#[1 0 6 0 1 0 6 0 2 0 45 0 5 0 7 0 6 0 11 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 29 0 24 0 69 0 25 0 73 0 42 0 41 0 44 0 6 0 47] 
#[1 0 38 0 1 0 38 0 2 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 77 0 27 0 81 0 28 0 42 0 47] 
#[1 0 34 0 1 0 34 0 2 0 15 0 6 0 19 0 7 0 34 0 8 0 34 0 9 0 34 0 10 0 29 0 24 0 85 0 26 0 41 0 44 0 34 0 47] 
#[1 0 34 0 1 0 34 0 2 0 15 0 6 0 19 0 7 0 34 0 8 0 34 0 9 0 34 0 10 0 29 0 24 0 89 0 26 0 41 0 44 0 34 0 47] 
#[1 0 6 0 1 0 6 0 2 0 6 0 6 0 6 0 7 0 6 0 8 0 6 0 9 0 6 0 10 0 93 0 25 0 6 0 47] 
#[0 0 46 0 1 0 2 0 6 0 7 0 8 0 9 0 10 0 47] 
#[1 0 97 0 1 0 101 0 2 0 21 0 6 0 105 0 7 0 109 0 8 0 113 0 9 0 117 0 10 0 121 0 29 0 125 0 39 0 129 0 40 0 133 0 44 0 137 0 45 0 141 0 46] 
#[1 0 38 0 1 0 38 0 2 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 77 0 27 0 81 0 28 0 50 0 47] 
#[1 0 38 0 1 0 38 0 2 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 77 0 27 0 81 0 28 0 54 0 47] 
#[1 0 34 0 1 0 34 0 2 0 15 0 6 0 19 0 7 0 34 0 8 0 34 0 9 0 34 0 10 0 29 0 24 0 145 0 26 0 41 0 44 0 34 0 47] 
#[0 0 58 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 62 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 66 0 1 0 2 0 6 0 7 0 8 0 9 0 10 0 47] 
#[1 0 149 0 17 0 153 0 18] 
#[1 0 157 0 19 0 161 0 20] 
#[1 0 165 0 16 0 169 0 37] 
#[1 0 38 0 1 0 38 0 2 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 173 0 28 0 38 0 47] 
#[0 0 70 0 1 0 2 0 6 0 7 0 8 0 9 0 10 0 47] 
#[0 0 74 0 1 0 2 0 6 0 7 0 8 0 9 0 10 0 47] 
#[0 0 78 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 82 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 86 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[1 0 38 0 1 0 38 0 2 0 38 0 6 0 38 0 7 0 38 0 8 0 38 0 9 0 38 0 10 0 77 0 27 0 81 0 28 0 90 0 47] 
#[0 0 94 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 98 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 102 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 106 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 110 0 12 0 13 0 16] 
#[1 0 114 0 12 0 114 0 13 0 114 0 16 0 177 0 30] 
#[1 0 23 0 1 0 27 0 2 0 118 0 6 0 31 0 7 0 118 0 8 0 118 0 9 0 118 0 10 0 125 0 39 0 129 0 40 0 118 0 47] 
#[1 0 181 0 12 0 185 0 13 0 189 0 16 0 193 0 34 0 197 0 35] 
#[1 0 35 0 1 0 35 0 2 0 35 0 4 0 35 0 6 0 39 0 7 0 35 0 8 0 35 0 9 0 35 0 10 0 43 0 11 0 209 0 31 0 213 0 33 0 217 0 38 0 122 0 47] 
#[0 0 130 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47] 
#[0 0 134 0 12 0 13 0 15 0 16] 
#[0 0 138 0 12 0 13 0 16] 
#[1 0 142 0 12 0 142 0 13 0 221 0 15 0 142 0 16] 
#[0 0 146 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[0 0 150 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[0 0 225 0 10] 
#[1 0 97 0 1 0 101 0 2 0 229 0 4 0 21 0 6 0 109 0 8 0 113 0 9 0 47 0 10 0 233 0 29 0 237 0 32 0 241 0 40 0 245 0 41 0 133 0 44 0 137 0 45 0 141 0 46] 
#[1 0 126 0 1 0 126 0 2 0 126 0 4 0 126 0 6 0 126 0 8 0 126 0 9 0 126 0 10 0 249 0 33] 
#[1 0 253 0 21 1 1 0 36] 
#[0 1 5 0 14] 
#[0 0 158 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11] 
#[1 0 162 0 1 0 162 0 2 0 162 0 4 0 162 0 6 0 201 0 7 0 162 0 8 0 162 0 9 0 162 0 10 0 205 0 11 1 9 0 38] 
#[0 0 166 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[1 0 170 0 1 0 170 0 2 0 170 0 4 0 170 0 6 0 201 0 7 0 170 0 8 0 170 0 9 0 170 0 10 0 205 0 11 1 13 0 38] 
#[1 0 174 0 1 0 174 0 2 0 174 0 4 0 174 0 6 0 201 0 7 0 174 0 8 0 174 0 9 0 174 0 10 0 205 0 11 1 17 0 38] 
#[1 0 97 0 1 0 101 0 2 0 229 0 4 0 21 0 6 0 109 0 8 0 113 0 9 0 51 0 10 0 233 0 29 0 237 0 32 0 241 0 40 0 245 0 41 0 133 0 44 0 137 0 45 0 141 0 46] 
#[0 0 182 0 12 0 13 0 16] 
#[0 0 186 0 12 0 13 0 16] 
#[1 0 165 0 16 1 21 0 37] 
#[0 0 190 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[0 0 194 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[0 0 198 0 1 0 2 0 4 0 6 0 8 0 9 0 10] 
#[0 1 25 0 12] 
#[0 0 202 0 1 0 2 0 4 0 6 0 7 0 8 0 9 0 10 0 11 0 47]
	).
]
