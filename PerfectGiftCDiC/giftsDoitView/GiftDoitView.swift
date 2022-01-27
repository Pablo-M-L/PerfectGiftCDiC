//
//  GiftDoitView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 19/8/21.
//

import SwiftUI

struct GiftDoitView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack{
            Button(action:{
                print("profile: \(viewModel.currentProfile.nameProfile ?? "nada")")
            }, label:{
                Text("profile")
            })
        }
    }
}

struct GiftDoitView_Previews: PreviewProvider {
    static var previews: some View {
        GiftDoitView()
    }
}
