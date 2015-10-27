using afPegger
using fandoc

** Parses Markdown strings into fandoc documents.
@Js
const class MarkdownParser {

	** Parses the given Markdown string into a fandoc document.
	Doc parse(Str markdown) {
		toFandoc(parseTree(markdown))
	}

	internal TreeCtx parseTree(Str markdown) {
		parser := Parser(MarkdownRules().rootRule)
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
					case "heading"		: push(Heading(item.data))
					case "blockquote"	: push(BlockQuote())
					case "pre"			: push(Pre())
					case "ul"			: push(UnorderedList())
					case "ol"			: push(OrderedList(OrderedListStyle.number))
					case "li"			: push(ListItem())
					case "italic"		: push(Emphasis())
					case "bold"			: push(Strong())
					case "code"			: push(Code())
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
						pop()					
					
					case "link":
						text := item.items.find { it.type == "linkText" }.matched
						href := item.items.find { it.type == "linkHref" }.matched
						push(Link(href))
						add(DocText(text))
						pop()

					case "link":
						text := item.items.find { it.type == "linkText" }.matched
						href := item.items.find { it.type == "linkHref" }.matched
						push(Link(href))
						add(DocText(text))
						pop()

					case "image":
						alt := item.items.find { it.type == "imageAlt" }.matched
						src := item.items.find { it.type == "imageSrc" }.matched
						push(Image(src, alt))
						pop()
				}
			}
		)

		return elems.first
	}
}
