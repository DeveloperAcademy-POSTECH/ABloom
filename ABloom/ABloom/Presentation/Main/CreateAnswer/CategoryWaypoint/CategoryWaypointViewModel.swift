//
//  CategoryWaypointViewModel.swift
//  ABloom
//
//  Created by yun on 11/18/23.
//

import SwiftUI

final class CategoryWaypointViewModel: ObservableObject {
  
  @AppStorage("lastQuestionChangeDate") var lastQuestionChangeDate: Date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
  
  // TODO: 차후 user Field로 생성하기
  @AppStorage("savedRecommendQuestionId") var savedRecommendQuestionId: Int = 3
  
  // MARK: - fetch from manager
  @Published var essentials = [Int]()
  @Published var answeredQuestionsID: [Int]? = nil
  
  // MARK: - 일반 필요 변수
  @Published var recommendQuestion: DBStaticQuestion = .init(questionID: 3, category: "", content: "추천질문입니다")
  @Published var recommendedQid: Int = 1
  
  @Published var selectedCategory: Category = Category.communication
  @Published var isSelectSheetOn = Bool()
  @Published var isAnswered: Bool = false
  
  
  // MARK: - 함수 정의
  func isClicked(selectedCategory: Category) {
    self.selectedCategory = selectedCategory
    self.isSelectSheetOn.toggle()
  }
  
  func fetchInformation() {
    
    if let essentials = EssentialQuestionManager.shared.essentialQuestions {
      // 에센션 질문 인덱스 가져오기
      self.essentials = essentials
    } else {
      // TODO: 로그인 되어 있지 않을 경우
      self.essentials = [1]
    }
    
    // 둘 다 답변하지 않은 질문의 id
    if let answeredQuestions = StaticQuestionManager.shared.filteredQuestions {
      self.answeredQuestionsID = answeredQuestions.map {$0.questionID}
    } else {
      self.answeredQuestionsID = nil
    }
  }

  // TODO: 로그인 안되어 있을 때 DB 접근 X => getQuestionById 함수 호출 불가
  func loadRecommendedQuestion() async throws {
    let currentDate = Date.now
    
    if currentDate.isSameDate(lastChangedDate: lastQuestionChangeDate) {
      // 하루가 지나지 않았을 경우 그대로 가져옴
      self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: savedRecommendQuestionId)
    } else { // 하루가 지났을 경우 없데이트
      if checkAvailable() {
        self.recommendQuestion = try await StaticQuestionManager.shared.getQuestionById(id: self.recommendedQid)
        lastQuestionChangeDate = currentDate
      }
    }
  }
  
  private func randomGenerator() -> Int {
    return self.essentials.randomElement()!
  }
  
  // 둘 다 답변하지 않은 질문인지 확인
  private func checkAvailable() -> Bool {
    
    self.recommendedQid = randomGenerator()
    
    if let ids = self.answeredQuestionsID {
      if ids.contains(recommendedQid) { 
        return true
      } else { return checkAvailable() }
    }
    return true
  }
  
  
  func checkIfAnswered() {
    if let myAnswers = AnswerManager.shared.myAnswers {
      let myAnswersID = myAnswers.map({$0.questionId})
      
      if myAnswersID.contains(self.recommendedQid) {
        self.isAnswered = true
      } else {
        self.isAnswered = false
      }
    } else {
      // TODO: 로그인 해라는 얼럴트가 필요
      self.isAnswered = false
    }
  }
}
