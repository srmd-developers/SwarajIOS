//
//  SubtleVolume.swift
//  SubtleVolume
//
//  Created by Andrea Mazzini on 05/03/16.
//  Copyright © 2016 Fancy Pixel. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

/**
  The style of the volume indicator

 - Plain: A plain bar
 - RoundedLine: A plain bar with rounded corners
 - Dashes: A bar divided in dashes
 - Dots: A bar composed by a line of dots
 */
public enum SubtleVolumeStyle {
  case plain
  case roundedLine
  case dashes
  case dots
}

/**
 The entry and exit animation of the volume indicator

 - None: The indicator is always visible
 - SlideDown: The indicator fades in/out and slides from/to the top into position
 - FadeIn: The indicator fades in and out
 */
public enum SubtleVolumeAnimation {
  case none
  case slideDown
  case fadeIn
}

/**
 Errors being thrown by `SubtleError`.

 - unableToChangeVolumeLevel: `SubtleVolume` was unable to change audio level
 */
public enum SubtleVolumeError: Error {
  case unableToChangeVolumeLevel
}

/**
 Delegate protocol fo `SubtleVolume`. 
 Notifies the delegate when a change is about to happen (before the entry animation)
 and when a change occurred (and the exit animation is complete)
 */
public protocol SubtleVolumeDelegate {
  /**
   The volume is about to change. This is fired before performing any entry animation

   - parameter subtleVolume: The current instance of `SubtleVolume`
   - parameter value: The value of the volume (between 0 an 1.0)
   */
  func subtleVolume(_ subtleVolume: SubtleVolume, willChange value: Float)

  /**
   The volume did change. This is fired after the exit animation is done

   - parameter subtleVolume: The current instance of `SubtleVolume`
   - parameter value: The value of the volume (between 0 an 1.0)
   */
  func subtleVolume(_ subtleVolume: SubtleVolume, didChange value: Float)
}

/**
 Replace the system volume popup with a more subtle way to display the volume 
 when the user changes it with the volume rocker.
*/
open class SubtleVolume: UIView {

  /**
   The style of the volume indicator
   */
  open var style = SubtleVolumeStyle.plain

  /**
   The entry and exit animation of the indicator. The animation is triggered by the volume
   If the animation is set to `.None`, the volume indicator is always visible
   */
  open var animation = SubtleVolumeAnimation.none {
    didSet {
      updateVolume(volumeLevel, animated: false)
    }
  }

  open var barBackgroundColor = UIColor.clear {
    didSet {
      backgroundColor = barBackgroundColor
    }
  }

  open var barTintColor = UIColor.white {
    didSet {
      overlay.backgroundColor = barTintColor
    }
  }

  open var delegate: SubtleVolumeDelegate?

  fileprivate let volume = MPVolumeView(frame: CGRect.zero)
  fileprivate let overlay = UIView()
  public fileprivate(set) var volumeLevel = Float(0)
  fileprivate let AVAudioSessionOutputVolumeKey = "outputVolume"

  convenience public init(style: SubtleVolumeStyle, frame: CGRect) {
    self.init(frame: frame)
    self.style = style
  }

  convenience public init(style: SubtleVolumeStyle) {
    self.init(style: style, frame: CGRect.zero)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  required public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required public init() {
    fatalError("Please use the convenience initializers instead")
  }

  /**
   Programatically set the volume level.

   - parameter volumeLevel: The new level of volume (between 0 an 1.0)
   - parameter animated: Indicating whether the change should be animated
   */
  public func setVolumeLevel(_ volumeLevel: Float, animated: Bool = false) throws {
    guard let slider = volume.subviews.compactMap({ $0 as? UISlider }).first else {
      throw SubtleVolumeError.unableToChangeVolumeLevel
    }

    // If user opted out of animation, toggle observation for the duration of the change
    if !animated {
      AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, context: nil)

      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
        guard let `self` = self else { return }
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: self.AVAudioSessionOutputVolumeKey, options: .new, context: nil)
      }
    }

    // Trick iOS into thinking that slider value has changed
    slider.value = max(0, min(1, volumeLevel))
  }

  fileprivate func setup() {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Unable to initialize AVAudioSession")
    }
    updateVolume(AVAudioSession.sharedInstance().outputVolume, animated: false)
    AVAudioSession.sharedInstance().addObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, options: .new, context: nil)

    backgroundColor = .clear

    volume.setVolumeThumbImage(UIImage(), for: UIControl.State())
    volume.isUserInteractionEnabled = false
    volume.alpha = 0.0001
    volume.showsRouteButton = false

    addSubview(volume)

    overlay.backgroundColor = .black
    addSubview(overlay)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    overlay.frame = frame
    overlay.frame = CGRect(x: 0, y: 0, width: frame.size.width * CGFloat(volumeLevel), height: frame.size.height)
  }

  fileprivate func updateVolume(_ value: Float, animated: Bool) {
    delegate?.subtleVolume(self, willChange: value)
    volumeLevel = value

    UIView.animate(withDuration: animated ? 0.1 : 0, animations: { () -> Void in
      self.overlay.frame.size.width = self.frame.size.width * CGFloat(self.volumeLevel)
    }) 

    UIView.animateKeyframes(withDuration: animated ? 2 : 0, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
        switch self.animation {
        case .none: break
        case .fadeIn:
          self.alpha = 1
        case .slideDown:
          self.alpha = 1
          self.transform = CGAffineTransform.identity
        }
      })

      UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: { () -> Void in
        switch self.animation {
        case .none: break
        case .fadeIn:
          self.alpha = 0.0001
        case .slideDown:
          self.alpha = 0.0001
          self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        }
      })

      }) { _ in
        self.delegate?.subtleVolume(self, didChange: value)
    }
  }

  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let change = change, let value = change[.newKey] as? Float , keyPath == AVAudioSessionOutputVolumeKey else { return }

    updateVolume(value, animated: true)
  }

  deinit {
    AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: AVAudioSessionOutputVolumeKey, context: nil)
  }

}
