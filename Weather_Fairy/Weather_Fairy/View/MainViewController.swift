import UIKit
import SwiftUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        

        let goToSearchButton = UIButton(type: .system)
        goToSearchButton.setTitle("검색 페이지로 이동", for: .normal)
        goToSearchButton.addTarget(self, action: #selector(goToSearchPage), for: .touchUpInside)
        view.addSubview(goToSearchButton)
        

        goToSearchButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }

    @objc func goToSearchPage() {
        let searchViewController = SearchPageViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
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
