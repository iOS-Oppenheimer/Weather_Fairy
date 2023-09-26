//
//  MainWeatherForecastView.swift
//  Weather_Fairy
//
//  Created by t2023-m0068 on 2023/09/26.
//

import UIKit

class BottomWeatherForecastView: UIView {
    let middleView = MiddleView()

    lazy var weatherForecastView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 9
        view.isHidden = true

        return view
    }()

    private func setupConstraints() {
        addSubview(weatherForecastView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            weatherForecastView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            weatherForecastView.topAnchor.constraint(equalTo: middleView.buttonOverlayView.bottomAnchor, constant: 50),
            weatherForecastView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            weatherForecastView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            weatherForecastView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

        ])
    }
}
