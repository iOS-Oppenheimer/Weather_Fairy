import UIKit

extension UIBarButtonItem {
    // 왼쪽 네비게이션 바 아이템에 'plus' 이미지 설정
    static func presentLocationItemButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(named: "location"), style: .plain, target: target, action: action)
        item.tintColor = .black
        return item
    }

    // 오른쪽 네비게이션 바 아이템에 'menu' 이미지 설정
    static func menuItemButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(named: "grid"), style: .plain, target: target, action: action)
        item.tintColor = .black
        return item
    }
}
