import ECMAScriptParser.ArgumentsExpressionContext
import ECMAScriptParser.EqualityExpressionContext
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
    boolean isInsideInheritMixin

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
    void enterLogicalOrExpression(LogicalOrExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)
        if (isSimpleExpression(expression0)) {
            dartSrc += "or("
            _walk(expression0)
            dartSrc += ","
            _walk(expression1)
            dartSrc += ")"
        }
    }

//    @Override
//    void enterLogicalAndExpression(LogicalAndExpressionContext ctx) {
//        dartSrc += "and("
//        _walk(ctx.singleExpression(0))
//        dartSrc += ","
//        _walk(ctx.singleExpression(1))
//        dartSrc += ")"
//    }

    @Override
    void enterInExpression(ECMAScriptParser.InExpressionContext ctx) {
//        if(ctx.singleExpression(1) instanceof )
        _walk(ctx.singleExpression(1))
        dartSrc += ".containsKey(${ctx.singleExpression(0).text})"
    }

    @Override
    void enterEqualityExpression(EqualityExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)

        if (expression0 instanceof TypeofExpressionContext) {
            _walk(expression0.singleExpression())

            def typeExpression = expression1.text.substring(1, expression1.text.length() - 1)
            if (typeExpression == "undefined") {
                dartSrc += ' == null'
            } else {
                typeExpression = typeExpression == 'number' ?
                        'num' : typeExpression == 'string' ?
                        'String' : typeExpression == 'function' ?
                        'Function' : typeExpression == 'object' ?
                        'JsonObject' : typeExpression == 'Array' ?
                        'List' : typeExpression == 'boolean' ?
                        'bool' : typeExpression
                dartSrc += " is ${typeExpression}"
            }
            _setLastVisited expression1
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
    void enterIdentifierExpression(IdentifierExpressionContext ctx) {
        if (ctx.text == 'Uint8Array') {
            dartSrc += 'Uint8List'
            _setLastVisited ctx
        } else if (ctx.text == 'Uint16Array') {
            dartSrc += 'Uint16List'
            _setLastVisited ctx
        } else if (ctx.text == 'Uint32Array') {
            dartSrc += 'Uint32List'
            _setLastVisited ctx
        } else if (ctx.text == 'undefined') {
            dartSrc += 'null'
            _setLastVisited ctx
        }
    }

    @Override
    void enterMemberDotExpression(MemberDotExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (ctx.identifierName().text == 'push') {
            _walk singleExpression
            dartSrc += '.add'
            _setLastVisited ctx.identifierName()
        } else if (ctx.text == 'Promise.resolve') {
            dartSrc += 'new Future.value'
            _setLastVisited ctx
        } else if (ctx.text == 'Promise.all') {
            dartSrc += 'Future.wait'
            _setLastVisited ctx
        } else if(ctx.text == 'String.fromCharCode') {
            dartSrc += 'new String.fromCharCode'
            _setLastVisited ctx
        } else if(ctx.text == 'String.fromCharCodes') {
            dartSrc += 'new String.fromCharCodes'
            _setLastVisited ctx
        } else if(ctx.text == 'Date.now') {
            dartSrc += 'new DateTime.now'
            _setLastVisited ctx
        } else if (ctx.text == 'console.log') {
            dartSrc += 'print'
            _setLastVisited ctx
        }
    }

    @Override
    void enterArgumentsExpression(ArgumentsExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (ctx.text.startsWith('Util.inherit')) {
            def mixin = ((ObjectLiteralExpressionContext) ctx.arguments().argumentList().singleExpression(2))
            if (mixin.objectLiteral().propertyNameAndValueList() != null) {
                isInsideInheritMixin = true
                _walk(mixin.objectLiteral().propertyNameAndValueList())
                isInsideInheritMixin = false
            }

            _setLastVisited ctx.parent.parent
        } else if (ctx.text == 'Object.create(null)') {
            dartSrc += '{}';
            _setLastVisited ctx
        } else if (singleExpression instanceof MemberDotExpressionContext) {
            def identifierNameText = singleExpression.identifierName().text
            if (['slice', 'splice', 'unshift', 'shift', 'pop'].any { it == identifierNameText }) {
                dartSrc += identifierNameText + '('
                _walk(singleExpression.singleExpression())
                dartSrc += ', '
                if(ctx.arguments().argumentList() != null)
                    _walk(ctx.arguments().argumentList())
                else if (identifierNameText == 'slice'){
                    dartSrc += '0'
                    _setLastVisited ctx
                }
                dartSrc += ')'
            } else if (identifierNameText == 'call') {
                def methodExpression = singleExpression.singleExpression()
                if (methodExpression instanceof MemberDotExpressionContext) {
                    dartSrc += "super.${methodExpression.identifierName().text}("
                    def argumentExpressions = ctx.arguments().argumentList().singleExpression()
                    for (int i = 1; i < argumentExpressions.size(); i++) {
                        _walk(argumentExpressions.get(i))
                        if (i < argumentExpressions.size() - 1) {
                            dartSrc += ","
                        }
                    }
                    dartSrc += ')'
                }
            } else if (ctx.singleExpression().text == 'Math.abs') {
                def expression0 = ctx.arguments().argumentList().singleExpression(0)
                if (isSimpleExpression(expression0)) {
                    dartSrc += "${expression0.text}.abs()"
                    _setLastVisited ctx
                } else {
                    _walk ctx.arguments()
                    dartSrc += '.abs()'
                }
            } else if (singleExpression.text == 'Array.prototype.push.apply') {
                _walk ctx.arguments().argumentList().singleExpression(0)
                dartSrc += '.addAll('
                _walk ctx.arguments().argumentList().singleExpression(1)
                dartSrc += ')'
                _setLastVisited ctx
            } else if (singleExpression.text == 'Array.prototype.unshift.apply') {
                _walk ctx.arguments().argumentList().singleExpression(0)
                dartSrc += '.insertAll(0,'
                _walk ctx.arguments().argumentList().singleExpression(1)
                dartSrc += ')'
                _setLastVisited ctx
            }
        } else if (ctx.text.startsWith('define')) {
            ((ECMAScriptParser.ElementListContext) ((ECMAScriptParser.ArrayLiteralContext) ctx.arguments().argumentList().singleExpression(1).children[0]).children[1]).singleExpression().each {
                dartSrc += "import 'package:${it.text.substring(1, it.text.length() - 1)}.dart';\n"
            }
            _setLastVisited ctx.parent.parent
        } else if (ctx.text.startsWith('require')) {
            dartSrc += "import ${ctx.arguments().argumentList().singleExpression(0).text.replace('.js', '.dart')};\n"
            _setLastVisited ctx
        }
    }

    private void _setLastVisited(ParserRuleContext ctx) {
        walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
    }

    private static boolean isSimpleExpression(ECMAScriptParser.SingleExpressionContext expression) {
        expression instanceof LiteralExpressionContext ||
                expression instanceof ThisExpressionContext ||
                expression instanceof IdentifierExpressionContext ||
                expression instanceof ArgumentsExpressionContext ||
                expression instanceof MemberIndexExpressionContext
    }

    @Override
    void enterExpressionStatement(ECMAScriptParser.ExpressionStatementContext ctx) {
        if (ctx.text == "'use strict';")
            _setLastVisited ctx
    }

    boolean isInsideClass

    ECMAScriptParser.FunctionBodyContext classBody
    String className

    @Override
    void enterVariableStatement(ECMAScriptParser.VariableStatementContext ctx) {
        def variableDeclaration = ctx.variableDeclarationList().variableDeclaration(0)
        def varIdentText = variableDeclaration.Identifier().text

        def initialiserExpression = variableDeclaration.initialiser()?.singleExpression()

        if (isUpperCase(varIdentText.charAt(0)) && initialiserExpression instanceof ArgumentsExpressionContext
                && initialiserExpression.singleExpression() instanceof ParenthesizedExpressionContext) {
            className = varIdentText
            isInsideClass = true
            dartSrc += "class $className "
            classBody = ((FunctionExpressionContext)
                    ((ParenthesizedExpressionContext)
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
            className = null
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
        if ((isInsideClass || isInsideSmallClass)) {
            if (expression0 instanceof MemberDotExpressionContext &&
                    expression0.identifierName().text == 'prototype' &&
                    expression1 instanceof ObjectLiteralExpressionContext
            ) {
                isInsideClassPrototype = true
                _walk(expression1.objectLiteral().propertyNameAndValueList())
                isInsideClassPrototype = false

                if (isInsideSmallClass) {
                    dartSrc += "\n}\n"
                    isInsideSmallClass = false
                }
                _setLastVisited ctx.parent.parent
            } else if (expression0 instanceof MemberDotExpressionContext &&
                    expression0.singleExpression().text == className &&
                    expression1 instanceof FunctionExpressionContext
            ) {

                dartSrc += "static ${expression0.identifierName().text}("
                _walk(expression1.formalParameterList())
                dartSrc += ') {'
                _walk(expression1.functionBody())
                _walk(expression1.children.last())
                _setLastVisited ctx.parent.parent
            }
        }
    }

    @Override
    void enterPropertyNameAndValueList(ECMAScriptParser.PropertyNameAndValueListContext ctx) {
        if (isInsideClassPrototype || isInsideInheritMixin) {
            ctx.propertyAssignment().each { _walk(it) }
        }
    }

    @Override
    void enterPropertyExpressionAssignment(ECMAScriptParser.PropertyExpressionAssignmentContext ctx) {
        def expression = ctx.singleExpression()
        if ((isInsideClassPrototype || isInsideInheritMixin) && expression instanceof FunctionExpressionContext) {
            _walk(ctx.propertyName())
            dartSrc += '('
            _walk(expression.formalParameterList())
            dartSrc += ') {'
            _walk(expression.functionBody())
            _setLastVisited ctx
            _visitTerminal(expression.children.last())
        }
    }

    @Override
    void enterPropertyGetter(ECMAScriptParser.PropertyGetterContext ctx) {
        _walk(ctx.getter())
        dartSrc += ' {'
        _walk(ctx.functionBody())
        _setLastVisited ctx
        _visitTerminal(ctx.children.last())
    }

    private void _walk(ParseTree t) {
        walker.walk(this, t)
    }

    @Override
    void enterFunctionDeclaration(ECMAScriptParser.FunctionDeclarationContext ctx) {
        def smallClassName = ctx.Identifier().text
        if (!isInsideClass && isUpperCase(smallClassName.charAt(0))) {
            dartSrc += "class ${smallClassName} {\n" +
                    "${smallClassName}("
            _walk(ctx.formalParameterList())
            dartSrc += ") {"
            _walk(ctx.functionBody())
            _walk(ctx.children.last())

            isInsideSmallClass = true


        } else if (isInsideClass && smallClassName == className && ctx.functionBody().sourceElements()?.sourceElement(0)?.text?.contains('.call(')) {
            dartSrc += "${smallClassName}("
            _walk(ctx.formalParameterList())
            dartSrc += ") : super("

            def superParams = (ECMAScriptParser.ArgumentListContext) ctx.functionBody().sourceElements().sourceElement(0).statement().expressionStatement()
                    .expressionSequence().singleExpression(0).getChild(1).getChild(1)

            for (def i = 1; i < superParams.singleExpression().size(); i++) {
                _walk(superParams.singleExpression(i))
                if (i != superParams.singleExpression().size() - 1) {
                    dartSrc += ', '
                }
            }
            dartSrc += ") {"
//            _walk(ctx.functionBody())
            for (def i = 1; i < ctx.functionBody().sourceElements().sourceElement().size(); i++) {
                _walk(ctx.functionBody().sourceElements().sourceElement(i))
            }
            _walk(ctx.children.last())
        } else {
            walker.lastVisitedNodeIndex = ctx.Function().symbol.tokenIndex
        }
    }

    @Override
    void enterFunctionExpression(FunctionExpressionContext ctx) {
        walker.lastVisitedNodeIndex = ctx.Function().symbol.tokenIndex
    }

    @Override
    void enterDeleteExpression(ECMAScriptParser.DeleteExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()

        // delete exp[keyName] -> exp.remove(keyName)
        if(singleExpression instanceof MemberIndexExpressionContext) {
            _walk singleExpression.singleExpression()
            dartSrc += '.remove('
            _walk singleExpression.expressionSequence()
            dartSrc += ')'
            _setLastVisited ctx
        }
    }

    @Override
    void enterInstanceofExpression(InstanceofExpressionContext ctx) {
        _walk ctx.singleExpression(0)
        dartSrc += ' is '
        _walk ctx.singleExpression(1)
    }

    //TODO:
    // setTimeOut ->
    // parseInt(exp) -> int.parse(exp)
    // parseInt(exp, radix) -> int.parse(exp, radix: radix)
}