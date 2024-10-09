//
//  ExtensionFont.swift
//  Vocabee
//
//  Created by Adam Daris Ryadhi on 28/09/24.
//

import SwiftUI

import SwiftUI

extension Font {
    enum PoppinsFont: String {
        case thin = "Poppins-Thin"
        case extraLight = "Poppins-ExtraLight"
        case light = "Poppins-Light"
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semiBold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
        case extraBold = "Poppins-ExtraBold"
        case black = "Poppins-Black"
    }
    
    enum PoppinsTextStyle {
        case largeTitle, title, title2, title3, headline, subheadline, body, callout, footnote, caption, caption2
        
        var uiFont: UIFont {
            switch self {
            case .largeTitle: return UIFont.preferredFont(forTextStyle: .largeTitle)
            case .title: return UIFont.preferredFont(forTextStyle: .title1)
            case .title2: return UIFont.preferredFont(forTextStyle: .title2)
            case .title3: return UIFont.preferredFont(forTextStyle: .title3)
            case .headline: return UIFont.preferredFont(forTextStyle: .headline)
            case .subheadline: return UIFont.preferredFont(forTextStyle: .subheadline)
            case .body: return UIFont.preferredFont(forTextStyle: .body)
            case .callout: return UIFont.preferredFont(forTextStyle: .callout)
            case .footnote: return UIFont.preferredFont(forTextStyle: .footnote)
            case .caption: return UIFont.preferredFont(forTextStyle: .caption1)
            case .caption2: return UIFont.preferredFont(forTextStyle: .caption2)
            }
        }
    }
    
    static func poppins(_ type: PoppinsFont, _ style: PoppinsTextStyle) -> Font {
        let size = style.uiFont.pointSize
        return Font.custom(type.rawValue, size: size)
    }
    
    static func poppins(_ type: PoppinsFont, size: CGFloat) -> Font {
        return Font.custom(type.rawValue, size: size)
    }
}
