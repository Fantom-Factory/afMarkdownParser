using fandoc
using afPegger::Match

class MarkdownWalker {
	private static const Log	log			:= MarkdownParser#.pod.log
	private Doc					doc
	private DocElem				elem
	private MarkdownParser2		parser
	
	new make(MarkdownParser2 parser) {
		this.parser	= parser
		this.doc	= this.elem = Doc()
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
			case "ol"			: ol(m)
			case "pre"			: pre(m)
			case "preGit"		: preGit(m)

			case "bold"			: elem.add(elem = Strong())
			case "italic"		: elem.add(elem = Emphasis())
			case "link"			: link(m)
			case "image"		: image(m)
			case "code"			: elem.add(elem = Code())
			case "lineBreak"	: text(" ")
			case "text"			: text(m.matched)
			case "trim"			: text(m.matched.trim)
			case "nltext"		: text("\n\n" + m.matched)
		}
	}
	
	private Void stepOut(Match m) {
		switch (m.name) {
			case "heading"		:
			case "paragraph"	:
			case "pre"			:
			case "blockquote"	:
			case "code"			:
			case "bold"			:
			case "italic"		:
				endElem()

			case "ul"			:
			case "ol"			:
				parseText()
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
	}

	private Void ol(Match m) {
		// keep re-using any existing lists
		if (elem.children.last is OrderedList)
			elem = elem.children.last
		else
			elem.add(elem = OrderedList(OrderedListStyle.number))
		
		elem.add(elem = ListItem())
	}
	
	private Void pre(Match m) {
		elem.add(elem = Pre())
		str := m.matched.splitLines.map { it.size >= 4 ? it[4..-1] : it }.join("\n").trimEnd + "\n"
		text(str)
	}
	
	private Void preGit(Match m) {
		elem.add(elem = Pre())
		str := m.matched
		if (str.startsWith("\n"))	str = str[1..-1]
		if (str.endsWith("\n"))		str = str[0..<-1]
		text(str)
	}
	
	private Void link(Match m) {
		txt := m["txt"].matched
		uri := m["uri"].matched
		elem.add(Link(uri).add(DocText(txt)))
	}
	
	private Void image(Match m) {
		alt := m["alt"].matched
		uri := m["uri"].matched
		elem.add(Image(uri, alt))
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
		if (elem is OrderedList)
			elem = elem.parent
	}
	
	private Void parseText() {
		text := elem.children.first as DocText
		if (text.str.contains("\n\n")) {
			elem.remove(text)
			elem := parser.parseDoc(text.str)
			elem.children.each {
				it.parent.remove(it)
				this.elem.add(it)
			}
		}
		endElem
	}
}
