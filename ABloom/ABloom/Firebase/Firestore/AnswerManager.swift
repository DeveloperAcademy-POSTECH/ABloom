//
//  AnswerManager.swift
//  ABloom
//
//  Created by 정승균 on 11/17/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class AnswerManager: ObservableObject {
  @Published var myAnswers: [DBAnswer]?
  @Published var fianceAnswers: [DBAnswer]?
  
  static let shared = AnswerManager()
  
  private let userCollection = Firestore.firestore().collection("users")
  
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
  
  private func userAnswerCollection(userId: String) -> CollectionReference {
    userDocument(userId: userId).collection("answers")
  }
  
  // MARK: Create
  func creatAnswer(userId: String, questionId: Int, content: String) throws {
    let collection = userAnswerCollection(userId: userId)
    let document = collection.document()
    
    let data = DBAnswer(questionId: questionId, userId: userId, answerContent: content, isComplete: false, reaction: nil)
    
    try? document.setData(from: data, merge: false)
  }
  
  // MARK: Retrieve
  func fetchMyAnswers() async throws {
    guard let currentUserId = UserManager.shared.currentUser?.userId else { return }
    
    let collection = userAnswerCollection(userId: currentUserId)
    
    self.myAnswers = try await collection.getDocuments(as: DBAnswer.self)
  }
  
  func fetchFianceAnswers(userId: String) async throws {
    guard let fianceId = UserManager.shared.currentUser?.fiance else { return }
    
    let collection = userAnswerCollection(userId: fianceId)
    self.fianceAnswers = try await collection.getDocuments(as: DBAnswer.self)
  }
  
  // MARK: Update
  func updateReaction(userId: String, answerId: String, reaction: ReactionType) {
    let data: [String: Any] = [DBAnswer.CodingKeys.reaction.rawValue:reaction.rawValue]
    
    userAnswerCollection(userId: userId).document(answerId).updateData(data)
  }
  
  func updateAnswerComplete(userId: String, answerId: String, status: Bool) {
    let data: [String: Any] = [DBAnswer.CodingKeys.isComplete.rawValue:status]
    
    userAnswerCollection(userId: userId).document(answerId).updateData(data)
  }
}