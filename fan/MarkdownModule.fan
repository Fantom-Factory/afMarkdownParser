
@NoDoc	// advanced use only
const class MarkdownModule {
	
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
