//
//  LinkedListTest.swift
//  LinkedListTest
//
//  Created by 강민수 on 2023/01/26.
//

import XCTest
@testable import Calculator

final class LinkedListTest: XCTestCase {
    
    var sut: LinkedList<String>!

    override func setUpWithError() throws {
        sut = LinkedList()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_초기_인스턴스_생성시_isEmpty는_true이다() {
        // then
        XCTAssertTrue(sut.isEmpty)
    }
    
    func test_a의_값을_append하면_isEmpty는_false이다() {
        // given
        let firstValue = "a"
        // when
        sut.append(firstValue)
        // then
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_a의_값을_처음_append한다면_head값은_a이다() {
        // given
        let value = "a"
        let exception = "a"
        // when
        sut.append(value)
        let headValue = sut.head!.value
        // then
        XCTAssertEqual(headValue, exception)
    }
    
    func test_a의_값을_처음_append한다면_tail값은_a이다() {
        // given
        let value = "a"
        let exception = "a"
        // when
        sut.append(value)
        let tailValue = sut.tail!.value
        // then
        XCTAssertEqual(tailValue, exception)
    }
    
    func test_a과_b_두개의_값을_append한다면_head는_a_tail은_b다() {
        // given
        let firstValue = "a"
        let secondValue = "b"
        let headException = "a"
        let tailException = "b"
        // when
        sut.append(firstValue)
        sut.append(secondValue)
        let headValue = sut.head!.value
        let tailValue = sut.tail!.value
        // then
        XCTAssertEqual(headValue, headException)
        XCTAssertEqual(tailValue, tailException)
    }
    
    func test_a와_b_두개의_Node를_가진_LinkedList에서_removeLast를_한다면_반환값은_b이다() {
        // given
        let firstValue = "a"
        let secondValue = "b"
        let exception = "b"
        // when
        sut.append(firstValue)
        sut.append(secondValue)
        let removedValue = sut.removeLast()!
        // then
        XCTAssertEqual(exception, removedValue)
    }
    
    func test_isEmpty가_true인_상태에서_removeLast를_한다면_nil이_반환된다() {
        // given
        // when
        XCTAssertTrue(sut.isEmpty)
        // then
        XCTAssertNil(sut.removeLast())
    }
}
