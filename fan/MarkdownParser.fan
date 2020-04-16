using afPegger::Grammar
using afPegger::Peg
using fandoc::Doc

@Js class MarkdownParser {
	private Grammar? _grammar
	
	** Parses the given Markdown string into a Fandoc document.
	Doc parse(Str markdown) {
		match := grammar["markdown"].match(markdown) ?: throw ParseErr("Could not parse Markdown")
		return MarkdownWalker(this).walk(match).root
	}
	
	** Returns the PEG grammar used to parse HTML.
	Grammar grammar() {
		if (_grammar == null) {
			grammar := `fan://afMarkdownParser/res/markdown.peg.txt`.toFile.readAllStr
			_grammar = Peg.parseGrammar(grammar)
		}
		return _grammar
	}
}
