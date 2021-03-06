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
    var hash = ""

    init(_ linkString: String) {
        print(linkString)
        // #### 3.3.2. 文件命名
        // depth = 4
        // text = "3.3.2. 文件命名"
        // hash = "332-文件命名"
        var pos = 0;
        for a in linkString.characters {
            if a == "#" {
                pos += 1
            } else {
                break;
            }
        }

        depth = pos
        text = linkString.substring(with: pos..<linkString.characters.count).trim()
        hash = convertLink(text)
    }

    // CustomStringConvertible Protocal
    var description: String {
        return "Link with depth:\(depth) text:\(text) hash:\(hash)"
    }

    // 转化为URL
    // .,/ 中文括号等各类字符 => DEL
    // 空格 => -
    // 字母转化为小写
    // 其它不处理
    func convertLink(_ inputText:String) -> String {
        let origin = inputText.lowercased()
        var output = "";
        for a in origin.characters {
            var append = "";
            switch a {
            case " ":
                append = "-"
            case ".", ",", "/", "）", "（", "”", "“", "#", "<", ">", "\"":
                append = ""
            default:
                append = String(a)
            }

            output += append;
        }

        return output
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
        let regexHelper = try RegexHelper("#+\\s\\d*.*")
        let linksMatch = regexHelper.match(input: content)
        var array = [Link]()
        for linkMatch in linksMatch {
            let start = linkMatch.range.location
            let end = linkMatch.range.location + linkMatch.range.length
            let linkString = content.substring(with: start..<end)
            //print(linkString)
            let link = Link(linkString)
            array.append(link)
            //print(link)
        }
        return array
    } catch {
    }
    return [] 
}

func buildContent(links: [Link]) -> String {
    var content = ""
    for link in links {
        if link.depth == 1 {
            //content += "\n"
        } else if link.depth == 2 {
            //content += "\n　　"
            content += "\n"
        } else {
            var tmpDepth = link.depth
            repeat {
                content += "　　"
                tmpDepth -= 1
            } while (tmpDepth > 2)
            //} while (tmpDepth > 1)
        }
        content += "[\(link.text)](#\(link.hash))  \n"
    }
    return content
}

if let filePathValue = filePath.value {
    // continue
    let fileContent = getConentOfFile(filePathValue)
    let links = getLinks(fileContent)
    let linkContent = buildContent(links: links)
    //print("File path is \(filePathValue), with content : \(fileContent)")
    //print(links)
    //print(linkContent)
    print("Put link to head of the File ...")
    let newFile = linkContent + fileContent
    do {
        try newFile.write(toFile:filePathValue, atomically:true, encoding:.utf8)
        print("Done!")
    } catch {
        print("Write to file with error:\(error)")
    }
} else {
    // end of cli
}

