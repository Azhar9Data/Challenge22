//
//  ContentView.swift
//  Challenge22
//
//  Created by Azhar on 19/04/1446 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Icon
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .frame(width: 325, height: 327)
                    .foregroundColor(.cccc)
                    .padding(.bottom, 30)
                
                // Main message
                Text("There's no recipe yet")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(width: 330, height: 40)
                    .padding(.bottom, 10)
                
                // Instructional subtext
                Text("Please add your recipes")
                    .font(.system(size: 18))
                    .frame(width: 238, height: 26)
                    .foregroundColor(.gray)
            }
            .navigationTitle("Food Recipes")
            .navigationBarItems(trailing:
                // Wrap the button inside a NavigationLink to navigate to AddRecipeView
                NavigationLink(destination: AddRecipeView()) {
                    Image(systemName: "plus")
                    .foregroundColor(.cccc)
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
