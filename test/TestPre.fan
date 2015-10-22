
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
 
 <pre>    Code block.
     This is a code block.
 
     This is a still a code block.
    
     A code block still.</pre>
 
 <p>This is a para</p>
 "
		verifyEq(html.trim, parseToHtml(markdown, false))
	}
}
