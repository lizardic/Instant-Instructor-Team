//
//  CustomTextField.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/22/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    /** Creates a text field with white text that is moderately sized and has a transparent white background. The textfield contains whatever text is given in parameter placeholder
    */
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
