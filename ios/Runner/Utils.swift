import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

typealias ByteArray = Array<UInt8>

typealias Handler = (_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void

struct GetQueryParameterError: Error {
}

extension URL {
    func getQueryStringParameter(key: String) throws -> String {
        if let param = NSURLComponents(string: absoluteString)?.queryItems?.filter({ $0.name == key }).first?.value {
            return param
        }
        throw GetQueryParameterError()
    }
}

extension FlutterStandardTypedData {

    var intArray: Array<Int> {
        Array(data) as! Array<Int>
    }
}
