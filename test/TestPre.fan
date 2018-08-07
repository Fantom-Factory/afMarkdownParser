
internal class TestPre : MarkdownTest {
	
	Void testPre() {
		markdown :=
"This is a para
 
     Code block.
     This is a code block.
 
     This is a still a code block.
    
     A code block still.
 
 This is a para
 "
		html :=
"<p>This is a para</p>
 
 <pre>Code block.
 This is a code block.
 
 This is a still a code block.
    
 A code block still.</pre>
 
 <p>This is a para</p>
 "
		verifyEq(html.trim, parseToHtml(markdown, false))
	}

	Void testPreBug() {
		// pre blocks weren't recognised unless they ended with a '\n' char
		markdown := "    Code block."
		html	 :="<pre>Code block.</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "    Code block.\n    Code block still\n"
		html	 ="<pre>Code block.\nCode block still</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))
	}

	Void testPreGithub() {
		markdown := "```\nCode block.\n```\n"
		html	 :="<pre>Code block.</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "```  \nCode block.\n  More code.\n\n```"
		html	 ="<pre>Code block.\n  More code.</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		// syntax highlighting is straight after the backticks - ignore it!
		markdown = "```ignore\nCode block.\n  More code.\n\n```"
		html	 ="<pre>Code block.\n  More code.</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		// empty code block - make sure we don't hang, or do an infinite loop!
		markdown = "```\n```\n"
		html	 = ""
		verifyEq(html.trim, parseToHtml(markdown, false))
	}
}
