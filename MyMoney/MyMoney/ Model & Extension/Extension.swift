//
//  Extension.swift
//  MyMoney
//
//  Created by Chonlasit on 8/5/2567 BE.
//

import Foundation
import UIKit

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}

extension UIColor {

    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: - Computed Properties

    var toHex: String? {
        return toHex()
    }

    // MARK: - From UIColor to HEX String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

// MARK: - UIVIEW ADD ATTRIBUTE
extension UIView {

  @IBInspectable var cornerRadius: CGFloat {

   get{
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }
    
    @IBInspectable var topLeftCornerRadius: CGFloat {
            get {
                return layer.maskedCorners.contains(.layerMinXMinYCorner) ? layer.cornerRadius : 0
            }
            set {
                layer.cornerRadius = newValue
                layer.maskedCorners = [.layerMinXMinYCorner]
            }
        }

        @IBInspectable var topRightCornerRadius: CGFloat {
            get {
                return layer.maskedCorners.contains(.layerMaxXMinYCorner) ? layer.cornerRadius : 0
            }
            set {
                layer.cornerRadius = newValue
                layer.maskedCorners = [.layerMaxXMinYCorner]
            }
        }

        @IBInspectable var bottomLeftCornerRadius: CGFloat {
            get {
                return layer.maskedCorners.contains(.layerMinXMaxYCorner) ? layer.cornerRadius : 0
            }
            set {
                layer.cornerRadius = newValue
                layer.maskedCorners = [.layerMinXMaxYCorner]
            }
        }

    @IBInspectable var bottomRightCornerRadius: CGFloat {
        get {
            return layer.maskedCorners.contains(.layerMaxXMaxYCorner) ? layer.cornerRadius : 0
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }

  @IBInspectable var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
        return UIColor(cgColor: layer.borderColor!)
    }
    set {
        layer.borderColor = borderColor?.cgColor
    }
  }
}

