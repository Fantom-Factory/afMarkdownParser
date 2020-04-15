using fandoc
using afPegger::Match

class MarkdownWalker {
	private static const Log	log			:= MarkdownParser#.pod.log
	private Doc					doc
	private DocElem				elem
	
	new make() {
		doc = elem = Doc()
	}
	
	Doc root() {
		doc
	}
	
	This walk(Match match) {
		go(match)
		return this
	}
	
	private Void go(Match match) {
		stepIn(match)
		match.matches.each { go(it) }
		stepOut(match)
	}
	
	private Void stepIn(Match m) {
		switch (m.name) {
			case "heading"		: heading(m)

			case "hr"			: elem.add(Hr())
			case "paragraph"	: elem.add(elem = Para())
			case "blockquote"	: elem.add(elem = BlockQuote())
			case "ul"			: ul(m)

			case "code"			: elem.add(elem = Code())
			case "bold"			: elem.add(elem = Strong())
			case "italic"		: elem.add(elem = Emphasis())
			case "lineBreak"	: text(" ")
			case "text"			: text(m.matched)
			case "trim"			: text(m.matched.trim)
		}
	}
	
	private Void stepOut(Match m) {
		switch (m.name) {
			case "heading"		:
			case "paragraph"	:
			case "blockquote"	:
			case "ul"			:
			case "code"			:
			case "bold"			:
			case "italic"		:
				endElem()
		}
	}
	
	
	private Void heading(Match m) {
		level := m["level"].matched.size.min(4)
		elem.add(elem = Heading(level))
	}
	
	private Void ul(Match m) {
		// keep re-using any existing lists
		if (elem.children.last is UnorderedList)
			elem = elem.children.last
		else
			elem.add(elem = UnorderedList())
		
		elem.add(elem = ListItem())
		// FIXME parse text
	}
	
	private Void text(Str text) {
		last := elem.children.last
		if (last is DocText) {
			elem.remove(last)
			text = ((DocText) last).str + text
		}
		elem.add(DocText(text))
	}
	
	private Void endElem() {
		elem = elem.parent
		if (elem is UnorderedList)
			elem = elem.parent
	}
}
