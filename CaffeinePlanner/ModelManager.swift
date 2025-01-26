//
//  ModelManager.swift
//  CaffeinePlanner
//
//  Created by Mykhailo Kravchuk on 24/01/2025.
//

import Foundation
import CoreML

class ModelManager {
    static let shared = ModelManager()

    private let model: RandomForest

    private init() {
        guard let loadedModel = try? RandomForest(configuration: MLModelConfiguration()) else {
            fatalError("Не вдалося завантажити модель RandomForest.mlmodel")
        }
        self.model = loadedModel
    }

    func predict(age: Double, gender: Double, weight: Double, activity: Double, sleepHours: Double) -> Double? {
        do {
            // Нормалізація годин сну
            let normalizedSleepHours = sleepHours / 12.0

            // Нормалізація віку
            let normalizedAge = (age - 16.0) / (140.0 - 16.0)

            // Нормалізація ваги
            let normalizedWeight = (weight - 16.0) / (140.0 - 16.0)

            // Передаємо нормалізовані вхідні дані у модель
            let input = RandomForestInput(
                age: normalizedAge,
                gender: gender,
                weight: normalizedWeight,
                activity: activity,
                sleep_hours: normalizedSleepHours
            )

            // Отримуємо прогноз
            let prediction = try model.prediction(input: input)
            return prediction.prediction
        } catch {
            print("Помилка прогнозу: \(error.localizedDescription)")
            return nil
        }
    }
}

