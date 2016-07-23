import groovy.transform.Field
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream

import static java.nio.charset.StandardCharsets.UTF_8
import static org.apache.commons.io.FilenameUtils.getFullPath
import static org.apache.commons.io.FilenameUtils.removeExtension

@Field String inputDirName = null
@Field String outputDirName

if (args.length > 0) inputDirName = args[0]
if (args.length > 1) outputDirName = args[1]

processInput(inputDirName)

void processInput(String fileName) {
    def inputFile = new File(fileName)
    if (inputFile.isDirectory()) {

        processDirectory(inputFile)
    } else {
        processFile(fileName)
    }
}

void processDirectory(File file) {
    file.list().each {
        processInput("$file.path/$it")
    }
}

void processFile(String fileName) {
    def is = new FileInputStream(fileName)

    def input = new ANTLRInputStream(is)

    String outputName = outputDirName != null ?
            removeExtension(fileName.replace(inputDirName, outputDirName)) + '.dart' :
            removeExtension(fileName) + '.dart'

    def outputDir = new File(getFullPath(outputName))
    if(!outputDir.exists()) outputDir.mkdirs()

    println "processing: $fileName"

    new File(outputName).write transpile(input)
}

String transpile(String input) {
    transpile(new ANTLRInputStream(new ByteArrayInputStream(input.getBytes(UTF_8))))
}

String transpile(ANTLRInputStream input) {
    def lexer = new ECMAScriptLexer(input)
    def tokens = new CommonTokenStream(lexer)
    def parser = new ECMAScriptParser(tokens)
    def tree = parser.program() // parse

    def walker = new CustomParserTreeWalker() // create standard walker
    def extractor = new RefPhase(parser, tokens, walker)
    walker.walk(extractor, tree) // initiate walk of tree with listener
    extractor.dartSrc
}