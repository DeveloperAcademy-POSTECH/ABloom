//
//  MyAccountView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MyAccountView: View {
  let avatarSize: CGFloat = 70
  
  @StateObject var myAccountVM = MyAccountViewModel()
  
  var body: some View {
    VStack(alignment: .leading) {
      userInfo
        .padding(.bottom, 50)
        .padding(.top, 40)
      
      accountMenuList
      
      Spacer()
    }
    .task {
      try? await myAccountVM.getMyInfo()
    }
    .navigationTitle("내 계정")
    .navigationBarTitleDisplayMode(.inline)
    .padding(.horizontal, 25)
    .background(backgroundDefault())
    .confirmationDialog("정보 변경", isPresented: $myAccountVM.showActionSheet, titleVisibility: .hidden) {
      Button("이름 변경하기", role: .none) {
        myAccountVM.showNameChangeAlert = true
      }
      
      Button("결혼예정일 수정하기", role: .none) {
        
      }
      
      Button("취소", role: .cancel) {
        myAccountVM.showActionSheet = false
      }
    }
    .alert("이름 변경하기", isPresented: $myAccountVM.showNameChangeAlert) {
      TextField(text: $myAccountVM.nameChangeTextfield) {
        Text("홍길동")
      }
      
      Button {
        myAccountVM.showNameChangeAlert = false
      } label: {
        Text("취소")
      }
      
      Button {
        Task {
          try? myAccountVM.updateMyName(name: myAccountVM.nameChangeTextfield)
          try? await myAccountVM.getMyInfo()
        }
      } label: {
        Text("확인")
      }
      
    } message: {
      Text("변경할 이름을 입력해주세요.")
    }

  }
}

#Preview {
  NavigationView {
    MyAccountView()
  }
}

extension MyAccountView {
  private var userInfo: some View {
    HStack(spacing: 15) {
      Image("avatar_Female circle GradientBG")
        .resizable()
        .scaledToFit()
        .frame(width: avatarSize)
      
      VStack(alignment: .leading) {
        Text(myAccountVM.userName ?? "정보 없음")
          .fontWithTracking(.title3Bold)
          .foregroundStyle(.stone800)
        HStack {
          Text("결혼까지 D-\(myAccountVM.dDay ?? 0)")
            .fontWithTracking(.footnoteR)
            .foregroundStyle(.stone500)
          
          Spacer()
          
          Button {
            myAccountVM.showActionSheet = true
          } label: {
            Text("정보 수정하기 >")
              .fontWithTracking(.footnoteR)
              .foregroundStyle(.stone500)
          }
        }
        .foregroundStyle(.stone500)
      }
    }
  }
  
  private var accountMenuList: some View {
    VStack(alignment: .leading, spacing: 30) {
      Text("내 계정 관리")
        .fontWithTracking(.headlineBold)
      
      MenuListButtonItem(title: "로그아웃") {
        do {
          try myAccountVM.signOut()
        } catch {
          print(error.localizedDescription)
        }
      }
      
      MenuListNavigationItem(title: "회원탈퇴") {
        Text("회원탈퇴")
      }
    }
  }
}
