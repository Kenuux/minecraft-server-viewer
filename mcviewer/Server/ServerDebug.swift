import Foundation


class ServerDebug: NSObject, NSCoding, Decodable {
    
    var ping: Bool!
    
    func encode(with coder: NSCoder) {
        coder.encode(self.ping, forKey: "ping")
    }
    
    required init?(coder: NSCoder) {
        self.ping = (coder.decodeObject(forKey: "ping") as? Bool)
    }
    
    init(ping: Bool) {
        self.ping = ping
        
        super.init()
    }
}
