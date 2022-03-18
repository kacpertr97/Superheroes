//
//  UIImage+extension.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import Foundation
import UIKit

extension UIImage {
       func colored(in color: UIColor) -> UIImage {
           let renderer = UIGraphicsImageRenderer(size: size)
           return renderer.image { _ in
               color.set()
               self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
           }
       }
   }
