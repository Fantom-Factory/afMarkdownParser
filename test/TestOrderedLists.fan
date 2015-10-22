
internal class TestOrderedLists : MarkdownTest {
	
	Void testOrderedLists() {
		markdown :=
"3. Red
  1. Green
   8. Blue
 "

		html :=
"<ol style='list-style-type:decimal'>
 <li>Red</li>
 
 <li>Green</li>
 
 <li>Blue</li>
 </ol>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testHangingIndents() {
		Log.get("afPegger").level = LogLevel.debug

		markdown :=
"  1. Red, 
     Green, 
     Blue
 "

		html :=
"<ol style='list-style-type:decimal'>
 <li>Red, Green, Blue</li>
 </ol>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testLazyIndents() {
		Log.get("afPegger").level = LogLevel.debug

		markdown :=
"  1. Red, 
 Green, 
 Blue
 "

		html :=
"<ol style='list-style-type:decimal'>
 <li>Red, Green, Blue</li>
 </ol>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
