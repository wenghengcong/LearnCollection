import PlaygroundSupport
import UIKit

public final class RingLayer: CALayer {
  public var ringBackgroundColor = UIColor.darkGray.cgColor
  public var ringColor = UIColor.green.cgColor
  public var ringWidth: CGFloat = 40.0
  public var value: CGFloat = 0 {
    didSet {
      foregroundMask.path = getMaskPath(value: value)
      
      for layer: CALayer in [ gradientLayer, ringTipLayer] {
        layer.setValue(getAngle(value: value), forKeyPath: CALayer.rotationKeyPath
        )
      }
    }
  }
  
//MARK: fileprivate
  fileprivate private(set) lazy var backgroundLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = self.ringBackgroundColor
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    return layer
  }()
  
  fileprivate private(set) lazy var gradientLayer: CircularGradientLayer = {
    let layer = CircularGradientLayer()
    layer.color = self.ringColor
    return layer
  }()
  
  fileprivate private(set) lazy var foregroundLayer: CALayer = {
    let layer = CALayer()
    // foregroundLayer 添加环形进度图层
    layer.addSublayer(self.gradientLayer)
    layer.mask = self.foregroundMask
    return layer
  }()
  
  fileprivate private(set) lazy var foregroundMask: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.black.cgColor
    layer.fillColor = UIColor.clear.cgColor
    layer.lineWidth = self.ringWidth
    layer.lineCap = CAShapeLayerLineCap.round
    return layer
  }()
 
  fileprivate private(set) lazy var ringTipLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.fillColor = nil
    layer.lineCap = CAShapeLayerLineCap.round
    layer.lineWidth = self.ringWidth
    layer.strokeColor = self.ringColor
    return layer
  }()
  
//MARK: init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  public override init() {
    super.init()
    initPhase2()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    
    guard let layer = layer as? RingLayer
    else {return}
    
    ringWidth = layer.ringWidth
    value = layer.value
    ringBackgroundColor = layer.ringBackgroundColor
    ringColor = layer.ringColor
  }
  
  private func initPhase2() {
    backgroundColor = UIColor.black.cgColor
    [ backgroundLayer,
      foregroundLayer,
      ringTipLayer
    ].forEach(addSublayer)
    value = 0.8
  }
}

//MARK: CALayer
public extension RingLayer {
  override func layoutSublayers() {
    super.layoutSublayers()
    
    guard backgroundLayer.bounds != bounds
    else {return}
    
    for layer in [
      backgroundLayer,
      foregroundLayer,
      foregroundMask,
      gradientLayer,
      ringTipLayer
    ] {
      layer.bounds = bounds
      layer.position = center
    }
    
    preparePaths()
  }
}

//MARK: fileprivate
private extension RingLayer {
  var radius: CGFloat {
    return ( min(bounds.width, bounds.height) - ringWidth ) / 2
  }
  
  func getAngle(value: CGFloat) -> CGFloat {
    return value * 2 * .pi + angleOffsetForZero
  }
  
  func getMaskPath(value: CGFloat) -> CGPath {
    return makePath(
      startAngle: angleOffsetForZero,
      endAngle: getAngle(value: value)
    )
  }
  
  func preparePaths() {
    backgroundLayer.path = getMaskPath(value: 1)
    foregroundMask.path = getMaskPath(value: value)
    ringTipLayer.path = makePath(
      startAngle: -0.0001,
      endAngle: 0
    )
  }
  
//MARK: private
  private var angleOffsetForZero: CGFloat {
    return -.pi / 2
  }
  
  private func makePath(startAngle: CGFloat = 0, endAngle: CGFloat) -> CGPath {
    return UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true
    ).cgPath
  }
}


let ringLayer = RingLayer()
ringLayer.value = 1.9

PlaygroundPage.set(layers: ringLayer)
