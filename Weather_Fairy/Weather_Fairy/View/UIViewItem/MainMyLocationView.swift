//
//  MainMyLocationView.swift
//  Weather_Fairy
//
//  Created by t2023-m0068 on 2023/09/26.
//

import UIKit

class BottomMyLocationView: UIView {
    let middleView = MiddleView()

    lazy var myLocationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 25
        view.isHidden = true

        return view
    }()
    
    private func setupConstraints() {
        addSubview(myLocationView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            myLocationView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            myLocationView.topAnchor.constraint(equalTo: middleView.buttonOverlayView.bottomAnchor, constant: 50),
            myLocationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            myLocationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            myLocationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

        ])
    }
}
