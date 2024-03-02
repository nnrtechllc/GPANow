//
//  ContentView.swift
//  GPANow
//
//  Created by Nikhil Vaddey on 2/10/24.
//

import SwiftUI

struct Grade {
    var name: String
    var grade: String
    var credits: Double
    var notes: String
}

struct Class {
    var name: String
    var gpa: Double
    var credits: Double
    var notes: String
}

struct ContentView: View {
    @State private var classes: [Class] = []
    @State private var currentClassName: String = ""
    @State private var currentGrade: String = "A"
    @State private var currentCredits: String = "0"
    @State private var currentNotes: String = ""
    @State private var selectedTab = 0
    @State private var averageGPA: Double = 0.0
    @State private var weightedAverageGPA: Double = 0.0

    var body: some View {
        VStack {
            if selectedTab == 0 {
                GradeCalculatorView(classes: $classes, currentClassName: $currentClassName, currentGrade: $currentGrade, currentCredits: $currentCredits, currentNotes: $currentNotes, averageGPA: $averageGPA, weightedAverageGPA: $weightedAverageGPA)
            } else if selectedTab == 1 {
                ClassListView(classes: $classes)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                TabButton(title: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                Spacer()
                TabButton(title: "Classes", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                Spacer()
                TabButton(title: "GPA Bud", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }

                
                
                
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
        }
        .background(Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

struct GradeCalculatorView: View {
    @Binding var classes: [Class]
    @Binding var currentClassName: String
    @Binding var currentGrade: String
    @Binding var currentCredits: String
    @Binding var currentNotes: String
    @Binding var averageGPA: Double
    @Binding var weightedAverageGPA: Double

    var body: some View {
        VStack {
            Text("GPA Calculator")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 50)

            Spacer()

            ScrollView {
                VStack {
                    Text("Add Class")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()

                    TextField("Class Name", text: $currentClassName)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)

                    Picker("Grade", selection: $currentGrade) {
                        Text("A").tag("4.0")
                        Text("B").tag("3.0")
                        Text("C").tag("2.0")
                        Text("D").tag("1.0")
                        Text("F").tag("0.0")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)

                    TextField("Credits", text: $currentCredits)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)

                    TextField("Additional Notes", text: $currentNotes)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)

                    Button(action: addClass) {
                        Text("Add Class")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()

                    Text("Classes")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()

                    ForEach(classes.indices, id: \.self) { index in
                        ClassView(classData: classes[index])
                    }

                    Button(action: calculateAverageGPA) {
                        Text("Calculate Average GPA")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    if averageGPA != 0 {
                        Text("Unweighted Average GPA: \(averageGPA, specifier: "%.2f")")
                            .foregroundColor(.white)
                            .padding()
                    }

                    if weightedAverageGPA != 0 {
                        Text("Weighted Average GPA: \(weightedAverageGPA, specifier: "%.2f")")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.2))
    }

    func addClass() {
        guard let credits = Double(currentCredits) else { return }
        let gpa = Double(currentGrade) ?? 0.0
        let newClass = Class(name: currentClassName, gpa: gpa, credits: credits, notes: currentNotes)
        classes.append(newClass)
        currentClassName = ""
        currentGrade = "A"
        currentCredits = "0"
        currentNotes = ""
    }

    func calculateAverageGPA() {
        guard !classes.isEmpty else {
            return
        }
        
        let totalGPA = classes.reduce(0.0) { $0 + $1.gpa }
        let unweightedAverageGPA = totalGPA / Double(classes.count)
        
        let totalCredits = classes.reduce(0.0) { $0 + $1.credits }
        let weightedGPA = classes.reduce(0.0) { $0 + ($1.gpa * ($1.credits / totalCredits)) }
        
        averageGPA = unweightedAverageGPA
        weightedAverageGPA = weightedGPA
    }
}

struct ClassListView: View {
    @Binding var classes: [Class]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(classes.indices, id: \.self) { index in
                    ClassView(classData: classes[index])
                }
            }
            .padding()
        }
    }
}

struct ClassView: View {
    var classData: Class

    var body: some View {
        VStack(alignment: .leading) {
            Text("Class Name: \(classData.name)")
                .foregroundColor(.white)
            Text("GPA: \(classData.gpa, specifier: "%.1f")")
                .foregroundColor(.white)
            Text("Credits: \(classData.credits)")
                .foregroundColor(.white)
            Text("Additional Notes: \(classData.notes)")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue.opacity(0.4))
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}

struct TabButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

