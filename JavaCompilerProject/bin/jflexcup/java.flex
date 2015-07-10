package jflexcup;


import java_cup.runtime.*;

%%

%public
%class Scanner

%unicode

%line
%column

%cup
%cupdebug

%{
  StringBuilder string = new StringBuilder();
  
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }
  /* error reporting */
  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }
 
  private long parseLong(int start, int end, int radix) {
    long result = 0;
    long digit;

    for (int i = start; i < end; i++) {
      digit  = Character.digit(yycharat(i),radix);
      result*= radix;
      result+= digit;
    }

    return result;
  }
%}

/* main character classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | 
          {DocumentationComment}

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/*" "*"+ [^/*] ~"*/"

/* identifiers */
Identifier = [:jletter:][:jletterdigit:]*

/* integer literals */
DecIntegerLiteral = 0 | [1-9][0-9]*
DecLongLiteral    = {DecIntegerLiteral} [lL]

HexIntegerLiteral = 0 [xX] 0* {HexDigit} {1,8}
HexLongLiteral    = 0 [xX] 0* {HexDigit} {1,16} [lL]
HexDigit          = [0-9a-fA-F]

OctIntegerLiteral = 0+ [1-3]? {OctDigit} {1,15}
OctLongLiteral    = 0+ 1? {OctDigit} {1,21} [lL]
OctDigit          = [0-7]
    
/* floating point literals */        
FloatLiteral  = ({FLit1}|{FLit2}|{FLit3}) {Exponent}? [fF]
DoubleLiteral = ({FLit1}|{FLit2}|{FLit3}) {Exponent}?

FLit1    = [0-9]+ \. [0-9]* 
FLit2    = \. [0-9]+ 
FLit3    = [0-9]+ 
Exponent = [eE] [+-]? [0-9]+

/* string and character literals */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

%state STRING, CHARLITERAL

%%

<YYINITIAL> {

  /* keywords */
  "abstract"                     { return symbol( sym.ABSTRACT); }
  "boolean"                      { return symbol( sym.BOOLEAN); }
  "break"                        { return symbol( sym.BREAK); }
  "byte"                         { return symbol( sym.BYTE); }
  "case"                         { return symbol( sym.CASE); }
  "catch"                        { return symbol( sym.CATCH); }
  "char"                         { return symbol( sym.CHAR); }
  "class"                        { return symbol( sym.CLASS); }
  "const"                        { return symbol( sym.CONST); }
  "continue"                     { return symbol( sym.CONTINUE); }
  "do"                           { return symbol( sym.DO); }
  "double"                       { return symbol( sym.DOUBLE); }
  "else"                         { return symbol( sym.ELSE); }
  "extends"                      { return symbol( sym.EXTENDS); }
  "final"                        { return symbol( sym.FINAL); }
  "finally"                      { return symbol( sym.FINALLY); }
  "float"                        { return symbol( sym.FLOAT); }
  "for"                          { return symbol( sym.FOR); }
  "default"                      { return symbol( sym.DEFAULT); }
  "implements"                   { return symbol( sym.IMPLEMENTS); }
  "import"                       { return symbol( sym.IMPORT); }
  "instanceof"                   { return symbol( sym.INSTANCEOF); }
  "int"                          { return symbol( sym.INT); }
  "interface"                    { return symbol( sym.INTERFACE); }
  "long"                         { return symbol( sym.LONG); }
  "native"                       { return symbol( sym.NATIVE); }
  "new"                          { return symbol( sym.NEW); }
  "goto"                         { return symbol( sym.GOTO); }
  "if"                           { return symbol( sym.IF); }
  "public"                       { return symbol( sym.PUBLIC); }
  "short"                        { return symbol( sym.SHORT); }
  "super"                        { return symbol( sym.SUPER); }
  "switch"                       { return symbol( sym.SWITCH); }
  "synchronized"                 { return symbol( sym.SYNCHRONIZED); }
  "package"                      { return symbol( sym.PACKAGE); }
  "private"                      { return symbol( sym.PRIVATE); }
  "protected"                    { return symbol( sym.PROTECTED); }
  "transient"                    { return symbol( sym.TRANSIENT); }
  "return"                       { return symbol( sym.RETURN); }
  "void"                         { return symbol( sym.VOID); }
  "static"                       { return symbol( sym.STATIC); }
  "while"                        { return symbol( sym.WHILE); }
  "this"                         { return symbol( sym.THIS); }
  "throw"                        { return symbol( sym.THROW); }
  "throws"                       { return symbol( sym.THROWS); }
  "try"                          { return symbol( sym.TRY); }
  "volatile"                     { return symbol( sym.VOLATILE); }
  "strictfp"                     { return symbol( sym.STRICTFP); }
  
  /* boolean literals */
  "true"                         { return symbol( sym.BOOLEAN_LITERAL, true); }
  "false"                        { return symbol( sym.BOOLEAN_LITERAL, false); }
  
  /* null literal */
  "null"                         { return symbol( sym.NULL_LITERAL); }
  
  
  /* separators */
  "("                            { return symbol( sym.LPAREN); }
  ")"                            { return symbol( sym.RPAREN); }
  "{"                            { return symbol( sym.LBRACE); }
  "}"                            { return symbol( sym.RBRACE); }
  "["                            { return symbol( sym.LBRACK); }
  "]"                            { return symbol( sym.RBRACK); }
  ";"                            { return symbol( sym.SEMICOLON); }
  ","                            { return symbol( sym.COMMA); }
  "."                            { return symbol( sym.DOT); }
  
  /* operators */
  "="                            { return symbol( sym.EQ); }
  ">"                            { return symbol( sym.GT); }
  "<"                            { return symbol( sym.LT); }
  "!"                            { return symbol( sym.NOT); }
  "~"                            { return symbol( sym.COMP); }
  "?"                            { return symbol( sym.QUESTION); }
  ":"                            { return symbol( sym.COLON); }
  "=="                           { return symbol( sym.EQEQ); }
  "<="                           { return symbol( sym.LTEQ); }
  ">="                           { return symbol( sym.GTEQ); }
  "!="                           { return symbol( sym.NOTEQ); }
  "&&"                           { return symbol( sym.ANDAND); }
  "||"                           { return symbol( sym.OROR); }
  "++"                           { return symbol( sym.PLUSPLUS); }
  "--"                           { return symbol( sym.MINUSMINUS); }
  "+"                            { return symbol( sym.PLUS); }
  "-"                            { return symbol( sym.MINUS); }
  "*"                            { return symbol( sym.MULT); }
  "/"                            { return symbol( sym.DIV); }
  "&"                            { return symbol( sym.AND); }
  "|"                            { return symbol( sym.OR); }
  "^"                            { return symbol( sym.XOR); }
  "%"                            { return symbol( sym.MOD); }
  "<<"                           { return symbol( sym.LSHIFT); }
  ">>"                           { return symbol( sym.RSHIFT); }
  ">>>"                          { return symbol( sym.URSHIFT); }
  "+="                           { return symbol( sym.PLUSEQ); }
  "-="                           { return symbol( sym.MINUSEQ); }
  "*="                           { return symbol( sym.MULTEQ); }
  "/="                           { return symbol( sym.DIVEQ); }
  "&="                           { return symbol( sym.ANDEQ); }
  "|="                           { return symbol( sym.OREQ); }
  "^="                           { return symbol( sym.XOREQ); }
  "%="                           { return symbol( sym.MODEQ); }
  "<<="                          { return symbol( sym.LSHIFTEQ); }
  ">>="                          { return symbol( sym.RSHIFTEQ); }
  ">>>="                         { return symbol( sym.URSHIFTEQ); }
  
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }

  /* character literal */
  \'                             { yybegin(CHARLITERAL); }

  /* numeric literals */

  /* This is matched together with the minus, because the number is too big to 
     be represented by a positive integer. */
  "-2147483648"                  { return symbol( sym.INTEGER_LITERAL, new Integer(Integer.MIN_VALUE)); }
  
  {DecIntegerLiteral}            { return symbol( sym.INTEGER_LITERAL, new Integer(yytext())); }
  {DecLongLiteral}               { return symbol( sym.INTEGER_LITERAL, new Long(yytext().substring(0,yylength()-1))); }
  
  {HexIntegerLiteral}            { return symbol( sym.INTEGER_LITERAL, new Integer((int) parseLong(2, yylength(), 16))); }
  {HexLongLiteral}               { return symbol( sym.INTEGER_LITERAL, new Long(parseLong(2, yylength()-1, 16))); }
 
  {OctIntegerLiteral}            { return symbol( sym.INTEGER_LITERAL, new Integer((int) parseLong(0, yylength(), 8))); }  
  {OctLongLiteral}               { return symbol( sym.INTEGER_LITERAL, new Long(parseLong(0, yylength()-1, 8))); }
  
  {FloatLiteral}                 { return symbol( sym.FLOATING_POINT_LITERAL, new Float(yytext().substring(0,yylength()-1))); }
  {DoubleLiteral}                { return symbol( sym.FLOATING_POINT_LITERAL, new Double(yytext())); }
  {DoubleLiteral}[dD]            { return symbol( sym.FLOATING_POINT_LITERAL, new Double(yytext().substring(0,yylength()-1))); }
  
  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol( sym.IDENTIFIER, yytext()); }  
}

<STRING> {
  \"                             { yybegin(YYINITIAL); return symbol( sym.STRING_LITERAL, string.toString()); }
  
  {StringCharacter}+             { string.append( yytext() ); }
  
  /* escape sequences */
  "\\b"                          { string.append( '\b' ); }
  "\\t"                          { string.append( '\t' ); }
  "\\n"                          { string.append( '\n' ); }
  "\\f"                          { string.append( '\f' ); }
  "\\r"                          { string.append( '\r' ); }
  "\\\""                         { string.append( '\"' ); }
  "\\'"                          { string.append( '\'' ); }
  "\\\\"                         { string.append( '\\' ); }
  \\[0-3]?{OctDigit}?{OctDigit}  { char val = (char) Integer.parseInt(yytext().substring(1),8);
                        				   string.append( val ); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Sequência de escape inválida \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("String não terminada no fim da linha."); }
}

<CHARLITERAL> {
  {SingleCharacter}\'            { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, yytext().charAt(0)); }
  
  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\b');}
  "\\t"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\t');}
  "\\n"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\n');}
  "\\f"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\f');}
  "\\r"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\r');}
  "\\\""\'                       { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\"');}
  "\\'"\'                        { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\'');}
  "\\\\"\'                       { yybegin(YYINITIAL); return symbol( sym.CHARACTER_LITERAL, '\\'); }
  \\[0-3]?{OctDigit}?{OctDigit}\' { yybegin(YYINITIAL); 
			                              int val = Integer.parseInt(yytext().substring(1,yylength()-1),8);
			                            return symbol( sym.CHARACTER_LITERAL, (char)val); }
  
  /* error cases */
  \\.                            { throw new RuntimeException("Sequência de escape inválida \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Caractere literal não terminado no fim da linha"); }

  
}

/* error fallback */
{DecIntegerLiteral}{Identifier}	 { throw new RuntimeException("Variável não pode começar com número em \""+yytext()+
                                                              "\" na linha "+(yyline+1)+", coluna "+(yycolumn+1)); }
[^]|\n                             { throw new RuntimeException("Caractere inválido \""+yytext()+
                                                              "\" na linha "+(yyline+1)+", coluna "+(yycolumn+1)); }
                                                              
                                                              
<<EOF>>                          { return symbol( sym.EOF); }