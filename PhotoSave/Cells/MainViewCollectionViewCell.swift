//
//  MainViewCollectionViewCell.swift
//  PhotoSave
//
//  Created by Alex Mac PRO on 06.11.2024.
//

import UIKit

protocol MainViewCollectionViewCellDelegate: AnyObject {
    func didTapImageView(_ indexPath: IndexPath)
}
class MainViewCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    
    weak var delegate: MainViewCollectionViewCellDelegate?
    @IBOutlet weak var indexCollectionViewOutlet: UIView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        indexCollectionViewOutlet.addGestureRecognizer(recognizer)
    }
    
    func configure(with image: UIImage) {
        imageViewOutlet.image = image
    }
    
    func addShadowToImageView(_ uiView: UIView) {
        // Настройка тени
        uiView.layer.shadowColor = UIColor.black.cgColor   // Цвет тени
        uiView.layer.shadowOpacity = 0.5                   // Прозрачность тени (0 — полностью прозрачная, 1 — полностью непрозрачная)
        uiView.layer.shadowOffset = CGSize(width: 2, height: 2) // Смещение тени (по X и Y)
        uiView.layer.shadowRadius = 5                      // Радиус размытия тени
        uiView.layer.masksToBounds = false                 // Отключаем обрезание тени
    }
    
    func addShadow(){
        indexCollectionViewOutlet.layer.cornerRadius = 0
            indexCollectionViewOutlet.clipsToBounds = false // Не обрезаем границы контейнера
            
            // Добавляем тень к контейнеру
            addShadowToImageView(indexCollectionViewOutlet)
            
            // Настройки для UIImageView
            imageViewOutlet.clipsToBounds = true // Обрезаем изображение по границам
            imageViewOutlet.contentMode = .scaleAspectFit
           
    }
    
    @IBAction func tapGestureRecognizer(){
        guard let indexPath = indexPath else { return }
        delegate?.didTapImageView(indexPath)
    }
}
