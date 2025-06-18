//
//  CustomAlertView.swift
//  PhotoSave
//
//  Created by Alex Mac PRO on 20.10.2024.
//

import UIKit

class CustomAlertView: UIView {
    
    @IBOutlet weak var textAlertOutlet: UILabel!
    @IBOutlet weak var frameOutlet: UIView!
    @IBOutlet weak var mainViewOutlet: UIView!
    
    static func instanceFromNib() -> CustomAlertView {
        return UINib(nibName: "CustomAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAlertView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        frameOutlet.rounded(15)
        mainViewOutlet.rounded(15)
    }
    public func showAlert(_ text: String) {
        textAlertOutlet.text = text
    }
    
    @IBAction func okPressedBtn(_ sender: UIButton) {
        self.removeFromSuperview()
     
    }
    
    
}


