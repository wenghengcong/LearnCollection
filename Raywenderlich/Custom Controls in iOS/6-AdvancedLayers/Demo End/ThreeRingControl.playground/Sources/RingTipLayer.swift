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
        // 尾随闭包
      processLayers{$0.lineWidth = ringWidth}
      preparePaths()
    }
  }
  
  //MARK: fileprivate
    // 阴影的mask图层
  fileprivate let shadowMaskLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.green.cgColor
    layer.lineCap = CAShapeLayerLineCap.butt
    return layer
  }()
  
    // 圆角图层
  fileprivate private(set) lazy var tipLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = CAShapeLayerLineCap.round
    layer.lineWidth = self.ringWidth
    return layer
  }()
  
    // 阴影图层
  fileprivate private(set) lazy var shadowLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = CAShapeLayerLineCap.round
    layer.strokeColor = UIColor.purple.cgColor
    layer.shadowColor = UIColor.purple.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = 12
    layer.shadowOpacity = 1
    layer.mask = self.shadowMaskLayer
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
    [shadowLayer, tipLayer].forEach(addSublayer)
    preparePaths()
  }
}

//MARK: fileprivate
private extension RingTipLayer {
    //
  func processLayers(process: (CAShapeLayer) -> Void) {
    [ tipLayer,
      shadowLayer,
      shadowMaskLayer
      ].forEach(process)
  }
  
    // 图层路径
    // 图层层次：shadowLayer在下，shadowMaskLayer是shadowLayer的mask层，tipLayer在上
    
    // 角度：以π/2为起点，顺时针方向
    // shadowLayer是 π/2 ~ 0，shadowMaskLayer、tipLayer都是 0 ~ -0.01
    // shadowMaskLayer的大小为 π/2 ~ 0，即第一象限的全部
    // shadowLayer,tipLayer都是0以下位置，即第四象限一丁点的大小
    
    // 三个图层在RingLayer中都会旋转到进度对应的角度，即从进度末端开始的位置。
    // 假如进度为0.5，那么进度层的位置为：π/2 ~ -π/2
    // 而且所有的图层需要移动 π-π/2（变量angleOffsetForZero为-π/2）的位置，即移动π/2的位置，且默认为顺时针旋转
    // angleOffsetForZero主要是为了修正从π/2，即最顶部开始计算角度
    
    // 但是shadowMaskLayer是从 π/2 ~ 0，移动π/2后，对应的角度 0 ~ -π/2
    // shadowLayer、tipLayer这是从 -0.01 ~ 0 移动到 -0.01-π/2 ~ -π/2
    // 结果就是，shadowLayer只会展示最末端的一部分阴影
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
    shadowMaskLayer.path = shadowMaskPath
    
    for layer in [shadowLayer, tipLayer] {
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
