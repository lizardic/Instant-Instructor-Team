//
//  AuthenticationViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/23/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
    func displayError()
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
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

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
            && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
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

struct ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?

    var formIsValid: Bool { return email?.isEmpty == false }
    
    var buttonBackgroundColor: UIColor {
        formIsValid ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
