//
//  AuthenticationViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/23/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

/** This protocol is to help update the form based on what the user enters. It is used for the login/signup/forgot password page.
 */
protocol FormViewModel {
    func updateForm()
}

/** This protocol is for authenticating forms with text fields, any class/struct conforming to this protocol needs to make sure the form is valid,
     and make sure the button colors respond accordingly.
 */
protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}
/** This struct implements the AuthenticationViewModel and is for updating the login form based on what the user enters. It checks whether or not the email and password text fields are blank, and updates the colors of the login button accordingly. It also enables the button if both textfields are non-empty.
 */
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
}

/** This struct implements the AuthenticationViewModel and is for updating the registration form based on what the user enters. It checks whether or not the email, password, fullname, and username text fields are blank, and updates the colors of the login button accordingly. It also enables the registration button if all text-fields are non empty.
 */
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
    

}

/** This struct implements the AutheticationViewModel and is for updating the forgot password form based on what the user enters. It checks whether or not the email text field is blank, and updates the color of the forgot password button accordingly. It also enables the forgot password button if all text-fields are non empty.
 */
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
