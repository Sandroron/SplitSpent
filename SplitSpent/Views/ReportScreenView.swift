//
//  ReportScreenView.swift
//  SplitSpent
//

import SwiftUI
import Charts

struct ReportScreenView: View {
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State var userExpenses: [UserExpense] = []
    
    var body: some View {
            
        Form {
            Section("Chart") {
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
            
            Section(header: Text("Owes relation"), footer: Text("Note: Mutual owes have already been calculated and not being displayed")) {
                
                ForEach(userExpenses) { userExpense in
                    
                    ForEach(userExpense.owesTo.sorted(by: >), id: \.key) { owesToKey, owesToValue in
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userExpense.email) ")
                            Text("owes \(String(format: "%.2f", owesToValue)) \(groupViewModel.group.currencyBase ?? "") to")
                                .foregroundColor(Color(uiColor: .systemPink))
                            Text("\(owesToKey)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Report")
        .background(Color(uiColor: .secondarySystemBackground))
        .onAppear(perform: {
            userExpenses = UserOwesCalculator.calculate(for: groupViewModel.users, with: groupViewModel.transactions)
        })
    }
}
