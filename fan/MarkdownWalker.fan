using fandoc
using afPegger::Match

class MarkdownWalker {
	private static const Log	log			:= MarkdownParser#.pod.log
	private Doc					doc
	private DocElem?			elem
	
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
			case "heading"				: level := m["level"].matched.size; elem.add(elem = Heading(level.min(4)))

			case "hr"					: elem.add(Hr())
			case "paragraph"			: elem.add(elem = Para())
			case "blockquote"			: elem.add(elem = BlockQuote())

			case "code"					: elem.add(elem = Code())
			case "bold"					: elem.add(elem = Strong())
			case "italic"				: elem.add(elem = Emphasis())
			case "lineBreak"			: text(" ")
			case "text"					: text(m.matched)
			case "trim"					: text(m.matched.trim)
			
//			case "doctypeElem"			: doctype (m.matched)
//			case "publicId"				: publicId(m.matched)
//			case "systemId"				: systemId(m.matched)
//
//			case "startTag"				: startTag(m.matched)
//			case "endTag"				: endTag  (m.matched)
//			case "voidTag"				: startTag(m.matched)
//
//			case "tagText"				: addText(deEscapeText(m))
//			case "rawTextContent"		: addText(m.matched)
//			case "escRawTextContent"	: addText(deEscapeText(m))
//
//			case "emptyAttr"			: elem.addAttr(m["attrName"].matched, m["attrName"].matched)
//			case "attr"					: elem.addAttr(m["attrName"].matched, deEscapeText(m["attrValue"]))
//
//			case "cdata"				: cdata(m.matched)
		}
	}
	
	private Void stepOut(Match m) {
		switch (m.name) {
			case "heading"				:
			case "paragraph"			:
			case "blockquote"			:
			case "code"					:
			case "bold"					:
			case "italic"				:
				endElem()
		}
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
	}
}
