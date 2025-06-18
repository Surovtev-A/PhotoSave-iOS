import Foundation
import UIKit

extension UIViewController {
    func setBackgroundImage(namePicter:String)
    {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: namePicter)
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
}




