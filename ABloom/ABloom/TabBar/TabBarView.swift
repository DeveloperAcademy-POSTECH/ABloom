//
//  TabBarView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/17/23.
//

import SwiftUI

struct TabBarView: View {
  @State var selectedTab: Tab = .main
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.white
  }
  
  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(Tab.allCases, id: \.self) { tab in
        switch tab {
        case .main:
          HomeView()
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        case .qna:
          QuestionMainView()
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        case .info:
          MenuView()
            .tabItem {
              Image(systemName: tab.icon)
              Text(tab.title)
            }
            .tag(tab)
        }
      }
    }
  }
}

#Preview {
  TabBarView()
}
