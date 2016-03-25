import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.tree.ParseTreeWalker

class Js2Dart {

    static void main(String[] args) throws Exception {
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

        def walker = new ParseTreeWalker() // create standard walker
        def extractor = new Js2DartListener(parser)
        walker.walk(extractor, tree) // initiate walk of tree with listener
    }
}

class Js2DartListener extends ECMAScriptBaseListener {
    ECMAScriptParser parser

    Js2DartListener(ECMAScriptParser parser) {
        this.parser = parser
    }

    @Override
    void enterLogicalOrExpression(ECMAScriptParser.LogicalOrExpressionContext ctx) {
        print "or("
        ctx.singleExpression(0).enterRule(this)
        print ", "
        ctx.singleExpression(1).enterRule(this)
        print ")\n"
    }

    @Override
    void enterEqualityExpression(ECMAScriptParser.EqualityExpressionContext ctx) {
        def operation = ctx.getChild(1).text

        operation = operation == '===' ?
                '==' : operation == '!==' ?
                '!=' : operation

        print "${ctx.singleExpression(0).text} $operation ${ctx.singleExpression(1).text}"
    }
}