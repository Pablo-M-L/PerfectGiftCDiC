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
        url = URL(string: UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String ?? "https://google.com")!
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
    @Published var urlString: String = UserDefaults.standard.value(forKey: key.homeWebAddres.rawValue) as? String ?? "https://google.com"

    // actions
    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func goBack() {
        webView.goBack()
    }
}
