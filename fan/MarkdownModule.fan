
@NoDoc	// advanced use only
@Js const class MarkdownModule {
	
	Str:Obj nonInvasiveIocModule() {
		[
			"services"	: [
				[
					"id"	: MarkdownParser#.qname,
					"type"	: MarkdownParser#
				]
			]
		]
	}

}
