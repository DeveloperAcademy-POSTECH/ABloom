//
//  SelectQuestionView.swift
//  ABloom
//
//  Created by yun on 10/23/23.
//

import SwiftUI

struct SelectQuestionView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var selectQVM = SelectQuestionViewModel()
  
  let sex: Bool
  
  var body: some View {
    VStack {
      
      categoryBar
      
      if selectQVM.isReady {
        
        questionListView
          .background(backWall())
        
      } else {
        
        VStack {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backWall())
        
      }
    }
    .navigationDestination(for: DBStaticQuestion.self, destination: { content in
      AnswerWriteView(question: content, isFromMain: false)
    })
    
    .onAppear {
      //TODO: mainView에서도 추가해야함! 충돌일어날까봐 우선 보류
      UINavigationController.isSwipeBackEnabled = true
      if NavigationModel.shared.isPopToMain {
        NavigationModel.shared.popToMainToggle()
        dismiss()
      }
    }
    
    .task {
      try? await selectQVM.fetchQuestions()
    }
    
    // 네비게이션바
    .customNavigationBar(
      centerView: {
        Text("질문 선택하기")
      },
      leftView: {
        Button {
          dismiss()
        } label: {
          NavigationArrowLeft()
        }
      },
      rightView: {
        EmptyView()
      })
    
    .background(backgroundDefault())
    .ignoresSafeArea(.all, edges: .bottom)
  }
}

extension SelectQuestionView {
  
  private var categoryBar: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        
        ForEach(Category.allCases, id: \.self) { category in
          VStack(alignment: .center, spacing: 6) {
            
            Image(category.imgName)
              .resizable()
              .frame(width: 64, height: 64)
            
            Text(category.type)
              .fontWithTracking(selectQVM.selectedCategory == category ? .caption1Bold : .caption1R)
              .foregroundStyle(.stone700)
          }
          .opacity(selectQVM.selectedCategory == category ? 1 : 0.4)
          .onTapGesture(perform: {
            selectQVM.selectCategory(seleted: category)
          })
        }
      }
      .padding([.horizontal, .bottom], 22)
      .padding(.top, 36)
      
    }
  }
  
  private var questionListView: some View {
    VStack(spacing: 0) {
      
      HStack {
        Text("\(selectQVM.selectedCategory.type) 문답")
          .fontWithTracking(.headlineBold)
          .foregroundStyle(.stone700)
        
        Spacer()
      }
      .padding(.horizontal, 22)
      .padding(.top, 34)
      .padding(.bottom, 10)
      
      ScrollViewReader { proxy in
        ScrollView(.vertical) {
          Spacer()
            .frame(height: 20)
            .id("top")
          
          ForEach(selectQVM.filteredLists, id: \.self) { question in
            NavigationLink(value: question) {
              QuestionChatBubble(text: question.content.useNonBreakingSpace())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 17)
            
          }
          Spacer()
            .frame(height: 50)
        }
        .onChange(of: selectQVM.selectedCategory) { new in
          proxy.scrollTo("top")
        }
        
      }
    }
  }
}

#Preview {
  SelectQuestionView(sex: false)
}
