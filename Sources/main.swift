// overview
print(CommandLine.arguments)

// parse input
import CommandLineKit
let cli = CommandLine()
let filePath = StringOption(shortFlag: "f", longFlag: "file", required: true, helpMessage: "Path to input file for parsing");

cli.addOptions(filePath)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
}

// logical
import Foundation

struct Link: CustomStringConvertible {
    var depth = 0
    var text = ""

    var description: String {
        return "Link with depth:\(depth) text:\(text)"
    }
}

func getConentOfFile(_ path: String) -> String {
    do {
        let content = try String(contentsOfFile:path, encoding:.utf8)
        return content;
    } catch {
        print("getConentOfFile with error:\(error)")
        return ""
    }
}

struct RegexHelper {
    let regex: NSRegularExpression

    init(_ pattern: String) throws {
        regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }

    func match(input: String) -> [NSTextCheckingResult] {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
        return matches
    }
}

func getLinks(_ content: String) -> [Link] {
    do {
        let regexHelper = try RegexHelper("#+\\s.*")
        let linksMatch = regexHelper.match(input: content)
        for linkMatch in linksMatch {
            let start = linkMatch.range.location
            let end = linkMatch.range.location + linkMatch.range.length
            let linkString = content.substring(with: start..<end)
            print(linkString)
        }
    } catch {
    }
    return [] 
}

if let filePathValue = filePath.value {
    // continue
    let fileContent = getConentOfFile(filePathValue)
    let links = getLinks(fileContent)
    print(links)
    //print("File path is \(filePathValue), with content : \(fileContent)")
} else {
    // end of cli
}

