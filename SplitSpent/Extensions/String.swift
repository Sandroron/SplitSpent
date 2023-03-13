//
//  String.swift
//  SplitSpent
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
