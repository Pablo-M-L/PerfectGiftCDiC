//
//  ListGiftDoitView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 19/8/21.
//

import SwiftUI

struct ListGiftDoitView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showSheetMode = false
    @State private var showAddEvent = false
    var profile: Profile
    var ideas: FetchRequest<Ideas>
 //   var eventParent: Event
    
//    init(filterProfile: String,  filterEvent: String, event: Event){
//        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND idEventIdea MATCHES[dc] %@", filterProfile, filterEvent),animation: .default)
        


  //      eventParent = event

  //  }
    
    init(profile: Profile){
        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND regalado == %@", argumentArray: [profile.idProfile?.uuidString ?? "nadie",true]),animation: .default)
        
        self.profile = profile
    }
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                Text("GIFTS")
                    .foregroundColor(Color("colorTextoTitulo"))
                    .font(.custom("marker Felt", size: 18))
                
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .frame(height: 5)
                    
                List{
                    ForEach(ideas.wrappedValue, id: \.self) { idea in
   
                        ZStack{
                            NavigationLink(destination: DetailGiftDoitView(idea: idea) ){
                                Text("gift do it")
                            }.opacity(0)
                            CellGiftDoitView(idea: idea)
                        }.background(Color("cellprofileBck"))
                        .cornerRadius(20)
                        

                    }
                }.listStyle(.inset)
            }
            
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                            NavigationLink(destination: AddGiftDoitView(profile: profile), isActive: $showSheetMode){
                                EmptyView()
                            }
                        
                        Button(action:{
                            showSheetMode = true
                            
                        }, label:{
                            ZStack{
                                Image("giftDoitIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("backgroundButton"))
                                    .offset(x: -25, y: 25)
                            }
                            .frame(width: 60, height: 60)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()
                        })

                    }
                    
                }
            }.padding(.bottom, 30)
            

        }
        
    }
}

//struct ListGiftDoitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListGiftDoitView()
//    }
//}
