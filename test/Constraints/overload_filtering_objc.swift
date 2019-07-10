// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -typecheck -verify %s -debug-constraints 2>%t.err
// RUN: %FileCheck %s < %t.err

// REQUIRES: objc_interop

// This test ensures that we are filtering out overloads based on argument
// labels, arity, etc., before those terms are visited. 

import Foundation

@objc protocol P {
  func foo(_ i: Int) -> Int
  func foo(_ d: Double) -> Int

  @objc optional func opt(_ i: Int) -> Int
  @objc optional func opt(double: Double) -> Int
  
  subscript(i: Int) -> String { get }
}

func testOptional(obj: P) {
  // FIXME: When we remove argument-label filtering from member name lookup,
  // this will start failing and need to be replaced with "disabled disjunction
  // term".
  //
  // CHECK-NOT: disjunction
  _ = obj.opt?(1)
}
