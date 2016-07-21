using afPegger
using fandoc

** (Service) - 
** Parses Markdown strings into fandoc documents.
@Js
const class MarkdownParser {
	private static const Regex hrefRegex	:= """([^"]+[^"\\s]+)(?:\\s+"(?:[^"]+)")?\\s*""".toRegex

	** Parses the given Markdown string into a fandoc document.
	Doc parse(Str markdown) {
		toFandoc(parseTree(markdown))
	}

	@NoDoc
	virtual internal MarkdownRules markdownRules() {
		MarkdownRules()
	}
	
	internal TreeCtx parseTree(Str markdown) {
		parser := Parser(markdownRules.rootRule)
		return ((TreeCtx) parser.parseAll(markdown.in, TreeCtx()))
	}
	
	internal Doc toFandoc(TreeCtx tree) {
		elems := DocElem[Doc()]
		push  := |DocElem elem| {
			elems.last.add(elem)
			elems.push(elem)
		}
		add  := |DocNode elem| {
			elems.last.add(elem)
		} 
		pop   := |->| {
			elems.pop
		}
	
		tree.root.walk(
			|TreeItem item| {
				switch (item.type) {
					case "paragraph"	: push(Para())
					case "heading"		: push(Heading(item.data->first) { it.anchorId = item.data->getSafe(1) })
					case "blockquote"	: push(BlockQuote())
					case "pre"			: push(Pre())
					case "ul"			: push(UnorderedList())
					case "ol"			: push(OrderedList(OrderedListStyle.number))
					case "li"			: push(ListItem())
					case "italic"		: push(Emphasis())
					case "bold"			: push(Strong())
					case "code"			: push(Code())
					case "hr"			: push(Para())	// fandoc has no <hr> element
					case "text"			: add(DocText(item.matched))
				}
			},
			|TreeItem item| {
				switch (item.type) {
					case "heading":
					case "paragraph":
					case "blockquote":
					case "pre":
					case "ul":
					case "ol":
					case "li":
					case "italic":
					case "bold":
					case "code":
					case "hr":
						pop()
					
					case "link":
						text := item.items.find { it.type == "linkText" }.matched
						href := item.items.find { it.type == "linkHref" }.matched
						push(Link(parseHref(href)))
						add(DocText(text))
						pop()

					case "image":
						alt := item.items.find { it.type == "imageAlt" }.matched
						src := item.items.find { it.type == "imageSrc" }.matched
						push(Image(parseHref(src), alt))
						pop()
					
				}
			}
		)

		return elems.first
	}
	
	private Str parseHref(Str href) {
		matcher := hrefRegex.matcher(href)
		if (matcher.find.not)
			throw Err("Could not find href in: $href")
		return matcher.group(1)
	}
}
