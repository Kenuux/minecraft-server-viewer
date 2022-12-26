import SwiftUI
import AppKit
import Foundation

struct Home: View {
    
    @Namespace var animation
    @ObservedObject var appModel: AppViewModel = AppViewModel()
    @State var domainInput: String = ""
    @FocusState var domainFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            CustomSegmentedConrol()
                .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(self.appModel.tempServers, id: \.self) { server in
                    ServerView(server: server, appModel: appModel)
                }
            }
        }
        .frame(width: 450, height: 450)
        .background(Color("BG"))
        .onTapGesture {
            self.domainFieldIsFocused = false
        }
    }
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedConrol() -> some View {
        HStack(spacing: 0) {
            TextField("Add minecraft server", text: $domainInput)
                .textFieldStyle(.roundedBorder)
                .focused($domainFieldIsFocused)
                .disableAutocorrection(true)
                .focusable(false)
                .onSubmit {
                    if (self.appModel.tempServers.filter{ $0.hostname == self.domainInput }.isEmpty == false) {
                        return
                    }

                    self.appModel.tempServers.append(Server(domain: self.domainInput))
                
                    self.appModel.items = Storage.archiveServerArray(object: self.appModel.tempServers)
                    
                    print("submitted " + self.domainInput)
                    
                    self.domainInput = ""
                }
                .padding([.leading, .trailing], 24)
        }
        .padding(2)
        .background {
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
