import UIKit

class ViewPhotoController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    @IBOutlet weak var uiImageViewOutlet: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var viewFromRecognizeOutlet: UIView!
    @IBOutlet weak var likeBtnOutlet: UIButton!
    
    // MARK: - Public Properties

    var images: [UIImage] = []
    var currentSetIndex = 0
    
    // MARK: - Private Properties
    
    private var savedPhotoClasses: [PhotoSaveClass] = []
    private var note: String = ""
    private var index = 0 // Индекс текущего изображения в наборе
    private var firstImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()
        setupUI()
        setupGestures()
        
        // Отображаем первый набор фото и заметок при запуске
        displayCurrentSet()
    }
    
    // MARK: - IBActions
    
    @IBAction func deleteImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Удалить изображение", message: "Вы уверены, что хотите удалить это изображение?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.deleteImagefunc()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @IBAction func likeBtnPressd(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // Обновляем статус like для текущего набора
        savedPhotoClasses[currentSetIndex].like = sender.isSelected
        print("Like status for current set: \(sender.isSelected)")
        
        // Сохраняем изменения
        saveImages()
    }
    
    @IBAction func backbtnPressd(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Gesture Handlers
    
    @objc private func leftswapImages() {
        if currentSetIndex < savedPhotoClasses.count - 1 {
            currentSetIndex += 1 // Переход к следующему набору
        } else {
            currentSetIndex = 0 // Возвращаемся к первому набору
        }
        index = 0 // Сбрасываем индекс изображений для нового набора
        displayCurrentSet()
    }
    
    @objc private func rightswapImages() {
        if currentSetIndex > 0 {
            currentSetIndex -= 1 // Переход к предыдущему набору
        } else {
            currentSetIndex = savedPhotoClasses.count - 1 // К последнему набору
        }
        index = 0 // Сбрасываем индекс изображений
        displayCurrentSet()
    }
    
    // MARK: - Core Logic
    
    private func displayCurrentSet() {
        guard !savedPhotoClasses.isEmpty, savedPhotoClasses.indices.contains(currentSetIndex) else {
            print("Нет доступных наборов для отображения или индекс вне диапазона.")
            // Очищаем UI, если нет данных
            uiImageViewOutlet.image = nil
            noteTextField.text = ""
            likeBtnOutlet.isSelected = false
            return
        }
        
        let currentSet = savedPhotoClasses[currentSetIndex]
        self.images = currentSet.getImages()
        self.note = currentSet.note
        self.likeBtnOutlet.isSelected = currentSet.like
        
        // Отображаем первое изображение и заметку
        self.uiImageViewOutlet.image = images.first
        self.noteTextField.text = note
    }
    
    private func deleteImagefunc() {
        guard !savedPhotoClasses.isEmpty, !images.isEmpty else {
            print("Нет фотографий для удаления.")
            return
        }
        
        // Удаляем текущее изображение из локального массива
        images.remove(at: index)
        
        // Обновляем массив изображений в основном хранилище
        savedPhotoClasses[currentSetIndex].images = images.compactMap { $0.pngData() }
        
        // Если в наборе не осталось изображений, удаляем весь набор
        if images.isEmpty {
            savedPhotoClasses.remove(at: currentSetIndex)
            // Корректируем индекс, чтобы не выйти за пределы массива
            if currentSetIndex >= savedPhotoClasses.count && !savedPhotoClasses.isEmpty {
                currentSetIndex = savedPhotoClasses.count - 1
            }
        }
        
        // Сохраняем изменения в UserDefaults
        saveUpdatedPhotos()
        
        // Обновляем интерфейс
        displayCurrentSet()
    }
    
    // MARK: - Data Persistence
    
    private func loadImages() {
        guard let data = UserDefaults.standard.data(forKey: "savedImages") else {
            print("No data found in UserDefaults for key 'savedImages'")
            return
        }
        
        do {
            savedPhotoClasses = try JSONDecoder().decode([PhotoSaveClass].self, from: data)
            print("Loaded \(savedPhotoClasses.count) photo sets")
        } catch {
            print("Error decoding saved images: \(error)")
        }
    }
    
    private func saveImages() {
        do {
            let newData = try JSONEncoder().encode(savedPhotoClasses)
            UserDefaults.standard.set(newData, forKey: "savedImages")
            print("Images and like status saved")
        } catch {
            print("Error saving images: \(error)")
        }
    }
    
    private func saveUpdatedPhotos() {
        do {
            let data = try JSONEncoder().encode(savedPhotoClasses)
            UserDefaults.standard.set(data, forKey: "savedImages")
            print("Updated photo sets saved.")
        } catch {
            print("Error saving updated photos: \(error)")
        }
    }
    
    /// Отладочный метод для полной очистки хранилища
    private func clearAllSavedPhotos() {
        UserDefaults.standard.removeObject(forKey: "savedImages")
        print("All saved photo sets have been deleted.")
    }

    // MARK: - UI Setup
    
    private func setupUI() {
        addShadowToButton(likeBtnOutlet)
        addShadowToButton(deleteBtnOutlet)
        addShadowToImageView(uiImageViewOutlet)
    }
    
    private func setupGestures() {
        let leftSwapRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftswapImages))
        leftSwapRecognizer.direction = .left
        viewFromRecognizeOutlet.addGestureRecognizer(leftSwapRecognizer)

        let rightSwapRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightswapImages))
        rightSwapRecognizer.direction = .right
        viewFromRecognizeOutlet.addGestureRecognizer(rightSwapRecognizer)
    }
    
    private func addShadowToButton(_ button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
    }
    
    private func addShadowToImageView(_ uiImageView: UIImageView) {
        uiImageView.layer.shadowColor = UIColor.black.cgColor
        uiImageView.layer.shadowOpacity = 0.5
        uiImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        uiImageView.layer.shadowRadius = 5
        uiImageView.layer.masksToBounds = false
    }
}

// MARK: - UITextFieldDelegate

extension ViewPhotoController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    private func hideKeyboard() {
        noteTextField.resignFirstResponder()
    }
}
