import ECMAScriptParser.ArgumentsExpressionContext
import ECMAScriptParser.EqualityExpressionContext
import ECMAScriptParser.LiteralExpressionContext
import ECMAScriptParser.LogicalAndExpressionContext
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.BufferedTokenStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.*

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

        print extractor.dartSrc
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
    String dartSrc = ''
    private ECMAScriptParser parser
    private BufferedTokenStream tokens
    private CustomParserTreeWalker walker
    boolean isInsideSmallClass

    Js2DartListener(ECMAScriptParser parser, BufferedTokenStream tokens, CustomParserTreeWalker walker) {
        this.parser = parser
        this.tokens = tokens
        this.walker = walker
    }

    private int _lastVisitedNodeIndex

    @Override
    void enterEveryRule(ParserRuleContext ctx) {
        if (_lastVisitedNodeIndex >= ctx.start.tokenIndex) return

        _lastVisitedNodeIndex = ctx.start.tokenIndex
        def hiddenTokensToLeft = tokens.getHiddenTokensToLeft(ctx.start.tokenIndex, ECMAScriptLexer.HIDDEN);
        hiddenTokensToLeft.each { dartSrc += it.text }
    }

    private void _visitTerminal(ParseTree node) {
        visitTerminal((TerminalNode) node)
    }

    @Override
    void visitTerminal(TerminalNode node) {

        if (_lastVisitedNodeIndex < node.symbol.tokenIndex) {
            def hiddenTokensToLeft = tokens.getHiddenTokensToLeft(node.symbol.tokenIndex, ECMAScriptLexer.HIDDEN);
            hiddenTokensToLeft.each { dartSrc += it.text }
        }

        dartSrc += node
    }

    @Override
    void enterLogicalOrExpression(ECMAScriptParser.LogicalOrExpressionContext ctx) {
        dartSrc += "or("
        _walk(ctx.singleExpression(0))
        dartSrc += ","
        _walk(ctx.singleExpression(1))
        dartSrc += ")"
    }

    @Override
    void enterLogicalAndExpression(LogicalAndExpressionContext ctx) {
        dartSrc += "and("
        _walk(ctx.singleExpression(0))
        dartSrc += ","
        _walk(ctx.singleExpression(1))
        dartSrc += ")"
    }

    @Override
    void enterEqualityExpression(EqualityExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)

        if(expression0 instanceof ECMAScriptParser.TypeofExpressionContext) {
            _walk(expression0.singleExpression())

            def typeExpression = expression1.text
            if(typeExpression == "'undefined'") {
                dartSrc += ' == null'
            } else {
                dartSrc += " is ${typeExpression.substring(1, typeExpression.length() - 1)}"
            }
            walker.lastVisitedNodeIndex = expression1.stop.tokenIndex
        } else {
            def operation = ctx.getChild(1).text

            _walk(expression0)


            dartSrc += ' ' + (operation == '===' ?
                    '==' : operation == '!==' ?
                    '!=' : operation)

            _walk(expression1)
        }
    }

    @Override
    void enterLiteralExpression(LiteralExpressionContext ctx) {
        def regexLiteral = ctx.literal().RegularExpressionLiteral()
        if (regexLiteral != null) {
            walker.lastVisitedNodeIndex = ctx.start.tokenIndex
            dartSrc += "new RegExp(r'${regexLiteral.text.substring(1, regexLiteral.text.length() - 1)}')"
        }
    }

    @Override
    void enterMemberDotExpression(ECMAScriptParser.MemberDotExpressionContext ctx) {
        if (ctx.identifierName().text == 'push') {
            _walk(ctx.singleExpression())
            dartSrc += '.add'
            walker.lastVisitedNodeIndex = ctx.identifierName().start.tokenIndex
        }
    }

    @Override
    void enterArgumentsExpression(ArgumentsExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (singleExpression instanceof ECMAScriptParser.MemberDotExpressionContext &&
                singleExpression.identifierName().text == 'slice') {
            dartSrc += 'slice('
            _walk(singleExpression.singleExpression())
            dartSrc += ', '
            _walk(ctx.arguments().argumentList())
            dartSrc += ')'
        } else if (singleExpression instanceof ECMAScriptParser.MemberDotExpressionContext &&
                singleExpression.identifierName().text == 'splice') {
            dartSrc += 'splice('
            _walk(singleExpression.singleExpression())
            dartSrc += ', '
            _walk(ctx.arguments().argumentList())
            dartSrc += ')'
        } else if (ctx.text.startsWith('Util.inherit')) {
            def mixin = ((ECMAScriptParser.ObjectLiteralExpressionContext) ctx.arguments().argumentList().singleExpression(2))
            if (mixin != null)
                _walk(mixin.objectLiteral().propertyNameAndValueList())

            walker.lastVisitedNodeIndex = ctx.parent.parent.stop.tokenIndex
        } else if (ctx.text.startsWith('define')) {
            ((ECMAScriptParser.ElementListContext) ((ECMAScriptParser.ArrayLiteralContext) ctx.arguments().argumentList().singleExpression(1).children[0]).children[1]).singleExpression().each {
                dartSrc += "import 'package:${it.text.substring(1, it.text.length() - 1)}.dart';\n"
            }
            walker.lastVisitedNodeIndex = ctx.parent.parent.stop.tokenIndex
        } else if (ctx.text.startsWith('require')) {
            dartSrc += "import ${ctx.arguments().argumentList().singleExpression(0).text.replace('.js', '.dart')};\n"
            walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
        }
    }

    @Override
    void enterExpressionStatement(ECMAScriptParser.ExpressionStatementContext ctx) {
        if (ctx.text == "'use strict';")
            walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
    }

    boolean isInsideClass

    ECMAScriptParser.FunctionBodyContext classBody

    @Override
    void enterVariableStatement(ECMAScriptParser.VariableStatementContext ctx) {
        def variableDeclaration = ctx.variableDeclarationList().variableDeclaration(0)
        def className = variableDeclaration.Identifier().text

        def initialiserExpression = variableDeclaration.initialiser()?.singleExpression()

        if (isUpperCase(className.charAt(0)) && initialiserExpression instanceof ArgumentsExpressionContext) {
            isInsideClass = true
            dartSrc += "class $className "
            classBody = ((ECMAScriptParser.FunctionExpressionContext)
                    ((ECMAScriptParser.ParenthesizedExpressionContext)
                            initialiserExpression.singleExpression())
                            .expressionSequence().singleExpression(0)).functionBody()

            def extendsElement = classBody.sourceElements().sourceElement(classBody.sourceElements().childCount - 2)
            if (extendsElement.text.startsWith("Util.inherit")) {
                def classToExtend =
                        ((ECMAScriptParser.ArgumentsContext) extendsElement
                                .statement().expressionStatement().expressionSequence().singleExpression(0)
                                .children[1])
                                .argumentList()
                                .singleExpression(1)

                dartSrc += "extends ${classToExtend.text} "
            }

            dartSrc += '{'
            _walk(classBody)
            dartSrc += "\n}"
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
            isInsideClass = false
            classBody = null
        }
    }

    @Override
    void enterReturnStatement(ECMAScriptParser.ReturnStatementContext ctx) {
        if (isInsideClass && ctx.parent.parent.parent.parent == classBody)
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
    }

    boolean isInsideClassPrototype

    @Override
    void enterAssignmentExpression(ECMAScriptParser.AssignmentExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)
        if ((isInsideClass || isInsideSmallClass) &&
                expression0 instanceof ECMAScriptParser.MemberDotExpressionContext &&
                expression0.identifierName().text == 'prototype' &&
                expression1 instanceof ECMAScriptParser.ObjectLiteralExpressionContext
        ) {
            isInsideClassPrototype = true
            _walk(expression1.objectLiteral().propertyNameAndValueList())
            isInsideClassPrototype = false

            if(isInsideSmallClass) {
                dartSrc += "\n}\n"
                isInsideSmallClass = false
                walker.lastVisitedNodeIndex = ctx.parent.parent.stop.tokenIndex
            }
        }
    }

    @Override
    void enterPropertyNameAndValueList(ECMAScriptParser.PropertyNameAndValueListContext ctx) {
        if(isInsideClassPrototype) {
            ctx.propertyAssignment().each { _walk(it) }
        }
    }

    @Override
    void enterPropertyExpressionAssignment(ECMAScriptParser.PropertyExpressionAssignmentContext ctx) {
        def expression = ctx.singleExpression()
        if (isInsideClassPrototype && expression instanceof ECMAScriptParser.FunctionExpressionContext) {
            _walk(ctx.propertyName())
            dartSrc += '('
            _walk(expression.formalParameterList())
            dartSrc += ') {'
            _walk(expression.functionBody())
            walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
            _visitTerminal(expression.children.last())
        }
    }

    @Override
    void enterPropertyGetter(ECMAScriptParser.PropertyGetterContext ctx) {
        _walk(ctx.getter())
        dartSrc += ' {'
        _walk(ctx.functionBody())
        walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
        _visitTerminal(ctx.children.last())
    }

    private void _walk(ParseTree t) {
        walker.walk(this, t)
    }

    @Override
    void enterFunctionDeclaration(ECMAScriptParser.FunctionDeclarationContext ctx) {
        def className = ctx.Identifier().text
        if(!isInsideClass && isUpperCase(className.charAt(0))) {
            dartSrc += "class ${className} {\n" +
                    "${className}("
            _walk(ctx.formalParameterList())
            dartSrc += ") {"
            _walk(ctx.functionBody())
            _walk(ctx.children.last())

            isInsideSmallClass = true


        } else {
            walker.lastVisitedNodeIndex = ctx.Function().symbol.tokenIndex
        }
    }

    @Override
    void enterFunctionExpression(ECMAScriptParser.FunctionExpressionContext ctx) {
        walker.lastVisitedNodeIndex = ctx.Function().symbol.tokenIndex
    }

    //Todo: shift, unshift, and super calls, static methods
}