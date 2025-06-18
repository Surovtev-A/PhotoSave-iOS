//
//  MainViewController.swift
//  PhotoSave
//
//  Created by Alex Mac PRO on 20.10.2024.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var exitBtnOutlet: UIImageView!
    @IBOutlet weak var keyBtnOutlet: UIImageView!
    @IBOutlet weak var addPhotoBtnOutlet: UIImageView!
    @IBOutlet weak var viewPhotoBtnOutlet: UIImageView!
    
    // MARK: - Private Properties
    
    private var savedPhotoClasses: [PhotoSaveClass] = []
    private var images: [UIImage] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Одноразовая настройка при загрузке view
        setupUI()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    // MARK: - Private Setup
    
    private func setupUI() {
        // Предполагается, что setBackgroundImage - это ваш метод-расширение
        setBackgroundImage(namePicter: "backgroundPS")
    }
    
    private func setupGestures() {
        // Добавляем обработчики нажатий на UIImageView
        addTapGesture(to: addPhotoBtnOutlet, with: #selector(addPhotoBtnTapped))
        addTapGesture(to: viewPhotoBtnOutlet, with: #selector(viewPhotoBtnTapped))
        addTapGesture(to: exitBtnOutlet, with: #selector(exitBtnTapped))
        addTapGesture(to: keyBtnOutlet, with: #selector(keyBtnTapped))
    }
    
    /// Вспомогательный метод для добавления UIGestureRecognizer
    private func addTapGesture(to imageView: UIImageView, with selector: Selector) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: selector)
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true // Важно для UIImageView
    }
    
    // MARK: - Actions & Selectors
    
    @objc private func exitBtnTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func keyBtnTapped() {
        navigateTo(controllerID: "Registration")
    }
    
    @objc private func addPhotoBtnTapped() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPhotoController") as? AddPhotoController else { return }
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func viewPhotoBtnTapped() {
        navigateTo(controllerID: "ViewPhotoController")
    }

    // MARK: - Data Handling
    
    private func reloadData() {
        loadImagesFromUserDefaults()
        extractImagesForDisplay()
        collectionViewOutlet.reloadData()
    }
    
    private func loadImagesFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "savedImages") else {
            print("Нет данных в UserDefaults по ключу 'savedImages'")
            savedPhotoClasses = [] // Очищаем массив, если данных нет
            return
        }
        
        do {
            savedPhotoClasses = try JSONDecoder().decode([PhotoSaveClass].self, from: data)
            print("Загружено \(savedPhotoClasses.count) наборов фотографий")
        } catch {
            print("Ошибка декодирования сохраненных изображений: \(error)")
            savedPhotoClasses = [] // Очищаем массив в случае ошибки
        }
    }
    
    private func extractImagesForDisplay() {
        // flatMap элегантно извлекает все изображения из всех наборов в один массив
        self.images = savedPhotoClasses.flatMap { $0.getImages() }
    }
    
    // MARK: - Navigation
    
    private func navigateTo(controllerID: String) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerID)
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCollectionViewCell", for: indexPath) as? MainViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        cell.addShadow()
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionViewOutlet.frame.size.width - 15) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

// MARK: - Custom Delegates

extension MainViewController: AddPhotoDelegate, MainViewCollectionViewCellDelegate {
    
    func updateCollectionView() {
        // Этот метод вызывается делегатом после добавления нового фото
        reloadData()
    }
    
    func didTapImageView(_ indexPath: IndexPath) {
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "ViewPhotoController") as! ViewPhotoController
        detailVC.currentSetIndex = indexPath.item
        detailVC.images = images
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
