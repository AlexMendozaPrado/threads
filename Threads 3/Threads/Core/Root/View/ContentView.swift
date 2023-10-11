//
//  ContentView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                ThreadsTabView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
