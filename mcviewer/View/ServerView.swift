import SwiftUI

struct ServerView: View {
    
    @ObservedObject var server: Server
    @ObservedObject var appModel: AppViewModel
    
    var body: some View {
        HStack {
            // MARK: Server Icon
            Image(nsImage: server.iconImage)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 0) {
                    // MARK: Domain/IP
                    Text(server.domain)
                        .fontWeight(.semibold)
                        .frame(width: 140, alignment: .leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    HStack(spacing: 8) {
                        // MARK: Player count
                        Text(verbatim: "\(server.players?.online ?? 0)/\(server.players?.max ?? 0)")
                            .fontWeight(.semibold)
                            .frame(width: 100, alignment: .trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        // MARK: Ping Indicator
                        Image(nsImage: server.pingImage)
                            .resizable()
                            .frame(width: 20, height: 14, alignment: .leading)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                // MARK: MOTD
                if let firstMotdLine = server.motd?.clean[0] {
                    Text(firstMotdLine.trimmingCharacters(in: .whitespacesAndNewlines))
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("Can't connect to server")
                        .foregroundColor(Color("TimeoutColor"))
                }
                Text(server.motd?.clean[1].trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: 325, alignment: .leading)
        }
        .contentShape(Rectangle())
        .contextMenu {
            Button("Delete \(server.domain)") {
                if let idx = self.appModel.tempServers.firstIndex(where: { $0 === self.server }) {
                    self.appModel.tempServers.remove(at: idx)
                    
                    self.appModel.items = Storage.archiveServerArray(object: self.appModel.tempServers)
                }
            }
        }
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
