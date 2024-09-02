import Foundation

enum LogItem {
    case header(String)
    case keyValue(String, String)
    case group(String, items: [LogItem])
    case raw(String)

    var description: String {
        switch self {
        case let .header(text):
            return "=== \(text) ==="
        case let .keyValue(key, value):
            return "\(key): \(value)"
        case let .group(title, items):
            let content = items.map(\.description).joined(separator: "\n").indented()
            return "\(title):\n\(content)"
        case let .raw(text):
            return text
        }
    }
}

extension String {
    func indented(by spaces: Int = 4) -> String {
        let indent = String(repeating: " ", count: spaces)
        return components(separatedBy: .newlines)
            .map { indent + $0 }
            .joined(separator: "\n")
    }
}

extension Data {
    var prettyString: String {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyString = String(data: data, encoding: .utf8)
        else {
            return String(data: self, encoding: .utf8) ?? "Unable to parse JSON"
        }
        return prettyString
    }
}
