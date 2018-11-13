//
//  AppColorDataAccessObject.swift
//  ViperTest
//
//  Created by De La Cruz, Eduardo on 25/10/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit

class AppColorDataAccessObject {
    
    func save(rgb: (CGFloat, CGFloat, CGFloat)) -> (Void) {
        
        UserDefaults.standard.set(rgb.0, forKey: "Red")
        UserDefaults.standard.set(rgb.1, forKey: "Green")
        UserDefaults.standard.set(rgb.2, forKey: "Blue")
        print("Current color is saved!")
    }
    
    func fetch() -> (CGFloat, CGFloat, CGFloat) {
        
        let red = CGFloat(UserDefaults.standard.float(forKey: "Red"))
        let green = CGFloat(UserDefaults.standard.float(forKey: "Green"))
        let blue = CGFloat(UserDefaults.standard.float(forKey: "Blue"))
        print("Current color ia loaded!")
        
        return (red, green, blue)
    }
}
