import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "EnergyPlayer" asset catalog image resource.
    static let energyPlayer = ImageResource(name: "EnergyPlayer", bundle: resourceBundle)

    /// The "IQButtonBarArrowDown" asset catalog image resource.
    static let iqButtonBarArrowDown = ImageResource(name: "IQButtonBarArrowDown", bundle: resourceBundle)

    /// The "IQButtonBarArrowLeft" asset catalog image resource.
    static let iqButtonBarArrowLeft = ImageResource(name: "IQButtonBarArrowLeft", bundle: resourceBundle)

    /// The "IQButtonBarArrowRight" asset catalog image resource.
    static let iqButtonBarArrowRight = ImageResource(name: "IQButtonBarArrowRight", bundle: resourceBundle)

    /// The "IQButtonBarArrowUp" asset catalog image resource.
    static let iqButtonBarArrowUp = ImageResource(name: "IQButtonBarArrowUp", bundle: resourceBundle)

    /// The "SwaRaj Kriya Logo" asset catalog image resource.
    static let swaRajKriyaLogo = ImageResource(name: "SwaRaj Kriya Logo", bundle: resourceBundle)

    /// The "back-white-icon" asset catalog image resource.
    static let backWhiteIcon = ImageResource(name: "back-white-icon", bundle: resourceBundle)

    /// The "back_white" asset catalog image resource.
    static let backWhite = ImageResource(name: "back_white", bundle: resourceBundle)

    /// The "bg1" asset catalog image resource.
    static let bg1 = ImageResource(name: "bg1", bundle: resourceBundle)

    /// The "bg2" asset catalog image resource.
    static let bg2 = ImageResource(name: "bg2", bundle: resourceBundle)

    /// The "bg3" asset catalog image resource.
    static let bg3 = ImageResource(name: "bg3", bundle: resourceBundle)

    /// The "bg_shadow" asset catalog image resource.
    static let bgShadow = ImageResource(name: "bg_shadow", bundle: resourceBundle)

    /// The "circleMinus" asset catalog image resource.
    static let circleMinus = ImageResource(name: "circleMinus", bundle: resourceBundle)

    /// The "circlePlus" asset catalog image resource.
    static let circlePlus = ImageResource(name: "circlePlus", bundle: resourceBundle)

    /// The "cloud_icon" asset catalog image resource.
    static let cloudIcon = ImageResource(name: "cloud_icon", bundle: resourceBundle)

    /// The "down_arrow" asset catalog image resource.
    static let downArrow = ImageResource(name: "down_arrow", bundle: resourceBundle)

    /// The "download" asset catalog image resource.
    static let download = ImageResource(name: "download", bundle: resourceBundle)

    /// The "dp1" asset catalog image resource.
    static let dp1 = ImageResource(name: "dp1", bundle: resourceBundle)

    /// The "dp2" asset catalog image resource.
    static let dp2 = ImageResource(name: "dp2", bundle: resourceBundle)

    /// The "eye_hide" asset catalog image resource.
    static let eyeHide = ImageResource(name: "eye_hide", bundle: resourceBundle)

    /// The "eye_show" asset catalog image resource.
    static let eyeShow = ImageResource(name: "eye_show", bundle: resourceBundle)

    /// The "ic_pause_black_36" asset catalog image resource.
    static let icPauseBlack36 = ImageResource(name: "ic_pause_black_36", bundle: resourceBundle)

    /// The "ic_play_arrow_black_36" asset catalog image resource.
    static let icPlayArrowBlack36 = ImageResource(name: "ic_play_arrow_black_36", bundle: resourceBundle)

    /// The "ic_skip_next_white_48" asset catalog image resource.
    static let icSkipNextWhite48 = ImageResource(name: "ic_skip_next_white_48", bundle: resourceBundle)

    /// The "ic_skip_previous_white_48" asset catalog image resource.
    static let icSkipPreviousWhite48 = ImageResource(name: "ic_skip_previous_white_48", bundle: resourceBundle)

    /// The "placholder_logo" asset catalog image resource.
    static let placholderLogo = ImageResource(name: "placholder_logo", bundle: resourceBundle)

    /// The "play" asset catalog image resource.
    static let play = ImageResource(name: "play", bundle: resourceBundle)

    /// The "playWhite" asset catalog image resource.
    static let playWhite = ImageResource(name: "playWhite", bundle: resourceBundle)

    /// The "playWhiteO" asset catalog image resource.
    static let playWhiteO = ImageResource(name: "playWhiteO", bundle: resourceBundle)

    /// The "play_green" asset catalog image resource.
    static let playGreen = ImageResource(name: "play_green", bundle: resourceBundle)

    /// The "profile" asset catalog image resource.
    static let profile = ImageResource(name: "profile", bundle: resourceBundle)

    /// The "riben" asset catalog image resource.
    static let riben = ImageResource(name: "riben", bundle: resourceBundle)

    /// The "right_arrow" asset catalog image resource.
    static let rightArrow = ImageResource(name: "right_arrow", bundle: resourceBundle)

    /// The "setting" asset catalog image resource.
    static let setting = ImageResource(name: "setting", bundle: resourceBundle)

    /// The "stop" asset catalog image resource.
    static let stop = ImageResource(name: "stop", bundle: resourceBundle)

    /// The "stopO" asset catalog image resource.
    static let stopO = ImageResource(name: "stopO", bundle: resourceBundle)

    /// The "stopOrg" asset catalog image resource.
    static let stopOrg = ImageResource(name: "stopOrg", bundle: resourceBundle)

    /// The "tick" asset catalog image resource.
    static let tick = ImageResource(name: "tick", bundle: resourceBundle)

    /// The "uamp_ic_pause_white_48" asset catalog image resource.
    static let uampIcPauseWhite48 = ImageResource(name: "uamp_ic_pause_white_48", bundle: resourceBundle)

    /// The "uamp_ic_play_arrow_white_48" asset catalog image resource.
    static let uampIcPlayArrowWhite48 = ImageResource(name: "uamp_ic_play_arrow_white_48", bundle: resourceBundle)

    /// The "up_arrow" asset catalog image resource.
    static let upArrow = ImageResource(name: "up_arrow", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif