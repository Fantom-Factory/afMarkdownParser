using build

class Build : BuildPod {

	new make() {
		podName = "afMarkdownParser"
		summary = "Parses Markdown text into Fandoc objects"
		version = Version("0.0.1")

		meta = [	
			"proj.name"		: "Markdown Parser",
			"repo.tags"		: "misc",
			"repo.internal"	: "true",
			"repo.public"	: "false"
		]

		depends = [
			"sys      1.0",
			"fandoc   1.0",
			"afPegger 0.0.6+"
		]

		srcDirs = [`test/`, `fan/`]
		resDirs = [`doc/`]
	}
}
