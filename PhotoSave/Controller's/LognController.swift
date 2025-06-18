import UIKit

class LognController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var loginBtnOutlet: UIImageView!
    @IBOutlet weak var passTextFieldOutlet: UITextField!
    
    // MARK: - Private Properties
    
    private var passApp = ""
    private var isRegistred = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupUI()
        setupGestures()
        
        isRegistred = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if !isRegistred {
            navigateToRegistration()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Обновляем пароль из UserDefaults каждый раз, когда экран появляется
        passApp = UserDefaults.standard.string(forKey: "password") ?? ""
    }
    
    deinit {
        // Отписываемся от уведомлений, чтобы избежать утечек памяти
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions & Selectors
    
    @IBAction func enterPassword() {
        guard let passTextField = passTextFieldOutlet.text else { return }
        
        if passTextField == passApp {
            navigateToMainScreen()
        } else {
            // Отправляем уведомление о неверном пароле
            NotificationCenter.default.post(name: .incorectPasswordNotification, object: nil)
        }
    }
    
    @objc private func showXIBAlert() {
        let customAlertView = CustomAlertView.instanceFromNib()
        customAlertView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 150)
        customAlertView.center = view.center
        customAlertView.showAlert("You have entered an incorrect password!")
        view.addSubview(customAlertView)
    }
    
    // MARK: - Private Setup
    
    private func setupUI() {
        // Предполагается, что setBackgroundImage - это ваш метод-расширение
        setBackgroundImage(namePicter: "backgroundPS")
        passTextFieldOutlet.backgroundColor = .clear
    }
    
    private func setupGestures() {
        let enterPasswordRecognizer = UITapGestureRecognizer(target: self, action: #selector(enterPassword))
        loginBtnOutlet.addGestureRecognizer(enterPasswordRecognizer)
        loginBtnOutlet.isUserInteractionEnabled = true // UIImageView по умолчанию не кликабельны
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showXIBAlert),
            name: .incorectPasswordNotification,
            object: nil
        )
    }
    
    // MARK: - Navigation
    
    private func navigateToMainScreen() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func navigateToRegistration() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Registration") as? Registration else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LognController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    private func hideKeyboard() {
        passTextFieldOutlet.resignFirstResponder()
    }
}
