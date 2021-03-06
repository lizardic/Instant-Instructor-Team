//
//  LoginController.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/22/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    /** This represents the logo of the app on the login page
    */
    private let appNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 30)
        lb.text = "Instant Instructor"
        lb.textColor = UIColor(white: 1, alpha: 1)
        return lb
    }()
    
    /** This represents the text field to put your email address for logging in , using the CustomTextField class.
     */
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    /** This represents the text field to put your password for loggging in , using the CustomTextField class.
     */
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        return tf
    }()
    
    /** This represents the login button, which you press after putting your email and password in. It connects to the firebase server to check if your email and password are valid.
     */
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    /** This represents the forgot password part of the login page, clicking it will move you to a new page where you can reset your password.
    */
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
    }()

    /** dontHaveAccountButton represents the button that the users select when they currently do not have an account to login with, so they are redirected to the RegistrationController so that they can create an account
     */
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    /** handleLogin() uses the email and password that are currently in the email and password text fields and attempts to login the user with Firebase email/password authentication using AuthService. If it doesn't work, an error message is displayed to the user
    */
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.displayError(error: "Username or password is invalid.")
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    /** handleShowSignUp() creates a RegistrationController that the NavigationController pushes on top of the stack of view controllers
     */
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    /** textDidChange(sender) responds to editing occuring in sender. We use the text that is currently in sender to update the LoginViewModel's email or password property, depending on which text field sender is. The form is also updated, adjusting the loginButton colors and enabled property
    */
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    /** handleShowResetPassword() creates a ResetPasswordController that the NavigationController pushes on top of the stack of view controllers
    */
    @objc func handleShowResetPassword() {
        let controller = ResetPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        navigationController?.pushViewController(controller, animated: true)
    }
        
    // MARK: - Helpers
    /** Sets up the login controller interface by giving it a gradient background, styling the navigation bar, an icon image, and adding textfields, and buttons to handle user login functionaity
     */
    func configureUI() {
        configureGradientLayer()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(appNameLabel)
        appNameLabel.centerX(inView: view)
        appNameLabel.setDimensions(height: 80, width: 220)
        appNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: appNameLabel.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    /** Adds observers that respond to editing in the either the email or password text fields, calling textDidChange whenever editing occurs
    */
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func displayError(error: String) {
         let alert = UIAlertController(title: "Failed Login Attempt", message: error, preferredStyle: .alert)
         let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
             //what will happen when you click dismiss
             print("Success")
             
         }
         alert.addAction(action)
         present(alert, animated: true, completion: nil)
         
     }
    
}

// MARK: - FormViewModel

extension LoginController: FormViewModel {
    /** updateForm() adjusts the loginButton colors and enabled property based whether or not the textfields have been filled in
    */
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - ResetPasswordControllerDelegate

extension LoginController: ResetPasswordControllerDelegate {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success",
                    message: "We sent a link to your email to reset your password")
    }
}
