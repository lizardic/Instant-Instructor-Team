//
//  RegistrationController.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/22/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    /** plushPhotoButton represents the button that the user selects to choose their profile picture when registering, at top
    */
    private let plushPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    /** emailTextField represents the text field that the user selects to enter their email when registering, below plushPhotoButton
    */
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    /** passwordTextField represents the text field that the user selects to enter their password when registering, below emailTextField
    */
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        return tf
    }()
    
    /** fullnameTextField represents the text field that the user selects to enter their full name when registering, below passwordTextField
    */
    private let fullnameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        tf.autocapitalizationType = .words
        return tf
    }()
    
    /** usernameTextField represents the text field that the user selects to enter their username when registering, below fullnameTextField
    */
    private let usernameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.autocapitalizationType = .none
        return tf
    }()
    
    /** signUpButton represents the button that the user selects to register, below usernameTextField
    */
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    /** alreadyHaveAccountButton represents the button that the user selects to indicate that they have an account they would like into so it redirects to LoginController, below usernameTextField
    */
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    /** handleSignUp() uses the email, password, full name, and username that are currently in the corresponding text fields to attempt to register the user up using a method in AuthService
    */
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password,
                                          fullname: fullname, username: username,
                                          profileImage: profileImage)

        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                viewModel.displayError(error: error.localizedDescription)
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    /** handleShowLogin() pops the top view controller off of the stack of view controllers, which is RegistrationController in this case, displaying the previous view controller, LoginController
     */
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    /** textDidChange is called whenever a user is typing in the textfield. It is used to update the information in the ViewModel so that we know when the form is valid i.e. when all the necessary fields have been filled in
    */
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        updateForm()
    }
    
    /** handleProfilePhotoSelect() creates a UIImagePickerController, makes the RegistrationController the delegate of it, and then presents the image picker to the viewer so that they can select a photo
    */
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    /** configureUI sets up the display for the RegistrationController by putting the photo selection button, the textfields, and sign up button, and already have account buttons aligned vertically and centered
    */
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plushPhotoButton)
        plushPhotoButton.centerX(inView: view)
        plushPhotoButton.setDimensions(height: 140, width: 140)
        plushPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   fullnameTextField, usernameTextField,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plushPhotoButton.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    /** Adds observers that respond to editing in the either the email, password, full name, or username text fields, calling textDidChange whenever editing occurs
    */
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {
    /** updateForm() adjusts the loginButton colors and enabled property based whether or not the textfields have been filled in
    */
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /** imagePickerController() is called when the user selects a photo. This photo is then stored and set as the image for the plushPhotoButton, which is adjusted within this function to ensure that the image is properly displayed and rounded. Then the image picker is dismissed so users can see the RegistrationController again
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plushPhotoButton.contentMode = .scaleAspectFill
        plushPhotoButton.clipsToBounds = true
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor.white.cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}
