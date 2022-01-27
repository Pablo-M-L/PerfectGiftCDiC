//
//  CellUrlsListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 27/7/21.
//

import SwiftUI

struct CellUrlsListView: View {
    var url: UrlIdeas
    
    var body: some View {
        
        HStack{
            VStack{
                Text(url.titleUrl ?? "no title")
                Text(url.webUrl ?? "no web")
            }
            
            Button(action:{
                print("ir a la web \(url.webUrl)")
                if let link = URL(string: url.webUrl ?? "www.google.com") {
                    UIApplication.shared.open(link)
                }
            }){
                Image(systemName: "safari")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }

    }
}

struct CellUrlsListView_Previews: PreviewProvider {
    static var previews: some View {
        CellUrlsListView(url: UrlIdeas())
    }
}
