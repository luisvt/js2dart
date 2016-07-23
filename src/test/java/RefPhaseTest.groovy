import org.junit.Test

import static org.junit.Assert.assertEquals

/**
 * Created by luis on 5/26/16.
 */
public class RefPhaseTest {
    @Test
    void convertRequireToImport() {
        String result = new Js2Dart().transpile('var a = require("a");')
        assertEquals('import \'package:a.dart\' show a;', result)
    }

    @Test
    void convertClass() {
        String result = new Js2Dart().transpile('var Prompt = module.exports = function (question, rl, answers) {};');
        assertEquals('class Prompt {' +
                '\n\tPrompt(question, rl, answers) {' +
                '\n\t}' +
                '\n}', result)
    }

    @Test
    void convertPrototypeAttrs() {
        String result = new Js2Dart().transpile('Prompt.prototype.run = function () {};');
        assertEquals('run() {\n' +
                '\n' +
                '}', result)
    }


    @Test
    void convertSmallClassNoPrototypeAttrs() {
        String result = new Js2Dart().transpile('function Prompt() {}');
        assertEquals('class Prompt {' +
                '\n\tPrompt() {}', result)
    }

    @Test
    void convertSmallClassPrototypeAttrs() {
        String result = new Js2Dart().transpile('''
function Prompt() {}

Prompt.prototype.run = function () {};''');
        assertEquals('''
class Prompt {
\tPrompt() {}

run() {

}''', result)
    }
}