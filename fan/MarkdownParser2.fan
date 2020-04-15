using afPegger::Grammar
using afPegger::Peg
using fandoc::Doc

//@Js ???
class MarkdownParser2 {
	private Grammar? _grammar
	
	** Parses the given HTML string into an XML document.
	Doc parseDoc(Str markdown) {
		match := grammar["markdown"].match(markdown) ?: throw ParseErr("Could not parse Markdown")
		
		match.dump
		return MarkdownWalker().walk(match).root
	}
	
	** Returns the PEG grammar used to parse HTML.
	Grammar grammar() {
		if (_grammar == null) {
			grammar := `fan://afMarkdownParser/res/markdown.peg.txt`.toFile.readAllStr
			_grammar = Peg.parseGrammar(grammar)
		}
		return _grammar
	}
	
	static Void main(Str[] args) {
		MarkdownParser2().grammar.dump
	}
}
