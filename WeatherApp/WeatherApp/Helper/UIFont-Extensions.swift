//
//  UIFont-Extensions.swift
//  WeatherApp
//
//  Created by Aubergine on 18/12/24.
//

import UIKit

public enum FontWeight:String {
    case ultralight, thin, light, regular, medium, semibold, bold, heavy, black
    
    public init(type:String) {
        self = FontWeight(rawValue: type)!
    }
}

extension UIFont {
    private static func fontWeight(weight:FontWeight) -> String {
        switch weight {
        case .ultralight:
            return "ExtraLight"
            
        case .thin:
            fallthrough
            
        case .light:
            return "Light"
            
        case .regular:
            fallthrough
            
        case .medium:
            fallthrough
            
        case .semibold:
            return "SemiBold"
            
        case .heavy:
            return "ExtraBold"
            
        case .black:
            return "Black"
            
        case .bold:
            return "Bold"
        }
    }
    
    private static func name(weight:FontWeight) -> String {
        let base = "Nunito"
        let weightNumber = UIFont.fontWeight(weight: weight)
        
        return "\(base)-\(weightNumber)"
    }
    
    static func appFont(size:CGFloat, weight:FontWeight, scaleFont : Bool) -> UIFont {
        
        var ratio : CGFloat = 1.0
        if scaleFont == true {
            ratio = Constants.SCREEN_RATIO
        }
        
        var s = size
        if DeviceType.IS_IPAD_PRO {
            s += 3
        }
        let fontName = UIFont.name(weight: weight)
        return UIFont(name: fontName, size: CGFloat(s * ratio)) ?? UIFont.systemFont(ofSize: CGFloat(s * ratio), weight: .regular)
    }
    
    static func appFont(size:CGFloat, weight:FontWeight) -> UIFont {
        
        let fontName = UIFont.name(weight: weight)
        
        var s = size
        if DeviceType.IS_IPAD_PRO {
            s += 3
        }
        return UIFont(name: fontName, size: CGFloat(s)) ?? UIFont.systemFont(ofSize: CGFloat(s), weight: .regular)
    }
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XS         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_XS_MAX     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH >= 1366.0

}
struct ScreenSize
{
    static var SCREEN_WIDTH: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    static var SCREEN_HEIGHT: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
