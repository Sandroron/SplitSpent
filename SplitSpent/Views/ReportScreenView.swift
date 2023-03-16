//
//  ReportScreenView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 16.03.2023.
//

import SwiftUI
import Charts

struct ReportScreenView: View {
    
    @EnvironmentObject var groupListViewModel: GroupViewModel
    
    @State var userExpenses: [UserExpense] = []
    
    var body: some View {
        
        ScrollView {
            VStack {
                Chart(userExpenses) { userExpense in
                    BarMark(
                        x: .value("Paid", userExpense.paid),
                        y: .value("Email", userExpense.email))
                    .foregroundStyle(.blue)
                    .annotation(position: .overlay, alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.2f", userExpense.paid))
                            .font(.footnote)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .clipped()
                    }
                    BarMark(
                        x: .value("Owes", userExpense.owes),
                        y: .value("Email", userExpense.email))
                    .foregroundStyle(.pink)
                    .annotation(position: .overlay, alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.2f", userExpense.owes))
                            .font(.footnote)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .clipped()
                    }
                }
                .frame(height: CGFloat(userExpenses.count) * 100)
                .chartForegroundStyleScale([
                    "Paid" : Color(uiColor: .systemBlue),
                    "Owes": Color(uiColor: .systemPink)
                ])
            }
            .padding()
        }
        
        .onAppear(perform: {
            userExpenses = groupListViewModel.calculateUserOwes()
        })
    }
}
