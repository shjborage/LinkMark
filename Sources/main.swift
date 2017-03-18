// overview
print(CommandLine.arguments)

import CommandLineKit
let cli = CommandLine()
let filePath = StringOption(shortFlag: "f", longFlag: "file", required: true, helpMessage: "Path to input file for parsing");

cli.addOptions(filePath)

do {
    try cli.parse()
    print("File path is \(filePath.value!)")
} catch {
    cli.printUsage(error)
}

