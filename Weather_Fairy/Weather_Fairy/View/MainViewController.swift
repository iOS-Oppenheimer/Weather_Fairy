import UIKit
import SwiftUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }


   

}

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
