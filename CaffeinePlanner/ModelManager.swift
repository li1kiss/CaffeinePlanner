import Foundation
import CoreML

class ModelManager {
    static let shared = ModelManager()
    
    private var model: LinearRegression
    
    private init() {
        guard let loadedModel = try? LinearRegression(configuration: MLModelConfiguration()) else {
            fatalError("Nie udało się załadować modelu LinearRegression")
        }
        self.model = loadedModel
    }

    func predict(
        age: Double,
        gender: Double,
        weight: Double,
        height: Double,
        activityLevel: Double,
        sleepHours: Double,
        cupsPerDay: Double,
        caffeineSensitivity: Double,
        doctorRecommendation: Double,
        coffeeTypeLatte: Double,
        coffeeTypeEspresso: Double,
        coffeeTypeAmericano: Double,
        coffeeTypeBlackCoffee: Double,
        coffeeTypeCappuccino: Double,
        medicalNone: Double,
        medicalHypertension: Double,
        medicalDiabetes: Double,
        medicalAnxiety: Double,
        medicalPregnancy: Double,
        coffeeGoalEnergy: Double,
        coffeeGoalTaste: Double,
        timeOfDayMorning: Double,
        timeOfDayAfternoon: Double,
        timeOfDayEvening: Double,
        timeOfDayNight: Double
    ) -> Double? {
        do {
            let input = try LinearRegressionInput(
                age: age,
                gender: gender,
                weight: weight,
                height: height,
                activity_level: activityLevel,
                sleep_hours: sleepHours,
                cups_per_day: cupsPerDay,
                caffeine_sensitivity: caffeineSensitivity,
                doctor_recommendation: doctorRecommendation,
                
                coffee_type_Latte: coffeeTypeLatte,
                coffee_type_Espresso: coffeeTypeEspresso,
                coffee_type_Americano: coffeeTypeAmericano,
                coffee_type_BlackCoffee: coffeeTypeBlackCoffee,
                coffee_type_Cappuccino: coffeeTypeCappuccino,
                
                medical_None: medicalNone,
                medical_Hypertension: medicalHypertension,
                medical_Diabetes: medicalDiabetes,
                medical_Anxiety: medicalAnxiety,
                medical_Pregnancy: medicalPregnancy,
                
                coffee_goal_Energy: coffeeGoalEnergy,
                coffee_goal_Taste: coffeeGoalTaste,
                
                time_of_day_Morning: timeOfDayMorning,
                time_of_day_Afternoon: timeOfDayAfternoon,
                time_of_day_Evening: timeOfDayEvening,
                time_of_day_Night: timeOfDayNight
            )
            
            // Wykonujemy prognozę
            let output = try model.prediction(input: input)
            return output.prediction
            
        } catch {
            print("Błąd podczas tworzenia prognozy: \(error)")
            return nil
        }
    }
}
