import UIKit

extension UIView {
    func rounded(_ radius: CGFloat = 15) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
