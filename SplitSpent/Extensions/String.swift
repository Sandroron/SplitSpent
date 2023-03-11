//
//  String.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 09.03.2023.
//

extension String {
    func generateStringSequence() -> [String] {
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        return sequences
    }
}
