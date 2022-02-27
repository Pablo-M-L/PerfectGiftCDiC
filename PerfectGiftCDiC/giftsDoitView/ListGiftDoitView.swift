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
    @State private var ideasListEmpty = false
    
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
            
            List{
                ForEach(ideas.wrappedValue, id: \.self) { idea in

                    ZStack{
                        NavigationLink(destination: DetailGiftDoitView(idea: idea, isNewIdea: false) ){
                            Text("gift do it")
                        }.opacity(0)
                        CellGiftDoitView(idea: idea)
                    }.background(Color("cellprofileBck"))
                    .cornerRadius(20)
                    

                }
            }.listStyle(.inset)
            
                VStack{
                        if ideasListEmpty{
                    HStack{
                        Spacer()
                            NavigationLink(destination: AddGiftDoitView(profile: profile), isActive: $showSheetMode){
                                EmptyView()
                            }
                        
                        Button(action:{
                            showSheetMode = true
                            
                        }, label:{
                            ZStack{
                                Image("addGiftDoitIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("backgroundButton"))
                                    .offset(x: -65, y: 70)
                            }
                            .frame(width: 150, height: 150)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()
                        })
                        Spacer()

                    }
                        }
                }
             .onAppear {
                 //comprobar si el fetchrequest está vacio
                 if ideas.wrappedValue.isEmpty{
                     ideasListEmpty = true
                 }else{
                     ideasListEmpty = false
                 }
                 
             }
            

        }
        
    }
}

//struct ListGiftDoitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListGiftDoitView()
//    }
//}
