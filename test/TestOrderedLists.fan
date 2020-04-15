
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
 
    Green
 
    Blue
 1. Red2
 
    Green2
 
    Blue2
 "
		html :=
"<ol style='list-style-type:decimal'>
 <li>
 <p>Red</p>
 <p>Green</p>
 <p>Blue</p>
 </li>
 <li>
 <p>Red2</p>
 <p>Green2</p>
 <p>Blue2</p>
 </li>
 </ol>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
