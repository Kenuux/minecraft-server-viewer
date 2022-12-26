import Foundation

class ServerMotd: NSObject, NSCoding, Decodable {
    
    var clean: [String]!
    
    func encode(with coder: NSCoder) {
        coder.encode(self.clean, forKey: "clean")
    }
    
    required init?(coder: NSCoder) {
        self.clean = (coder.decodeObject(forKey: "clean") as! [String])
    }
    
    init(clean: [String]) {
        self.clean = clean
        
        super.init()
    }
}
