import PlaygroundSupport
import UIKit

final class RingTipLayer: CALayer {
//MARK: internal
  var color = UIColor.red.cgColor {
    didSet {
      tipLayer.strokeColor = color
    }
  }
  
  var ringWidth: CGFloat = 40 {
    didSet {
      processLayers{$0.lineWidth = ringWidth}
      preparePaths()
    }
  }
  
//MARK: fileprivate
  fileprivate let shadowMaskLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.black.cgColor
    layer.lineCap = kCALineCapButt
    return layer
  }()
  
  fileprivate private(set) lazy var tipLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.lineWidth = self.ringWidth
    return layer
  }()
  
  fileprivate private(set) lazy var shadowLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    return layer
  }()
  
//MARK: init
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  override init() {
    super.init()
    initPhase2()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    
    guard let layer = layer as? RingTipLayer
    else {return}
    
    color = layer.color
    ringWidth = layer.ringWidth
  }
  
  private func initPhase2() {
    addSublayer(tipLayer)
    preparePaths()
  }
}

//MARK: fileprivate
private extension RingTipLayer {
  func processLayers(process: (CAShapeLayer) -> Void) {
    [ tipLayer,
      shadowLayer,
      shadowMaskLayer
    ].forEach(process)
  }
  
  func preparePaths() {
    func makePath(
      startAngle: CGFloat = 0,
      endAngle: CGFloat
    ) -> CGPath {
      return UIBezierPath(
        arcCenter: center,
        radius: ( min(bounds.width, bounds.height) - ringWidth ) / 2,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: true
      ).cgPath
    }
    
    let shadowMaskPath = makePath(endAngle: .pi / 2)
    
    for layer in [tipLayer] {
      layer.path = makePath(
        startAngle: -0.01,
        endAngle: 0
      )
    }
  }
}

//MARK: CALayer
extension RingTipLayer {
  override func layoutSublayers() {
    processLayers{
      $0.bounds = bounds
      $0.position = center
    }
    preparePaths()
  }
}


let tipLayer = RingTipLayer()
tipLayer.backgroundColor = UIColor.white.cgColor
tipLayer.color = Color.pink
tipLayer.ringWidth = 60

let ringLayer = RingLayer()
ringLayer.value = 0.6
ringLayer.ringWidth = 60
ringLayer.ringColor = Color.pink

PlaygroundPage.set(layers: tipLayer, ringLayer)
