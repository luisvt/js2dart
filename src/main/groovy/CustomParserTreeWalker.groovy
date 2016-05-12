import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.ErrorNode
import org.antlr.v4.runtime.tree.ParseTree
import org.antlr.v4.runtime.tree.ParseTreeListener
import org.antlr.v4.runtime.tree.ParseTreeWalker
import org.antlr.v4.runtime.tree.TerminalNode

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

