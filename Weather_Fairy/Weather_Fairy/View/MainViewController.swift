import SwiftUI
import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        
        let presentLocationBarItem = UIBarButtonItem.presentLocationItemButton(target: self, action: #selector(presentLocationTapped))
        navigationItem.leftBarButtonItem = presentLocationBarItem

        let menuBarItem = UIBarButtonItem.menuItemButton(target: self, action: #selector(menuTapped))
        navigationItem.rightBarButtonItem = menuBarItem
    } //: viewDidLoad()
    
// ========================================🔽 navigation Bar Tapped구현==========================================
    @objc func presentLocationTapped(){}
    
    @objc func menuTapped(){}
} //: UIViewController

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

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // You can add update logic here if needed
    }

    typealias UIViewControllerType = UIViewController
}
