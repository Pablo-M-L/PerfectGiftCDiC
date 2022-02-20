//
//  CellUrlsListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 27/7/21.
//

import SwiftUI

struct CellUrlsListView: View {
    var url: UrlIdeas
    @State var thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        
        HStack{
            HStack{
//                Image(uiImage: thumbailUrl)
//                    .resizable()
//                    .clipShape(Circle())
//                    .frame(width: 25, height: 25)
//                    .padding(10)
                Text(url.titleUrl ?? "no title")
                Spacer()
            }
            
            Spacer()
            
            Button(action:{
                print(url.webUrl)
                if let link = URL(string: url.webUrl ?? "https://.google.com") {
                    UIApplication.shared.open(link)
                }
            }){
                Image(systemName: "safari")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("backgroundButton"))
                    .padding(.trailing, 10)
            }
        }
        .padding(5)
        .onAppear {
            if url.thumbailUrl == nil{
                thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = url.thumbailUrl
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                thumbailUrl = UIImage(data: data)!
            }
        }

    }
}

struct CellUrlsListView_Previews: PreviewProvider {
    static var previews: some View {
        CellUrlsListView(url: UrlIdeas())
    }
}
