//
//  IdeasListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI

struct IdeasListView: View {
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
        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND regalado == %@", argumentArray: [profile.idProfile?.uuidString ?? "nadie",false] ),animation: .default)
        
        self.profile = profile
    }
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                Text("IDEAS")
                    .foregroundColor(Color("colorTextoTitulo"))
                    .font(.custom("marker Felt", size: 18))
                
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .frame(height: 5)
                    
                List{
                    ForEach(ideas.wrappedValue, id: \.self) { idea in
   
                        ZStack{
                            NavigationLink(destination: DetailIdeaView(idea: idea) ){
                                Text("idea")
                            }.opacity(0)
                            CellIdeaListView(idea: idea)
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
                            NavigationLink(destination: AddIdeaView(profile: profile), isActive: $showSheetMode){
                                EmptyView()
                            }
                        
                        Button(action:{
                            showSheetMode = true
                            
                        }, label:{
                            ZStack{
                                Image("addIdeaIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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

//struct IdeasListView_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeasListView(filterProfile: "pablo", filterEvent: "cumple")
//    }
//}
