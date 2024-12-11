//
//  Extensions.swift
//  MovieApp
//
//  Created by User on 21.08.2024.
//

import UIKit

extension UIViewController {
    func configureNavBarForUpcomingAndSearch() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Настройка внешнего вида UINavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black // Черный фон для навигационной панели
           
           // Устанавливаем белый цвет для текста заголовка
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           
           // Устанавливаем белый цвет для текста большого заголовка
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           
           // Применение настроек ко всем состояниям UINavigationBar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

           // Цвет для элементов навигационной панели (например, кнопок)
        navigationController?.navigationBar.tintColor = .white
    }
}
