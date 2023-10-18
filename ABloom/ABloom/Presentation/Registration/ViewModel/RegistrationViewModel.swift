//
//  RegistrationViewModel.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/17/23.
//

import SwiftUI

enum InputField {
  case text
  case radio
  case datePicker
}

enum UserType: String, CaseIterable {
  case woman = "예비신부"
  case man = "예비신랑"
}

enum RegisterField {
  case username
  case userType
  case weddingDate
}

class RegistrationViewModel: ObservableObject {
  @Published var userName: String = ""
  @Published var userType: UserType?
  @Published var weddingDate: Date = .now
  @Published var isDatePickerTapped: Bool = false
  @Published var isShowingDatePicker = false

  var formattedWeddingDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: weddingDate)
  }
    
  var isNextButtonEnabled: Bool {
    return isUserNameValid && isWeddingDateValid && 
    (isUserTypeValid(type: .man) || isUserTypeValid(type: .woman))
  }
  
  var isUserNameValid: Bool {
    return isFieldValid(.text, value: userName)
  }
  
  var isWeddingDateValid: Bool {
    return isFieldValid(.datePicker, value: formattedWeddingDate)
  }
  
  func isUserTypeValid(type: UserType) -> Bool {
    isFieldValid(.radio, value: type.rawValue, selectedType: userType)
  }
  
  private func isFieldValid(_ type: InputField, value: String?, selectedType: UserType? = nil) -> Bool {
    switch type {
    case .datePicker:
      return isDatePickerTapped
    case .text:
      if let text = value {
        return !text.isEmpty
      }
      else {
        return false
      }
    case .radio:
      return selectedType != nil && selectedType?.rawValue == value
    }
  }
}