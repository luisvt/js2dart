import org.antlr.v4.runtime.BufferedTokenStream
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.ParseTree
import org.antlr.v4.runtime.tree.TerminalNode

import static java.lang.Character.isUpperCase

class RefPhase extends ECMAScriptBaseListener {
    String dartSrc = ''
    private ECMAScriptParser parser
    private BufferedTokenStream tokens
    private CustomParserTreeWalker walker
    boolean isInsideSmallClass

    RefPhase(ECMAScriptParser parser, BufferedTokenStream tokens, CustomParserTreeWalker walker) {
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

        if (node.text != '<EOF>')
            dartSrc += node
    }

    @Override
    void enterLogicalOrExpression(ECMAScriptParser.LogicalOrExpressionContext ctx) {
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
    void enterEqualityExpression(ECMAScriptParser.EqualityExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)

        if (expression0 instanceof ECMAScriptParser.TypeofExpressionContext) {
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
    void enterLiteralExpression(ECMAScriptParser.LiteralExpressionContext ctx) {
        def regexLiteral = ctx.literal().RegularExpressionLiteral()
        if (regexLiteral != null) {
            walker.lastVisitedNodeIndex = ctx.start.tokenIndex
            dartSrc += "new RegExp(r'${regexLiteral.text.substring(1, regexLiteral.text.length() - 1)}')"
        }
    }

    @Override
    void enterIdentifierExpression(ECMAScriptParser.IdentifierExpressionContext ctx) {
        for (it in ['Uint8Array'  : 'Uint8List',
                    'Uint16Array' : 'Uint16List',
                    'Uint32Array' : 'Uint32List',
                    'Int8Array'   : 'Int8List',
                    'Int16Array'  : 'Int16List',
                    'Int32Array'  : 'Int32List',
                    'Float32Array': 'Float32List',
                    'Array'       : 'List',
                    'undefined'   : 'null']) {
            if (it.key == ctx.text) {
                dartSrc += it.value
                _setLastVisited ctx
                break
            }
        }
    }

    @Override
    void enterMemberDotExpression(ECMAScriptParser.MemberDotExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (ctx.text == 'Promise.resolve') {
            dartSrc += 'new Future.value'
            _setLastVisited ctx
        } else if (ctx.text == 'Promise.all') {
            dartSrc += 'Future.wait'
            _setLastVisited ctx
        } else if (ctx.text == 'String.fromCharCode') {
            dartSrc += 'new String.fromCharCode'
            _setLastVisited ctx
        } else if (ctx.text == 'String.fromCharCodes') {
            dartSrc += 'new String.fromCharCodes'
            _setLastVisited ctx
        } else if (ctx.text == 'Date.now') {
            dartSrc += 'new DateTime.now'
            _setLastVisited ctx
        } else if (ctx.text == 'console.log') {
            dartSrc += 'print'
            _setLastVisited ctx
        }
    }

    @Override
    void enterArgumentsExpression(ECMAScriptParser.ArgumentsExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()
        if (ctx.text.startsWith('Util.inherit')) {
            def mixin = ((ECMAScriptParser.ObjectLiteralExpressionContext) ctx.arguments().argumentList().singleExpression(2))
            if (mixin.objectLiteral().propertyNameAndValueList() != null) {
                _walkPropertyAssigments(mixin)
            }

            _setLastVisited ctx.parent.parent
        } else if (ctx.text == 'Object.create(null)') {
            dartSrc += '{}';
            _setLastVisited ctx
        } else if (singleExpression instanceof ECMAScriptParser.MemberDotExpressionContext) {
            def identifierNameText = singleExpression.identifierName().text
            if (['slice', 'splice', 'unshift'].any { it == identifierNameText }) {
                dartSrc += identifierNameText + '('
                _walk(singleExpression.singleExpression())
                dartSrc += ', '
                if (ctx.arguments().argumentList() != null)
                    _walk(ctx.arguments().argumentList())
                else if (identifierNameText == 'slice') {
                    dartSrc += '0'
                    _setLastVisited ctx
                }
                dartSrc += ')'
            } else if (['shift', 'pop'].any { it == identifierNameText }) {
                dartSrc += identifierNameText + '('
                _walk(singleExpression.singleExpression())
                dartSrc += ')'
                _setLastVisited ctx
            } else if (identifierNameText == 'push') {
                _walk singleExpression.singleExpression()
                if (ctx.arguments().argumentList().singleExpression().size() < 2) {
                    dartSrc += '.add'
                    _setLastVisited singleExpression.identifierName()
                } else {
                    dartSrc += '.addAll(['
                    _walk ctx.arguments().argumentList()
                    dartSrc += '])'
                    _setLastVisited ctx
                }
            } else if (identifierNameText == 'call') {
                def methodExpression = singleExpression.singleExpression()
                if (methodExpression instanceof ECMAScriptParser.MemberDotExpressionContext) {
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
            } else if (ctx.singleExpression().text == 'Math.round') {
                def expression0 = ctx.arguments().argumentList().singleExpression(0)
                if (isSimpleExpression(expression0)) {
                    dartSrc += "${expression0.text}.round()"
                    _setLastVisited ctx
                } else {
                    _walk ctx.arguments()
                    dartSrc += '.round()'
                }
            } else if (ctx.singleExpression().text == 'Math.floor') {
                def expression0 = ctx.arguments().argumentList().singleExpression(0)
                if (isSimpleExpression(expression0)) {
                    dartSrc += "${expression0.text}.floor()"
                    _setLastVisited ctx
                } else {
                    _walk ctx.arguments()
                    dartSrc += '.floor()'
                }
            } else if (ctx.singleExpression().text == 'Math.ceil') {
                def expression0 = ctx.arguments().argumentList().singleExpression(0)
                if (isSimpleExpression(expression0)) {
                    dartSrc += "${expression0.text}.ceil()"
                    _setLastVisited ctx
                } else {
                    _walk ctx.arguments()
                    dartSrc += '.ceil()'
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
        } else if (ctx.singleExpression().text == 'parseInt') {
            // parseInt(exp) -> int.parse(exp)
            // parseInt(exp, radix) -> int.parse(exp, radix: radix)
            dartSrc += "int.parse"
            if (ctx.arguments().argumentList().singleExpression().size() == 1)
                _walk ctx.arguments()
            else if (ctx.arguments().argumentList().singleExpression().size() == 2) {
                dartSrc += '('
                _walk ctx.arguments().argumentList().singleExpression(0)
                dartSrc += ', radix:'
                _walk ctx.arguments().argumentList().singleExpression(1)
                dartSrc += ')'
                _setLastVisited ctx
            }
        } else if (ctx.singleExpression().text == 'parseFloat') {
            // parseFloat(exp) -> double.parse(exp)
            dartSrc += "double.parse"
            _walk ctx.arguments()
        } else if (ctx.text.startsWith('define')) {
            ((ECMAScriptParser.ElementListContext) ((ECMAScriptParser.ArrayLiteralContext) ctx.arguments().argumentList().singleExpression(1).children[0]).children[1]).singleExpression().each {
                dartSrc += "import 'package:${it.text.substring(1, it.text.length() - 1)}.dart';\n"
            }
            _setLastVisited ctx.parent.parent
//        } else if (ctx.text.startsWith('require')) {
//            dartSrc += "import ${ctx.arguments().argumentList().singleExpression(0).text.replace('.js', '.dart')};\n"
//            _setLastVisited ctx
        }
    }

    private void _setLastVisited(ParserRuleContext ctx) {
        walker.lastVisitedNodeIndex = ctx.stop.tokenIndex
    }

    private static boolean isSimpleExpression(ECMAScriptParser.SingleExpressionContext expression) {
        expression instanceof ECMAScriptParser.LiteralExpressionContext ||
                expression instanceof ECMAScriptParser.ThisExpressionContext ||
                expression instanceof ECMAScriptParser.IdentifierExpressionContext ||
                expression instanceof ECMAScriptParser.ArgumentsExpressionContext ||
                expression instanceof ECMAScriptParser.MemberIndexExpressionContext
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

        if (isUpperCase(varIdentText.charAt(0)) && initialiserExpression instanceof ECMAScriptParser.ArgumentsExpressionContext
                && initialiserExpression.singleExpression() instanceof ECMAScriptParser.ParenthesizedExpressionContext
        ) {
            className = varIdentText
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
            className = null
        } else if (initialiserExpression instanceof ECMAScriptParser.AssignmentExpressionContext
                && initialiserExpression.singleExpression(0).text == 'module.exports'
                && initialiserExpression.singleExpression(1) instanceof ECMAScriptParser.FunctionExpressionContext
        ) {
            className = varIdentText
            isInsideClass = true
            dartSrc += "class $className "

            def constructorExp = (ECMAScriptParser.FunctionExpressionContext) initialiserExpression.singleExpression(1)

            dartSrc += '{' +
                    "\n\t$className("
            _walk(constructorExp.formalParameterList())
            dartSrc += ") {"

            _walk(constructorExp.functionBody())
            dartSrc += "\n\t}\n}"
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
            isInsideClass = false
            classBody = null
            className = null
        } else if (initialiserExpression instanceof ECMAScriptParser.ArgumentsExpressionContext &&
                initialiserExpression.singleExpression().text == 'require'
        ) {
            def importExpression = initialiserExpression.arguments().argumentList().singleExpression(0)
            def importPathText = importExpression.text.substring(1, importExpression.text.length() - 1)

            if (importPathText.startsWith('.') || importPathText.startsWith('/'))
                importPathText = "${importPathText}.dart"
            else
                importPathText = "package:${importPathText}.dart"

            dartSrc += "import '$importPathText' show $varIdentText;"
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
        }
    }

    @Override
    void enterReturnStatement(ECMAScriptParser.ReturnStatementContext ctx) {
        if (isInsideClass && ctx.parent.parent.parent.parent == classBody
                && ctx.expressionSequence().singleExpression(0) instanceof ECMAScriptParser.IdentifierExpressionContext
        ) {
            walker.lastVisitedNodeIndex = ctx.eos().start.tokenIndex
        }
    }

    boolean isInsideClassPrototype

    @Override
    void enterAssignmentExpression(ECMAScriptParser.AssignmentExpressionContext ctx) {
        def expression0 = ctx.singleExpression(0)
        def expression1 = ctx.singleExpression(1)
        if ((isInsideClass || isInsideSmallClass)) {
            if (expression0 instanceof ECMAScriptParser.MemberDotExpressionContext) {
                if (expression0.identifierName().text == 'prototype' &&
                        expression1 instanceof ECMAScriptParser.ObjectLiteralExpressionContext
                ) {
                    dartSrc = _walkPropertyAssigments(expression1)

                    if (isInsideSmallClass) {
                        dartSrc += "\n}\n"
                        isInsideSmallClass = false
                    }
                    _setLastVisited ctx.parent.parent
                } else if (expression0.singleExpression().text == className) {
                    if (expression1 instanceof ECMAScriptParser.FunctionExpressionContext) {
                        dartSrc += "static ${expression0.identifierName().text}("
                        _walk(expression1.formalParameterList())
                        dartSrc += ') {'
                        _walk(expression1.functionBody())
                        _walk(expression1.children.last())
                        _setLastVisited ctx.parent.parent
                    } else {
                        dartSrc += "static var ${expression0.identifierName().text} ="
                        _walk expression1
                    }
                } else if (expression0.singleExpression().text == className + ".prototype") {
                    if (expression1 instanceof ECMAScriptParser.FunctionExpressionContext) {
                        dartSrc += "${expression0.identifierName().text}("
                        _walk(expression1.formalParameterList())
                        dartSrc += ') {'
                        _walk(expression1.functionBody())
                        _walk(expression1.children.last())
                        _setLastVisited ctx.parent.parent
                    } else {
                        dartSrc += "var ${expression0.identifierName().text} ="
                        _walk expression1
                    }
                } else if (expression0.singleExpression().text.contains('prototype')
                        && expression1 instanceof ECMAScriptParser.FunctionExpressionContext
                ) {
                    dartSrc += "${expression0.identifierName().text}("
                    _walk(expression1.formalParameterList())
                    dartSrc += ") {\n"
                    _walk(expression1.functionBody())
                    dartSrc += "\n}"
                    walker.lastVisitedNodeIndex = ((ECMAScriptParser.ExpressionStatementContext) ctx.parent.parent)
                            .eos().start.tokenIndex
                }
            }
        } else if (expression0 instanceof ECMAScriptParser.MemberDotExpressionContext
                && expression0.singleExpression().text.contains('prototype')
                && expression1 instanceof ECMAScriptParser.FunctionExpressionContext
        ) {
            dartSrc += "${expression0.identifierName().text}("
            _walk(expression1.formalParameterList())
            dartSrc += ") {\n"
            _walk(expression1.functionBody())
            dartSrc += "\n}"
            walker.lastVisitedNodeIndex = ((ECMAScriptParser.ExpressionStatementContext) ctx.parent.parent)
                    .eos().start.tokenIndex
        }
    }

    private String _walkPropertyAssigments(ECMAScriptParser.ObjectLiteralExpressionContext expression1) {
        for (def it : expression1.objectLiteral().propertyNameAndValueList().propertyAssignment()) {
            if (it instanceof ECMAScriptParser.PropertyExpressionAssignmentContext) {
                def expression = it.singleExpression()
                if (expression instanceof ECMAScriptParser.FunctionExpressionContext) {
                    _walk(it.propertyName())
                    dartSrc += '('
                    _walk(expression.formalParameterList())
                    dartSrc += ') {'
                    _walk(expression.functionBody())
                    _setLastVisited it
                    _visitTerminal(expression.children.last())
                }
            } else if (it instanceof ECMAScriptParser.PropertyGetterContext) {
                _walk(it.getter())
                dartSrc += ' {'
                _walk(it.functionBody())
                _setLastVisited it
                _visitTerminal(it.children.last())
            } else {
                _walk(it)
            }
        }
        dartSrc
    }

    @Override
    void enterPropertyExpressionAssignment(ECMAScriptParser.PropertyExpressionAssignmentContext ctx) {
        dartSrc += "'"
        _walk ctx.propertyName()
        dartSrc += "':"
        _walk ctx.singleExpression()
    }

    private void _walk(ParseTree t) {
        walker.walk(this, t)
    }

    @Override
    void enterFunctionDeclaration(ECMAScriptParser.FunctionDeclarationContext ctx) {
        def smallClassName = ctx.Identifier().text

        def firstBodySourceElement = ctx.functionBody().sourceElements()?.sourceElement(0)
        if (!isInsideClass && isUpperCase(smallClassName.charAt(0))) {
            dartSrc += "class ${smallClassName} {\n" +
                    "\t${smallClassName}("
            _walk(ctx.formalParameterList())
            dartSrc += ") {"
            _walk(ctx.functionBody())
            _walk(ctx.children.last())

            isInsideSmallClass = true


        } else if (isInsideClass && smallClassName == className
                && firstBodySourceElement?.text?.contains('.call(')
                && !firstBodySourceElement?.text?.contains('prototype')) {
            dartSrc += "${smallClassName}("
            _walk(ctx.formalParameterList())
            dartSrc += ") : super("

            def superParams = (ECMAScriptParser.ArgumentListContext) ctx.functionBody().sourceElements().sourceElement(0).statement().expressionStatement()
                    .expressionSequence().singleExpression(0).getChild(1).getChild(1)
            println ctx.text
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
    void enterFunctionExpression(ECMAScriptParser.FunctionExpressionContext ctx) {
        walker.lastVisitedNodeIndex = ctx.Function().symbol.tokenIndex
    }

    @Override
    void enterDeleteExpression(ECMAScriptParser.DeleteExpressionContext ctx) {
        def singleExpression = ctx.singleExpression()

        // delete exp[keyName] -> exp.remove(keyName)
        if (singleExpression instanceof ECMAScriptParser.MemberIndexExpressionContext) {
            _walk singleExpression.singleExpression()
            dartSrc += '.remove('
            _walk singleExpression.expressionSequence()
            dartSrc += ')'
            _setLastVisited ctx
        }
    }

    @Override
    void enterInstanceofExpression(ECMAScriptParser.InstanceofExpressionContext ctx) {
        _walk ctx.singleExpression(0)
        dartSrc += ' is '
        _walk ctx.singleExpression(1)
    }

    @Override
    void enterBitShiftExpression(ECMAScriptParser.BitShiftExpressionContext ctx) {
        if (ctx.getChild(1).text == '>>>') {
            _walk ctx.singleExpression(0)
            dartSrc += '>>'
            _walk ctx.singleExpression(1)
        }
    }
//TODO:
    // setTimeOut ->
}
