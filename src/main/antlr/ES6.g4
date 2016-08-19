grammar ES6;

//SourceCharacter ::
//   any Unicode code point 

//InputElementDiv ::
//   WhiteSpace
//   LineTerminator
//   Comment
//   CommonToken
//   DivPunctuator
//   RightBracePunctuator
inputElementDiv
  : WhiteSpace
  | LineTerminator
  | Comment
  | commonToken
  | DivPunctuator
  | RightBracePunctuator
  ;
    
//  InputElementRegExp ::
//   WhiteSpace
//   LineTerminator
//   Comment
//   CommonToken
//   RightBracePunctuator
//   RegularExpressionLiteral
inputElementRegExp
  : WhiteSpace
  | LineTerminator
  | Comment
  | commonToken
  | RightBracePunctuator
  | RegularExpressionLiteral
  ;

//  InputElementRegExpOrTemplateTail ::
//   WhiteSpace
//   LineTerminator
//   Comment
//   CommonToken
//   RegularExpressionLiteral
//   TemplateSubstitutionTail
inputElementRegExpOrTemplateTail
  : WhiteSpace
  | LineTerminator
  | Comment
  | commonToken
  | RegularExpressionLiteral
  | templateSubstitutionTail
  ;

//  InputElementTemplateTail ::
//   WhiteSpace
//   LineTerminator
//   Comment
//   CommonToken
//   DivPunctuator
//   TemplateSubstitutionTail
inputElementTemplateTail
  : WhiteSpace
  | LineTerminator
  | Comment
  | commonToken
  | DivPunctuator
  | templateSubstitutionTail
  ;

//  WhiteSpace ::
//   <TAB>
//   <VT>
//   <FF>
//   <SP>
//   <NBSP>
//   <ZWNBSP>
//   <USP>
WhiteSpace
  : [\t\u000B\u000C\u0020\u00A0]
  ;

WhiteSpaces
 : [\t\u000B\u000C\u0020\u00A0]+ -> channel(HIDDEN)
 ;

//  LineTerminator ::
//   <LF>
//   <CR>
//   <LS>
//   <PS>
LineTerminator
 : [\r\n\u2028\u2029]
 ;

//  LineTerminatorSequence ::
//   <LF>
//   <CR> [lookahead ≠ <LF>]
//   <LS>
//   <PS>
//   <CR> <LF>
LineTerminatorSequence
 : '\r\n'
 | LineTerminator
 ;

//  Comment ::
//   MultiLineComment
//   SingleLineComment
Comment
  : MultiLineComment
  | SingleLineComment
  ;

//  MultiLineComment ::
//   /* MultiLineCommentCharsopt */
MultiLineComment
   : '/*' MultiLineCommentChars? '*/'
   ;

//  MultiLineCommentChars ::
//   MultiLineNotAsteriskChar MultiLineCommentCharsopt
//   * PostAsteriskCommentCharsopt
MultiLineCommentChars
 :  MultiLineNotAsteriskChar MultiLineCommentChars?
 |  '*' PostAsteriskCommentChars?
 ;

//  PostAsteriskCommentChars ::
//   MultiLineNotForwardSlashOrAsteriskChar MultiLineCommentCharsopt
//   * PostAsteriskCommentCharsopt
PostAsteriskCommentChars
  : MultiLineNotForwardSlashOrAsteriskChar MultiLineCommentChars?
  | '*' PostAsteriskCommentChars?
  ;

//  MultiLineNotAsteriskChar ::
//   SourceCharacter but not *
MultiLineNotAsteriskChar
  : ~[*]
  ;

//  MultiLineNotForwardSlashOrAsteriskChar ::
//   SourceCharacter but not one of / or *
MultiLineNotForwardSlashOrAsteriskChar
  : ~[/*]
  ;

//  SingleLineComment ::
//   // SingleLineCommentCharsopt
SingleLineComment
  : '//' SingleLineCommentChars?
  ;

//  SingleLineCommentChars ::
//   SingleLineCommentChar SingleLineCommentCharsopt
SingleLineCommentChars
  : SingleLineCommentChar SingleLineCommentChars?
  ;

//  SingleLineCommentChar ::
//   SourceCharacter but not LineTerminator
SingleLineCommentChar
  : ~[\r\n\u2028\u2029]
  ;

//  CommonToken ::
//   IdentifierName
//   Punctuator
//   NumericLiteral
//   StringLiteral
//   Template
commonToken
  : IdentifierName
  | Punctuator
  | NumericLiteral
  | StringLiteral
  | template
  ;

//  IdentifierName ::
//   IdentifierStart
//   IdentifierName IdentifierPart
IdentifierName
  : IdentifierStart IdentifierPart*
  ;

//  IdentifierStart ::
//   UnicodeIDStart
//   $
//   _
//   \ UnicodeEscapeSequence
IdentifierStart
  : UnicodeIDStart
  | '$'
  | '_'
  | '\\' UnicodeEscapeSequence
  ;

//  IdentifierPart ::
//   UnicodeIDContinue
//   $
//   _
//   \ UnicodeEscapeSequence
//   <ZWNJ>
//   <ZWJ>
IdentifierPart
  : UnicodeIDContinue
  | '$'
  | '_'
  | '\\' UnicodeEscapeSequence
  | ZWNJ
  | ZWJ
  ;

fragment ZWNJ
 : '\u200C'
 ;

fragment ZWJ
 : '\u200D'
 ;

//  UnicodeIDStart ::
//   any Unicode code point with the Unicode property "ID_Start" or "Other_ID_Start"
UnicodeIDStart
  : //any Unicode code point with the Unicode property "ID_Start" or "Other_ID_Start"
  ;

//  UnicodeIDContinue ::
//   any Unicode code point with the Unicode property "ID_Continue" or "Other_ID_Continue", or "Other_ID_Start"
UnicodeIDContinue
  : //any Unicode code point with the Unicode property "ID_Continue" or "Other_ID_Continue", or "Other_ID_Start"
  ;

//  ReservedWord ::
//   Keyword
//   FutureReservedWord
//   NullLiteral
//   BooleanLiteral
ReservedWord
  : Keyword
  | FutureReservedWord
  | NullLiteral
  | BooleanLiteral
  ;

//  Keyword :: one of
//
//   break      do         in         typeof     case
//   else       instanceof var        catch      export
//   new        void       class      extends    return
//   while      const      finally    super      with
//   continue   for        switch     yield      debugger
//   function   this       default    if         throw
//   delete     import     try
Keyword
  : 'break'     | 'do'         | 'in'        | 'typeof'    | 'case'
  | 'else'      | 'instanceof' | 'var'       | 'catch'     | 'export'
  | 'new'       | 'void'       | 'class'     | 'extends'   | 'return'
  | 'while'     | 'const'      | 'finally'   | 'super'     | 'with'
  | 'continue'  | 'for'        | 'switch'    | 'yield'     | 'debugger'
  | 'function'  | 'this'       | 'default'   | 'if'        | 'throw'
  | 'delete'    | 'import'     | 'try'
  ;

//  FutureReservedWord :: one of
//   enum       await      implements package    protected
//   interface  private    public
FutureReservedWord
  : 'enum'       | 'await'      | 'implements' | 'package'    | 'protected'
  | 'interface'  | 'private'    | 'public'
  ;

//  Punctuator :: one of
//   {     }     (     )     [     ]     .     ;     ,     <
//   >     <=    >=    ==    !=    ===   !==   +     -     *
//   %     ++    --    <<    >>    >>>   &     |     ^     !
//   ~     &&    ||    ?      ::   =     +=    -=    *=    %=
//   <<=   >>=   >>>=  &=    |=    ^=    =>
Punctuator
  : '{'     | '}'     | '('     | ')'     | '['     | ']'     | '.'     | ';'     | ','     | '<'
  | '>'     | '<='    | '>='    | '=='    | '!='    | '==='   | '!=='   | '+'     | '-'     | '*'
  | '%'     | '++'    | '--'    | '<<'    | '>>'    | '>>>'   | '&'     | '|'     | '^'     | '!'
  | '~'     | '&&'    | '||'    | '?'     | '::'    | '='     | '+='    | '-='    | '*='    | '%='
  | '<<='   | '>>='   | '>>>='  | '&='    | '|='    | '^='    | '=>'
  ;

//  DivPunctuator :: one of
//   /     /=
DivPunctuator
  : '/' | '/='
  ;

//  RightBracePunctuator :: one of
//   )
RightBracePunctuator
  : ')'
  ;

//  NullLiteral ::
//   null
NullLiteral
  : 'null'
  ;

//  BooleanLiteral ::
//   true
//   false
BooleanLiteral
  : 'true'
  | 'false'
  ;

//  NumericLiteral ::
//   DecimalLiteral
//   BinaryIntegerLiteral
//   OctalIntegerLiteral
//   HexIntegerLiteral
NumericLiteral
  : DecimalLiteral
  | BinaryIntegerLiteral
  | OctalIntegerLiteral
  | HexIntegerLiteral
  ;

//  DecimalLiteral ::
//   DecimalIntegerLiteral . DecimalDigitsopt ExponentPartopt
//   . DecimalDigits ExponentPartopt
//   DecimalIntegerLiteral ExponentPartopt
DecimalLiteral
  : DecimalIntegerLiteral '.' DecimalDigits? ExponentPart?
  | '.' DecimalDigits ExponentPart?
  | DecimalIntegerLiteral ExponentPart?
  ;

//  DecimalIntegerLiteral ::
//   0
//   NonZeroDigit DecimalDigitsopt
DecimalIntegerLiteral
  : '0'
  | NonZeroDigit DecimalDigits?
  ;

//  DecimalDigits ::
//   DecimalDigit
//   DecimalDigits DecimalDigit
DecimalDigits
  : DecimalDigit+
//  | DecimalDigits DecimalDigit
  ;

//  DecimalDigit :: one of
//   0     1     2     3     4     5     6     7     8     9
DecimalDigit
  : [0-9]
  ;

//  NonZeroDigit :: one of
//   1     2     3     4     5     6     7     8     9
NonZeroDigit
  : [1-9]
  ;

//  ExponentPart ::
//   ExponentIndicator SignedInteger
ExponentPart
  : ExponentIndicator SignedInteger
  ;

//  ExponentIndicator :: one of
//   e     E
ExponentIndicator
  : 'e' | 'E'
  ;

//  SignedInteger ::
//   DecimalDigits
//   + DecimalDigits
//   - DecimalDigits
SignedInteger
  : DecimalDigits
  | '+' DecimalDigits
  | '-' DecimalDigits
  ;

//  BinaryIntegerLiteral ::
//   0b BinaryDigits
//   0B BinaryDigits
//  BinaryDigits ::
//   BinaryDigit
//   BinaryDigits BinaryDigit
BinaryIntegerLiteral
  : '0' [bB] BinaryDigit+
  ;

//  BinaryDigit :: one of
//   0     1
BinaryDigit
  : '0' | '1'
  ;

//  OctalIntegerLiteral ::
//   0o OctalDigits
//   0O OctalDigits
//  OctalDigits ::
//   OctalDigit
//   OctalDigits OctalDigit
OctalIntegerLiteral
  : '0' [oO] OctalDigit+
  ;

//  OctalDigit :: one of
//   0     1     2     3     4     5     6     7
OctalDigit
  : [0-7]
  ;

//  HexIntegerLiteral ::
//   0x HexDigits
//   0X HexDigits
//
//  HexDigits ::
//   HexDigit
//   HexDigits HexDigit
HexIntegerLiteral
  : '0' [xX] HexDigit+;

//  HexDigit :: one of
//   0     1     2     3     4     5     6     7     8     9
//   a     b     c     d     e     f     A     B     C     D
//   E     F
HexDigit
  : [0-9a-fA-F]
  ;

//  StringLiteral ::
//   " DoubleStringCharactersopt "
//   ' SingleStringCharactersopt '
StringLiteral
  : '"' DoubleStringCharacters? '"'
  | '\'' SingleStringCharacters? '\''
  ;

//  DoubleStringCharacters ::
//   DoubleStringCharacter DoubleStringCharactersopt
DoubleStringCharacters
  : DoubleStringCharacter DoubleStringCharacters?
  ;

//  SingleStringCharacters ::
//   SingleStringCharacter SingleStringCharactersopt
SingleStringCharacters
  : SingleStringCharacter SingleStringCharacters?
  ;

//  DoubleStringCharacter ::
//   SourceCharacter but not one of " or \ or LineTerminator
//   \ EscapeSequence
//   LineContinuation
DoubleStringCharacter
  : ~('"' | '\\' | LineTerminator)
  | '\\' EscapeSequence
  | LineContinuation
  ;

//  SingleStringCharacter ::
//   SourceCharacter but not one of ' or \ or LineTerminator
//   \ EscapeSequence
//   LineContinuation
SingleStringCharacter
  : ~('\'' | '\\' | LineTerminator)
  | '\\' EscapeSequence
  | LineContinuation
  ;

//  LineContinuation ::
//   \ LineTerminatorSequence
LineContinuation
  : '\\' LineTerminatorSequence
  ;

//  EscapeSequence ::
//   CharacterEscapeSequence
//   0 [lookahead ≠ DecimalDigit]
//   HexEscapeSequence
//   UnicodeEscapeSequence
EscapeSequence
  : CharacterEscapeSequence
  | '0' {_input.LA(1) !=  DecimalDigit}?
  | HexEscapeSequence
  | UnicodeEscapeSequence
  ;

//  CharacterEscapeSequence ::
//   SingleEscapeCharacter
//   NonEscapeCharacter
CharacterEscapeSequence
  : SingleEscapeCharacter
  | NonEscapeCharacter
  ;

//  SingleEscapeCharacter :: one of
//   '     "     \     b     f     n     r     t     v
SingleEscapeCharacter
  : '\'' | '"' | '\\' | 'b' | 'f' | 'n' | 'r' | 't' | 'v'
  ;

//  NonEscapeCharacter ::
//   SourceCharacter but not one of EscapeCharacter or LineTerminator
NonEscapeCharacter
  : ~(EscapeCharacter | LineTerminator)
  ;

//  EscapeCharacter ::
//   SingleEscapeCharacter
//   DecimalDigit
//   x
//   u
EscapeCharacter
  : SingleEscapeCharacter
  | DecimalDigit
  | 'x'
  | 'u'
  ;

//  HexEscapeSequence ::
//   x HexDigit HexDigit
HexEscapeSequence
  : 'x' HexDigit HexDigit
  ;

//  UnicodeEscapeSequence ::
//   u Hex4Digits
//   u{ HexDigits }
UnicodeEscapeSequence
  : 'u' Hex4Digits
  | 'u{' HexDigit+ '}'
  ;

//  Hex4Digits ::
//   HexDigit HexDigit HexDigit HexDigit
Hex4Digits
  : HexDigit HexDigit HexDigit HexDigit
  ;

//  RegularExpressionLiteral ::
//   / RegularExpressionBody / RegularExpressionFlags
RegularExpressionLiteral
  : '/' RegularExpressionBody '/' RegularExpressionFlags
  ;

//  RegularExpressionBody ::
//   RegularExpressionFirstChar RegularExpressionChars
RegularExpressionBody
  : RegularExpressionFirstChar RegularExpressionChars
  ;

//  RegularExpressionChars ::
//   [empty]
//   RegularExpressionChars RegularExpressionChar
RegularExpressionChars
  : RegularExpressionChar*
  ;

//  RegularExpressionFirstChar ::
//   RegularExpressionNonTerminator but not one of * or \ or / or [
//   RegularExpressionBackslashSequence
//   RegularExpressionClass
RegularExpressionFirstChar
  : RegularExpressionNonTerminator ~('*' | '\\' | '/' | '[')
  | RegularExpressionBackslashSequence
  | RegularExpressionClass
  ;

//  RegularExpressionChar ::
//   RegularExpressionNonTerminator but not one of \ or / or [
//   RegularExpressionBackslashSequence
//   RegularExpressionClass
RegularExpressionChar
  : RegularExpressionNonTerminator ~('\\' | '/' | '[')
  | RegularExpressionBackslashSequence
  | RegularExpressionClass
  ;

//  RegularExpressionBackslashSequence ::
//   \ RegularExpressionNonTerminator
RegularExpressionBackslashSequence
  : '\\' RegularExpressionNonTerminator
  ;

//  RegularExpressionNonTerminator ::
//   SourceCharacter but not LineTerminator
RegularExpressionNonTerminator
  : ~LineTerminator
  ;

//  RegularExpressionClass ::
//   [ RegularExpressionClassChars ]
RegularExpressionClass
  : '[' RegularExpressionClassChars ']'
  ;

//  RegularExpressionClassChars ::
//   [empty]
//   RegularExpressionClassChars RegularExpressionClassChar
RegularExpressionClassChars
  : RegularExpressionClassChar*
  ;

//  RegularExpressionClassChar ::
//   RegularExpressionNonTerminator but not one of ] or \
//   RegularExpressionBackslashSequence
RegularExpressionClassChar
  : RegularExpressionNonTerminator ~(']' | '\\')
  | RegularExpressionBackslashSequence
  ;

//  RegularExpressionFlags ::
//   [empty]
//   RegularExpressionFlags IdentifierPart
RegularExpressionFlags
  : IdentifierPart*
  ;

//  Template ::
//   NoSubstitutionTemplate
//   TemplateHead
template
  : noSubstitutionTemplate
  | templateHead
  ;

//  NoSubstitutionTemplate ::
//   ` TemplateCharactersopt `
noSubstitutionTemplate
  : '`' templateCharacters? '`'
  ;

//  TemplateHead ::
//   ` TemplateCharactersopt ${
templateHead
  : '`' templateCharacters? '${'
  ;

//  TemplateSubstitutionTail ::
//   TemplateMiddle
//   TemplateTail
templateSubstitutionTail
  : templateMiddle
  | templateTail
  ;

//  TemplateMiddle ::
//   } TemplateCharactersopt ${
templateMiddle
  : '}' templateCharacters? '${'
  ;

//  TemplateTail ::
//   } TemplateCharactersopt `
templateTail
  : '}' templateCharacters? '`'
  ;

//  TemplateCharacters ::
//   TemplateCharacter TemplateCharactersopt
templateCharacters
  : templateCharacter templateCharacters?
  ;

//  TemplateCharacter ::
//   $ [lookahead ≠ {]
//   \ EscapeSequence
//   LineContinuation
//   LineTerminatorSequence
//   SourceCharacter but not one of ` or \ or $ or LineTerminator
templateCharacter
  : '$' {(_input.LA(1) != '{')}?
  | '\\' EscapeSequence
  | LineContinuation
  | LineTerminatorSequence
  | ~('`' | '\\' | '$' | LineTerminator)
  ;

//  IdentifierReference[Yield] :
//   Identifier
//   [~Yield] yield
identifierReference
  : identifier
  | 'yield'
  ;

identifierReference_Yield
  : identifier
  ;

//  BindingIdentifier[Yield] :
//   Identifier
//   [~Yield] yield
bindingIdentifier
  : identifier
  | 'yield'
  ;

bindingIdentifier_Yield
  : identifier
  ;

//  LabelIdentifier[Yield] :
//   Identifier
//   [~Yield] yield
labelIdentifier
  : identifier
  | 'yield'
  ;

labelIdentifier_Yield
  : identifier
  ;

//  Identifier :
//   IdentifierName but not ReservedWord
identifier
  : IdentifierName ~ReservedWord
  ;

//  PrimaryExpression[Yield] :
//   this
//   IdentifierReference[?Yield]
//   Literal
//   ArrayLiteral[?Yield]
//   ObjectLiteral[?Yield]
//   FunctionExpression
//   ClassExpression[?Yield]
//   GeneratorExpression
//   RegularExpressionLiteral
//   TemplateLiteral[?Yield]
//   CoverParenthesizedExpressionAndArrowParameterList[?Yield]
primaryExpression
  : 'this'
  | identifierReference
  | Literal
  | arrayLiteral
  | objectLiteral
  | functionExpression
  | classExpression
  | generatorExpression
  | RegularExpressionLiteral
  | templateLiteral
  | coverParenthesizedExpressionAndArrowParameterList
  ;

primaryExpression_Yield
  : 'this'
  | identifierReference_Yield
  | Literal
  | arrayLiteral_Yield
  | objectLiteral_Yield
  | functionExpression
  | classExpression_Yield
  | generatorExpression
  | RegularExpressionLiteral
  | templateLiteral_Yield
  | coverParenthesizedExpressionAndArrowParameterList_Yield
  ;

//  CoverParenthesizedExpressionAndArrowParameterList[Yield] :
//   ( Expression[In, ?Yield] )
//   ( )
//   ( ... BindingIdentifier[?Yield] )
//   ( Expression[In, ?Yield] , ... BindingIdentifier[?Yield] )
coverParenthesizedExpressionAndArrowParameterList
  : '(' expression_In ')'
  | '(' ')'
  | '(' '...' bindingIdentifier ')'
  | '(' expression_In ',' '...' bindingIdentifier ')'
  ;

coverParenthesizedExpressionAndArrowParameterList_Yield
  : '(' expression_In_Yield ')'
  | '(' ')'
  | '(' '...' bindingIdentifier_Yield ')'
  | '(' expression_In_Yield ',' '...' bindingIdentifier_Yield ')'
  ;

//  Literal :
//   NullLiteral
//   BooleanLiteral
//   NumericLiteral
//   StringLiteral
Literal
  : NullLiteral
  | BooleanLiteral
  | NumericLiteral
  | StringLiteral
  ;

//  ArrayLiteral[Yield] :
//   [ Elisionopt ]
//   [ ElementList[?Yield] ]
//   [ ElementList[?Yield] , Elisionopt ]
arrayLiteral
  : '[' Elision? ']'
  | '[' elementList ']'
  | '[' elementList ',' Elision? ']'
  ;

arrayLiteral_Yield
  : '[' Elision? ']'
  | '[' elementList_Yield ']'
  | '[' elementList_Yield ',' Elision? ']'
  ;

//  ElementList[Yield] :
//   Elisionopt AssignmentExpression[In, ?Yield]
//   Elisionopt SpreadElement[?Yield]
//   ElementList[?Yield] , Elisionopt AssignmentExpression[In, ?Yield]
//   ElementList[?Yield] , Elisionopt SpreadElement[?Yield]
elementList
  : Elision? (assignmentExpression_In | spreadElement) (',' Elision? (assignmentExpression_In | spreadElement))*
  ;

elementList_Yield
  : Elision? (assignmentExpression_In_Yield | spreadElement_Yield) (',' Elision? (assignmentExpression_In_Yield | spreadElement_Yield))*
  ;

//  Elision :
//   ,
//   Elision ,
Elision
  : ','+
  ;

//  SpreadElement[Yield] :
//   ... AssignmentExpression[In, ?Yield]
spreadElement
  : '...' assignmentExpression_In
  ;

spreadElement_Yield
  : '...' assignmentExpression_In_Yield
  ;

//  ObjectLiteral[Yield] :
//   { }
//   { PropertyDefinitionList[?Yield] }
//   { PropertyDefinitionList[?Yield] , }
objectLiteral
  : '{' '}'
  | '{' propertyDefinitionList '}'
  | '{' propertyDefinitionList ',' '}'
  ;

objectLiteral_Yield
  : '{' '}'
  | '{' propertyDefinitionList_Yield '}'
  | '{' propertyDefinitionList_Yield ',' '}'
  ;

//  PropertyDefinitionList[Yield] :
//   PropertyDefinition[?Yield]
//   PropertyDefinitionList[?Yield] , PropertyDefinition[?Yield]
propertyDefinitionList
  : propertyDefinition (',' propertyDefinition)*
  ;

propertyDefinitionList_Yield
  : propertyDefinition_Yield (',' propertyDefinition_Yield)*
  ;

//  PropertyDefinition[Yield] :
//   IdentifierReference[?Yield]
//   CoverInitializedName[?Yield]
//   PropertyName[?Yield] : AssignmentExpression[In, ?Yield]
//   MethodDefinition[?Yield]
propertyDefinition
  : identifierReference
  | coverInitializedName
  | propertyName ':' assignmentExpression_In
  | methodDefinition
  ;

propertyDefinition_Yield
  : identifierReference_Yield
  | coverInitializedName_Yield
  | propertyName_Yield ':' assignmentExpression_In_Yield
  | methodDefinition_Yield
  ;

//  PropertyName[Yield] :
//   LiteralPropertyName
//   ComputedPropertyName[?Yield]
propertyName
  : LiteralPropertyName
  | computedPropertyName
  ;

propertyName_Yield
  : LiteralPropertyName
  | computedPropertyName_Yield
  ;

//  LiteralPropertyName :
//   IdentifierName
//   StringLiteral
//   NumericLiteral
LiteralPropertyName
  : IdentifierName
  | StringLiteral
  | NumericLiteral
  ;

//  ComputedPropertyName[Yield] :
//   [ AssignmentExpression[In, ?Yield] ]
computedPropertyName
  : '[' assignmentExpression_In ']'
  ;

computedPropertyName_Yield
  : '[' assignmentExpression_In_Yield ']'
  ;

//  CoverInitializedName[Yield] :
//   IdentifierReference[?Yield] Initializer[In, ?Yield]
coverInitializedName
  : identifierReference initializer_In
  ;

coverInitializedName_Yield
  : identifierReference_Yield initializer_In_Yield
  ;

//  Initializer[In, Yield] :
//   = AssignmentExpression[?In, ?Yield]
initializer
  : '=' assignmentExpression
  ;

initializer_In
  : '=' assignmentExpression_In
  ;

initializer_Yield
  : '=' assignmentExpression_Yield
  ;

initializer_In_Yield
  : '=' assignmentExpression_In_Yield
  ;

//  TemplateLiteral[Yield] :
//   NoSubstitutionTemplate
//   TemplateHead Expression[In, ?Yield] TemplateSpans[?Yield]
templateLiteral
  : noSubstitutionTemplate
  | templateHead expression_In templateSpans
  ;

templateLiteral_Yield
  : noSubstitutionTemplate
  | templateHead expression_In_Yield templateSpans_Yield
  ;

//  TemplateSpans[Yield] :
//   TemplateTail
//   TemplateMiddleList[?Yield] TemplateTail
templateSpans
  : templateTail
  | templateMiddleList templateTail
  ;

templateSpans_Yield
  : templateTail
  | templateMiddleList_Yield templateTail
  ;

//  TemplateMiddleList[Yield] :
//   TemplateMiddle Expression[In, ?Yield]
//   TemplateMiddleList[?Yield] TemplateMiddle Expression[In, ?Yield]
templateMiddleList
  :  (templateMiddle expression_In)+
  ;

templateMiddleList_Yield
  : (templateMiddle expression_In_Yield)+
  ;

//  MemberExpression[Yield] :
//   PrimaryExpression[?Yield]
//   MemberExpression[?Yield] [ Expression[In, ?Yield] ]
//   MemberExpression[?Yield] . IdentifierName
//   MemberExpression[?Yield] TemplateLiteral[?Yield]
//   SuperProperty[?Yield]
//   MetaProperty
//   new MemberExpression[?Yield] Arguments[?Yield]
memberExpression
  : primaryExpression
  | memberExpression '[' expression_In ']'
  | memberExpression '.' IdentifierName
  | memberExpression templateLiteral
  | superProperty
  | MetaProperty
  | 'new' memberExpression arguments
  ;

memberExpression_Yield
  : primaryExpression_Yield
  | memberExpression_Yield '[' expression_In_Yield ']'
  | memberExpression_Yield '.' IdentifierName
  | memberExpression_Yield templateLiteral_Yield
  | superProperty_Yield
  | MetaProperty
  | 'new' memberExpression_Yield arguments_Yield
  ;

//  SuperProperty[Yield] :
//   super [ Expression[In, ?Yield] ]
//   super . IdentifierName
superProperty
  : 'super' '[' expression_In ']'
  | 'super' '.' IdentifierName
  ;

superProperty_Yield
  : 'super' '[' expression_In_Yield ']'
  | 'super' '.' IdentifierName
  ;

//  MetaProperty :
//   NewTarget
MetaProperty
  : NewTarget
  ;

//  NewTarget :
//   new . target
NewTarget
  : 'new' '.' 'target'
  ;

//  NewExpression[Yield] :
//   MemberExpression[?Yield]
//   new NewExpression[?Yield]
newExpression
  : memberExpression
  | 'new' newExpression
  ;

newExpression_Yield
  : memberExpression_Yield
  | 'new' newExpression_Yield
  ;

//  CallExpression[Yield] :
//   MemberExpression[?Yield] Arguments[?Yield]
//   SuperCall[?Yield]
//   CallExpression[?Yield] Arguments[?Yield]
//   CallExpression[?Yield] [ Expression[In, ?Yield] ]
//   CallExpression[?Yield] . IdentifierName
//   CallExpression[?Yield] TemplateLiteral[?Yield]
callExpression
  : memberExpression arguments
  | superCall
  | callExpression arguments
  | callExpression '[' expression_In ']'
  | callExpression '.' IdentifierName
  | callExpression templateLiteral
  ;
callExpression_Yield
  : memberExpression_Yield arguments_Yield
  | superCall_Yield
  | callExpression_Yield arguments_Yield
  | callExpression_Yield '[' expression_In_Yield ']'
  | callExpression_Yield '.' IdentifierName
  | callExpression_Yield templateLiteral_Yield
  ;

//  SuperCall[Yield] :
//   super Arguments[?Yield]
superCall
  : 'super' arguments
  ;

superCall_Yield
  : 'super' arguments_Yield
  ;

//  Arguments[Yield] :
//   ( )
//   ( ArgumentList[?Yield] )
arguments
  : '(' ')'
  | '(' argumentList ')'
  ;

arguments_Yield
  : '(' ')'
  | '(' argumentList_Yield ')'
  ;

//  ArgumentList[Yield] :
//   AssignmentExpression[In, ?Yield]
//   ... AssignmentExpression[In, ?Yield]
//   ArgumentList[?Yield] , AssignmentExpression[In, ?Yield]
//   ArgumentList[?Yield] , ... AssignmentExpression[In, ?Yield]
argumentList
  : '...'? assignmentExpression_In (',' '...'? assignmentExpression_In)*
  ;

argumentList_Yield
  : '...'? assignmentExpression_In_Yield (',' '...'? assignmentExpression_In_Yield)*
  ;

//  LeftHandSideExpression[Yield] :
//   NewExpression[?Yield]
//   CallExpression[?Yield]
leftHandSideExpression
  : newExpression
  | callExpression
  ;

leftHandSideExpression_Yield
  : newExpression_Yield
  | callExpression_Yield
  ;

//  PostfixExpression[Yield] :
//   LeftHandSideExpression[?Yield]
//   LeftHandSideExpression[?Yield] [no LineTerminator here] ++
//   LeftHandSideExpression[?Yield] [no LineTerminator here] --
postfixExpression
  : leftHandSideExpression
  | leftHandSideExpression ~LineTerminator '++'
  | leftHandSideExpression ~LineTerminator '--'
  ;
  
postfixExpression_Yield
  : leftHandSideExpression_Yield
  | leftHandSideExpression_Yield ~LineTerminator '++'
  | leftHandSideExpression_Yield ~LineTerminator '--'
  ;

//  UnaryExpression[Yield] :
//   PostfixExpression[?Yield]
//   delete UnaryExpression[?Yield]
//   void UnaryExpression[?Yield]
//   typeof UnaryExpression[?Yield]
//   ++ UnaryExpression[?Yield]
//   -- UnaryExpression[?Yield]
//   + UnaryExpression[?Yield]
//   - UnaryExpression[?Yield]
//   ~ UnaryExpression[?Yield]
//   ! UnaryExpression[?Yield]
unaryExpression
  : postfixExpression
  | 'delete' unaryExpression
  | 'void' unaryExpression
  | 'typeof' unaryExpression
  | '++' unaryExpression
  | '--' unaryExpression
  | '+' unaryExpression
  | '-' unaryExpression
  | '~' unaryExpression
  | '!' unaryExpression
  ;

unaryExpression_Yield
  : postfixExpression_Yield
  | 'delete' unaryExpression_Yield
  | 'void' unaryExpression_Yield
  | 'typeof' unaryExpression_Yield
  | '++' unaryExpression_Yield
  | '--' unaryExpression_Yield
  | '+' unaryExpression_Yield
  | '-' unaryExpression_Yield
  | '~' unaryExpression_Yield
  | '!' unaryExpression_Yield
  ;

//  MultiplicativeExpression[Yield] :
//   UnaryExpression[?Yield]
//   MultiplicativeExpression[?Yield] MultiplicativeOperator UnaryExpression[?Yield]
multiplicativeExpression
  : unaryExpression
  | multiplicativeExpression MultiplicativeOperator unaryExpression
  ;
  
multiplicativeExpression_Yield
  : unaryExpression_Yield
  | multiplicativeExpression_Yield MultiplicativeOperator unaryExpression_Yield
  ;

//  MultiplicativeOperator : one of
//   *     /     %
MultiplicativeOperator
  : '*' | '/' | '%'
  ;

//  AdditiveExpression[Yield] :
//   MultiplicativeExpression[?Yield]
//   AdditiveExpression[?Yield] + MultiplicativeExpression[?Yield]
//   AdditiveExpression[?Yield] - MultiplicativeExpression[?Yield]
additiveExpression
  : multiplicativeExpression
  | additiveExpression '+' multiplicativeExpression
  | additiveExpression '-' multiplicativeExpression
  ;

additiveExpression_Yield
  : multiplicativeExpression_Yield
  | additiveExpression_Yield '+' multiplicativeExpression_Yield
  | additiveExpression_Yield '-' multiplicativeExpression_Yield
  ;

//  ShiftExpression[Yield] :
//   AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] << AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] >> AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] >>> AdditiveExpression[?Yield]
shiftExpression
  : additiveExpression
  | shiftExpression '<<' additiveExpression
  | shiftExpression '>>' additiveExpression
  | shiftExpression '>>>' additiveExpression
  ;

shiftExpression_Yield
  : additiveExpression_Yield
  | shiftExpression_Yield '<<' additiveExpression_Yield
  | shiftExpression_Yield '>>' additiveExpression_Yield
  | shiftExpression_Yield '>>>' additiveExpression_Yield
  ;

//  RelationalExpression[In, Yield] :
//   ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] < ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] > ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] <= ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] >= ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] instanceof ShiftExpression[?Yield]
//   [+In] RelationalExpression[In, ?Yield] in ShiftExpression[?Yield]
relationalExpression
  : shiftExpression
  | relationalExpression '<' shiftExpression
  | relationalExpression '>' shiftExpression
  | relationalExpression '<=' shiftExpression
  | relationalExpression '>=' shiftExpression
  | relationalExpression 'instanceof' shiftExpression
  ;

relationalExpression_In
  : shiftExpression
  | relationalExpression_In '<' shiftExpression
  | relationalExpression_In '>' shiftExpression
  | relationalExpression_In '<=' shiftExpression
  | relationalExpression_In '>=' shiftExpression
  | relationalExpression_In 'instanceof' shiftExpression
  | relationalExpression_In 'in' shiftExpression
  ;

relationalExpression_Yield
  : shiftExpression_Yield
  | relationalExpression_Yield '<' shiftExpression_Yield
  | relationalExpression_Yield '>' shiftExpression_Yield
  | relationalExpression_Yield '<=' shiftExpression_Yield
  | relationalExpression_Yield '>=' shiftExpression_Yield
  | relationalExpression_Yield 'instanceof' shiftExpression_Yield
  ;

relationalExpression_In_Yield
  : shiftExpression_Yield
  | relationalExpression_In_Yield '<' shiftExpression_Yield
  | relationalExpression_In_Yield '>' shiftExpression_Yield
  | relationalExpression_In_Yield '<=' shiftExpression_Yield
  | relationalExpression_In_Yield '>=' shiftExpression_Yield
  | relationalExpression_In_Yield 'instanceof' shiftExpression_Yield
  | relationalExpression_In_Yield 'in' shiftExpression_Yield
  ;

//  EqualityExpression[In, Yield] :
//   RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] == RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] != RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] === RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] !== RelationalExpression[?In, ?Yield]
equalityExpression
  : relationalExpression
  | equalityExpression '==' relationalExpression
  | equalityExpression '!=' relationalExpression
  | equalityExpression '===' relationalExpression
  | equalityExpression '!==' relationalExpression
  ;

equalityExpression_In
  : relationalExpression_In
  | equalityExpression_In '==' relationalExpression_In
  | equalityExpression_In '!=' relationalExpression_In
  | equalityExpression_In '===' relationalExpression_In
  | equalityExpression_In '!==' relationalExpression_In
  ;

equalityExpression_Yield
  : relationalExpression_Yield
  | equalityExpression_Yield '==' relationalExpression_Yield
  | equalityExpression_Yield '!=' relationalExpression_Yield
  | equalityExpression_Yield '===' relationalExpression_Yield
  | equalityExpression_Yield '!==' relationalExpression_Yield
  ;

equalityExpression_In_Yield
  : relationalExpression_In_Yield
  | equalityExpression_In_Yield '==' relationalExpression_In_Yield
  | equalityExpression_In_Yield '!=' relationalExpression_In_Yield
  | equalityExpression_In_Yield '===' relationalExpression_In_Yield
  | equalityExpression_In_Yield '!==' relationalExpression_In_Yield
  ;

//  BitwiseANDExpression[In, Yield] :
//   EqualityExpression[?In, ?Yield]
//   BitwiseANDExpression[?In, ?Yield] & EqualityExpression[?In, ?Yield]
bitwiseANDExpression
  : equalityExpression
  | bitwiseANDExpression '&' equalityExpression
  ;

bitwiseANDExpression_In
  : equalityExpression_In
  | bitwiseANDExpression_In '&' equalityExpression_In
  ;

bitwiseANDExpression_Yield
  : equalityExpression_Yield
  | bitwiseANDExpression_Yield '&' equalityExpression_Yield
  ;

bitwiseANDExpression_In_Yield
  : equalityExpression_In_Yield
  | bitwiseANDExpression_In_Yield '&' equalityExpression_In_Yield
  ;

//  BitwiseXORExpression[In, Yield] :
//   BitwiseANDExpression[?In, ?Yield]
//   BitwiseXORExpression[?In, ?Yield] ^ BitwiseANDExpression[?In, ?Yield]
bitwiseXORExpression
  : bitwiseANDExpression
  | bitwiseXORExpression '^' bitwiseANDExpression
  ;

bitwiseXORExpression_In
  : bitwiseANDExpression_In
  | bitwiseXORExpression_In '^' bitwiseANDExpression_In
  ;

bitwiseXORExpression_Yield
  : bitwiseANDExpression_Yield
  | bitwiseXORExpression_Yield '^' bitwiseANDExpression_Yield
  ;

bitwiseXORExpression_In_Yield
  : bitwiseANDExpression_In_Yield
  | bitwiseXORExpression_In_Yield '^' bitwiseANDExpression_In_Yield
  ;

//  BitwiseORExpression[In, Yield] :
//   BitwiseXORExpression[?In, ?Yield]
//   BitwiseORExpression[?In, ?Yield] | BitwiseXORExpression[?In, ?Yield]
bitwiseORExpression
  : bitwiseXORExpression
  | bitwiseORExpression '|' bitwiseXORExpression
  ;

bitwiseORExpression_In
  : bitwiseXORExpression_In
  | bitwiseORExpression_In '|' bitwiseXORExpression_In
  ;

bitwiseORExpression_Yield
  : bitwiseXORExpression_Yield
  | bitwiseORExpression_Yield '|' bitwiseXORExpression_Yield
  ;

bitwiseORExpression_In_Yield
  : bitwiseXORExpression_In_Yield
  | bitwiseORExpression_In_Yield '|' bitwiseXORExpression_In_Yield
  ;

//  LogicalANDExpression[In, Yield] :
//   BitwiseORExpression[?In, ?Yield]
//   LogicalANDExpression[?In, ?Yield] && BitwiseORExpression[?In, ?Yield]
logicalANDExpression
  : bitwiseORExpression
  | logicalANDExpression '&&' bitwiseORExpression
  ;

logicalANDExpression_In
  : bitwiseORExpression_In
  | logicalANDExpression_In '&&' bitwiseORExpression_In
  ;

logicalANDExpression_Yield
  : bitwiseORExpression_Yield
  | logicalANDExpression_Yield '&&' bitwiseORExpression_Yield
  ;

logicalANDExpression_In_Yield
  : bitwiseORExpression_In_Yield
  | logicalANDExpression_In_Yield '&&' bitwiseORExpression_In_Yield
  ;

//  LogicalORExpression[In, Yield] :
//   LogicalANDExpression[?In, ?Yield]
//   LogicalORExpression[?In, ?Yield] || LogicalANDExpression[?In, ?Yield]
logicalORExpression
  : logicalANDExpression
  | logicalORExpression '||' logicalANDExpression
  ;

logicalORExpression_In
  : logicalANDExpression_In
  | logicalORExpression_In '||' logicalANDExpression_In
  ;

logicalORExpression_Yield
  : logicalANDExpression_Yield
  | logicalORExpression_Yield '||' logicalANDExpression_Yield
  ;

logicalORExpression_In_Yield
  : logicalANDExpression_In_Yield
  | logicalORExpression_In_Yield '||' logicalANDExpression_In_Yield
  ;

//  ConditionalExpression[In, Yield] :
//   LogicalORExpression[?In, ?Yield]
//   LogicalORExpression[?In, ?Yield] ? AssignmentExpression[In, ?Yield] : AssignmentExpression[?In, ?Yield]
conditionalExpression
  : logicalORExpression
  | logicalORExpression '?' assignmentExpression_In ':' assignmentExpression
  ;

conditionalExpression_In
  : logicalORExpression_In
  | logicalORExpression_In '?' assignmentExpression_In ':' assignmentExpression_In
  ;

conditionalExpression_Yield
  : logicalORExpression_Yield
  | logicalORExpression_Yield '?' assignmentExpression_In_Yield ':' assignmentExpression_Yield
  ;

conditionalExpression_In_Yield
  : logicalORExpression_In_Yield
  | logicalORExpression_In_Yield '?' assignmentExpression_In_Yield ':' assignmentExpression_In_Yield
  ;

//  AssignmentExpression[In, Yield] :
//   ConditionalExpression[?In, ?Yield]
//   [+Yield] YieldExpression[?In]
//   ArrowFunction[?In, ?Yield]
//   LeftHandSideExpression[?Yield] = AssignmentExpression[?In, ?Yield]
//   LeftHandSideExpression[?Yield] AssignmentOperator AssignmentExpression[?In, ?Yield]
assignmentExpression
   : conditionalExpression
   | arrowFunction
   | leftHandSideExpression '=' assignmentExpression
   | leftHandSideExpression AssignmentOperator assignmentExpression
   ;

assignmentExpression_In
   : conditionalExpression_In
   | arrowFunction_In
   | leftHandSideExpression '=' assignmentExpression_In
   | leftHandSideExpression AssignmentOperator assignmentExpression_In
   ;

assignmentExpression_Yield
   : conditionalExpression_Yield
   | yieldExpression
   | arrowFunction_Yield
   | leftHandSideExpression_Yield '=' assignmentExpression_Yield
   | leftHandSideExpression_Yield AssignmentOperator assignmentExpression_Yield
   ;

assignmentExpression_In_Yield
   : conditionalExpression_In_Yield
   | yieldExpression_In
   | arrowFunction_In_Yield
   | leftHandSideExpression_Yield '=' assignmentExpression_In_Yield
   | leftHandSideExpression_Yield AssignmentOperator assignmentExpression_In_Yield
   ;

//  AssignmentOperator : one of
//   *=    /=    %=    +=    -=    <<=   >>=   >>>=  &=    ^=
//   |=
AssignmentOperator
   : '*=' | '/=' | '%=' | '+=' | '-=' | '<<=' | '>>=' | '>>>=' | '&=' | '^='
   | '|='
   ;

//  Expression[In, Yield] :
//   AssignmentExpression[?In, ?Yield]
//   Expression[?In, ?Yield] , AssignmentExpression[?In, ?Yield]
expression
   : assignmentExpression
   | expression ',' assignmentExpression
   ;

expression_In
   : assignmentExpression_In
   | expression_In ',' assignmentExpression_In
   ;

expression_Yield
   : assignmentExpression_Yield
   | expression_Yield ',' assignmentExpression_Yield
   ;

expression_In_Yield
   : assignmentExpression_In_Yield
   | expression_In_Yield ',' assignmentExpression_In_Yield
   ;

//  Statement[Yield, Return] :
//   BlockStatement[?Yield, ?Return]
//   VariableStatement[?Yield]
//   EmptyStatement
//   ExpressionStatement[?Yield]
//   IfStatement[?Yield, ?Return]
//   BreakableStatement[?Yield, ?Return]
//   ContinueStatement[?Yield]
//   BreakStatement[?Yield]
//   [+Return] ReturnStatement[?Yield]
//   WithStatement[?Yield, ?Return]
//   LabelledStatement[?Yield, ?Return]
//   ThrowStatement[?Yield]
//   TryStatement[?Yield, ?Return]
//   DebuggerStatement
statement
  : blockStatement
  | variableStatement
  | EmptyStatement
  | expressionStatement
  | ifStatement
  | breakableStatement
  | continueStatement
  | breakStatement
  | withStatement
  | labelledStatement
  | throwStatement
  | tryStatement
  | DebuggerStatement
  ;

statement_Yield
  : blockStatement_Yield
  | variableStatement_Yield
  | EmptyStatement
  | expressionStatement_Yield
  | ifStatement_Yield
  | breakableStatement_Yield
  | continueStatement_Yield
  | breakStatement_Yield
  | withStatement_Yield
  | labelledStatement_Yield
  | throwStatement_Yield
  | tryStatement_Yield
  | DebuggerStatement
  ;

statement_Return
  : blockStatement_Return
  | variableStatement
  | EmptyStatement
  | expressionStatement
  | ifStatement_Return
  | breakableStatement_Return
  | continueStatement
  | breakStatement
  | returnStatement
  | withStatement_Return
  | labelledStatement_Return
  | throwStatement
  | tryStatement_Return
  | DebuggerStatement
  ;

statement_Yield_Return
  : blockStatement_Yield_Return
  | variableStatement_Yield
  | EmptyStatement
  | expressionStatement_Yield
  | ifStatement_Yield_Return
  | breakableStatement_Yield_Return
  | continueStatement_Yield
  | breakStatement_Yield
  | returnStatement_Yield
  | withStatement_Yield_Return
  | labelledStatement_Yield_Return
  | throwStatement_Yield
  | tryStatement_Yield_Return
  | DebuggerStatement
  ;

//  Declaration[Yield] :
//   HoistableDeclaration[?Yield]
//   ClassDeclaration[?Yield]
//   LexicalDeclaration[In, ?Yield]
declaration
  : hoistableDeclaration
  | classDeclaration
  | lexicalDeclaration_In
  ;

declaration_Yield
  : hoistableDeclaration_Yield
  | classDeclaration_Yield
  | lexicalDeclaration_In_Yield
  ;

//  HoistableDeclaration[Yield, Default] :
//   FunctionDeclaration[?Yield, ?Default]
//   GeneratorDeclaration[?Yield, ?Default]
hoistableDeclaration
  : functionDeclaration
  | generatorDeclaration
  ;

hoistableDeclaration_Yield
  : functionDeclaration_Yield
  | generatorDeclaration_Yield
  ;

hoistableDeclaration_Default
  : functionDeclaration_Default
  | generatorDeclaration_Default
  ;

hoistableDeclaration_Yield_Default
  : functionDeclaration_Yield_Default
  | generatorDeclaration_Yield_Default
  ;

//  BreakableStatement[Yield, Return] :
//   IterationStatement[?Yield, ?Return]
//   SwitchStatement[?Yield, ?Return]
breakableStatement
  : iterationStatement
  | switchStatement
  ;

breakableStatement_Yield
  : iterationStatement_Yield
  | switchStatement_Yield
  ;

breakableStatement_Return
  : iterationStatement_Return
  | switchStatement_Return
  ;

breakableStatement_Yield_Return
  : iterationStatement_Yield_Return
  | switchStatement_Yield_Return
  ;

//  BlockStatement[Yield, Return] :
//   Block[?Yield, ?Return]
blockStatement
  : block
  ;

blockStatement_Yield
  : block_Yield
  ;

blockStatement_Return
  : block_Return
  ;

blockStatement_Yield_Return
  : block_Yield_Return
  ;

//  Block[Yield, Return] :
//   { StatementList[?Yield, ?Return]opt }
block
  : '{' statementList? '}'
  ;

block_Yield
  : '{' statementList_Yield? '}'
  ;

block_Return
  : '{' statementList_Return? '}'
  ;

block_Yield_Return
  : '{' statementList_Yield_Return? '}'
  ;

//  StatementList[Yield, Return] :
//   StatementListItem[?Yield, ?Return]
//   StatementList[?Yield, ?Return] StatementListItem[?Yield, ?Return]
statementList
  : statementListItem
  | statementList statementListItem
  ;

statementList_Yield
  : statementListItem_Yield
  | statementList_Yield statementListItem_Yield
  ;

statementList_Return
  : statementListItem_Return
  | statementList_Return statementListItem_Return
  ;

statementList_Yield_Return
  : statementListItem_Yield_Return
  | statementList_Yield_Return statementListItem_Yield_Return
  ;

//  StatementListItem[Yield, Return] :
//   Statement[?Yield, ?Return]
//   Declaration[?Yield]
statementListItem
  : statement
  | declaration
  ;
statementListItem_Yield
  : statement_Yield
  | declaration_Yield
  ;
statementListItem_Return
  : statement_Return
  | declaration
  ;
statementListItem_Yield_Return
  : statement_Yield_Return
  | declaration_Yield
  ;

//  LexicalDeclaration[In, Yield] :
//   LetOrConst BindingList[?In, ?Yield] ;
lexicalDeclaration
  : LetOrConst bindingList ';'
  ;

lexicalDeclaration_In
  : LetOrConst bindingList_In ';'
  ;

lexicalDeclaration_Yield
  : LetOrConst bindingList_Yield ';'
  ;

lexicalDeclaration_In_Yield
  : LetOrConst bindingList_In_Yield ';'
  ;

//  LetOrConst :
//   let
//   const
LetOrConst
  : 'let'
  | 'const'
  ;

//  BindingList[In, Yield] :
//   LexicalBinding[?In, ?Yield]
//   BindingList[?In, ?Yield] , LexicalBinding[?In, ?Yield]
bindingList
  : lexicalBinding
  | bindingList ',' lexicalBinding
  ;

bindingList_In
  : lexicalBinding_In
  | bindingList_In ',' lexicalBinding_In
  ;

bindingList_Yield
  : lexicalBinding_Yield
  | bindingList_Yield ',' lexicalBinding_Yield
  ;

bindingList_In_Yield
  : lexicalBinding_In_Yield
  | bindingList_In_Yield ',' lexicalBinding_In_Yield
  ;

//  LexicalBinding[In, Yield] :
//   BindingIdentifier[?Yield] Initializer[?In, ?Yield]opt
//   BindingPattern[?Yield] Initializer[?In, ?Yield]
lexicalBinding
  : bindingIdentifier initializer?
  | bindingPattern initializer
  ;

lexicalBinding_In
  : bindingIdentifier initializer_In?
  | bindingPattern initializer_In
  ;

lexicalBinding_Yield
  : bindingIdentifier_Yield initializer_Yield?
  | bindingPattern_Yield initializer_Yield
  ;

lexicalBinding_In_Yield
  : bindingIdentifier_Yield initializer_In_Yield?
  | bindingPattern_Yield initializer_In_Yield
  ;

//  VariableStatement[Yield] :
//   var VariableDeclarationList[In, ?Yield] ;
variableStatement
  : 'var' variableDeclarationList_In ';'
  ;

variableStatement_Yield
  : 'var' variableDeclarationList_In_Yield ';'
  ;

//  VariableDeclarationList[In, Yield] :
//   VariableDeclaration[?In, ?Yield]
//   VariableDeclarationList[?In, ?Yield] , VariableDeclaration[?In, ?Yield]
variableDeclarationList
  : variableDeclaration
  | variableDeclarationList ',' variableDeclaration
  ;

variableDeclarationList_In
  : variableDeclaration_In
  | variableDeclarationList_In ',' variableDeclaration_In
  ;

variableDeclarationList_Yield
  : variableDeclaration_Yield
  | variableDeclarationList_Yield ',' variableDeclaration_Yield
  ;

variableDeclarationList_In_Yield
  : variableDeclaration_In_Yield
  | variableDeclarationList_In_Yield ',' variableDeclaration_In_Yield
  ;

//  VariableDeclaration[In, Yield] :
//   BindingIdentifier[?Yield] Initializer[?In, ?Yield]opt
//   BindingPattern[?Yield] Initializer[?In, ?Yield]
variableDeclaration
  : bindingIdentifier initializer?
  | bindingPattern initializer
  ;
variableDeclaration_In
  : bindingIdentifier initializer_In?
  | bindingPattern initializer_In
  ;
variableDeclaration_Yield
  : bindingIdentifier_Yield initializer_Yield?
  | bindingPattern_Yield initializer_Yield
  ;
variableDeclaration_In_Yield
  : bindingIdentifier_Yield initializer_In_Yield?
  | bindingPattern_Yield initializer_In_Yield
  ;

//  BindingPattern[Yield] :
//   ObjectBindingPattern[?Yield]
//   ArrayBindingPattern[?Yield]
bindingPattern
  : objectBindingPattern
  | arrayBindingPattern
  ;

bindingPattern_Yield
  : objectBindingPattern_Yield
  | arrayBindingPattern_Yield
  ;

//  ObjectBindingPattern[Yield] :
//   { }
//   { BindingPropertyList[?Yield] }
//   { BindingPropertyList[?Yield] , }
objectBindingPattern
  : '{' '}'
  | '{' bindingPropertyList '}'
  | '{' bindingPropertyList ',' '}'
  ;
objectBindingPattern_Yield
  : '{' '}'
  | '{' bindingPropertyList_Yield '}'
  | '{' bindingPropertyList_Yield ',' '}'
  ;

//  ArrayBindingPattern[Yield] :
//   [ Elisionopt BindingRestElement[?Yield]opt ]
//   [ BindingElementList[?Yield] ]
//   [ BindingElementList[?Yield] , Elisionopt BindingRestElement[?Yield]opt ]
arrayBindingPattern
  : '[' Elision? bindingRestElement? ']'
  | '[' bindingElementList ']'
  | '[' bindingElementList ',' Elision? bindingRestElement? ']'
  ;

arrayBindingPattern_Yield
  : '[' Elision? bindingRestElement_Yield? ']'
  | '[' bindingElementList_Yield ']'
  | '[' bindingElementList_Yield ',' Elision? bindingRestElement_Yield? ']'
  ;

//  BindingPropertyList[Yield] :
//   BindingProperty[?Yield]
//   BindingPropertyList[?Yield] , BindingProperty[?Yield]
bindingPropertyList
  : bindingProperty
  | bindingPropertyList ',' bindingProperty
  ;
bindingPropertyList_Yield
  : bindingProperty_Yield
  | bindingPropertyList_Yield ',' bindingProperty_Yield
  ;

//  BindingElementList[Yield] :
//   BindingElisionElement[?Yield]
//   BindingElementList[?Yield] , BindingElisionElement[?Yield]
bindingElementList
  : bindingElisionElement
  | bindingElementList ',' bindingElisionElement
  ;

bindingElementList_Yield
  : bindingElisionElement_Yield
  | bindingElementList_Yield ',' bindingElisionElement_Yield
  ;

//  BindingElisionElement[Yield] :
//   Elisionopt BindingElement[?Yield]
bindingElisionElement
  : Elision? bindingElement
  ;
bindingElisionElement_Yield
  : Elision? bindingElement_Yield
  ;

//  BindingProperty[Yield] :
//   SingleNameBinding[?Yield]
//   PropertyName[?Yield] : BindingElement[?Yield]
bindingProperty
  : singleNameBinding
  | propertyName ':' bindingElement
  ;

bindingProperty_Yield
  : singleNameBinding_Yield
  | propertyName_Yield ':' bindingElement_Yield
  ;

//  BindingElement[Yield] :
//   SingleNameBinding[?Yield]
//   BindingPattern[?Yield] Initializer[In, ?Yield]opt
bindingElement
  : singleNameBinding
  | bindingPattern initializer_In?
  ;

bindingElement_Yield
  : singleNameBinding_Yield
  | bindingPattern_Yield initializer_In_Yield?
  ;

//  SingleNameBinding[Yield] :
//   BindingIdentifier[?Yield] Initializer[In, ?Yield]opt
singleNameBinding
  : bindingIdentifier initializer?
  ;

singleNameBinding_Yield
  : bindingIdentifier_Yield initializer_In_Yield?
  ;

//  BindingRestElement[Yield] :
//   ... BindingIdentifier[?Yield]
bindingRestElement
  : '...' bindingIdentifier
  ;

bindingRestElement_Yield
  : '...' bindingIdentifier_Yield
  ;

EmptyStatement
  : ';'
  ;

//  ExpressionStatement[Yield] :
//   [lookahead ∉ { {, function, class, let [ }] Expression[In, ?Yield] ;
expressionStatement
  : {(_input.LA(1) != '{') && (_input.LA(1) != 'function') && (_input.LA(1) != 'class') && (_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression ';'
  ;

expressionStatement_Yield
  : {(_input.LA(1) != '{') && (_input.LA(1) != 'function') && (_input.LA(1) != 'class') && (_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression_In_Yield ';'
  ;

//  IfStatement[Yield, Return] :
//   if ( Expression[In, ?Yield] ) Statement[?Yield, ?Return] else Statement[?Yield, ?Return]
//   if ( Expression[In, ?Yield] ) Statement[?Yield, ?Return]
ifStatement
  : 'if' ( expression_In ) statement 'else' statement
  | 'if' ( expression_In ) statement
  ;

ifStatement_Yield
  : 'if' ( expression_In_Yield ) statement_Yield 'else' statement_Yield
  | 'if' ( expression_In_Yield ) statement_Yield
  ;

ifStatement_Return
  : 'if' ( expression_In ) statement_Return 'else' statement_Return
  | 'if' ( expression_In ) statement_Return
  ;

ifStatement_Yield_Return
  : 'if' ( expression_In_Yield ) statement_Yield_Return 'else' statement_Yield_Return
  | 'if' ( expression_In_Yield ) statement_Yield_Return
  ;

//  IterationStatement[Yield, Return] :
//   do Statement[?Yield, ?Return] while ( Expression[In, ?Yield] ) ;
//   while ( Expression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( [lookahead ∉ { let [ }] Expression[?Yield]opt ; Expression[In, ?Yield]opt ; Expression[In, ?Yield]opt ) Statement[?Yield, ?Return]
//   for ( var VariableDeclarationList[?Yield] ; Expression[In, ?Yield]opt ; Expression[In, ?Yield]opt ) Statement[?Yield, ?Return]
//   for ( LexicalDeclaration[?Yield] Expression[In, ?Yield]opt ; Expression[In, ?Yield]opt ) Statement[?Yield, ?Return]
//   for ( [lookahead ∉ { let [ }] LeftHandSideExpression[?Yield] in Expression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( var ForBinding[?Yield] in Expression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( ForDeclaration[?Yield] in Expression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( [lookahead ≠ let] LeftHandSideExpression[?Yield] of AssignmentExpression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( var ForBinding[?Yield] of AssignmentExpression[In, ?Yield] ) Statement[?Yield, ?Return]
//   for ( ForDeclaration[?Yield] of AssignmentExpression[In, ?Yield] ) Statement[?Yield, ?Return]
iterationStatement
  : 'do' statement 'while' '(' expression ')' ';'
  | 'while' '(' expression ')' statement
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression? ';' expression? ';' expression? ')' statement
  | 'for' '(' 'var' variableDeclarationList ';' expression? ';' expression? ')' statement
  | 'for' '(' lexicalDeclaration expression? ';' expression? ')' statement
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? leftHandSideExpression 'in' expression ')' statement
  | 'for' '(' 'var' forBinding 'in' expression ')' statement
  | 'for' '(' forDeclaration 'in' expression ')' statement
  | 'for' '(' {(_input.LA(1) != 'let')}? leftHandSideExpression 'of' assignmentExpression ')' statement
  | 'for' '(' 'var' forBinding 'of' assignmentExpression ')' statement
  | 'for' '(' forDeclaration 'of' assignmentExpression ')' statement
  ;

iterationStatement_Yield
  : 'do' statement_Yield 'while' '(' expression_Yield ')' ';'
  | 'while' '(' expression_Yield ')' statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression_Yield? ';' expression_Yield? ';' expression_Yield? ')' statement_Yield
  | 'for' '(' 'var' variableDeclarationList_Yield ';' expression_Yield? ';' expression_Yield? ')' statement_Yield
  | 'for' '(' lexicalDeclaration_Yield expression_Yield? ';' expression_Yield? ')' statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? leftHandSideExpression_Yield 'in' expression_Yield ')' statement_Yield
  | 'for' '(' 'var' forBinding_Yield 'in' expression_Yield ')' statement_Yield
  | 'for' '(' forDeclaration_Yield 'in' expression_Yield ')' statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let'))}? leftHandSideExpression_Yield 'of' assignmentExpression_Yield ')' statement_Yield
  | 'for' '(' 'var' forBinding_Yield 'of' assignmentExpression_Yield ')' statement_Yield
  | 'for' '(' forDeclaration_Yield 'of' assignmentExpression_Yield ')' statement_Yield
  ;

iterationStatement_Return
  : 'do' statement_Return 'while' '(' expression_In ')' ';'
  | 'while' '(' expression_In ')' statement_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression? ';' expression_In? ';' expression_In? ')' statement_Return
  | 'for' '(' 'var' variableDeclarationList ';' expression_In? ';' expression_In? ')' statement_Return
  | 'for' '(' lexicalDeclaration expression_In? ';' expression_In? ')' statement_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? leftHandSideExpression 'in' expression_In ')' statement_Return
  | 'for' '(' 'var' forBinding 'in' expression_In ')' statement_Return
  | 'for' '(' forDeclaration 'in' expression_In ')' statement_Return
  | 'for' '(' {(_input.LA(1) != 'let'))}? leftHandSideExpression 'of' assignmentExpression_In ')' statement_Return
  | 'for' '(' 'var' forBinding 'of' assignmentExpression_In ')' statement_Return
  | 'for' '(' forDeclaration 'of' assignmentExpression_In ')' statement_Return
  ;

iterationStatement_Yield_Return
  : 'do' statement_Yield_Return 'while' '(' expression_In_Yield ')' ';'
  | 'while' '(' expression_In_Yield ')' statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? expression_Yield? ';' expression_In_Yield? ';' expression_In_Yield? ')' statement_Yield_Return
  | 'for' '(' 'var' variableDeclarationList_Yield ';' expression_In_Yield? ';' expression_In_Yield? ')' statement_Yield_Return
  | 'for' '(' lexicalDeclaration_Yield expression_In_Yield? ';' expression_In_Yield? ')' statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? leftHandSideExpression_Yield 'in' expression_In_Yield ')' statement_Yield_Return
  | 'for' '(' 'var' forBinding_Yield 'in' expression_In_Yield ')' statement_Yield_Return
  | 'for' '(' forDeclaration_Yield 'in' expression_In_Yield ')' statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let'))}? leftHandSideExpression_Yield 'of' assignmentExpression_In_Yield ')' statement_Yield_Return
  | 'for' '(' 'var' forBinding_Yield 'of' assignmentExpression_In_Yield ')' statement_Yield_Return
  | 'for' '(' forDeclaration_Yield 'of' assignmentExpression_In_Yield ')' statement_Yield_Return
  ;

//  ForDeclaration[Yield] :
//   LetOrConst ForBinding[?Yield]
forDeclaration
  : LetOrConst forBinding
  ;

forDeclaration_Yield
  : LetOrConst forBinding_Yield
  ;

//  ForBinding[Yield] :
//   BindingIdentifier[?Yield]
//   BindingPattern[?Yield]
forBinding
  : bindingIdentifier
  | bindingPattern
  ;

forBinding_Yield
  : bindingIdentifier_Yield
  | bindingPattern_Yield
  ;

//  ContinueStatement[Yield] :
//   continue ;
//   continue [no LineTerminator here] LabelIdentifier[?Yield] ;
continueStatement
  : 'continue' ';'
  | 'continue' ~LineTerminator labelIdentifier ';'
  ;

continueStatement_Yield
  : 'continue' ';'
  | 'continue' ~LineTerminator labelIdentifier_Yield ';'
  ;

//  BreakStatement[Yield] :
//   break ;
//   break [no LineTerminator here] LabelIdentifier[?Yield] ;
breakStatement
  : 'break' ';'
  | 'break' ~LineTerminator labelIdentifier ';'
  ;

breakStatement_Yield
  : 'break' ';'
  | 'break' ~LineTerminator labelIdentifier_Yield ';'
  ;

//  ReturnStatement[Yield] :
//   return ;
//   return [no LineTerminator here] Expression[In, ?Yield] ;
returnStatement
  : 'return' ';'
  | 'return' ~LineTerminator expression_In ';'
  ;

returnStatement_Yield
  : 'return' ';'
  | 'return' ~LineTerminator expression_In_Yield ';'
  ;

//  WithStatement[Yield, Return] :
//   with ( Expression[In, ?Yield] ) Statement[?Yield, ?Return]
withStatement
  : 'with' '(' expression_Yield ')' statement
  ;

withStatement_Yield
  : 'with' '(' expression_In_Yield ')' statement_Yield
  ;

withStatement_Return
  : 'with' '(' expression_In ')' statement_Return
  ;

withStatement_Yield_Return
  : 'with' '(' expression_In_Yield ')' statement_Yield_Return
  ;

//  SwitchStatement[Yield, Return] :
//   switch ( Expression[In, ?Yield] ) CaseBlock[?Yield, ?Return]
switchStatement
  : 'switch' '(' expression_In ')' caseBlock
  ;

switchStatement_Yield
  : 'switch' '(' expression_In_Yield ')' caseBlock_Yield
  ;

switchStatement_Return
  : 'switch' '(' expression_In ')' caseBlock_Return
  ;

switchStatement_Yield_Return
  : 'switch' '(' expression_In_Yield ')' caseBlock_Yield_Return
  ;

//  CaseBlock[Yield, Return] :
//   { CaseClauses[?Yield, ?Return]opt }
//   { CaseClauses[?Yield, ?Return]opt DefaultClause[?Yield, ?Return] CaseClauses[?Yield, ?Return]opt }
caseBlock
  : '{' caseClauses? '}'
  | '{' caseClauses? defaultClause caseClauses? '}'
  ;

caseBlock_Yield
  : '{' caseClauses_Yield? '}'
  | '{' caseClauses_Yield? defaultClause_Yield caseClauses_Yield? '}'
  ;

caseBlock_Return
  : '{' caseClauses_Return? '}'
  | '{' caseClauses_Return? defaultClause_Return caseClauses_Return? '}'
  ;

caseBlock_Yield_Return
  : '{' caseClauses_Yield_Return? '}'
  | '{' caseClauses_Yield_Return? defaultClause_Yield_Return caseClauses_Yield_Return? '}'
  ;

//  CaseClauses[Yield, Return] :
//   CaseClause[?Yield, ?Return]
//   CaseClauses[?Yield, ?Return] CaseClause[?Yield, ?Return]
caseClauses
  : caseClause
  | caseClauses caseClause
  ;

caseClauses_Yield
  : caseClause_Yield
  | caseClauses_Yield caseClause_Yield
  ;

caseClauses_Return
  : caseClause_Return
  | caseClauses_Return caseClause_Return
  ;

caseClauses_Yield_Return
  : caseClause_Yield_Return
  | caseClauses_Yield_Return caseClause_Yield_Return
  ;

//  CaseClause[Yield, Return] :
//   case Expression[In, ?Yield] : StatementList[?Yield, ?Return]opt
caseClause
  : 'case' expression_In ':' statementList?
  ;

caseClause_Yield
  : 'case' expression_In_Yield ':' statementList_Yield?
  ;

caseClause_Return
  : 'case' expression_In ':' statementList_Return?
  ;

caseClause_Yield_Return
  : 'case' expression_In_Yield ':' statementList_Yield_Return?
  ;

//  DefaultClause[Yield, Return] :
//   default : StatementList[?Yield, ?Return]opt
defaultClause
  : 'default' ':' statementList?
  ;

defaultClause_Yield
  : 'default' ':' statementList_Yield?
  ;

defaultClause_Return
  : 'default' ':' statementList_Return?
  ;

defaultClause_Yield_Return
  : 'default' ':' statementList_Yield_Return?
  ;

//  LabelledStatement[Yield, Return] :
//   LabelIdentifier[?Yield] : LabelledItem[?Yield, ?Return]
labelledStatement
  : labelIdentifier ':' labelledItem
  ;

labelledStatement_Yield
  : labelIdentifier_Yield ':' labelledItem_Yield
  ;

labelledStatement_Return
  : labelIdentifier ':' labelledItem_Return
  ;

labelledStatement_Yield_Return
  : labelIdentifier_Yield ':' labelledItem_Yield_Return
  ;

//  LabelledItem[Yield, Return] :
//   Statement[?Yield, ?Return]
//   FunctionDeclaration[?Yield]
labelledItem
  : statement
  | functionDeclaration
  ;

labelledItem_Yield
  : statement_Yield
  | functionDeclaration_Yield
  ;

labelledItem_Return
  : statement_Return
  | functionDeclaration
  ;

labelledItem_Yield_Return
  : statement_Yield_Return
  | functionDeclaration_Yield
  ;

//  ThrowStatement[Yield] :
//   throw [no LineTerminator here] Expression[In, ?Yield] ;
throwStatement
  : 'throw' ~LineTerminator expression_In ';'
  ;

throwStatement_Yield
  : 'throw' ~LineTerminator expression_In_Yield ';'
  ;

//  TryStatement[Yield, Return] :
//   try Block[?Yield, ?Return] Catch[?Yield, ?Return]
//   try Block[?Yield, ?Return] Finally[?Yield, ?Return]
//   try Block[?Yield, ?Return] Catch[?Yield, ?Return] Finally[?Yield, ?Return]
tryStatement
  : 'try' block catchStatement
  | 'try' block finallyStatement
  | 'try' block catchStatement finallyStatement
  ;

tryStatement_Yield
  : 'try' block_Yield catch_Yield
  | 'try' block_Yield finally_Yield
  | 'try' block_Yield catch_Yield finally_Yield
  ;

tryStatement_Return
  : 'try' block_Return catch_Return
  | 'try' block_Return finally_Return
  | 'try' block_Return catch_Return finally_Return
  ;

tryStatement_Yield_Return
  : 'try' block_Yield_Return catch_Yield_Return
  | 'try' block_Yield_Return finally_Yield_Return
  | 'try' block_Yield_Return catch_Yield_Return finally_Yield_Return
  ;

//  Catch[Yield, Return] :
//   catch ( CatchParameter[?Yield] ) Block[?Yield, ?Return]
catchStatement
  : 'catch' '(' catchParameter ')' block
  ;

catch_Yield
  : 'catch' '(' catchParameter_Yield ')' block_Yield
  ;

catch_Return
  : 'catch' '(' catchParameter ')' block_Return
  ;

catch_Yield_Return
  : 'catch' '(' catchParameter_Yield ')' block_Yield_Return
  ;

//  Finally[Yield, Return] :
//   finally Block[?Yield, ?Return]
finallyStatement
  : 'finally' block
  ;

finally_Yield
  : 'finally' block_Yield
  ;

finally_Return
  : 'finally' block_Return
  ;

finally_Yield_Return
  : 'finally' block_Yield_Return
  ;

//  CatchParameter[Yield] :
//   BindingIdentifier[?Yield]
//   BindingPattern[?Yield]
catchParameter
  : bindingIdentifier
  | bindingPattern
  ;

catchParameter_Yield
  : bindingIdentifier_Yield
  | bindingPattern_Yield
  ;

//  DebuggerStatement :
//   debugger ;
DebuggerStatement
  : 'debugger' ';'
  ;

//  FunctionDeclaration[Yield, Default] :
//   function BindingIdentifier[?Yield] ( FormalParameters ) { FunctionBody }
//   [+Default] function ( FormalParameters ) { FunctionBody }
functionDeclaration
  : 'function' bindingIdentifier '(' formalParameters ')' '{' functionBody '}'
  | 'function' '(' formalParameters ')' '{' functionBody '}'
  ;

functionDeclaration_Yield
  : 'function' bindingIdentifier_Yield '(' formalParameters ')' '{' functionBody '}'
  | 'function' '(' formalParameters ')' '{' functionBody '}'
  ;

functionDeclaration_Default
  : 'function' bindingIdentifier '(' formalParameters ')' '{' functionBody '}'
  | 'function' '(' formalParameters ')' '{' functionBody '}'
  ;

functionDeclaration_Yield_Default
  : 'function' bindingIdentifier_Yield '(' formalParameters ')' '{' functionBody '}'
  | 'function' '(' formalParameters ')' '{' functionBody '}'
  ;

//  FunctionExpression :
//   function BindingIdentifieropt ( FormalParameters ) { FunctionBody }
functionExpression
  : 'function' bindingIdentifier? '(' formalParameters ')' '{' functionBody '}'
  ;

//  StrictFormalParameters[Yield] :
//   FormalParameters[?Yield]
strictFormalParameters
  : formalParameters
  ;

strictFormalParameters_Yield
  : formalParameters_Yield
  ;

//  FormalParameters[Yield] :
//   [empty]
//   FormalParameterList[?Yield]
formalParameters
  : //[empty]
  | formalParameterList
  ;

formalParameters_Yield
  : //[empty]
  | formalParameterList_Yield
  ;

//  FormalParameterList[Yield] :
//   FunctionRestParameter[?Yield]
//   FormalsList[?Yield]
//   FormalsList[?Yield] , FunctionRestParameter[?Yield]
formalParameterList
  : functionRestParameter
  | formalsList
  | formalsList ',' functionRestParameter
  ;

formalParameterList_Yield
  : functionRestParameter_Yield
  | formalsList_Yield
  | formalsList_Yield ',' functionRestParameter_Yield
  ;

//  FormalsList[Yield] :
//   FormalParameter[?Yield]
//   FormalsList[?Yield] , FormalParameter[?Yield]
formalsList
  : formalParameter
  | formalsList ',' formalParameter
  ;

formalsList_Yield
  : formalParameter_Yield
  | formalsList_Yield ',' formalParameter_Yield
  ;

//  FunctionRestParameter[Yield] :
//   BindingRestElement[?Yield]
functionRestParameter
  : bindingRestElement
  ;

functionRestParameter_Yield
  : bindingRestElement_Yield
  ;

//  FormalParameter[Yield] :
//   BindingElement[?Yield]
formalParameter
  : bindingElement
  ;

formalParameter_Yield
  : bindingElement_Yield
  ;

//  FunctionBody[Yield] :
//   FunctionStatementList[?Yield]
functionBody
  : functionStatementList
  ;

functionBody_Yield
  : functionStatementList_Yield
  ;

//  FunctionStatementList[Yield] :
//   StatementList[?Yield, Return]opt
functionStatementList
  : statementList_Yield?
  ;

functionStatementList_Yield
  : statementList_Yield_Return?
  ;

//  ArrowFunction[In, Yield] :
//   ArrowParameters[?Yield] [no LineTerminator here] => ConciseBody[?In]
arrowFunction
  : arrowParameters ~LineTerminator '=>' conciseBody
  ;

arrowFunction_In
  : arrowParameters ~LineTerminator '=>' conciseBody_In
  ;

arrowFunction_Yield
  : arrowParameters_Yield ~LineTerminator '=>' conciseBody
  ;

arrowFunction_In_Yield
  : arrowParameters_Yield ~LineTerminator '=>' conciseBody_In
  ;

//  ArrowParameters[Yield] :
//   BindingIdentifier[?Yield]
//   CoverParenthesizedExpressionAndArrowParameterList[?Yield]
arrowParameters
     : bindingIdentifier
     | coverParenthesizedExpressionAndArrowParameterList
     ;

arrowParameters_Yield
  : bindingIdentifier_Yield
  | coverParenthesizedExpressionAndArrowParameterList_Yield
  ;

//  ConciseBody[In] :
//   [lookahead ≠ {] AssignmentExpression[?In]
//   { FunctionBody }
conciseBody
  : {(_input.LA(1) != '{')}? assignmentExpression
  | '{' functionBody '}'
  ;

conciseBody_In
  : {(_input.LA(1) != '{'))}? assignmentExpression_In
  | '{' functionBody '}'
  ;

//  MethodDefinition[Yield] :
//   PropertyName[?Yield] ( StrictFormalParameters ) { FunctionBody }
//   GeneratorMethod[?Yield]
//   get PropertyName[?Yield] ( ) { FunctionBody }
//   set PropertyName[?Yield] ( PropertySetParameterList ) { FunctionBody }
methodDefinition
  : propertyName '(' strictFormalParameters ')' '{' functionBody '}'
  | generatorMethod
  | 'get 'propertyName '(' ')' '{' functionBody '}'
  | 'set' propertyName '(' propertySetParameterList ')' '{' functionBody '}'
  ;

methodDefinition_Yield
  : propertyName_Yield '(' strictFormalParameters ')' '{' functionBody '}'
  | generatorMethod_Yield
  | 'get 'propertyName_Yield '(' ')' '{' functionBody '}'
  | 'set' propertyName_Yield '(' propertySetParameterList ')' '{' functionBody '}'
  ;

//  PropertySetParameterList :
//   FormalParameter
propertySetParameterList
  : formalParameter
  ;

//  GeneratorMethod[Yield] :
//   * PropertyName[?Yield] ( StrictFormalParameters[Yield] ) { GeneratorBody }
generatorMethod
  : '*' propertyName ( strictFormalParameters ) '{' generatorBody '}'
  ;

generatorMethod_Yield
  : '*' propertyName_Yield ( strictFormalParameters_Yield ) '{' generatorBody '}'
  ;

//  GeneratorDeclaration[Yield, Default] :
//   function * BindingIdentifier[?Yield] ( FormalParameters[Yield] ) { GeneratorBody }
//   [+Default] function * ( FormalParameters[Yield] ) { GeneratorBody }
generatorDeclaration
  : 'function' '*' bindingIdentifier '(' formalParameters_Yield ')' '{' generatorBody '}'
  ;

generatorDeclaration_Yield
  : 'function' '*' bindingIdentifier_Yield '(' formalParameters_Yield ')' '{' generatorBody '}'
  ;

generatorDeclaration_Default
  : 'function' '*' bindingIdentifier_Yield '(' formalParameters_Yield ')' '{' generatorBody '}'
  | 'function' '*' '(' formalParameters_Yield ')' '{' generatorBody '}'
  ;

generatorDeclaration_Yield_Default
  : 'function' '*' bindingIdentifier_Yield '(' formalParameters_Yield ')' '{' generatorBody '}'
  | 'function' '*' '(' formalParameters_Yield ')' '{' generatorBody '}'
  ;

//  GeneratorExpression :
//   function * BindingIdentifier[Yield]opt ( FormalParameters[Yield] ) { GeneratorBody }
generatorExpression
  : 'function' '*' bindingIdentifier_Yield? '(' formalParameters_Yield ')' '{' generatorBody '}'
  ;

//  GeneratorBody :
//   FunctionBody[Yield]
generatorBody
  : functionBody_Yield
  ;

//  YieldExpression[In] :
//   yield
//   yield [no LineTerminator here] AssignmentExpression[?In, Yield]
//   yield [no LineTerminator here] * AssignmentExpression[?In, Yield]
yieldExpression
  : 'yield'
  | 'yield' ~LineTerminator assignmentExpression_Yield
  | 'yield' ~LineTerminator '*' assignmentExpression_Yield
  ;

yieldExpression_In
  : 'yield'
  | 'yield' ~LineTerminator assignmentExpression_In_Yield
  | 'yield' ~LineTerminator '*' assignmentExpression_In_Yield
  ;

//  ClassDeclaration[Yield, Default] :
//   class BindingIdentifier[?Yield] ClassTail[?Yield]
//   [+Default] class ClassTail[?Yield]
classDeclaration
  : 'class' bindingIdentifier classTail
  ;

classDeclaration_Yield
  : 'class' bindingIdentifier_Yield classTail_Yield
  ;

classDeclaration_Default
  : 'class' bindingIdentifier classTail
  | 'class' classTail
  ;

classDeclaration_Yield_Default
  : 'class' bindingIdentifier_Yield classTail_Yield
  | 'class' classTail_Yield
  ;

//  ClassExpression[Yield] :
//   class BindingIdentifier[?Yield]opt ClassTail[?Yield]
classExpression
  : 'class' bindingIdentifier? classTail
  ;

classExpression_Yield
  : 'class' bindingIdentifier_Yield? classTail_Yield
  ;

//  ClassTail[Yield] :
//   ClassHeritage[?Yield]opt { ClassBody[?Yield]opt }
classTail
  : classHeritage? '{' classBody? '}'
  ;

classTail_Yield
  : classHeritage_Yield? '{' classBody_Yield? '}'
  ;

//  ClassHeritage[Yield] :
//   extends LeftHandSideExpression[?Yield]
classHeritage
  : 'extends' leftHandSideExpression
  ;

classHeritage_Yield
  : 'extends' leftHandSideExpression_Yield
  ;

//  ClassBody[Yield] :
//   ClassElementList[?Yield]
classBody
  : classElementList
  ;

classBody_Yield
  : classElementList_Yield
  ;

//  ClassElementList[Yield] :
//   ClassElement[?Yield]
//   ClassElementList[?Yield] ClassElement[?Yield]
classElementList
  : classElement
  | classElementList classElement
  ;

classElementList_Yield
  : classElement_Yield
  | classElementList_Yield classElement_Yield
  ;

//  ClassElement[Yield] :
//   MethodDefinition[?Yield]
//   static MethodDefinition[?Yield]
//   ;
classElement
  : methodDefinition
  | 'static' methodDefinition
  | ';'
  ;

classElement_Yield
  : methodDefinition_Yield
  | 'static' methodDefinition_Yield
  | ';'
  ;

//  Script :
//   ScriptBodyopt
script
  : scriptBody?
  ;

//  ScriptBody :
//   StatementList
scriptBody
  : statementList;

//  Module :
//   ModuleBodyopt
module
  : moduleBody?;

//  ModuleBody :
//   ModuleItemList
moduleBody
  : moduleItemList;

//  ModuleItemList :
//   ModuleItem
//   ModuleItemList ModuleItem
moduleItemList
  : moduleItem
  | moduleItemList moduleItem;

//  ModuleItem :
//   ImportDeclaration
//   ExportDeclaration
//   StatementListItem
moduleItem
  : importDeclaration
  | exportDeclaration
  | statementListItem;

//  ImportDeclaration :
//   import ImportClause FromClause ;
//   import ModuleSpecifier ;
importDeclaration
  : 'import' importClause FromClause ';'
  | 'import' ModuleSpecifier ';'
  ;

//  ImportClause :
//   ImportedDefaultBinding
//   NameSpaceImport
//   NamedImports
//   ImportedDefaultBinding , NameSpaceImport
//   ImportedDefaultBinding , NamedImports
importClause
  : importedDefaultBinding
  | nameSpaceImport
  | namedImports
  | importedDefaultBinding ',' nameSpaceImport
  | importedDefaultBinding ',' namedImports
  ;

//  ImportedDefaultBinding :
//   ImportedBinding
importedDefaultBinding
  : importedBinding;

//  NameSpaceImport :
//   * as ImportedBinding
nameSpaceImport
  : '*' 'as' importedBinding;

//  NamedImports :
//   { }
//   { ImportsList }
//   { ImportsList , }
namedImports
  : '{' '}'
  | '{' importsList '}'
  | '{' importsList ',' '}'
  ;

//  FromClause :
//   from ModuleSpecifier
FromClause
  : 'from' ModuleSpecifier
  ;

//  ImportsList :
//   ImportSpecifier
//   ImportsList , ImportSpecifier
importsList
  : importSpecifier
  | importsList ',' importSpecifier
  ;

//  ImportSpecifier :
//   ImportedBinding
//   IdentifierName as ImportedBinding
importSpecifier
  : importedBinding
  | IdentifierName 'as' importedBinding
  ;

//  ModuleSpecifier :
//   StringLiteral
ModuleSpecifier
  : StringLiteral
  ;

//  ImportedBinding :
//   BindingIdentifier
importedBinding
  : bindingIdentifier
  ;

//  ExportDeclaration :
//   export * FromClause ;
//   export ExportClause FromClause ;
//   export ExportClause ;
//   export VariableStatement
//   export Declaration
//   export default HoistableDeclaration[Default]
//   export default ClassDeclaration[Default]
//   export default [lookahead ∉ { function, class }] AssignmentExpression[In] ;
exportDeclaration
  : 'export' '*' FromClause ';'
  | 'export' exportClause FromClause ';'
  | 'export' exportClause ';'
  | 'export' variableStatement
  | 'export' declaration
  | 'export' 'default' hoistableDeclaration_Default
  | 'export' 'default' classDeclaration_Default
  | 'export' 'default' {(_input.LA(1) != 'function') && (_input.LA(1) != 'class')}? assignmentExpression_In ';'
  ;

//  ExportClause :
//   { }
//   { ExportsList }
//   { ExportsList , }
exportClause
  : '{' '}'
  | '{' exportsList '}'
  | '{' exportsList ',' '}'
  ;

//  ExportsList :
//   ExportSpecifier
//   ExportsList , ExportSpecifier
exportsList
  : ExportSpecifier
  | exportsList ',' ExportSpecifier
  ;

//  ExportSpecifier :
//   IdentifierName
//   IdentifierName as IdentifierName
ExportSpecifier
  : IdentifierName
  | IdentifierName 'as' IdentifierName
  ;
