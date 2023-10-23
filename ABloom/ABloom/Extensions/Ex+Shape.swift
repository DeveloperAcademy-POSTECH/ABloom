//
//  GradientColors.swift
//  ABloom
//
//  Created by yun on 10/17/23.
//

import SwiftUI

extension Shape {
  
  /***
   Customized Shadows
   - Shape에 대한 Modifier로 적용
   
   총 7개의 함수 존재
   1. clayMorpMDShadow()
   2. clayMorpXLShadow()
   3. mainImgShadow()
   4. glassBG1Shadow()
   5. clayMorpMDPinkShadow()
   6. clayMorpBtnXLPinkShadow()
   7. clayMorpBtnGrayShadow()
   
   사용예제
   -
   Rectangle()
   .clayMorpMDShadow()
   */
  public func clayMorpMDShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.03), radius: 20, x: 0, y: 7))
    )
  }
  
  public func clayMorpXLShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 7))
    )
  }
  
  public func mainImgShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 20, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.6), radius: 30, x: 3, y: 1))
      .shadow(.drop(color: Color.pink500.opacity(0.12), radius: 20, x: 0, y: 12))
    )
  }
  
  public func glassBG1Shadow() -> some View {
    self.fill(
      .shadow(.drop(color: Color.black.opacity(0.05), radius: 12.5, x: 0, y: 4))
    )
    .blur(radius: 1)
  }
  
  public func clayMorpMDPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink600.opacity(0.03), radius: 20, x: 0, y: 7))
    )
  }
  
  public func clayMorpBtnXLPinkShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.pink100.opacity(1), radius: 40, x: 0, y: 20))
    )
  }
  
  public func clayMorpBtnGrayShadow() -> some View {
    self.fill(
      .shadow(.inner(color: Color.black.opacity(0.03), radius: 10, x: 0, y: -3))
      .shadow(.inner(color: Color.white.opacity(0.5), radius: 15, x: 3, y: 1))
      .shadow(.drop(color: Color.stone200.opacity(1), radius: 40, x: 0, y: 20))
    )
  }
}
