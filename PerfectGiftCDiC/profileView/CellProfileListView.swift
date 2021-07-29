//
//  CellProfileListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 6/7/21.
//

import SwiftUI

struct CellProfileListView: View {
    
    //    TextEditor is backed by UITextView. So you need to get rid of the UITextView's backgroundColor first and then you can set any View to the background.
//        init() {
//            UITextView.appearance().backgroundColor = .clear
//        }
    
    var profile: Profile
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    Image(uiImage: imgServicio)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading){
                        Text(profile.nameProfile ?? "sin nombre")
                        Text("fecha proximo evento")
                    }
                    Spacer()
                }
            }
            .frame(height: 80)
            .onAppear{
                if profile.imageProfile == nil{
                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = profile.imageProfile
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgServicio = UIImage(data: data)!
                }
            }
        }
    }
}

struct CellProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        CellProfileListView(profile: Profile())
    }
}
