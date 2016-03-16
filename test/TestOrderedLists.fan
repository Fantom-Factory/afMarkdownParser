
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
	
	Void testParagraphListItems() {
//		Log.get("afPegger").level = LogLevel.debug
		markdown :=
" 1. Red
  2. Green
 
  3. Blue
 "

		html :=
"<ol style='list-style-type:decimal'>
 <li>Red</li>
 <li>
 <p>Green</p>
 </li>
 <li>
 <p>Blue</p>
 </li>
 </ol>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
