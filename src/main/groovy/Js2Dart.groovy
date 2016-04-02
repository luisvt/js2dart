import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.BufferedTokenStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.ErrorNode
import org.antlr.v4.runtime.tree.ParseTree
import org.antlr.v4.runtime.tree.ParseTreeListener
import org.antlr.v4.runtime.tree.ParseTreeWalker
import org.antlr.v4.runtime.tree.TerminalNode

import static java.lang.Character.isUpperCase

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
        _walk(ctx.singleExpression(0))
        print ","
        _walk(ctx.singleExpression(1))
        print ")"
    }

    @Override
    void enterLogicalAndExpression(ECMAScriptParser.LogicalAndExpressionContext ctx) {
        print "and("
        _walk(ctx.singleExpression(0))
        print ","
        _walk(ctx.singleExpression(1))
        print ")"
    }

    @Override
    void enterEqualityExpression(ECMAScriptParser.EqualityExpressionContext ctx) {
        def operation = ctx.getChild(1).text

        _walk(ctx.singleExpression(0))


        print ' ' + (operation == '===' ?
                '==' : operation == '!==' ?
                '!=' : operation)

        _walk(ctx.singleExpression(1))
    }

    @Override
    void enterLiteralExpression(ECMAScriptParser.LiteralExpressionContext ctx) {
        def regexLiteral = ctx.literal().RegularExpressionLiteral()
        if (regexLiteral != null) {
            walker.lastVisitedNodeIndex = ctx.start.tokenIndex
            print "new RegExp(r'${regexLiteral.text.substring(1, regexLiteral.text.length() - 1)}')"
        }
    }

    @Override
    void enterMemberDotExpression(ECMAScriptParser.MemberDotExpressionContext ctx) {
        if (ctx.identifierName().text == 'push') {
            _walk(ctx.singleExpression())
            print '.add'
            walker.lastVisitedNodeIndex = ctx.identifierName().start.tokenIndex
        }
    }

    @Override
    void enterArgumentsExpression(ECMAScriptParser.ArgumentsExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (singleExpression instanceof ECMAScriptParser.MemberDotExpressionContext &&
                singleExpression.identifierName().text == 'slice') {
            print 'slice('
            _walk(singleExpression.singleExpression())
            print ', '
            _walk(ctx.arguments().argumentList())
            print ')'
        } else if (singleExpression instanceof ECMAScriptParser.MemberDotExpressionContext &&
                singleExpression.identifierName().text == 'splice') {
            print 'splice('
            _walk(singleExpression.singleExpression())
            print ', '
            _walk(ctx.arguments().argumentList())
            print ')'
        }
    }

    boolean isInsideClass

    @Override
    void enterVariableStatement(ECMAScriptParser.VariableStatementContext ctx) {
        def variableDeclaration = ctx.variableDeclarationList().variableDeclaration(0)
        def className = variableDeclaration.Identifier().text

        def initialiserExpression = variableDeclaration.initialiser()?.singleExpression()

        if (isUpperCase(className.charAt(0)) && initialiserExpression instanceof ECMAScriptParser.ArgumentsExpressionContext) {
            isInsideClass = true
            print "class $className {"
            _walk(
                    ((ECMAScriptParser.FunctionExpressionContext)
                            ((ECMAScriptParser.ParenthesizedExpressionContext)
                                    initialiserExpression.singleExpression()).expressionSequence().singleExpression(0)).functionBody())
            print "\n}"
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
            isInsideClass = false
        }
    }

    boolean isInsideClassPrototype

    @Override
    void enterAssignmentExpression(ECMAScriptParser.AssignmentExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)
        if (isInsideClass &&
                expression0 instanceof ECMAScriptParser.MemberDotExpressionContext &&
                expression0.identifierName().text == 'prototype' &&
                expression1 instanceof ECMAScriptParser.ObjectLiteralExpressionContext
        ) {
            isInsideClassPrototype = true
            _walk(expression1.objectLiteral().propertyNameAndValueList())
            isInsideClassPrototype = false
        }
    }

    @Override
    void enterPropertyNameAndValueList(ECMAScriptParser.PropertyNameAndValueListContext ctx) {
        if(isInsideClassPrototype) {
            for(def propertyAssignment : ctx.propertyAssignment()) {
                _walk(propertyAssignment)
            }
        }
    }

    @Override
    void enterPropertyExpressionAssignment(ECMAScriptParser.PropertyExpressionAssignmentContext ctx) {
        def expression = ctx.singleExpression()
        if(isInsideClassPrototype && expression instanceof ECMAScriptParser.FunctionExpressionContext) {
            _walk(ctx.propertyName())
            print '('
            _walk(expression.formalParameterList())
            print ') {'
            _walk(expression.functionBody())
            walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
            visitTerminal(((TerminalNode) expression.children.last()))
        }
    }

    @Override
    void enterPropertyGetter(ECMAScriptParser.PropertyGetterContext ctx) {
        _walk(ctx.getter())
        print ' {'
        _walk(ctx.functionBody())
        walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
        visitTerminal(((TerminalNode) ctx.children.last()))
    }

    private void _walk(ParseTree t) {
        walker.walk(this, t)
    }

    @Override
    void enterFunctionDeclaration(ECMAScriptParser.FunctionDeclarationContext ctx) {
        _walk(ctx.Identifier())
        print '('
        _walk(ctx.formalParameterList())
        print ') {'
        _walk(ctx.functionBody())
        walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
        visitTerminal((TerminalNode) ctx.children.last())
    }
    int lastVisitedNodeIndex

    @Override
    void enterEveryRule(ParserRuleContext ctx) {
        if (lastVisitedNodeIndex >= ctx.start.tokenIndex) return

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