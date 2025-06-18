import UIKit

// MARK: - AddPhotoDelegate Protocol

protocol AddPhotoDelegate: AnyObject {
    func updateCollectionView()
}

// MARK: - AddPhotoController

class AddPhotoController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    
    // MARK: - Public Properties
    
    weak var delegate: AddPhotoDelegate?
    
    // MARK: - Private Properties
    
    private var images: [UIImage] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(namePicter: "backgroundPS")
    }
    
    // MARK: - IBActions
    
    @IBAction func choosePhotoBtn(_ sender: UIButton) {
        let imagePickerAlert = UIAlertController(title: "Выберите изображение", message: nil, preferredStyle: .actionSheet)

        // Действие для выбора фото из галереи
        let photoLibraryAction = UIAlertAction(title: "Фотографии", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        imagePickerAlert.addAction(photoLibraryAction)

        // Действие для съемки с камеры (если доступна)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }
            imagePickerAlert.addAction(cameraAction)
        }

        // Действие отмены
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        imagePickerAlert.addAction(cancelAction)

        // Настройка для iPad
        if let popoverController = imagePickerAlert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
        }

        present(imagePickerAlert, animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePhotoBtn(_ sender: UIButton) {
        guard let image = imageViewOutlet.image else { return }
        
        images.append(image)
        
        let note = noteTextField.text ?? ""
        let like = false
        let photoSaveObject = PhotoSaveClass(images: images, note: note, like: like)
        
        saveImages(photoSaveObject)
        
        delegate?.updateCollectionView()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Persistence
    
    /// Сохраняет объект с фото и заметкой в UserDefaults.
    private func saveImages(_ photoSaveClass: PhotoSaveClass) {
        do {
            var savedPhotoClasses: [PhotoSaveClass] = []
            
            // Загружаем существующие данные, если они есть
            if let data = UserDefaults.standard.data(forKey: "savedImages") {
                savedPhotoClasses = try JSONDecoder().decode([PhotoSaveClass].self, from: data)
            }
            
            // Добавляем новый объект и сохраняем обновленный массив
            savedPhotoClasses.append(photoSaveClass)
            let newData = try JSONEncoder().encode(savedPhotoClasses)
            UserDefaults.standard.set(newData, forKey: "savedImages")
            
        } catch {
            print("Ошибка сохранения изображения: \(error)")
        }
    }
    
    // MARK: - Private Helpers
    
    /// Отображает UIImagePickerController с заданным источником.
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AddPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            chosenImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            chosenImage = originalImage
        }
        
        imageViewOutlet.image = chosenImage
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddPhotoController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    private func hideKeyboard() {
        noteTextField.resignFirstResponder()
    }
}
