using build

class Build : BuildPod {

	new make() {
		podName = "afMarkdownParser"
		summary = "Parses Markdown text into Fandoc objects"
		version = Version("0.1.0")

		meta = [
			"pod.dis"		: "Markdown Parser",
			"afIoc.module"	: "afMarkdownParser::MarkdownModule",
			"repo.internal"	: "true",
			"repo.tags"		: "templating, misc",
			"repo.public"	: "true"
		]

		depends = [
			"sys      1.0.70 - 1.0",
			"fandoc   1.0.70 - 1.0",
			"util     1.0.70 - 1.0",
			"afPegger 1.1.2  - 1.1"
		]

		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`, `res/`]
	}
}
