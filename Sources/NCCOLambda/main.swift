import AWSLambdaRuntime

typealias CallJSON = [[String: AnyEncodable]]

struct AnyEncodable: Encodable {
    let value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

struct Input: Codable {
    let to: String
}

struct NCCO: Codable {
    let to: String
    
    func makeJson() -> CallJSON {
        [
            ["action": AnyEncodable("talk"),
             "text": AnyEncodable("Please wait while we connect you.")],
            
            ["action": AnyEncodable("connect"),
             "endpoint": AnyEncodable([[
                "type":"phone",
                "number": to
             ]])
            ]
        ]
    }
}


Lambda.run { (context, input: Input, callback: @escaping (Result<CallJSON, Error>) -> Void) in
    callback(.success(NCCO(to: input.to).makeJson()))
}
