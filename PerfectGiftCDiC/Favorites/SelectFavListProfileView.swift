//
//  SelectFavListProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 14/2/22.
//

import SwiftUI
import WidgetKit

struct SelectFavListProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    
    private var profiles: FetchedResults<Profile>
    
    var sortNumer: Int
    
    var body: some View {
        
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text(NSLocalizedString("selectFav", comment: ""))
                    .foregroundColor(Color("colorTextoTitulo"))
                    .font(.custom("marker Felt", size: 24))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .frame(height: 3)
                
                List{
                    ForEach(profiles){ profile in
                        HStack{
                            Spacer()
                        Text(profile.nameProfile ?? NSLocalizedString("noName", comment: ""))
                            .onTapGesture {
                                print(String("fav num \(sortNumer)"))
                                cambiarArrayFav(sortNumber: sortNumer, profile: profile)
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.custom("marker Felt", size: 20))
                            .padding(.vertical, 5)
                            .foregroundColor(.purple)
                            Spacer()
                        }.background(Color("background3"))
                         .cornerRadius(10)
                    }
                }.listStyle(.inset)
                 .colorMultiply(Color("background"))
                    
                
            }
        }
        
    }
    
    func cambiarArrayFav(sortNumber: Int, profile: Profile){
        if let userDefaults = UserDefaults(suiteName: appGroupName){
            
            HelperWidget.arrayFavoriteData[(sortNumer - 1)].nameProfileFav = profile.nameProfile!
            HelperWidget.arrayFavoriteData[(sortNumer - 1)].imgProfileFav = profile.imageProfile!
            HelperWidget.arrayFavoriteData[(sortNumer - 1)].idProfileFav = profile.idProfile!.uuidString
            userDefaults.setArray(HelperWidget.arrayFavoriteData, forKey: key.arrayFavoriteData.rawValue)
            userDefaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
            
        }

    }
}

//struct SelectFavListProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectFavListProfileView()
//    }
//}
