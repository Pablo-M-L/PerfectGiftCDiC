//
//  MesajeBienvenidaView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 8/2/22.
//

import SwiftUI

struct MensajeBienvenidaView: View {

    @Binding var firstAppRun: Bool

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            TabView{
                mensaje1()
                
                mensaje2()
                
                mensaje3()
                
                mensaje4()
                
                mensaje5()
                
                mensaje6()
                
                mensaje7(firstAppRun: $firstAppRun)
                
            }.tabViewStyle(PageTabViewStyle())
             .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct mensaje1: View{
    @State private var positionHandX = UIScreen.main.bounds.midX
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                Text(NSLocalizedString(NSLocalizedString("mess1A", comment: ""), comment: ""))
                    .font(.custom("Marker Felt", size: 70))
                    .lineLimit(1)
                    .frame(alignment: .center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()

                Text(NSLocalizedString("mess1B", comment: ""))
                    .font(.custom("Marker Felt", size: 56))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding(.bottom,55)
                
                
                formatoParrafo(texto: NSLocalizedString("mess1C", comment: ""))
                
                Spacer()
                
                ZStack{
                    HStack{
                        formatoParrafo(texto: NSLocalizedString("mess1D", comment: ""))
                        Spacer()
                    }
                    
                    Image("swipeHand")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .offset(x: positionHandX - 28)
                        .animation(Animation.easeInOut(duration: 5).repeatForever().speed(3))
                    
                }.padding(.bottom,50)
                    .onAppear {
                        withAnimation {
                            positionHandX = UIScreen.main.bounds.minX
                        }
                    }
                
                

            }.padding()

        }.padding(.horizontal,10)
         .padding(.bottom,10)

    }
}

struct mensaje2: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Image("mainView")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                formatoParrafo(texto: NSLocalizedString("mess2A", comment: ""))
                
                Spacer()
            }.padding()

        }.padding(.horizontal,10)
         .padding(.bottom,10)

    }
}

struct mensaje3: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Image("profileView")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                formatoParrafo(texto: NSLocalizedString("mess3A", comment: ""))
                
                formatoParrafo(texto: NSLocalizedString("mess3B", comment: ""))
                    .padding(.top,15)
                
                
                Spacer()
            }.padding()
                

        }.padding(.horizontal,10)
         .padding(.bottom,10)

    }
}

struct mensaje4: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                HStack{
                    Image("addEventView")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("addGift")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Image("addIdea")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                formatoParrafo(texto: NSLocalizedString("mess4A", comment: ""))
                
                
                Spacer()
            }.padding()

        }.padding(.horizontal,10)
         .padding(.bottom,10)

    }
}

struct mensaje5: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Image("webBrowser")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                formatoParrafo(texto: NSLocalizedString("mess5A", comment: ""))
                
                Spacer()
            }.padding()
        }.padding(.horizontal,10)
         .padding(.bottom,10)

    }
}

struct mensaje6: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Image("widgets")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                formatoParrafo(texto: NSLocalizedString("mess6A", comment: ""))
                
                Spacer()
            }.padding()

        }.padding(.horizontal,10)
         .padding(.bottom,10)
    }
}

struct mensaje7: View{
    @Binding var firstAppRun: Bool
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Spacer()
                
                Text(NSLocalizedString("mess7A", comment: ""))
                    .font(.custom("Marker Felt", size: 70))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()
                
                Text(NSLocalizedString("mess7B", comment: ""))
                    .font(.custom("Marker Felt", size: 40))
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()
                                               
                Spacer()
                
                Button(action:{
                    UserDefaults.standard.setValue(false, forKey: key.firstAppRun.rawValue)
                    firstAppRun = false
                },label:{
                    Text(NSLocalizedString("mess7C", comment: ""))
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Color.orange)
                        .cornerRadius(25)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                }).padding(.bottom,50)

            }.padding()

        }.padding(.horizontal,10)
    }
}

struct formatoParrafo: View{
    var texto: String
    
    var body: some View{
        Text(texto)
            .lineSpacing(5)
            .font(.custom("Marker Felt", size: 20))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.3)
            .foregroundColor(.purple)
            .padding(.bottom, 5)
    }
}

//struct MesajeBienvenidaView_Previews: PreviewProvider {
//    static var previews: some View {
//        MensajeBienvenidaView()
//    }
//}
