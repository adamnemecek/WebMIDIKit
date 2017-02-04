//
//  Utils.swift
//  Test
//
//  Created by Adam Nemecek on 2/4/17.
//
//

import Foundation

func check<T>(_ value: T, predicate: (T) -> Bool) -> T {
  assert(predicate(value))
  return value
}

