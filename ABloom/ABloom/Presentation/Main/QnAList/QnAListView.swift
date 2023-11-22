//
//  QnAListView.swift
//  ABloom
//
//  Created by 정승균 on 11/15/23.
//

import SwiftUI

struct QnAListView: View {
  @StateObject var qnaListVM = QnAListViewModel()
  @ObservedObject var activeSheet: ActiveSheet = ActiveSheet()

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        HStack {
          Text("MERY")
            .customFont(.largeTitleXB)
          
          Spacer()
          
          profileButton
        }
        .padding(.top, 37)
        .padding([.horizontal, .bottom], 20)
        
        switch qnaListVM.viewState {
        case .isEmpty:
          emptyView
        case .isSorted:
          scrollView
        case .isProgress:
          ProgressView()
            .frame(maxHeight: .infinity)
        }
      }
     
      plusButton
    }
    .background(Color.background)
    .sheet(isPresented: $activeSheet.showSheet) { self.sheet }

    .task {
      let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
      
      if authUser == nil {
        activeSheet.kind = .signIn
      } else {
        guard let uid = authUser?.uid else { return }
        let dbUser = try? await UserManager.shared.getUser(userId: uid)
        if dbUser == nil {
          activeSheet.kind = .signUp
        }
        qnaListVM.getUserInfo()
      }
    }
  }
}

extension QnAListView {
  private var profileButton: some View {
    Button {
      qnaListVM.tapProfileButton()
    } label: {
      Image("profile.circle")
    }
    .sheet(isPresented: $qnaListVM.showProfileSheet) {
      ProfileMenuView()
    }
  }
  
  // TODO: 날짜 연결
  private var scrollView: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 12) {
        ForEach(qnaListVM.questions, id: \.questionID) { question in
          Button {
            qnaListVM.tapQnAListItem()
          } label: {
            QnAListItem(
              question: question,
              date: .now,
              answerStatus: qnaListVM.checkAnswerStatus(qid: question.questionID)
            )
          }
          .sheet(isPresented: $qnaListVM.showQnASheet) {
            CheckAnswerView(question: question)
          }
          .padding(.horizontal, 20)
        }
        
        Spacer().frame(height: 30)
      }
    }
    .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 0)
  }
  
  private var emptyView: some View {
    VStack(spacing: 12) {
      Image(systemName: "stop.fill")
        .resizable()
        .frame(width: 68, height: 68)
        .padding(.bottom, 4)
      
      Text("메리 사용 시작하기")
        .customFont(.title3B)
      
      Text("우리 둘만의 결혼문답을 작성해보세요.\n더하기 버튼을 눌러 시작할 수 있어요.")
        .customFont(.footnoteR)
    }
    .padding(.bottom, 100)
    .foregroundStyle(.black)
    .frame(maxHeight: .infinity)
  }
  
  private var plusButton: some View {
    Button {
      qnaListVM.tapPlusButton()
    } label: {
      Circle()
        .foregroundStyle(.white)
        .frame(width: 72, height: 72)
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 0)
        .overlay {
          Image(systemName: "plus")
            .resizable()
            .frame(width: 22, height: 22)
            .foregroundStyle(.purple800)
        }
        .padding(.bottom, 7)
    }
    .sheet(isPresented: $qnaListVM.showCategoryWayPointSheet) {
      CategoryWaypointView(isSheetOn: $qnaListVM.showCategoryWayPointSheet)
    }
  }
  
  private var sheet: some View {
    switch activeSheet.kind {
    case .none: return AnyView(EmptyView())
    case .signIn: return AnyView(signInSheet)
    case .signUp: return AnyView(signUpSheet)
    }
  }
  
  private var signInSheet: some View {
    SignInView(activeSheet: activeSheet)
      .presentationDetents([.height(302)])
      .onDisappear {
        Task { qnaListVM.getUserInfo() }
      }
  }
  private var signUpSheet: some View {
    SignUpView()
      .interactiveDismissDisabled()
      .onDisappear {
        Task { qnaListVM.getUserInfo() }
      }
  }
}

#Preview {
  QnAListView()
}
