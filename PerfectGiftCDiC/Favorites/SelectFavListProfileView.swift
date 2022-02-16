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
        VStack{
            Text("select")
            List{
                ForEach(profiles){ profile in
                    Text(profile.nameProfile ?? "no name")
                        .onTapGesture {
                            print(String("fav num \(sortNumer)"))
                            cambiarArrayFav(sortNumber: sortNumer, profile: profile)
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }.listStyle(.inset)
            
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
