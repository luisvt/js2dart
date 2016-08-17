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
InputElementDiv
  : WhiteSpace
  | LineTerminator
  | Comment
  | CommonToken
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
InputElementRegExp
  : WhiteSpace
  | LineTerminator
  | Comment
  | CommonToken
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
InputElementRegExpOrTemplateTail
  : WhiteSpace
  | LineTerminator
  | Comment
  | CommonToken
  | RegularExpressionLiteral
  | TemplateSubstitutionTail
  ;

//  InputElementTemplateTail ::
//   WhiteSpace
//   LineTerminator
//   Comment
//   CommonToken
//   DivPunctuator
//   TemplateSubstitutionTail
InputElementTemplateTail
  : WhiteSpace
  | LineTerminator
  | Comment
  | CommonToken
  | DivPunctuator
  | TemplateSubstitutionTail
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
CommonToken
  : IdentifierName
  | Punctuator
  | NumericLiteral
  | StringLiteral
  | Template
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
  | '0' //[lookahead ≠ DecimalDigit]
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
Template
  : NoSubstitutionTemplate
  | TemplateHead
  ;

//  NoSubstitutionTemplate ::
//   ` TemplateCharactersopt `
NoSubstitutionTemplate
  : '`' TemplateCharacters? '`'
  ;

//  TemplateHead ::
//   ` TemplateCharactersopt ${
TemplateHead
  : '`' TemplateCharacters? '${'
  ;

//  TemplateSubstitutionTail ::
//   TemplateMiddle
//   TemplateTail
TemplateSubstitutionTail
  : TemplateMiddle
  | TemplateTail
  ;

//  TemplateMiddle ::
//   } TemplateCharactersopt ${
TemplateMiddle
  : '}' TemplateCharacters? '${'
  ;

//  TemplateTail ::
//   } TemplateCharactersopt `
TemplateTail
  : '}' TemplateCharacters? '`'
  ;

//  TemplateCharacters ::
//   TemplateCharacter TemplateCharactersopt
TemplateCharacters
  : TemplateCharacter TemplateCharacters?
  ;

//  TemplateCharacter ::
//   $ [lookahead ≠ {]
//   \ EscapeSequence
//   LineContinuation
//   LineTerminatorSequence
//   SourceCharacter but not one of ` or \ or $ or LineTerminator
TemplateCharacter
  : '$' [lookahead ≠ {]
  | '\\' EscapeSequence
  | LineContinuation
  | LineTerminatorSequence
  | ~('`' | '\\' | '$' | LineTerminator)
  ;

//  IdentifierReference[Yield] :
//   Identifier
//   [~Yield] yield
IdentifierReference
  : Identifier
  | 'yield'
  ;

IdentifierReference_Yield
  : Identifier
  ;

//  BindingIdentifier[Yield] :
//   Identifier
//   [~Yield] yield
BindingIdentifier
  : Identifier
  | 'yield'
  ;

BindingIdentifier_Yield
  : Identifier
  ;

//  LabelIdentifier[Yield] :
//   Identifier
//   [~Yield] yield
LabelIdentifier
  : Identifier
  | 'yield'
  ;

LabelIdentifier_Yield
  : Identifier
  ;

//  Identifier :
//   IdentifierName but not ReservedWord
Identifier
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
PrimaryExpression
  : 'this'
  | IdentifierReference
  | Literal
  | ArrayLiteral
  | ObjectLiteral
  | FunctionExpression
  | ClassExpression
  | GeneratorExpression
  | RegularExpressionLiteral
  | TemplateLiteral
  | CoverParenthesizedExpressionAndArrowParameterList
  ;

PrimaryExpression_Yield
  : 'this'
  | IdentifierReference_Yield
  | Literal
  | ArrayLiteral_Yield
  | ObjectLiteral_Yield
  | FunctionExpression
  | ClassExpression_Yield
  | GeneratorExpression
  | RegularExpressionLiteral
  | TemplateLiteral_Yield
  | CoverParenthesizedExpressionAndArrowParameterList_Yield
  ;

//  CoverParenthesizedExpressionAndArrowParameterList[Yield] :
//   ( Expression[In, ?Yield] )
//   ( )
//   ( ... BindingIdentifier[?Yield] )
//   ( Expression[In, ?Yield] , ... BindingIdentifier[?Yield] )
CoverParenthesizedExpressionAndArrowParameterList
  : '(' Expression_In ')'
  | '(' ')'
  | '(' '...' BindingIdentifier ')'
  | '(' Expression_In ',' '...' BindingIdentifier ')'
  ;

CoverParenthesizedExpressionAndArrowParameterList_Yield
  : '(' Expression_In_Yield ')'
  | '(' ')'
  | '(' '...' BindingIdentifier_Yield ')'
  | '(' Expression_In_Yield ',' '...' BindingIdentifier_Yield ')'
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
ArrayLiteral
  : '[' Elision? ']'
  | '[' ElementList ']'
  | '[' ElementList ',' Elision? ']'
  ;

ArrayLiteral_Yield
  : '[' Elision? ']'
  | '[' ElementList_Yield ']'
  | '[' ElementList_Yield ',' Elision? ']'
  ;

//  ElementList[Yield] :
//   Elisionopt AssignmentExpression[In, ?Yield]
//   Elisionopt SpreadElement[?Yield]
//   ElementList[?Yield] , Elisionopt AssignmentExpression[In, ?Yield]
//   ElementList[?Yield] , Elisionopt SpreadElement[?Yield]
ElementList
  : Elision? (AssignmentExpression_In | SpreadElement) (',' Elision? (AssignmentExpression_In | SpreadElement))*
  ;

ElementList_Yield
  : Elision? (AssignmentExpression_In_Yield | SpreadElement_Yield) (',' Elision? (AssignmentExpression_In_Yield | SpreadElement_Yield))*
  ;

//  Elision :
//   ,
//   Elision ,
Elision
  : ','+
  ;

//  SpreadElement[Yield] :
//   ... AssignmentExpression[In, ?Yield]
SpreadElement
  : '...' AssignmentExpression_In
  ;

SpreadElement_Yield
  : '...' AssignmentExpression_In_Yield
  ;

//  ObjectLiteral[Yield] :
//   { }
//   { PropertyDefinitionList[?Yield] }
//   { PropertyDefinitionList[?Yield] , }
ObjectLiteral
  : '{' '}'
  | '{' PropertyDefinitionList '}'
  | '{' PropertyDefinitionList ',' '}'
  ;

ObjectLiteral_Yield
  : '{' '}'
  | '{' PropertyDefinitionList_Yield '}'
  | '{' PropertyDefinitionList_Yield ',' '}'
  ;

//  PropertyDefinitionList[Yield] :
//   PropertyDefinition[?Yield]
//   PropertyDefinitionList[?Yield] , PropertyDefinition[?Yield]
PropertyDefinitionList
  : PropertyDefinition (',' PropertyDefinition)*
  ;

PropertyDefinitionList_Yield
  : PropertyDefinition_Yield (',' PropertyDefinition_Yield)*
  ;

//  PropertyDefinition[Yield] :
//   IdentifierReference[?Yield]
//   CoverInitializedName[?Yield]
//   PropertyName[?Yield] : AssignmentExpression[In, ?Yield]
//   MethodDefinition[?Yield]
PropertyDefinition
  : IdentifierReference
  | CoverInitializedName
  | PropertyName ':' AssignmentExpression_In
  | MethodDefinition
  ;

PropertyDefinition_Yield
  : IdentifierReference_Yield
  | CoverInitializedName_Yield
  | PropertyName_Yield ':' AssignmentExpression_In_Yield
  | MethodDefinition_Yield
  ;

//  PropertyName[Yield] :
//   LiteralPropertyName
//   ComputedPropertyName[?Yield]
PropertyName
  : LiteralPropertyName
  | ComputedPropertyName
  ;

PropertyName_Yield
  : LiteralPropertyName
  | ComputedPropertyName_Yield
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
ComputedPropertyName
  : '[' AssignmentExpression_In ']'
  ;

ComputedPropertyName_Yield
  : '[' AssignmentExpression_In_Yield ']'
  ;

//  CoverInitializedName[Yield] :
//   IdentifierReference[?Yield] Initializer[In, ?Yield]
CoverInitializedName
  : IdentifierReference Initializer_In
  ;

CoverInitializedName_Yield
  : IdentifierReference_Yield Initializer_In_Yield
  ;

//  Initializer[In, Yield] :
//   = AssignmentExpression[?In, ?Yield]
Initializer
  : '=' AssignmentExpression
  ;

Initializer_In
  : '=' AssignmentExpression_In
  ;

Initializer_Yield
  : '=' AssignmentExpression_Yield
  ;

Initializer_In_Yield
  : '=' AssignmentExpression_In_Yield
  ;

//  TemplateLiteral[Yield] :
//   NoSubstitutionTemplate
//   TemplateHead Expression[In, ?Yield] TemplateSpans[?Yield]
TemplateLiteral
  : NoSubstitutionTemplate
  | TemplateHead Expression_In TemplateSpans
  ;

TemplateLiteral_Yield
  : NoSubstitutionTemplate
  | TemplateHead Expression_In_Yield TemplateSpans_Yield
  ;

//  TemplateSpans[Yield] :
//   TemplateTail
//   TemplateMiddleList[?Yield] TemplateTail
TemplateSpans
  : TemplateTail
  | TemplateMiddleList TemplateTail
  ;

TemplateSpans_Yield
  : TemplateTail
  | TemplateMiddleList_Yield TemplateTail
  ;

//  TemplateMiddleList[Yield] :
//   TemplateMiddle Expression[In, ?Yield]
//   TemplateMiddleList[?Yield] TemplateMiddle Expression[In, ?Yield]
TemplateMiddleList
  :  (TemplateMiddle Expression_In)+
  ;

TemplateMiddleList_Yield
  : (TemplateMiddle Expression_In_Yield)+
  ;

//  MemberExpression[Yield] :
//   PrimaryExpression[?Yield]
//   MemberExpression[?Yield] [ Expression[In, ?Yield] ]
//   MemberExpression[?Yield] . IdentifierName
//   MemberExpression[?Yield] TemplateLiteral[?Yield]
//   SuperProperty[?Yield]
//   MetaProperty
//   new MemberExpression[?Yield] Arguments[?Yield]
MemberExpression
  : PrimaryExpression
  | MemberExpression '[' Expression_In ']'
  | MemberExpression '.' IdentifierName
  | MemberExpression TemplateLiteral
  | SuperProperty
  | MetaProperty
  | 'new' MemberExpression Arguments
  ;

MemberExpression_Yield
  : PrimaryExpression_Yield
  | MemberExpression_Yield '[' Expression_In_Yield ']'
  | MemberExpression_Yield '.' IdentifierName
  | MemberExpression_Yield TemplateLiteral_Yield
  | SuperProperty_Yield
  | MetaProperty
  | 'new' MemberExpression_Yield Arguments_Yield
  ;

//  SuperProperty[Yield] :
//   super [ Expression[In, ?Yield] ]
//   super . IdentifierName
SuperProperty
  : 'super' '[' Expression_In ']'
  | 'super' '.' IdentifierName
  ;

SuperProperty_Yield
  : 'super' '[' Expression_In_Yield ']'
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
NewExpression
  : MemberExpression
  | 'new' NewExpression
  ;

NewExpression_Yield
  : MemberExpression_Yield
  | 'new' NewExpression_Yield
  ;

//  CallExpression[Yield] :
//   MemberExpression[?Yield] Arguments[?Yield]
//   SuperCall[?Yield]
//   CallExpression[?Yield] Arguments[?Yield]
//   CallExpression[?Yield] [ Expression[In, ?Yield] ]
//   CallExpression[?Yield] . IdentifierName
//   CallExpression[?Yield] TemplateLiteral[?Yield]
CallExpression
  : MemberExpression Arguments
  | SuperCall
  | CallExpression Arguments
  | CallExpression '[' Expression_In ']'
  | CallExpression '.' IdentifierName
  | CallExpression TemplateLiteral
  ;
CallExpression_Yield
  : MemberExpression_Yield Arguments_Yield
  | SuperCall_Yield
  | CallExpression_Yield Arguments_Yield
  | CallExpression_Yield '[' Expression_In_Yield ']'
  | CallExpression_Yield '.' IdentifierName
  | CallExpression_Yield TemplateLiteral_Yield
  ;

//  SuperCall[Yield] :
//   super Arguments[?Yield]
SuperCall
  : 'super' Arguments
  ;

SuperCall_Yield
  : 'super' Arguments_Yield
  ;

//  Arguments[Yield] :
//   ( )
//   ( ArgumentList[?Yield] )
Arguments
  : '(' ')'
  | '(' ArgumentList ')'
  ;

Arguments_Yield
  : '(' ')'
  | '(' ArgumentList_Yield ')'
  ;

//  ArgumentList[Yield] :
//   AssignmentExpression[In, ?Yield]
//   ... AssignmentExpression[In, ?Yield]
//   ArgumentList[?Yield] , AssignmentExpression[In, ?Yield]
//   ArgumentList[?Yield] , ... AssignmentExpression[In, ?Yield]
ArgumentList
  : '...'? AssignmentExpression_In (',' '...'? AssignmentExpression_In)*
  ;

ArgumentList_Yield
  : '...'? AssignmentExpression_In_Yield (',' '...'? AssignmentExpression_In_Yield)*
  ;

//  LeftHandSideExpression[Yield] :
//   NewExpression[?Yield]
//   CallExpression[?Yield]
LeftHandSideExpression
  : NewExpression
  | CallExpression
  ;

LeftHandSideExpression_Yield
  : NewExpression_Yield
  | CallExpression_Yield
  ;

//  PostfixExpression[Yield] :
//   LeftHandSideExpression[?Yield]
//   LeftHandSideExpression[?Yield] [no LineTerminator here] ++
//   LeftHandSideExpression[?Yield] [no LineTerminator here] --
PostfixExpression
  : LeftHandSideExpression
  | LeftHandSideExpression ~LineTerminator '++'
  | LeftHandSideExpression ~LineTerminator '--'
  ;
  
PostfixExpression_Yield
  : LeftHandSideExpression_Yield
  | LeftHandSideExpression_Yield ~LineTerminator '++'
  | LeftHandSideExpression_Yield ~LineTerminator '--'
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
UnaryExpression
  : PostfixExpression
  | 'delete' UnaryExpression
  | 'void' UnaryExpression
  | 'typeof' UnaryExpression
  | '++' UnaryExpression
  | '--' UnaryExpression
  | '+' UnaryExpression
  | '-' UnaryExpression
  | '~' UnaryExpression
  | '!' UnaryExpression
  ;

UnaryExpression_Yield
  : PostfixExpression_Yield
  | 'delete' UnaryExpression_Yield
  | 'void' UnaryExpression_Yield
  | 'typeof' UnaryExpression_Yield
  | '++' UnaryExpression_Yield
  | '--' UnaryExpression_Yield
  | '+' UnaryExpression_Yield
  | '-' UnaryExpression_Yield
  | '~' UnaryExpression_Yield
  | '!' UnaryExpression_Yield
  ;

//  MultiplicativeExpression[Yield] :
//   UnaryExpression[?Yield]
//   MultiplicativeExpression[?Yield] MultiplicativeOperator UnaryExpression[?Yield]
MultiplicativeExpression
  : UnaryExpression
  | MultiplicativeExpression MultiplicativeOperator UnaryExpression
  ;
  
MultiplicativeExpression_Yield
  : UnaryExpression_Yield
  | MultiplicativeExpression_Yield MultiplicativeOperator UnaryExpression_Yield
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
AdditiveExpression
  : MultiplicativeExpression
  | AdditiveExpression '+' MultiplicativeExpression
  | AdditiveExpression '-' MultiplicativeExpression
  ;

AdditiveExpression_Yield
  : MultiplicativeExpression_Yield
  | AdditiveExpression_Yield '+' MultiplicativeExpression_Yield
  | AdditiveExpression_Yield '-' MultiplicativeExpression_Yield
  ;

//  ShiftExpression[Yield] :
//   AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] << AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] >> AdditiveExpression[?Yield]
//   ShiftExpression[?Yield] >>> AdditiveExpression[?Yield]
ShiftExpression
  : AdditiveExpression
  | ShiftExpression '<<' AdditiveExpression
  | ShiftExpression '>>' AdditiveExpression
  | ShiftExpression '>>>' AdditiveExpression
  ;

ShiftExpression_Yield
  : AdditiveExpression_Yield
  | ShiftExpression_Yield '<<' AdditiveExpression_Yield
  | ShiftExpression_Yield '>>' AdditiveExpression_Yield
  | ShiftExpression_Yield '>>>' AdditiveExpression_Yield
  ;

//  RelationalExpression[In, Yield] :
//   ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] < ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] > ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] <= ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] >= ShiftExpression[?Yield]
//   RelationalExpression[?In, ?Yield] instanceof ShiftExpression[?Yield]
//   [+In] RelationalExpression[In, ?Yield] in ShiftExpression[?Yield]
RelationalExpression
  : ShiftExpression
  | RelationalExpression '<' ShiftExpression
  | RelationalExpression '>' ShiftExpression
  | RelationalExpression '<=' ShiftExpression
  | RelationalExpression '>=' ShiftExpression
  | RelationalExpression 'instanceof' ShiftExpression
  ;

RelationalExpression_In
  : ShiftExpression
  | RelationalExpression_In '<' ShiftExpression
  | RelationalExpression_In '>' ShiftExpression
  | RelationalExpression_In '<=' ShiftExpression
  | RelationalExpression_In '>=' ShiftExpression
  | RelationalExpression_In 'instanceof' ShiftExpression
  | RelationalExpression_In 'in' ShiftExpression
  ;

RelationalExpression_Yield
  : ShiftExpression_Yield
  | RelationalExpression_Yield '<' ShiftExpression_Yield
  | RelationalExpression_Yield '>' ShiftExpression_Yield
  | RelationalExpression_Yield '<=' ShiftExpression_Yield
  | RelationalExpression_Yield '>=' ShiftExpression_Yield
  | RelationalExpression_Yield 'instanceof' ShiftExpression_Yield
  ;

RelationalExpression_In_Yield
  : ShiftExpression_Yield
  | RelationalExpression_In_Yield '<' ShiftExpression_Yield
  | RelationalExpression_In_Yield '>' ShiftExpression_Yield
  | RelationalExpression_In_Yield '<=' ShiftExpression_Yield
  | RelationalExpression_In_Yield '>=' ShiftExpression_Yield
  | RelationalExpression_In_Yield 'instanceof' ShiftExpression_Yield
  | RelationalExpression_In_Yield 'in' ShiftExpression_Yield
  ;

//  EqualityExpression[In, Yield] :
//   RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] == RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] != RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] === RelationalExpression[?In, ?Yield]
//   EqualityExpression[?In, ?Yield] !== RelationalExpression[?In, ?Yield]
EqualityExpression
  : RelationalExpression
  | EqualityExpression '==' RelationalExpression
  | EqualityExpression '!=' RelationalExpression
  | EqualityExpression '===' RelationalExpression
  | EqualityExpression '!==' RelationalExpression
  ;

EqualityExpression_In
  : RelationalExpression_In
  | EqualityExpression_In '==' RelationalExpression_In
  | EqualityExpression_In '!=' RelationalExpression_In
  | EqualityExpression_In '===' RelationalExpression_In
  | EqualityExpression_In '!==' RelationalExpression_In
  ;

EqualityExpression_Yield
  : RelationalExpression_Yield
  | EqualityExpression_Yield '==' RelationalExpression_Yield
  | EqualityExpression_Yield '!=' RelationalExpression_Yield
  | EqualityExpression_Yield '===' RelationalExpression_Yield
  | EqualityExpression_Yield '!==' RelationalExpression_Yield
  ;

EqualityExpression_In_Yield
  : RelationalExpression_In_Yield
  | EqualityExpression_In_Yield '==' RelationalExpression_In_Yield
  | EqualityExpression_In_Yield '!=' RelationalExpression_In_Yield
  | EqualityExpression_In_Yield '===' RelationalExpression_In_Yield
  | EqualityExpression_In_Yield '!==' RelationalExpression_In_Yield
  ;

//  BitwiseANDExpression[In, Yield] :
//   EqualityExpression[?In, ?Yield]
//   BitwiseANDExpression[?In, ?Yield] & EqualityExpression[?In, ?Yield]
BitwiseANDExpression
  : EqualityExpression
  | BitwiseANDExpression '&' EqualityExpression
  ;

BitwiseANDExpression_In
  : EqualityExpression_In
  | BitwiseANDExpression_In '&' EqualityExpression_In
  ;

BitwiseANDExpression_Yield
  : EqualityExpression_Yield
  | BitwiseANDExpression_Yield '&' EqualityExpression_Yield
  ;

BitwiseANDExpression_In_Yield
  : EqualityExpression_In_Yield
  | BitwiseANDExpression_In_Yield '&' EqualityExpression_In_Yield
  ;

//  BitwiseXORExpression[In, Yield] :
//   BitwiseANDExpression[?In, ?Yield]
//   BitwiseXORExpression[?In, ?Yield] ^ BitwiseANDExpression[?In, ?Yield]
BitwiseXORExpression
  : BitwiseANDExpression
  | BitwiseXORExpression '^' BitwiseANDExpression
  ;

BitwiseXORExpression_In
  : BitwiseANDExpression_In
  | BitwiseXORExpression_In '^' BitwiseANDExpression_In
  ;

BitwiseXORExpression_Yield
  : BitwiseANDExpression_Yield
  | BitwiseXORExpression_Yield '^' BitwiseANDExpression_Yield
  ;

BitwiseXORExpression_In_Yield
  : BitwiseANDExpression_In_Yield
  | BitwiseXORExpression_In_Yield '^' BitwiseANDExpression_In_Yield
  ;

//  BitwiseORExpression[In, Yield] :
//   BitwiseXORExpression[?In, ?Yield]
//   BitwiseORExpression[?In, ?Yield] | BitwiseXORExpression[?In, ?Yield]
BitwiseORExpression
  : BitwiseXORExpression
  | BitwiseORExpression '|' BitwiseXORExpression
  ;

BitwiseORExpression_In
  : BitwiseXORExpression_In
  | BitwiseORExpression_In '|' BitwiseXORExpression_In
  ;

BitwiseORExpression_Yield
  : BitwiseXORExpression_Yield
  | BitwiseORExpression_Yield '|' BitwiseXORExpression_Yield
  ;

BitwiseORExpression_In_Yield
  : BitwiseXORExpression_In_Yield
  | BitwiseORExpression_In_Yield '|' BitwiseXORExpression_In_Yield
  ;

//  LogicalANDExpression[In, Yield] :
//   BitwiseORExpression[?In, ?Yield]
//   LogicalANDExpression[?In, ?Yield] && BitwiseORExpression[?In, ?Yield]
LogicalANDExpression
  : BitwiseORExpression
  | LogicalANDExpression '&&' BitwiseORExpression
  ;

LogicalANDExpression_In
  : BitwiseORExpression_In
  | LogicalANDExpression_In '&&' BitwiseORExpression_In
  ;

LogicalANDExpression_Yield
  : BitwiseORExpression_Yield
  | LogicalANDExpression_Yield '&&' BitwiseORExpression_Yield
  ;

LogicalANDExpression_In_Yield
  : BitwiseORExpression_In_Yield
  | LogicalANDExpression_In_Yield '&&' BitwiseORExpression_In_Yield
  ;

//  LogicalORExpression[In, Yield] :
//   LogicalANDExpression[?In, ?Yield]
//   LogicalORExpression[?In, ?Yield] || LogicalANDExpression[?In, ?Yield]
LogicalORExpression
  : LogicalANDExpression
  | LogicalORExpression '||' LogicalANDExpression
  ;

LogicalORExpression_In
  : LogicalANDExpression_In
  | LogicalORExpression_In '||' LogicalANDExpression_In
  ;

LogicalORExpression_Yield
  : LogicalANDExpression_Yield
  | LogicalORExpression_Yield '||' LogicalANDExpression_Yield
  ;

LogicalORExpression_In_Yield
  : LogicalANDExpression_In_Yield
  | LogicalORExpression_In_Yield '||' LogicalANDExpression_In_Yield
  ;

//  ConditionalExpression[In, Yield] :
//   LogicalORExpression[?In, ?Yield]
//   LogicalORExpression[?In, ?Yield] ? AssignmentExpression[In, ?Yield] : AssignmentExpression[?In, ?Yield]
  ConditionalExpression
  : LogicalORExpression
  | LogicalORExpression '?' AssignmentExpression_In ':' AssignmentExpression
  ;

  ConditionalExpression_In
  : LogicalORExpression_In
  | LogicalORExpression_In '?' AssignmentExpression_In ':' AssignmentExpression_In
  ;

  ConditionalExpression_Yield
  : LogicalORExpression_Yield
  | LogicalORExpression_Yield '?' AssignmentExpression_In_Yield ':' AssignmentExpression_Yield
  ;

  ConditionalExpression_In_Yield
  : LogicalORExpression_In_Yield
  | LogicalORExpression_In_Yield '?' AssignmentExpression_In_Yield ':' AssignmentExpression_In_Yield
  ;

//  AssignmentExpression[In, Yield] :
//   ConditionalExpression[?In, ?Yield]
//   [+Yield] YieldExpression[?In]
//   ArrowFunction[?In, ?Yield]
//   LeftHandSideExpression[?Yield] = AssignmentExpression[?In, ?Yield]
//   LeftHandSideExpression[?Yield] AssignmentOperator AssignmentExpression[?In, ?Yield]
AssignmentExpression
   : ConditionalExpression
   | ArrowFunction
   | LeftHandSideExpression '=' AssignmentExpression
   | LeftHandSideExpression AssignmentOperator AssignmentExpression
   ;

AssignmentExpression_In
   : ConditionalExpression_In
   | ArrowFunction_In
   | LeftHandSideExpression '=' AssignmentExpression_In
   | LeftHandSideExpression AssignmentOperator AssignmentExpression_In
   ;

AssignmentExpression_Yield
   : ConditionalExpression_Yield
   | YieldExpression
   | ArrowFunction_Yield
   | LeftHandSideExpression_Yield '=' AssignmentExpression_Yield
   | LeftHandSideExpression_Yield AssignmentOperator AssignmentExpression_Yield
   ;

AssignmentExpression_In_Yield
   : ConditionalExpression_In_Yield
   | YieldExpression_In
   | ArrowFunction_In_Yield
   | LeftHandSideExpression_Yield '=' AssignmentExpression_In_Yield
   | LeftHandSideExpression_Yield AssignmentOperator AssignmentExpression_In_Yield
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
Expression
   : AssignmentExpression
   | Expression ',' AssignmentExpression
   ;

Expression_In
   : AssignmentExpression_In
   | Expression_In ',' AssignmentExpression_In
   ;

Expression_Yield
   : AssignmentExpression_Yield
   | Expression_Yield ',' AssignmentExpression_Yield
   ;

Expression_In_Yield
   : AssignmentExpression_In_Yield
   | Expression_In_Yield ',' AssignmentExpression_In_Yield
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
Statement
  : BlockStatement
  | VariableStatement
  | EmptyStatement
  | ExpressionStatement
  | IfStatement
  | BreakableStatement
  | ContinueStatement
  | BreakStatement
  | WithStatement
  | LabelledStatement
  | ThrowStatement
  | TryStatement
  | DebuggerStatement
  ;

Statement_Yield
  : BlockStatement_Yield
  | VariableStatement_Yield
  | EmptyStatement
  | ExpressionStatement_Yield
  | IfStatement_Yield
  | BreakableStatement_Yield
  | ContinueStatement_Yield
  | BreakStatement_Yield
  | WithStatement_Yield
  | LabelledStatement_Yield
  | ThrowStatement_Yield
  | TryStatement_Yield
  | DebuggerStatement
  ;

Statement_Return
  : BlockStatement_Return
  | VariableStatement
  | EmptyStatement
  | ExpressionStatement
  | IfStatement_Return
  | BreakableStatement_Return
  | ContinueStatement
  | BreakStatement
  | ReturnStatement
  | WithStatement_Return
  | LabelledStatement_Return
  | ThrowStatement
  | TryStatement_Return
  | DebuggerStatement
  ;

Statement_Yield_Return
  : BlockStatement_Yield_Return
  | VariableStatement_Yield
  | EmptyStatement
  | ExpressionStatement_Yield
  | IfStatement_Yield_Return
  | BreakableStatement_Yield_Return
  | ContinueStatement_Yield
  | BreakStatement_Yield
  | ReturnStatement_Yield
  | WithStatement_Yield_Return
  | LabelledStatement_Yield_Return
  | ThrowStatement_Yield
  | TryStatement_Yield_Return
  | DebuggerStatement
  ;

//  Declaration[Yield] :
//   HoistableDeclaration[?Yield]
//   ClassDeclaration[?Yield]
//   LexicalDeclaration[In, ?Yield]
Declaration
  : HoistableDeclaration
  | ClassDeclaration
  | LexicalDeclaration_In
  ;

Declaration_Yield
  : HoistableDeclaration_Yield
  | ClassDeclaration_Yield
  | LexicalDeclaration_In_Yield
  ;

//  HoistableDeclaration[Yield, Default] :
//   FunctionDeclaration[?Yield, ?Default]
//   GeneratorDeclaration[?Yield, ?Default]
HoistableDeclaration
  : FunctionDeclaration
  | GeneratorDeclaration
  ;

HoistableDeclaration_Yield
  : FunctionDeclaration_Yield
  | GeneratorDeclaration_Yield
  ;

HoistableDeclaration_Default
  : FunctionDeclaration_Default
  | GeneratorDeclaration_Default
  ;

HoistableDeclaration_Yield_Default
  : FunctionDeclaration_Yield_Default
  | GeneratorDeclaration_Yield_Default
  ;

//  BreakableStatement[Yield, Return] :
//   IterationStatement[?Yield, ?Return]
//   SwitchStatement[?Yield, ?Return]
BreakableStatement
  : IterationStatement
  | SwitchStatement
  ;

BreakableStatement_Yield
  : IterationStatement_Yield
  | SwitchStatement_Yield
  ;

BreakableStatement_Return
  : IterationStatement_Return
  | SwitchStatement_Return
  ;

BreakableStatement_Yield_Return
  : IterationStatement_Yield_Return
  | SwitchStatement_Yield_Return
  ;

//  BlockStatement[Yield, Return] :
//   Block[?Yield, ?Return]
BlockStatement
  : Block
  ;

BlockStatement_Yield
  : Block_Yield
  ;

BlockStatement_Return
  : Block_Return
  ;

BlockStatement_Yield_Return
  : Block_Yield_Return
  ;

//  Block[Yield, Return] :
//   { StatementList[?Yield, ?Return]opt }
Block
  : '{' StatementList? '}'
  ;

Block_Yield
  : '{' StatementList_Yield? '}'
  ;

Block_Return
  : '{' StatementList_Return? '}'
  ;

Block_Yield_Return
  : '{' StatementList_Yield_Return? '}'
  ;

//  StatementList[Yield, Return] :
//   StatementListItem[?Yield, ?Return]
//   StatementList[?Yield, ?Return] StatementListItem[?Yield, ?Return]
StatementList
  : StatementListItem
  | StatementList StatementListItem
  ;

StatementList_Yield
  : StatementListItem_Yield
  | StatementList_Yield StatementListItem_Yield
  ;

StatementList_Return
  : StatementListItem_Return
  | StatementList_Return StatementListItem_Return
  ;

StatementList_Yield_Return
  : StatementListItem_Yield_Return
  | StatementList_Yield_Return StatementListItem_Yield_Return
  ;

//  StatementListItem[Yield, Return] :
//   Statement[?Yield, ?Return]
//   Declaration[?Yield]
StatementListItem
  : Statement
  | Declaration
  ;
StatementListItem_Yield
  : Statement_Yield
  | Declaration_Yield
  ;
StatementListItem_Return
  : Statement_Return
  | Declaration
  ;
StatementListItem_Yield_Return
  : Statement_Yield_Return
  | Declaration_Yield
  ;

//  LexicalDeclaration[In, Yield] :
//   LetOrConst BindingList[?In, ?Yield] ;
LexicalDeclaration
  : LetOrConst BindingList ';'
  ;

LexicalDeclaration_In
  : LetOrConst BindingList_In ';'
  ;

LexicalDeclaration_Yield
  : LetOrConst BindingList_Yield ';'
  ;

LexicalDeclaration_In_Yield
  : LetOrConst BindingList_In_Yield ';'
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
BindingList
  : LexicalBinding
  | BindingList ',' LexicalBinding
  ;

BindingList_In
  : LexicalBinding_In
  | BindingList_In ',' LexicalBinding_In
  ;

BindingList_Yield
  : LexicalBinding_Yield
  | BindingList_Yield ',' LexicalBinding_Yield
  ;

BindingList_In_Yield
  : LexicalBinding_In_Yield
  | BindingList_In_Yield ',' LexicalBinding_In_Yield
  ;

//  LexicalBinding[In, Yield] :
//   BindingIdentifier[?Yield] Initializer[?In, ?Yield]opt
//   BindingPattern[?Yield] Initializer[?In, ?Yield]
LexicalBinding
  : BindingIdentifier Initializer?
  | BindingPattern Initializer
  ;

LexicalBinding_In
  : BindingIdentifier Initializer_In?
  | BindingPattern Initializer_In
  ;

LexicalBinding_Yield
  : BindingIdentifier_Yield Initializer_Yield?
  | BindingPattern_Yield Initializer_Yield
  ;

LexicalBinding_In_Yield
  : BindingIdentifier_Yield Initializer_In_Yield?
  | BindingPattern_Yield Initializer_In_Yield
  ;

//  VariableStatement[Yield] :
//   var VariableDeclarationList[In, ?Yield] ;
VariableStatement
  : 'var' VariableDeclarationList_In ';'
  ;

VariableStatement_Yield
  : 'var' VariableDeclarationList_In_Yield ';'
  ;

//  VariableDeclarationList[In, Yield] :
//   VariableDeclaration[?In, ?Yield]
//   VariableDeclarationList[?In, ?Yield] , VariableDeclaration[?In, ?Yield]
VariableDeclarationList
  : VariableDeclaration
  | VariableDeclarationList ',' VariableDeclaration
  ;

VariableDeclarationList_In
  : VariableDeclaration_In
  | VariableDeclarationList_In ',' VariableDeclaration_In
  ;

VariableDeclarationList_Yield
  : VariableDeclaration_Yield
  | VariableDeclarationList_Yield ',' VariableDeclaration_Yield
  ;

VariableDeclarationList_In_Yield
  : VariableDeclaration_In_Yield
  | VariableDeclarationList_In_Yield ',' VariableDeclaration_In_Yield
  ;

//  VariableDeclaration[In, Yield] :
//   BindingIdentifier[?Yield] Initializer[?In, ?Yield]opt
//   BindingPattern[?Yield] Initializer[?In, ?Yield]
VariableDeclaration
  : BindingIdentifier Initializer?
  | BindingPattern Initializer
  ;
VariableDeclaration_In
  : BindingIdentifier Initializer_In?
  | BindingPattern Initializer_In
  ;
VariableDeclaration_Yield
  : BindingIdentifier_Yield Initializer_Yield?
  | BindingPattern_Yield Initializer_Yield
  ;
VariableDeclaration_In_Yield
  : BindingIdentifier_Yield Initializer_In_Yield?
  | BindingPattern_Yield Initializer_In_Yield
  ;

//  BindingPattern[Yield] :
//   ObjectBindingPattern[?Yield]
//   ArrayBindingPattern[?Yield]
BindingPattern
  : ObjectBindingPattern
  | ArrayBindingPattern
  ;

BindingPattern_Yield
  : ObjectBindingPattern_Yield
  | ArrayBindingPattern_Yield
  ;

//  ObjectBindingPattern[Yield] :
//   { }
//   { BindingPropertyList[?Yield] }
//   { BindingPropertyList[?Yield] , }
ObjectBindingPattern
  : '{' '}'
  | '{' BindingPropertyList '}'
  | '{' BindingPropertyList ',' '}'
  ;
ObjectBindingPattern_Yield
  : '{' '}'
  | '{' BindingPropertyList_Yield '}'
  | '{' BindingPropertyList_Yield ',' '}'
  ;

//  ArrayBindingPattern[Yield] :
//   [ Elisionopt BindingRestElement[?Yield]opt ]
//   [ BindingElementList[?Yield] ]
//   [ BindingElementList[?Yield] , Elisionopt BindingRestElement[?Yield]opt ]
ArrayBindingPattern
  : '[' Elision? BindingRestElement? ']'
  | '[' BindingElementList ']'
  | '[' BindingElementList ',' Elision? BindingRestElement? ']'
  ;

ArrayBindingPattern_Yield
  : '[' Elision? BindingRestElement_Yield? ']'
  | '[' BindingElementList_Yield ']'
  | '[' BindingElementList_Yield ',' Elision? BindingRestElement_Yield? ']'
  ;

//  BindingPropertyList[Yield] :
//   BindingProperty[?Yield]
//   BindingPropertyList[?Yield] , BindingProperty[?Yield]
BindingPropertyList
  : BindingProperty
  | BindingPropertyList ',' BindingProperty
  ;
BindingPropertyList_Yield
  : BindingProperty_Yield
  | BindingPropertyList_Yield ',' BindingProperty_Yield
  ;

//  BindingElementList[Yield] :
//   BindingElisionElement[?Yield]
//   BindingElementList[?Yield] , BindingElisionElement[?Yield]
BindingElementList
  : BindingElisionElement
  | BindingElementList ',' BindingElisionElement
  ;

BindingElementList_Yield
  : BindingElisionElement_Yield
  | BindingElementList_Yield ',' BindingElisionElement_Yield
  ;

//  BindingElisionElement[Yield] :
//   Elisionopt BindingElement[?Yield]
BindingElisionElement
  : Elision? BindingElement
  ;
BindingElisionElement_Yield
  : Elision? BindingElement_Yield
  ;

//  BindingProperty[Yield] :
//   SingleNameBinding[?Yield]
//   PropertyName[?Yield] : BindingElement[?Yield]
BindingProperty
  : SingleNameBinding
  | PropertyName ':' BindingElement
  ;

BindingProperty_Yield
  : SingleNameBinding_Yield
  | PropertyName_Yield ':' BindingElement_Yield
  ;

//  BindingElement[Yield] :
//   SingleNameBinding[?Yield]
//   BindingPattern[?Yield] Initializer[In, ?Yield]opt
BindingElement
  : SingleNameBinding
  | BindingPattern Initializer_In?
  ;

BindingElement_Yield
  : SingleNameBinding_Yield
  | BindingPattern_Yield Initializer_In_Yield?
  ;

//  SingleNameBinding[Yield] :
//   BindingIdentifier[?Yield] Initializer[In, ?Yield]opt
SingleNameBinding
  : BindingIdentifier Initializer?
  ;

SingleNameBinding_Yield
  : BindingIdentifier_Yield Initializer_In_Yield?
  ;

//  BindingRestElement[Yield] :
//   ... BindingIdentifier[?Yield]
BindingRestElement
  : '...' BindingIdentifier
  ;

BindingRestElement_Yield
  : '...' BindingIdentifier_Yield
  ;

EmptyStatement
  : ';'
  ;

//  ExpressionStatement[Yield] :
//   [lookahead ∉ { {, function, class, let [ }] Expression[In, ?Yield] ;
ExpressionStatement
  : {(_input.LA(1) != '{') && (_input.LA(1) != 'function') && (_input.LA(1) != 'class') && (_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression ';'
  ;

ExpressionStatement_Yield
  : {(_input.LA(1) != '{') && (_input.LA(1) != 'function') && (_input.LA(1) != 'class') && (_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression_In_Yield ';'
  ;

//  IfStatement[Yield, Return] :
//   if ( Expression[In, ?Yield] ) Statement[?Yield, ?Return] else Statement[?Yield, ?Return]
//   if ( Expression[In, ?Yield] ) Statement[?Yield, ?Return]
IfStatement
  : 'if' ( Expression_In ) Statement 'else' Statement
  | 'if' ( Expression_In ) Statement
  ;

IfStatement_Yield
  : 'if' ( Expression_In_Yield ) Statement_Yield 'else' Statement_Yield
  | 'if' ( Expression_In_Yield ) Statement_Yield
  ;

IfStatement_Return
  : 'if' ( Expression_In ) Statement_Return 'else' Statement_Return
  | 'if' ( Expression_In ) Statement_Return
  ;

IfStatement_Yield_Return
  : 'if' ( Expression_In_Yield ) Statement_Yield_Return 'else' Statement_Yield_Return
  | 'if' ( Expression_In_Yield ) Statement_Yield_Return
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
IterationStatement
  : 'do' Statement 'while' '(' Expression ')' ';'
  | 'while' '(' Expression ')' Statement
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression? ';' Expression? ';' Expression? ')' Statement
  | 'for' '(' 'var' VariableDeclarationList ';' Expression? ';' Expression? ')' Statement
  | 'for' '(' LexicalDeclaration Expression? ';' Expression? ')' Statement
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? LeftHandSideExpression 'in' Expression ')' Statement
  | 'for' '(' 'var' ForBinding 'in' Expression ')' Statement
  | 'for' '(' ForDeclaration 'in' Expression ')' Statement
  | 'for' '(' {(_input.LA(1) != 'let')}? LeftHandSideExpression 'of' AssignmentExpression ')' Statement
  | 'for' '(' 'var' ForBinding 'of' AssignmentExpression ')' Statement
  | 'for' '(' ForDeclaration 'of' AssignmentExpression ')' Statement
  ;

IterationStatement_Yield
  : 'do' Statement_Yield 'while' '(' Expression_Yield ')' ';'
  | 'while' '(' Expression_Yield ')' Statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression_Yield? ';' Expression_Yield? ';' Expression_Yield? ')' Statement_Yield
  | 'for' '(' 'var' VariableDeclarationList_Yield ';' Expression_Yield? ';' Expression_Yield? ')' Statement_Yield
  | 'for' '(' LexicalDeclaration_Yield Expression_Yield? ';' Expression_Yield? ')' Statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? LeftHandSideExpression_Yield 'in' Expression_Yield ')' Statement_Yield
  | 'for' '(' 'var' ForBinding_Yield 'in' Expression_Yield ')' Statement_Yield
  | 'for' '(' ForDeclaration_Yield 'in' Expression_Yield ')' Statement_Yield
  | 'for' '(' {(_input.LA(1) != 'let'))}? LeftHandSideExpression_Yield 'of' AssignmentExpression_Yield ')' Statement_Yield
  | 'for' '(' 'var' ForBinding_Yield 'of' AssignmentExpression_Yield ')' Statement_Yield
  | 'for' '(' ForDeclaration_Yield 'of' AssignmentExpression_Yield ')' Statement_Yield
  ;

IterationStatement_Return
  : 'do' Statement_Return 'while' '(' Expression_In ')' ';'
  | 'while' '(' Expression_In ')' Statement_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression? ';' Expression_In? ';' Expression_In? ')' Statement_Return
  | 'for' '(' 'var' VariableDeclarationList ';' Expression_In? ';' Expression_In? ')' Statement_Return
  | 'for' '(' LexicalDeclaration Expression_In? ';' Expression_In? ')' Statement_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? LeftHandSideExpression 'in' Expression_In ')' Statement_Return
  | 'for' '(' 'var' ForBinding 'in' Expression_In ')' Statement_Return
  | 'for' '(' ForDeclaration 'in' Expression_In ')' Statement_Return
  | 'for' '(' {(_input.LA(1) != 'let'))}? LeftHandSideExpression 'of' AssignmentExpression_In ')' Statement_Return
  | 'for' '(' 'var' ForBinding 'of' AssignmentExpression_In ')' Statement_Return
  | 'for' '(' ForDeclaration 'of' AssignmentExpression_In ')' Statement_Return
  ;

IterationStatement_Yield_Return
  : 'do' Statement_Yield_Return 'while' '(' Expression_In_Yield ')' ';'
  | 'while' '(' Expression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? Expression_Yield? ';' Expression_In_Yield? ';' Expression_In_Yield? ')' Statement_Yield_Return
  | 'for' '(' 'var' VariableDeclarationList_Yield ';' Expression_In_Yield? ';' Expression_In_Yield? ')' Statement_Yield_Return
  | 'for' '(' LexicalDeclaration_Yield Expression_In_Yield? ';' Expression_In_Yield? ')' Statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let') && (_input.LA(1) != '[')}? LeftHandSideExpression_Yield 'in' Expression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' 'var' ForBinding_Yield 'in' Expression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' ForDeclaration_Yield 'in' Expression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' {(_input.LA(1) != 'let'))}? LeftHandSideExpression_Yield 'of' AssignmentExpression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' 'var' ForBinding_Yield 'of' AssignmentExpression_In_Yield ')' Statement_Yield_Return
  | 'for' '(' ForDeclaration_Yield 'of' AssignmentExpression_In_Yield ')' Statement_Yield_Return
  ;

//  ForDeclaration[Yield] :
//   LetOrConst ForBinding[?Yield]
ForDeclaration
  : LetOrConst ForBinding
  ;

ForDeclaration_Yield
  : LetOrConst ForBinding_Yield
  ;

//  ForBinding[Yield] :
//   BindingIdentifier[?Yield]
//   BindingPattern[?Yield]
ForBinding
  : BindingIdentifier
  | BindingPattern
  ;

ForBinding_Yield
  : BindingIdentifier_Yield
  | BindingPattern_Yield
  ;

//  ContinueStatement[Yield] :
//   continue ;
//   continue [no LineTerminator here] LabelIdentifier[?Yield] ;
ContinueStatement
  : 'continue' ';'
  | 'continue' ~LineTerminator LabelIdentifier ';'
  ;

ContinueStatement_Yield
  : 'continue' ';'
  | 'continue' ~LineTerminator LabelIdentifier_Yield ';'
  ;

//  BreakStatement[Yield] :
//   break ;
//   break [no LineTerminator here] LabelIdentifier[?Yield] ;
BreakStatement
  : 'break' ';'
  | 'break' ~LineTerminator LabelIdentifier ';'
  ;

BreakStatement_Yield
  : 'break' ';'
  | 'break' ~LineTerminator LabelIdentifier_Yield ';'
  ;

//  ReturnStatement[Yield] :
//   return ;
//   return [no LineTerminator here] Expression[In, ?Yield] ;
ReturnStatement
  : 'return' ';'
  | 'return' ~LineTerminator Expression_In ';'
  ;

ReturnStatement_Yield
  : 'return' ';'
  | 'return' ~LineTerminator Expression_In_Yield ';'
  ;

//  WithStatement[Yield, Return] :
//   with ( Expression[In, ?Yield] ) Statement[?Yield, ?Return]
WithStatement
  : 'with' '(' Expression_Yield ')' Statement
  ;

WithStatement_Yield
  : 'with' '(' Expression_In_Yield ')' Statement_Yield
  ;

WithStatement_Return
  : 'with' '(' Expression_In ')' Statement_Return
  ;

WithStatement_Yield_Return
  : 'with' '(' Expression_In_Yield ')' Statement_Yield_Return
  ;

//  SwitchStatement[Yield, Return] :
//   switch ( Expression[In, ?Yield] ) CaseBlock[?Yield, ?Return]
SwitchStatement
  : 'switch' '(' Expression_In ')' CaseBlock
  ;

SwitchStatement_Yield
  : 'switch' '(' Expression_In_Yield ')' CaseBlock_Yield
  ;

SwitchStatement_Return
  : 'switch' '(' Expression_In ')' CaseBlock_Return
  ;

SwitchStatement_Yield_Return
  : 'switch' '(' Expression_In_Yield ')' CaseBlock_Yield_Return
  ;

//  CaseBlock[Yield, Return] :
//   { CaseClauses[?Yield, ?Return]opt }
//   { CaseClauses[?Yield, ?Return]opt DefaultClause[?Yield, ?Return] CaseClauses[?Yield, ?Return]opt }
CaseBlock
  : '{' CaseClauses? '}'
  | '{' CaseClauses? DefaultClause CaseClauses? '}'
  ;

CaseBlock_Yield
  : '{' CaseClauses_Yield? '}'
  | '{' CaseClauses_Yield? DefaultClause_Yield CaseClauses_Yield? '}'
  ;

CaseBlock_Return
  : '{' CaseClauses_Return? '}'
  | '{' CaseClauses_Return? DefaultClause_Return CaseClauses_Return? '}'
  ;

CaseBlock_Yield_Return
  : '{' CaseClauses_Yield_Return? '}'
  | '{' CaseClauses_Yield_Return? DefaultClause_Yield_Return CaseClauses_Yield_Return? '}'
  ;

//  CaseClauses[Yield, Return] :
//   CaseClause[?Yield, ?Return]
//   CaseClauses[?Yield, ?Return] CaseClause[?Yield, ?Return]
CaseClauses
  : CaseClause
  | CaseClauses CaseClause
  ;

CaseClauses_Yield
  : CaseClause_Yield
  | CaseClauses_Yield CaseClause_Yield
  ;

CaseClauses_Return
  : CaseClause_Return
  | CaseClauses_Return CaseClause_Return
  ;

CaseClauses_Yield_Return
  : CaseClause_Yield_Return
  | CaseClauses_Yield_Return CaseClause_Yield_Return
  ;

//  CaseClause[Yield, Return] :
//   case Expression[In, ?Yield] : StatementList[?Yield, ?Return]opt
CaseClause
  : 'case' Expression_In ':' StatementList?
  ;

CaseClause_Yield
  : 'case' Expression_In_Yield ':' StatementList_Yield?
  ;

CaseClause_Return
  : 'case' Expression_In ':' StatementList_Return?
  ;

CaseClause_Yield_Return
  : 'case' Expression_In_Yield ':' StatementList_Yield_Return?
  ;

//  DefaultClause[Yield, Return] :
//   default : StatementList[?Yield, ?Return]opt
DefaultClause
  : 'default' ':' StatementList?
  ;

DefaultClause_Yield
  : 'default' ':' StatementList_Yield?
  ;

DefaultClause_Return
  : 'default' ':' StatementList_Return?
  ;

DefaultClause_Yield_Return
  : 'default' ':' StatementList_Yield_Return?
  ;

//  LabelledStatement[Yield, Return] :
//   LabelIdentifier[?Yield] : LabelledItem[?Yield, ?Return]
LabelledStatement
  : LabelIdentifier ':' LabelledItem
  ;

LabelledStatement_Yield
  : LabelIdentifier_Yield ':' LabelledItem_Yield
  ;

LabelledStatement_Return
  : LabelIdentifier ':' LabelledItem_Return
  ;

LabelledStatement_Yield_Return
  : LabelIdentifier_Yield ':' LabelledItem_Yield_Return
  ;

//  LabelledItem[Yield, Return] :
//   Statement[?Yield, ?Return]
//   FunctionDeclaration[?Yield]
LabelledItem
  : Statement
  | FunctionDeclaration
  ;

LabelledItem_Yield
  : Statement_Yield
  | FunctionDeclaration_Yield
  ;

LabelledItem_Return
  : Statement_Return
  | FunctionDeclaration
  ;

LabelledItem_Yield_Return
  : Statement_Yield_Return
  | FunctionDeclaration_Yield
  ;

//  ThrowStatement[Yield] :
//   throw [no LineTerminator here] Expression[In, ?Yield] ;
ThrowStatement
  : 'throw' ~LineTerminator Expression_In ';'
  ;

ThrowStatement_Yield
  : 'throw' ~LineTerminator Expression_In_Yield ';'
  ;

//  TryStatement[Yield, Return] :
//   try Block[?Yield, ?Return] Catch[?Yield, ?Return]
//   try Block[?Yield, ?Return] Finally[?Yield, ?Return]
//   try Block[?Yield, ?Return] Catch[?Yield, ?Return] Finally[?Yield, ?Return]
TryStatement
  : 'try' Block Catch
  | 'try' Block Finally
  | 'try' Block Catch Finally
  ;

TryStatement_Yield
  : 'try' Block_Yield Catch_Yield
  | 'try' Block_Yield Finally_Yield
  | 'try' Block_Yield Catch_Yield Finally_Yield
  ;

TryStatement_Return
  : 'try' Block_Return Catch_Return
  | 'try' Block_Return Finally_Return
  | 'try' Block_Return Catch_Return Finally_Return
  ;

TryStatement_Yield_Return
  : 'try' Block_Yield_Return Catch_Yield_Return
  | 'try' Block_Yield_Return Finally_Yield_Return
  | 'try' Block_Yield_Return Catch_Yield_Return Finally_Yield_Return
  ;

//  Catch[Yield, Return] :
//   catch ( CatchParameter[?Yield] ) Block[?Yield, ?Return]
Catch
  : 'catch' '(' CatchParameter ')' Block
  ;

Catch_Yield
  : 'catch' '(' CatchParameter_Yield ')' Block_Yield
  ;

Catch_Return
  : 'catch' '(' CatchParameter ')' Block_Return
  ;

Catch_Yield_Return
  : 'catch' '(' CatchParameter_Yield ')' Block_Yield_Return
  ;

//  Finally[Yield, Return] :
//   finally Block[?Yield, ?Return]
Finally
  : 'finally' Block
  ;

Finally_Yield
  : 'finally' Block_Yield
  ;

Finally_Return
  : 'finally' Block_Return
  ;

Finally_Yield_Return
  : 'finally' Block_Yield_Return
  ;

//  CatchParameter[Yield] :
//   BindingIdentifier[?Yield]
//   BindingPattern[?Yield]
CatchParameter
  : BindingIdentifier
  | BindingPattern
  ;

CatchParameter_Yield
  : BindingIdentifier_Yield
  | BindingPattern_Yield
  ;

//  DebuggerStatement :
//   debugger ;
DebuggerStatement
  : 'debugger' ';'
  ;

//  FunctionDeclaration[Yield, Default] :
//   function BindingIdentifier[?Yield] ( FormalParameters ) { FunctionBody }
//   [+Default] function ( FormalParameters ) { FunctionBody }
FunctionDeclaration
  : 'function' BindingIdentifier '(' FormalParameters ')' '{' FunctionBody '}'
  | 'function' '(' FormalParameters ')' '{' FunctionBody '}'
  ;

FunctionDeclaration_Yield
  : 'function' BindingIdentifier_Yield '(' FormalParameters ')' '{' FunctionBody '}'
  | 'function' '(' FormalParameters ')' '{' FunctionBody '}'
  ;

FunctionDeclaration_Default
  : 'function' BindingIdentifier '(' FormalParameters ')' '{' FunctionBody '}'
  | 'function' '(' FormalParameters ')' '{' FunctionBody '}'
  ;

FunctionDeclaration_Yield_Default
  : 'function' BindingIdentifier_Yield '(' FormalParameters ')' '{' FunctionBody '}'
  | 'function' '(' FormalParameters ')' '{' FunctionBody '}'
  ;

//  FunctionExpression :
//   function BindingIdentifieropt ( FormalParameters ) { FunctionBody }
FunctionExpression
  : 'function' BindingIdentifier? '(' FormalParameters ')' '{' FunctionBody '}'
  ;

//  StrictFormalParameters[Yield] :
//   FormalParameters[?Yield]
StrictFormalParameters
  : FormalParameters
  ;

StrictFormalParameters_Yield
  : FormalParameters_Yield
  ;

//  FormalParameters[Yield] :
//   [empty]
//   FormalParameterList[?Yield]
FormalParameters
  : //[empty]
  | FormalParameterList
  ;

FormalParameters_Yield
  : //[empty]
  | FormalParameterList_Yield
  ;

//  FormalParameterList[Yield] :
//   FunctionRestParameter[?Yield]
//   FormalsList[?Yield]
//   FormalsList[?Yield] , FunctionRestParameter[?Yield]
FormalParameterList
  : FunctionRestParameter
  | FormalsList
  | FormalsList ',' FunctionRestParameter
  ;

FormalParameterList_Yield
  : FunctionRestParameter_Yield
  | FormalsList_Yield
  | FormalsList_Yield ',' FunctionRestParameter_Yield
  ;

//  FormalsList[Yield] :
//   FormalParameter[?Yield]
//   FormalsList[?Yield] , FormalParameter[?Yield]
FormalsList
  : FormalParameter
  | FormalsList ',' FormalParameter
  ;

FormalsList_Yield
  : FormalParameter_Yield
  | FormalsList_Yield ',' FormalParameter_Yield
  ;

//  FunctionRestParameter[Yield] :
//   BindingRestElement[?Yield]
FunctionRestParameter
  : BindingRestElement
  ;

FunctionRestParameter_Yield
  : BindingRestElement_Yield
  ;

//  FormalParameter[Yield] :
//   BindingElement[?Yield]
FormalParameter
  : BindingElement
  ;

FormalParameter_Yield
  : BindingElement_Yield
  ;

//  FunctionBody[Yield] :
//   FunctionStatementList[?Yield]
FunctionBody
  : FunctionStatementList
  ;

FunctionBody_Yield
  : FunctionStatementList_Yield
  ;

//  FunctionStatementList[Yield] :
//   StatementList[?Yield, Return]opt
FunctionStatementList
  : StatementList_Yield?
  ;

FunctionStatementList_Yield
  : StatementList_Yield_Return?
  ;

//  ArrowFunction[In, Yield] :
//   ArrowParameters[?Yield] [no LineTerminator here] => ConciseBody[?In]
ArrowFunction
  : ArrowParameters ~LineTerminator '=>' ConciseBody
  ;

ArrowFunction_In
  : ArrowParameters ~LineTerminator '=>' ConciseBody_In
  ;

ArrowFunction_Yield
  : ArrowParameters_Yield ~LineTerminator '=>' ConciseBody
  ;

ArrowFunction_In_Yield
  : ArrowParameters_Yield ~LineTerminator '=>' ConciseBody_In
  ;

//  ArrowParameters[Yield] :
//   BindingIdentifier[?Yield]
//   CoverParenthesizedExpressionAndArrowParameterList[?Yield]
ArrowParameters
     : BindingIdentifier
     | CoverParenthesizedExpressionAndArrowParameterList
     ;

ArrowParameters_Yield
  : BindingIdentifier_Yield
  | CoverParenthesizedExpressionAndArrowParameterList_Yield
  ;

//  ConciseBody[In] :
//   [lookahead ≠ {] AssignmentExpression[?In]
//   { FunctionBody }
ConciseBody
  : {(_input.LA(1) != '{')}? AssignmentExpression
  | '{' FunctionBody '}'
  ;

ConciseBody_In
  : {(_input.LA(1) != '{'))}? AssignmentExpression_In
  | '{' FunctionBody '}'
  ;

//  MethodDefinition[Yield] :
//   PropertyName[?Yield] ( StrictFormalParameters ) { FunctionBody }
//   GeneratorMethod[?Yield]
//   get PropertyName[?Yield] ( ) { FunctionBody }
//   set PropertyName[?Yield] ( PropertySetParameterList ) { FunctionBody }
MethodDefinition
  : PropertyName '(' StrictFormalParameters ')' '{' FunctionBody '}'
  | GeneratorMethod
  | 'get 'PropertyName '(' ')' '{' FunctionBody '}'
  | 'set' PropertyName '(' PropertySetParameterList ')' '{' FunctionBody '}'
  ;

MethodDefinition_Yield
  : PropertyName_Yield '(' StrictFormalParameters ')' '{' FunctionBody '}'
  | GeneratorMethod_Yield
  | 'get 'PropertyName_Yield '(' ')' '{' FunctionBody '}'
  | 'set' PropertyName_Yield '(' PropertySetParameterList ')' '{' FunctionBody '}'
  ;

//  PropertySetParameterList :
//   FormalParameter
PropertySetParameterList
  : FormalParameter
  ;

//  GeneratorMethod[Yield] :
//   * PropertyName[?Yield] ( StrictFormalParameters[Yield] ) { GeneratorBody }
GeneratorMethod
  : '*' PropertyName ( StrictFormalParameters ) '{' GeneratorBody '}'
  ;

GeneratorMethod_Yield
  : '*' PropertyName_Yield ( StrictFormalParameters_Yield ) '{' GeneratorBody '}'
  ;

//  GeneratorDeclaration[Yield, Default] :
//   function * BindingIdentifier[?Yield] ( FormalParameters[Yield] ) { GeneratorBody }
//   [+Default] function * ( FormalParameters[Yield] ) { GeneratorBody }
GeneratorDeclaration
  : 'function' '*' BindingIdentifier '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  ;

GeneratorDeclaration_Yield
  : 'function' '*' BindingIdentifier_Yield '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  ;

GeneratorDeclaration_Default
  : 'function' '*' BindingIdentifier_Yield '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  | 'function' '*' '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  ;

GeneratorDeclaration_Yield_Default
  : 'function' '*' BindingIdentifier_Yield '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  | 'function' '*' '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  ;

//  GeneratorExpression :
//   function * BindingIdentifier[Yield]opt ( FormalParameters[Yield] ) { GeneratorBody }
GeneratorExpression
  : 'function' '*' BindingIdentifier_Yield? '(' FormalParameters_Yield ')' '{' GeneratorBody '}'
  ;

//  GeneratorBody :
//   FunctionBody[Yield]
GeneratorBody
  : FunctionBody_Yield
  ;

//  YieldExpression[In] :
//   yield
//   yield [no LineTerminator here] AssignmentExpression[?In, Yield]
//   yield [no LineTerminator here] * AssignmentExpression[?In, Yield]
YieldExpression
  : 'yield'
  | 'yield' ~LineTerminator AssignmentExpression_Yield
  | 'yield' ~LineTerminator '*' AssignmentExpression_Yield
  ;

YieldExpression_In
  : 'yield'
  | 'yield' ~LineTerminator AssignmentExpression_In_Yield
  | 'yield' ~LineTerminator '*' AssignmentExpression_In_Yield
  ;

//  ClassDeclaration[Yield, Default] :
//   class BindingIdentifier[?Yield] ClassTail[?Yield]
//   [+Default] class ClassTail[?Yield]
ClassDeclaration
  : 'class' BindingIdentifier ClassTail
  ;

ClassDeclaration_Yield
  : 'class' BindingIdentifier_Yield ClassTail_Yield
  ;

ClassDeclaration_Default
  : 'class' BindingIdentifier ClassTail
  | 'class' ClassTail
  ;

ClassDeclaration_Yield_Default
  : 'class' BindingIdentifier_Yield ClassTail_Yield
  | 'class' ClassTail_Yield
  ;

//  ClassExpression[Yield] :
//   class BindingIdentifier[?Yield]opt ClassTail[?Yield]
ClassExpression
  : 'class' BindingIdentifier? ClassTail
  ;

ClassExpression_Yield
  : 'class' BindingIdentifier_Yield? ClassTail_Yield
  ;

//  ClassTail[Yield] :
//   ClassHeritage[?Yield]opt { ClassBody[?Yield]opt }
ClassTail
  : ClassHeritage? '{' ClassBody? '}'
  ;

ClassTail_Yield
  : ClassHeritage_Yield? '{' ClassBody_Yield? '}'
  ;

//  ClassHeritage[Yield] :
//   extends LeftHandSideExpression[?Yield]
ClassHeritage
  : 'extends' LeftHandSideExpression
  ;

ClassHeritage_Yield
  : 'extends' LeftHandSideExpression_Yield
  ;

//  ClassBody[Yield] :
//   ClassElementList[?Yield]
ClassBody
  : ClassElementList
  ;

ClassBody_Yield
  : ClassElementList_Yield
  ;

//  ClassElementList[Yield] :
//   ClassElement[?Yield]
//   ClassElementList[?Yield] ClassElement[?Yield]
ClassElementList
  : ClassElement
  | ClassElementList ClassElement
  ;

ClassElementList_Yield
  : ClassElement_Yield
  | ClassElementList_Yield ClassElement_Yield
  ;

//  ClassElement[Yield] :
//   MethodDefinition[?Yield]
//   static MethodDefinition[?Yield]
//   ;
ClassElement
  : MethodDefinition
  | 'static' MethodDefinition
  | ';'
  ;

ClassElement_Yield
  : MethodDefinition_Yield
  | 'static' MethodDefinition_Yield
  | ';'
  ;

//  Script :
//   ScriptBodyopt
Script
  : ScriptBody?
  ;

//  ScriptBody :
//   StatementList
ScriptBody :
   StatementList;

//  Module :
//   ModuleBodyopt
  Module :
   ModuleBody?;

//  ModuleBody :
//   ModuleItemList
  ModuleBody :
   ModuleItemList;

//  ModuleItemList :
//   ModuleItem
//   ModuleItemList ModuleItem
  ModuleItemList :
   ModuleItem
  | ModuleItemList ModuleItem;

//  ModuleItem :
//   ImportDeclaration
//   ExportDeclaration
//   StatementListItem
  ModuleItem :
   ImportDeclaration
  | ExportDeclaration
  | StatementListItem;

//  ImportDeclaration :
//   import ImportClause FromClause ;
//   import ModuleSpecifier ;
  ImportDeclaration
  : 'import' ImportClause FromClause ';'
  | 'import' ModuleSpecifier ';'
  ;

//  ImportClause :
//   ImportedDefaultBinding
//   NameSpaceImport
//   NamedImports
//   ImportedDefaultBinding , NameSpaceImport
//   ImportedDefaultBinding , NamedImports
ImportClause
  : ImportedDefaultBinding
  | NameSpaceImport
  | NamedImports
  | ImportedDefaultBinding ',' NameSpaceImport
  | ImportedDefaultBinding ',' NamedImports
  ;

//  ImportedDefaultBinding :
//   ImportedBinding
  ImportedDefaultBinding :
   ImportedBinding;

//  NameSpaceImport :
//   * as ImportedBinding
  NameSpaceImport :
   '*' 'as' ImportedBinding;

//  NamedImports :
//   { }
//   { ImportsList }
//   { ImportsList , }
NamedImports
  : '{' '}'
  | '{' ImportsList '}'
  | '{' ImportsList ',' '}'
  ;

//  FromClause :
//   from ModuleSpecifier
FromClause
  : 'from' ModuleSpecifier
  ;

//  ImportsList :
//   ImportSpecifier
//   ImportsList , ImportSpecifier
ImportsList
  : ImportSpecifier
  | ImportsList ',' ImportSpecifier
  ;

//  ImportSpecifier :
//   ImportedBinding
//   IdentifierName as ImportedBinding
ImportSpecifier
  : ImportedBinding
  | IdentifierName 'as' ImportedBinding
  ;

//  ModuleSpecifier :
//   StringLiteral
ModuleSpecifier
  : StringLiteral
  ;

//  ImportedBinding :
//   BindingIdentifier
ImportedBinding
  : BindingIdentifier
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
ExportDeclaration
  : 'export' '*' FromClause ';'
  | 'export' ExportClause FromClause ';'
  | 'export' ExportClause ';'
  | 'export' VariableStatement
  | 'export' Declaration
  | 'export' 'default' HoistableDeclaration_Default
  | 'export' 'default' ClassDeclaration_Default
  | 'export' 'default' {(_input.LA(1) != 'function') && (_input.LA(1) != 'class')}? AssignmentExpression_In ';'
  ;

//  ExportClause :
//   { }
//   { ExportsList }
//   { ExportsList , }
ExportClause
  : '{' '}'
  | '{' ExportsList '}'
  | '{' ExportsList ',' '}'
  ;

//  ExportsList :
//   ExportSpecifier
//   ExportsList , ExportSpecifier
ExportsList
  : ExportSpecifier
  | ExportsList ',' ExportSpecifier
  ;

//  ExportSpecifier :
//   IdentifierName
//   IdentifierName as IdentifierName
ExportSpecifier
  : IdentifierName
  | IdentifierName 'as' IdentifierName
  ;
