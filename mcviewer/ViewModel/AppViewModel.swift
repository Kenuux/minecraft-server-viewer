import SwiftUI

class AppViewModel: ObservableObject {
        
    @Published var tempServers: [Server] = []
    
    @AppStorage("DOMAINS", store: UserDefaults(suiteName: "dev.hbib.mcviewer")) var items: Data = Data()
    
    init() {
        self.tempServers = Storage.loadServerArray(data: items)
                
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [self] _ in
            Task {
                do {
                    try await self.fetchServerData()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.fire()
    }
    
    func fetchServerData() async throws {
        let session = URLSession.shared
        
        for server in tempServers {
            let optionalURL = URL(string: "https://api.mcsrvstat.us/2/\(server.domain!)")
            
            guard let url = optionalURL else {
                return
            }
            
            let response = try await session.data(from: url)
                        
            do {
                let object = try JSONDecoder().decode(Server.self, from: response.0)
                
                // MARK: Handle player count
                if let players = object.players {
                    DispatchQueue.main.async {
                        server.players = players
                    }
                }
                
                // MARK: Handle motd
                if let motd = object.motd {
                    DispatchQueue.main.async {
                        server.motd = motd
                    }
                }
                
                // MARK: Handle ping image
                if let ping = object.debug?.ping {
                    DispatchQueue.main.async {
                        server.pingImage = NSImage(named: NSImage.Name(ping ? "Pinged" : "Timeout"))!
                    }
                } else {
                    DispatchQueue.main.async {
                        server.pingImage = NSImage(named: NSImage.Name("Timeout"))!
                    }
                }
                
                // MARK: Handle server icon
                if let icon = object.icon {
                    let base64 = icon.components(separatedBy: "data:image/png;base64,")
                    
                    server.icon = base64[1]
                    
                    DispatchQueue.main.async {
                        server.iconImage = NSImage(data: Data(base64Encoded: server.icon!)!)!
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
