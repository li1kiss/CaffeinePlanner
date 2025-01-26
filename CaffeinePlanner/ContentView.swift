//
//  ContentView.swift
//  CaffeinePlanner
//
//  Created by Mykhailo Kravchuk on 23/01/2025.
//

import SwiftUI

struct ContentView: View {
    // Вхідні дані
    @State private var age: Double = 25.0           // Вік у роках
    @State private var gender: Int = 1             // 0 = Жіночий, 1 = Чоловічий
    @State private var weight: Double = 70.0       // Вага у кілограмах
    @State private var activity: Int = 2           // Рівень активності (0, 1, 2)
    @State private var sleepHours: Double = 8.0    // Години сну

    // Результат прогнозу
    @State private var recommendedCoffee: Double?

    var body: some View {
        VStack(spacing: 20) {
            Text("Рекомендація кави")
                .font(.title)
                .padding()

            // Поле для введення віку
            VStack {
                Text("Вік: \(String(format: "%.0f", age)) років")
                Slider(value: $age, in: 18.0...100.0, step: 1.0)
            }

            // Вибір статі
            Picker("Стать", selection: $gender) {
                Text("Жіночий").tag(0)
                Text("Чоловічий").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            // Поле для введення ваги
            VStack {
                Text("Вага: \(String(format: "%.0f", weight)) кг")
                Slider(value: $weight, in: 40.0...150.0, step: 1.0)
            }

            // Вибір активності
            Picker("Рівень активності", selection: $activity) {
                Text("Низький").tag(0)
                Text("Середній").tag(1)
                Text("Високий").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())

            // Поле для введення годин сну
            VStack {
                Text("Години сну: \(String(format: "%.1f", sleepHours))")
                Slider(value: $sleepHours, in: 0...12, step: 1)
            }

            // Кнопка для виконання прогнозу
            Button(action: {
                recommendedCoffee = ModelManager.shared.predict(
                       age: age,
                       gender: Double(gender),
                       weight: weight,
                       activity: Double(activity),
                       sleepHours: sleepHours
                   )
            }) {
                Text("Розрахувати")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // Відображення результату
            if let coffee = recommendedCoffee {
                Text("Рекомендована кількість кави: \(String(format: "%.2f", coffee)) грамів")
                    .font(.headline)
                    .padding()
            } else {
                Text("Введіть дані та натисніть 'Розрахувати'")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    // Метод для обчислення рекомендованої кількості кави
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
