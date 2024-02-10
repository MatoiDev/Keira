//
//  StarterView.swift
//  Keira
//
//  Created by Matoi on 16.12.2023.
//

import SwiftUI

final class StarterViewModel: ObservableObject {
    @Published var action: Int? = 0
    @Published var showModePopup: Bool = false
    
    func openGitHub() {
        guard let url = URL(string: "https://github.com/MatoiDev/Keira") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct StarterView: View {
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    @EnvironmentObject var popupVM: PopupViewModel
    
    @StateObject var _vm: StarterViewModel = StarterViewModel()
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
    }
    
    var body: some View {
        NavigationView {
            ZStack {

                Color.black.ignoresSafeArea()
                VStack {
                    VStack(alignment: .trailing) {
                        Text("Welcome to Keira")
                            .ralewayFont(.semibold, Device.set(padnmac: 64, phone: 32), color: .white)
                        HStack {
                            Text("Control your FPV bot via BLE.")
                                .ralewayFont(.medium, Device.set(padnmac: 32, phone: 16), color: .secondary)
                            if Device.get() != .phone {
                                #if targetEnvironment(macCatalyst)
                                Text("[Mac beta]").ralewayFont(.light, 30.0, color: .orange)
                                #endif
                            }
                        }
                    }
                    
                    .padding(.top, 32)
                    
                    Spacer()
                    
                    List {
                        NavigationLink(destination: ControllersView()) { MainPickerCell(withType: .forRobot) }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                            
                        NavigationLink(destination: ControllersView()) { MainPickerCell(withType: .forCamera) }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .overlay(content: {
                        VStack {
                            LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
                                .frame(height: 20)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }

                    })
                    .listStyle(.plain)
                    .background(.black)
                    .modifier(ListBackgroundModifier())
                    
                    Spacer()
                    
                    Button {
                        self._vm.showModePopup.toggle()
                    } label: {
                        Text("Control")
                            .ralewayFont(.semibold, Device.set(padnmac: 24.0, phone: 16.0), color: .black)
                            .frame(height: Device.set(padnmac: 75, phone: 50))
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(16)
                            .shadow(color: Color.orange.opacity(0.3), radius: 16, x: 0.0, y: 7.0)
                            .opacity(self.btVM.selectedDevice != nil && self.btVM.deviceConnectionStatus == .connected ? 1 : 0.5)
                    }
                  
                    .startButtonStyle(scale: 0.95)
                    .disabled(self.btVM.deviceConnectionStatus != .connected)
                    
                
                    Button {
                        self._vm.openGitHub()
                    } label: {
                        Text("View project on GitHub")
                            .ralewayFont(.regular, Device.set(padnmac: 25.5, phone: 17.0), color: .orange)
                    }
                    .padding()
                    .padding(.bottom, 16)
                    
                }
                ModePopup(isPresented: self.$_vm.showModePopup).zIndex(10)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Main"))
        }
        .accentColor(.orange)
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: self.btVM.deviceConnectionStatus, perform: { status in
            
            switch status {
            case .connected:
                self.popupVM.popupCase = .succes
            case .error:
                self.popupVM.popupCase = .failed
            default:
                return
            }
            self.popupVM.showPopup()
            
        })

    }
}

struct StarterView_Previews: PreviewProvider {
    static var previews: some View {
        StarterView()
    }
}

