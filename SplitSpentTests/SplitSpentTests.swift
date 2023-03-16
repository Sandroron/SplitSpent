//
//  SplitSpentTests.swift
//  SplitSpentTests
//

import XCTest
import SplitSpent

final class SplitSpentTests: XCTestCase {

    func testExampleFromDevChallenge() throws {
        // User A paid in a cafe for 30$ for himself and B and C users. Users B part is 5$, user’s C part is 15$. User A opens the application, and adds their expense (30$), with information about each user’s parts.
        
        let users: Set<String> = ["A", "B", "C"]
        
        let transactions: Set<Transaction> = [Transaction(id: "qwerty",
                                                          expenses: ["A": 30.0,
                                                                     "B": -5.0,
                                                                     "C": -15.0])]
        
        let userExpenses = UserOwesCalculator.calculate(for: users, with: transactions)
        
        for userExpense in userExpenses {
            
            if userExpense.email == "B" {
                
                XCTAssertEqual( userExpense.owesTo["A"], 5)
            }
            
            if userExpense.email == "C" {
                
                XCTAssertEqual( userExpense.owesTo["A"], 15)
            }
        }
    }
}
