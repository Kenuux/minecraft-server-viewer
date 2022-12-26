import Foundation

class ServerPlayers: NSObject, NSCoding, Decodable {
    
    var online: Int!
    var max: Int!
    
    func encode(with coder: NSCoder) {
        coder.encode(self.online, forKey: "online")
        coder.encode(self.max, forKey: "max")
    }
    
    required init?(coder: NSCoder) {
        self.online = (coder.decodeObject(forKey: "online") as! Int)
        self.max = (coder.decodeObject(forKey: "max") as! Int)
    }
    
    init(online: Int, max: Int) {
        self.online = online
        self.max = max
        
        super.init()
    }
}

