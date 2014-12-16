//
//  ObservableArray.swift
//  Avalon
//
//  Created by Colin Eberhardt on 12/12/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

/// An array implementation that informs its delegate of any mutating
/// operations that have been performed on the array.
@objc public class ObservableArray: ArrayLiteralConvertible {
  
  var backingArray: [AnyObject]
 
  /// A delegate that receives notifications whenever the array is mutated
  public weak var delegate: ObservableArrayDelegate?
  
  public  init() {
    backingArray = [AnyObject]()
  }
 
  /// Create an instance containing `elements`.
  public convenience required init(arrayLiteral elements: AnyObject...) {
    self.init()
    backingArray = Array(elements)
  }
  
  /// How many elements the Array stores
  public var count: Int {
    return backingArray.count
  }
  
  /// How many elements the `Array` can store without reallocation
  public var capacity: Int {
    return backingArray.capacity
  }
  
  /// `true` if and only if the `Array` is empty
  public var isEmpty: Bool {
    return backingArray.isEmpty
  }
  
  /// The first element, or `nil` if the array is empty
  public var first: AnyObject? {
    return backingArray.first
  }
  
  /// The last element, or `nil` if the array is empty
  public var last: AnyObject? {
    return backingArray.last
  }
  
  /// Append newElement to the Array
  public func append(newElement: AnyObject) {
    backingArray.append(newElement)
    delegate?.didAddItem?(newElement, atIndex: count - 1, inArray: self)
  }
  
  /// Remove an element from the end of the Array
  public func removeLast() -> AnyObject {
    let result: AnyObject = backingArray.removeLast()
    delegate?.didRemoveItem?(result, atIndex: count, inArray: self)
    return result
  }
  
  /// Insert `newElement` at index `i`.
  public func insert(newElement: AnyObject, atIndex i: Int) {
    backingArray.insert(newElement, atIndex: i)
    delegate?.didAddItem?(newElement, atIndex: i, inArray: self)
  }
  
  /// Remove and return the element at index `i`
  public func removeAtIndex(index: Int) -> AnyObject {
    let result: AnyObject = backingArray.removeAtIndex(index)
    delegate?.didRemoveItem?(result, atIndex: index, inArray: self)
    return result
  }
  
  /*

/// Construct from an arbitrary sequence with elements of type `T`
init<S : SequenceType where T == T>(_ s: S)

/// Reserve enough space to store minimumCapacity elements.
///
/// PostCondition: `capacity >= minimumCapacity` and the array has
/// mutable contiguous storage.
///
/// Complexity: O(`count`)
mutating func reserveCapacity(minimumCapacity: Int)



/// Append the elements of `newElements` to `self`.
///
/// Complexity: O(*length of result*)
///
mutating func extend<S : SequenceType where T == T>(newElements: S)



/// Remove all elements.
///
/// Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
///
/// Complexity: O(\ `countElements(self)`\ ).
mutating func removeAll(keepCapacity: Bool = default)

/// Interpose `self` between each consecutive pair of `elements`,
/// and concatenate the elements of the resulting sequence.  For
/// example, `[-1, -2].join([[1, 2, 3], [4, 5, 6], [7, 8, 9]])`
/// yields `[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]`
func join<S : SequenceType where [T] == [T]>(elements: S) -> [T]

/// Return the result of repeatedly calling `combine` with an
/// accumulated value initialized to `initial` and each element of
/// `self`, in turn, i.e. return
/// `combine(combine(...combine(combine(initial, self[0]),
/// self[1]),...self[count-2]), self[count-1])`.
func reduce<U>(initial: U, combine: (U, T) -> U) -> U

/// Sort `self` in-place according to `isOrderedBefore`.  Requires:
/// `isOrderedBefore` induces a `strict weak ordering
/// <http://en.wikipedia.org/wiki/Strict_weak_order#Strict_weak_orderings>`__
/// over the elements.
mutating func sort(isOrderedBefore: (T, T) -> Bool)

/// Return a copy of `self` that has been sorted according to
/// `isOrderedBefore`.  Requires: `isOrderedBefore` induces a
/// `strict weak ordering
/// <http://en.wikipedia.org/wiki/Strict_weak_order#Strict_weak_orderings>`__
/// over the elements.
func sorted(isOrderedBefore: (T, T) -> Bool) -> [T]

/// Return an `Array` containing the results of calling
/// `transform(x)` on each element `x` of `self`
func map<U>(transform: (T) -> U) -> [U]

/// A Array containing the elements of `self` in reverse order
func reverse() -> [T]

/// Return an `Array` containing the elements `x` of `self` for which
/// `includeElement(x)` is `true`
func filter(includeElement: (T) -> Bool) -> [T]
*/
}

extension ObservableArray: SequenceType {
  
  typealias Generator = IndexingGenerator<Array<AnyObject>>
  
  public func generate() -> IndexingGenerator<Array<AnyObject>> {
    return backingArray.generate()
  }
}