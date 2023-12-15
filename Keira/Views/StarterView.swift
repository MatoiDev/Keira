//
//  StarterView.swift
//  Keira
//
//  Created by Matoi on 16.12.2023.
//

import SwiftUI

struct StarterView: View {
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    @EnvironmentObject var popupVM: PopupViewModel
    
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
                            Text("The best iOS IoT Interface")
                                .ralewayFont(.medium, Device.set(padnmac: 32, phone: 16), color: .secondary)
                            if Device.get() != .phone {
                                #if targetEnvironment(macCatalyst)
                                Text("[Mac beta]").ralewayFont(.light, 30.0, color: .orange).onAppear(perform: {print(Device.get() == .pad)})
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
                        print("Hey")
    
                    } label: {
                        
                        Text("Start Translation")
                            .ralewayFont(.semibold, Device.set(padnmac: 24.0, phone: 16.0), color: .black)
                            .frame(height: Device.set(padnmac: 75, phone: 50))
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(16)
                            .shadow(color: Color.orange.opacity(0.3), radius: 16, x: 0.0, y: 7.0)
                        
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Button {
                        guard let url = URL(string: "https://github.com/MatoiDev/Keira") else {return}
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("View project on GitHub")
                            .ralewayFont(.regular, Device.set(padnmac: 25.5, phone: 17.0), color: .orange)
                    }.padding()
                        .padding(.bottom, 16)
                    
                }
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

