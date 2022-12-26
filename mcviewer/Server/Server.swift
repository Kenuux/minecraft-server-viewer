import Foundation
import SwiftUI

private class PublishedWrapper<T> {
    @Published private(set) var value: T

    init(_ value: Published<T>) {
        _value = value
    }
}

extension Published {
    var unofficialValue: Value {
        PublishedWrapper(self).value
    }
}

extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try .init(from: decoder))
    }
}

extension Published: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try unofficialValue.encode(to: encoder)
    }
}

class Server: NSObject, NSCoding, Decodable, ObservableObject {
    
    @Published var iconImage: NSImage = NSImage(named: NSImage.Name("UnknownServer"))!
    @Published var pingImage: NSImage = NSImage(named: NSImage.Name("Timeout"))!

    var domain: String!
    
    var debug: ServerDebug?
    @Published var players: ServerPlayers?
    @Published var motd: ServerMotd?
    var hostname: String?
    var icon: String?
    
    private enum CodingKeys: String, CodingKey {
            case domain, hostname, icon, debug, players, motd
        }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.domain, forKey: "domain")
    }
    
    required init?(coder: NSCoder) {
        self.domain = (coder.decodeObject(forKey: "domain") as! String)
        
        self.debug = (coder.decodeObject(forKey: "debug") as? ServerDebug)
        self.players = (coder.decodeObject(forKey: "players") as? ServerPlayers)
        self.motd = (coder.decodeObject(forKey: "motd") as? ServerMotd)
        self.hostname = (coder.decodeObject(forKey: "hostname") as? String)
        self.icon = (coder.decodeObject(forKey: "icon") as? String)
    }
    
    init(domain: String) {
        self.domain = domain
        
        super.init()
    }
}
