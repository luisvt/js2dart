import ECMAScriptParser.ArgumentsExpressionContext
import ECMAScriptParser.EqualityExpressionContext
import ECMAScriptParser.PropertyGetterContext
import ECMAScriptParser.PropertyExpressionAssignmentContext
import ECMAScriptParser.LiteralExpressionContext
import ECMAScriptParser.LogicalAndExpressionContext
import ECMAScriptParser.LogicalOrExpressionContext
import ECMAScriptParser.RelationalExpressionContext
import ECMAScriptParser.InstanceofExpressionContext
import ECMAScriptParser.NotExpressionContext
import ECMAScriptParser.ThisExpressionContext
import ECMAScriptParser.IdentifierExpressionContext
import ECMAScriptParser.LiteralExpressionContext
import ECMAScriptParser.ArrayLiteralExpressionContext
import ECMAScriptParser.MemberIndexExpressionContext
import ECMAScriptParser.FunctionExpressionContext
import ECMAScriptParser.ObjectLiteralExpressionContext
import ECMAScriptParser.MemberDotExpressionContext
import ECMAScriptParser.ParenthesizedExpressionContext
import ECMAScriptParser.TypeofExpressionContext
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.BufferedTokenStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.*

import static java.lang.Character.isUpperCase

String inputFile = null
if (args.length > 0) inputFile = args[0]
def is = System.in

if (inputFile != null) {
    is = new FileInputStream(inputFile)
}
def input = new ANTLRInputStream(is)

def lexer = new ECMAScriptLexer(input)
def tokens = new CommonTokenStream(lexer)
def parser = new ECMAScriptParser(tokens)
def tree = parser.program() // parse

def walker = new CustomParserTreeWalker() // create standard walker
def extractor = new RefPhase(parser, tokens, walker)
walker.walk(extractor, tree) // initiate walk of tree with listener

print extractor.dartSrc
