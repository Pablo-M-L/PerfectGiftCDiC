//
//  MesajeBienvenidaView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 8/2/22.
//

import SwiftUI

struct MensajeBienvenidaView: View {
    var body: some View {
        TabView{
            mensaje1()

            mensaje2()

            mensaje3()

            mensaje4()
            
            mensaje5()
            
            mensaje6()
        }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct mensaje1: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                Text("Welcome and thank you for using Perfect Gift.")
                    .font(.custom("Marker Felt", size: 26))
                    .lineLimit(5)
                    .minimumScaleFactor(0.3)
                    .foregroundColor(.purple)
                    .padding(.bottom,25)
                    .padding(.top,20)
                
                
                formatoParrafo(texto: "With perfect gift you will not only be able to remember that you have to give a gift, but it will also help you choose the best gift for the person you love.")
                
                Spacer()

            }.padding()
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("..........>")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct mensaje2: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                
                formatoParrafo(texto: "You will see the list of people you want to give a gift to, and the closest event for each of them.")
                
                formatoParrafo(texto: "In the 'coming soon' list, all the events will be shown ordered by date, in which the information of the person, the event and the years that are fulfilled.")
                
                Spacer()
            }.padding()
                .padding(.top, 20)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("Continue -->")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct mensaje3: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                
                formatoParrafo(texto: "Within each person's profile you can add as many events, ideas and gifts as you need.")
                
                formatoParrafo(texto: "In the list of gift ideas you can save all the ideas you have or that the interested party has suggested.")
                
                formatoParrafo(texto: "The gift idea that has become a gift can be saved and moved to the list of gifts made")
                    .padding(.top,15)
                
                
                Spacer()
            }.padding()
                .padding(.top,20)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("Continue -->")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct mensaje4: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                
                formatoParrafo(texto: "Each event can be one of these 3 types:")
                
                formatoParrafo(texto: "BIRTHDAY, ANNIVERSARY and SPECIAL DAY")
                
                formatoParrafo(texto: "in which you only have to indicate the date you want to commemorate, the title indicating the reason for the commemoration and you will always have the day and the years that have passed since that special day.")
                
                
                Spacer()
            }.padding()
                .padding(.top,20)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("Continue -->")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct mensaje5: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                
                formatoParrafo(texto: "In the list of gifts made, it will let you know what you have given him previously and for what reason, giving you very valuable information to choose the next gift.")
                
                formatoParrafo(texto: "You can also add gifts made by you or someone else directly to the gift list.")
                
                Spacer()
            }.padding()
                .padding(.top,20)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("Continue -->")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct mensaje6: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.pink)
                .opacity(0.1)
            
            VStack{
                
                formatoParrafo(texto: "WELCOME!!I HOPE YOU ENJOY AND IT WILL BE OF GREAT HELP.")
                
                formatoParrafo(texto: "THANK YOU FOR USING PERFECT GIFT!!!")
                               
                formatoParrafo(texto: "I HOPE YOU ENJOY AND IT WILL BE OF GREAT HELP.")
                
                Spacer()
            }.padding()
                .padding(.top,20)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .opacity(0.4)
                        
                    Text("Continue -->")
                        .font(.custom("Arial", size: 18))
                        .foregroundColor(.red)
                        .bold()
                }.frame(width: 200, height: 50, alignment: .center)
                    .padding(.bottom,50)
                    .padding(.trailing, 20)
            }
            }

        }.padding(25)
    }
}

struct formatoParrafo: View{
    var texto: String
    
    var body: some View{
        Text(texto)
            .lineSpacing(5)
            .font(.custom("Marker Felt", size: 20))
            .minimumScaleFactor(0.3)
            .foregroundColor(.purple)
            .padding(.bottom, 5)
    }
}

struct MesajeBienvenidaView_Previews: PreviewProvider {
    static var previews: some View {
        MensajeBienvenidaView()
    }
}
