//
//  WebViewModel.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 22/2/22.
//

import Foundation
import Combine
import WebKit


class WebViewModel: ObservableObject{
    let webView: WKWebView
    let url: URL
    
    
    init(){
        webView = WKWebView(frame: .zero)
        url = URL(string: "https://google.com")!
        loadUrl()
    }
    
    //salidas
    @Published var canGoBack:Bool = false
    @Published var canGoForward: Bool = false
    
    
    @Published var didFinishLoading: Bool = false
    @Published var linkString: String = "no url"
    
    private func setUpBindings(){
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)
        
        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)
    }
    
    // inputs
    @Published var urlString: String = "https://www.google.es"

    // actions
    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func goForward() {
        print("go")
        webView.goForward()
    }
    
    func goBack() {
        print("goba")
        webView.goBack()
    }
}
