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
                Text("WELCOME")
                    .font(.custom("Marker Felt", size: 70))
                    .lineLimit(1)
                    .frame(alignment: .center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()

                Text("Thank you \n for using \n Perfect Gift.")
                    .font(.custom("Marker Felt", size: 56))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding(.bottom,55)
                
                
                formatoParrafo(texto: "With perfect gift you will not only be able to remember that you have to give a gift, but it will also help you choose the best gift for the person you love.")
                
                Spacer()
                
                ZStack{
                    HStack{
                        formatoParrafo(texto: "see quick guide")
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
                
                formatoParrafo(texto: "In the home view you will see the list of your favorite people to whom you want to give a gift, all the events and select among them 6 favorite people to display them in the widgets.")
                
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
                
                formatoParrafo(texto: "Within each person's profile you can see and add, as many events, ideas and gifts as you need.")
                
                formatoParrafo(texto: "The gift idea that has been converted into a gift can be saved and moved to the list of gifts made")
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
                
                formatoParrafo(texto: "Fill in the data and save any idea, event or gift you want.")
                
                
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
                
                formatoParrafo(texto: "In the browser you can search for all the options to help you find that perfect gift with which you want to surprise one of your favorite people.")
                
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
                formatoParrafo(texto: "You also have the option to add widgets to your home screen so you never forget to give someone you love a gift.")
                
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
                
                Text("THANK YOU \n FOR USING \n PERFECT GIFT!!!")
                    .font(.custom("Marker Felt", size: 70))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()
                
                Text("I HOPE \n YOU ENJOY \n AND \n IT WILL BE OF \n GREAT HELP.")
                    .font(.custom("Marker Felt", size: 40))
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding()
                                               
                Spacer()

            }.padding()
            
            VStack{
                Spacer()
                Button(action:{
                    UserDefaults.standard.setValue(false, forKey: key.firstAppRun.rawValue)
                    firstAppRun = false
                },label:{
                    Text("Close")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.blue)
                        .padding(20)
                        .background(Color.orange)
                        .cornerRadius(25)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                }).padding(.bottom,50)
            }

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
