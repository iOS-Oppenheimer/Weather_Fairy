import SnapKit
import SwiftUI
import UIKit

class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // NavigationBarButton 구현
        let presentLocationBarItem = UIBarButtonItem.presentLocationItemButton(target: self, action: #selector(presentLocationTapped))
        let menuBarItem = UIBarButtonItem.menuItemButton(target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = presentLocationBarItem
        navigationItem.rightBarButtonItem = menuBarItem

        // MapKit 띄우기
        let locationView = MyLocationUIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        view.addSubview(locationView)
    } //: viewDidLoad()

    // ========================================🔽 navigation Bar Tapped구현==========================================
    @objc func presentLocationTapped() {}

    @objc func menuTapped() {}
} //: UIViewController


// MainViewController Preview
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainVCRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mainViewController = MainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    typealias UIViewControllerType = UIViewController
}
