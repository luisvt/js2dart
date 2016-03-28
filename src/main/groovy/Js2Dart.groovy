import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.BufferedTokenStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.ErrorNode
import org.antlr.v4.runtime.tree.ParseTree
import org.antlr.v4.runtime.tree.ParseTreeListener
import org.antlr.v4.runtime.tree.ParseTreeWalker
import org.antlr.v4.runtime.tree.RuleNode
import org.antlr.v4.runtime.tree.TerminalNode

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

        def walker = new CustomParserTreeWalker() // create standard walker
        def extractor = new Js2DartListener(parser, tokens, walker)
        walker.walk(extractor, tree) // initiate walk of tree with listener
    }
}

class CustomParserTreeWalker extends ParseTreeWalker {
    int lastVisitedNodeIndex = -1

    @Override
    void walk(ParseTreeListener listener, ParseTree t) {
        if (t instanceof ErrorNode) {
            listener.visitErrorNode(t);
        } else if (t instanceof TerminalNode) {
            if (lastVisitedNodeIndex >= t.symbol.tokenIndex) return
            listener.visitTerminal(t);
            lastVisitedNodeIndex = t.symbol.tokenIndex
        } else if (t instanceof ParserRuleContext) {
            if (lastVisitedNodeIndex >= t.start.tokenIndex) return

            enterRule(listener, t);
            for (def child : t.children) {
                walk(listener, child);
            }
            exitRule(listener, t);
        }
    }
}

class Js2DartListener extends ECMAScriptBaseListener {
    private ECMAScriptParser parser
    private BufferedTokenStream tokens
    private CustomParserTreeWalker walker

    Js2DartListener(ECMAScriptParser parser, BufferedTokenStream tokens, CustomParserTreeWalker walker) {
        this.parser = parser
        this.tokens = tokens
        this.walker = walker
    }

    @Override
    void enterLogicalOrExpression(ECMAScriptParser.LogicalOrExpressionContext ctx) {
        print "or("
        walker.walk(this, ctx.singleExpression(0))
        print ","
        walker.walk(this, ctx.singleExpression(1))
        print ")"
    }

    @Override
    void enterLogicalAndExpression(ECMAScriptParser.LogicalAndExpressionContext ctx) {
        print "and("
        walker.walk(this, ctx.singleExpression(0))
        print ","
        walker.walk(this, ctx.singleExpression(1))
        print ")"
    }

    @Override
    void enterEqualityExpression(ECMAScriptParser.EqualityExpressionContext ctx) {
        def operation = ctx.getChild(1).text

        walker.walk(this, ctx.singleExpression(0))


        print ' ' + (operation == '===' ?
                '==' : operation == '!==' ?
                '!=' : operation)

        walker.walk(this, ctx.singleExpression(1))
    }

    int lastVisitedNodeIndex
    @Override
    void enterEveryRule(ParserRuleContext ctx) {
        if(lastVisitedNodeIndex >= ctx.start.tokenIndex) return

        lastVisitedNodeIndex = ctx.start.tokenIndex
        def hiddenTokensToLeft = tokens.getHiddenTokensToLeft(ctx.start.tokenIndex, ECMAScriptLexer.HIDDEN);
        hiddenTokensToLeft.each { print it.text }
    }


    @Override
    void visitTerminal(TerminalNode node) {

        if (lastVisitedNodeIndex < node.symbol.tokenIndex) {
            def hiddenTokensToLeft = tokens.getHiddenTokensToLeft(node.symbol.tokenIndex, ECMAScriptLexer.HIDDEN);
            hiddenTokensToLeft.each { print it.text }
        }

        print node
    }
}