import SwiftUI

struct ContentView: View {
    // MARK: - Dane wejściowe użytkownika
    @State private var age: String = ""
    @State private var selectedGender: String = "Kobieta"
    @State private var weight: String = ""
    @State private var height: String = ""
    
    @State private var selectedActivityLevelIndex: Int = 0
    let activityLevels = ["Niski", "Średni", "Wysoki"]
    
    @State private var sleepHours: String = ""
    @State private var cupsPerDay: String = ""
    
    @State private var selectedSensitivityIndex: Int = 1
    let sensitivityLevels = ["Niska", "Średnia", "Wysoka"]
    
    @State private var doctorRecommendation: Bool = false
    
    @State private var selectedCoffeeTypes: Set<String> = []
    let coffeeTypeOptions = ["Latte", "Espresso", "Americano", "Black Coffee", "Cappuccino"]
    
    @State private var selectedMedicalConditions: Set<String> = []
    let medicalConditionOptions = ["None", "Hypertension", "Diabetes", "Anxiety", "Pregnancy"]
    
    @State private var selectedCoffeeGoals: Set<String> = []
    let coffeeGoalOptions = ["Energy", "Taste"]
    
    @State private var selectedTimeOfDay: Set<String> = []
    let timeOfDayOptions = ["Morning", "Afternoon", "Evening", "Night"]
    
    // Wynik prognozy
    @State private var predictionResult: Double?
    @State private var showAlert: Bool = false
        @State private var alertTitle: String = ""
        @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Wprowadź swoje dane:")
                        .font(.headline)
                    
                    Group {
                        // Wiek
                        TextField("Wiek (18–75)", text: $age)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Płeć
                        Picker("Płeć", selection: $selectedGender) {
                            Text("Kobieta").tag("Kobieta")
                            Text("Mężczyzna").tag("Mężczyzna")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        // Waga
                        TextField("Waga (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Wzrost
                        TextField("Wzrost (cm)", text: $height)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        VStack(alignment: .leading) {
                            Text("Poziom aktywności")
                            Picker("", selection: $selectedActivityLevelIndex) {
                                ForEach(0..<activityLevels.count, id: \.self) { index in
                                    Text(activityLevels[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        
                        TextField("Godziny snu (3.0–9.0)", text: $sleepHours)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        TextField("Filiżanek kawy na dzień (0–5)", text: $cupsPerDay)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        
                        VStack(alignment: .leading) {
                            Text("Wrażliwość na kofeinę")
                            Picker("", selection: $selectedSensitivityIndex) {
                                ForEach(0..<sensitivityLevels.count, id: \.self) { index in
                                    Text(sensitivityLevels[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        
                        Toggle("Czy masz zalecenie lekarza?", isOn: $doctorRecommendation)
                    }
                    
                    Divider()
                    
                   
                    VStack(alignment: .leading) {
                        Text("Typ kawy:").font(.headline)
                        ForEach(coffeeTypeOptions, id: \.self) { type in
                            MultipleSelectionRow(title: type,
                                                 isSelected: selectedCoffeeTypes.contains(type)) {
                                if selectedCoffeeTypes.contains(type) {
                                    selectedCoffeeTypes.remove(type)
                                } else {
                                    selectedCoffeeTypes.insert(type)
                                }
                            }
                        }
                    }
                    
                   
                    VStack(alignment: .leading) {
                        Text("Stany medyczne:").font(.headline)
                        ForEach(medicalConditionOptions, id: \.self) { condition in
                            MultipleSelectionRow(title: condition,
                                                 isSelected: selectedMedicalConditions.contains(condition)) {
                                if selectedMedicalConditions.contains(condition) {
                                    selectedMedicalConditions.remove(condition)
                                } else {
                                    selectedMedicalConditions.insert(condition)
                                }
                            }
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Cele kawy:").font(.headline)
                        ForEach(coffeeGoalOptions, id: \.self) { goal in
                            MultipleSelectionRow(title: goal,
                                                 isSelected: selectedCoffeeGoals.contains(goal)) {
                                if selectedCoffeeGoals.contains(goal) {
                                    selectedCoffeeGoals.remove(goal)
                                } else {
                                    selectedCoffeeGoals.insert(goal)
                                }
                            }
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Czas dnia:").font(.headline)
                        ForEach(timeOfDayOptions, id: \.self) { time in
                            MultipleSelectionRow(title: time,
                                                 isSelected: selectedTimeOfDay.contains(time)) {
                                if selectedTimeOfDay.contains(time) {
                                    selectedTimeOfDay.remove(time)
                                } else {
                                    selectedTimeOfDay.insert(time)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    
                    Button(action: {
                        performPrediction()
                    }) {
                        Text("Prognozuj")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    
                    if let result = predictionResult {
                        Text("Zalecona ilość kawy: \(String(format: "%.1f", result)) mg")
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding()
                .alert(isPresented: $showAlert) {
                                    Alert(title: Text(alertTitle),
                                          message: Text(alertMessage),
                                          dismissButton: .default(Text("OK")))
                                }
            }
            .navigationTitle("Caffeine Predictor")
        }
    }
    
    
    func performPrediction() {
    
        guard let ageValue = Double(age),
              let weightValue = Double(weight),
              let heightValue = Double(height),
              let sleepHoursValue = Double(sleepHours),
              let cupsPerDayValue = Double(cupsPerDay)
        else {
            predictionResult = nil
            return
        }
        
        
        let genderValue: Double = (selectedGender == "Mężczyzna") ? 1.0 : 0.0
        let activityLevelValue = Double(selectedActivityLevelIndex)
        let caffeineSensitivityValue = Double(selectedSensitivityIndex)
        let doctorValue = doctorRecommendation ? 1.0 : 0.0
        
        let coffeeTypeLatte = selectedCoffeeTypes.contains("Latte") ? 1.0 : 0.0
        let coffeeTypeEspresso = selectedCoffeeTypes.contains("Espresso") ? 1.0 : 0.0
        let coffeeTypeAmericano = selectedCoffeeTypes.contains("Americano") ? 1.0 : 0.0
        let coffeeTypeBlackCoffee = selectedCoffeeTypes.contains("Black Coffee") ? 1.0 : 0.0
        let coffeeTypeCappuccino = selectedCoffeeTypes.contains("Cappuccino") ? 1.0 : 0.0
        
        let medicalNone = selectedMedicalConditions.contains("None") ? 1.0 : 0.0
        let medicalHypertension = selectedMedicalConditions.contains("Hypertension") ? 1.0 : 0.0
        let medicalDiabetes = selectedMedicalConditions.contains("Diabetes") ? 1.0 : 0.0
        let medicalAnxiety = selectedMedicalConditions.contains("Anxiety") ? 1.0 : 0.0
        let medicalPregnancy = selectedMedicalConditions.contains("Pregnancy") ? 1.0 : 0.0
        
        let coffeeGoalEnergy = selectedCoffeeGoals.contains("Energy") ? 1.0 : 0.0
        let coffeeGoalTaste = selectedCoffeeGoals.contains("Taste") ? 1.0 : 0.0
        
        let timeOfDayMorning = selectedTimeOfDay.contains("Morning") ? 1.0 : 0.0
        let timeOfDayAfternoon = selectedTimeOfDay.contains("Afternoon") ? 1.0 : 0.0
        let timeOfDayEvening = selectedTimeOfDay.contains("Evening") ? 1.0 : 0.0
        let timeOfDayNight = selectedTimeOfDay.contains("Night") ? 1.0 : 0.0
        
        let prediction = ModelManager.shared.predict(
            age: ageValue,
            gender: genderValue,
            weight: weightValue,
            height: heightValue,
            activityLevel: activityLevelValue,
            sleepHours: sleepHoursValue,
            cupsPerDay: cupsPerDayValue,
            caffeineSensitivity: caffeineSensitivityValue,
            doctorRecommendation: doctorValue,
            
            coffeeTypeLatte: coffeeTypeLatte,
            coffeeTypeEspresso: coffeeTypeEspresso,
            coffeeTypeAmericano: coffeeTypeAmericano,
            coffeeTypeBlackCoffee: coffeeTypeBlackCoffee,
            coffeeTypeCappuccino: coffeeTypeCappuccino,
            
            medicalNone: medicalNone,
            medicalHypertension: medicalHypertension,
            medicalDiabetes: medicalDiabetes,
            medicalAnxiety: medicalAnxiety,
            medicalPregnancy: medicalPregnancy,
            
            coffeeGoalEnergy: coffeeGoalEnergy,
            coffeeGoalTaste: coffeeGoalTaste,
            
            timeOfDayMorning: timeOfDayMorning,
            timeOfDayAfternoon: timeOfDayAfternoon,
            timeOfDayEvening: timeOfDayEvening,
            timeOfDayNight: timeOfDayNight
            
        )
        if let result = prediction {
                        predictionResult = result
                        // Ustawiamy alert z wynikiem prognozy oraz zaostrzeniem
                        alertTitle = "Prognoza zakończona"
                        alertMessage = """
                        Zalecona ilość kawy: \(String(format: "%.1f", result)) mg
                        
                        Pamiętaj, że są to jedynie ogólne zalecenia. Każda osoba jest inna, dlatego przed wprowadzeniem zmian w diecie skonsultuj się z lekarzem.
                        """
                        showAlert = true
                    } else {
                        // Ustawiamy alert w przypadku błędu prognozy
                        alertTitle = "Błąd prognozy"
                        alertMessage = "Nie udało się wykonać prognozy. Spróbuj ponownie."
                        showAlert = true
                        predictionResult = nil
                    }
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
