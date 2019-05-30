import PlaygroundSupport
import UIKit

public final class ThreeRingView: UIView {
//MARK: public
  public var ringWidth: CGFloat = 20 {
    didSet {
      drawLayers()
      for ringLayer in ringLayers.values {
        ringLayer.ringWidth = ringWidth
      }
    }
  }

  public var ringPadding: CGFloat = 1 {
    didSet {
      drawLayers()
    }
  }
  
  public var ringBackgroundColor = UIColor.darkGray {
    didSet {
      for ringLayer in ringLayers.values {
        ringLayer.ringBackgroundColor = ringBackgroundColor.cgColor
      }
    }
  }
  
//MARK: fileprivate
  fileprivate let ringLayers: [Ring: RingLayer] = [
    .inner: RingLayer(),
    .middle: RingLayer(),
    .outer: RingLayer()
  ]
  
//MARK: init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initPhase2()
  }
  
  private func initPhase2() {
    backgroundColor = UIColor.black
    for ringLayer in ringLayers.values {
      layer.addSublayer(ringLayer)
      ringLayer.backgroundColor = UIColor.clear.cgColor
      ringLayer.ringBackgroundColor = ringBackgroundColor.cgColor
      ringLayer.ringWidth = ringWidth
      ringLayer.value = 0
    }
    
    innerRingColor = UIColor(cgColor: Color.pink)
    middleRingColor = UIColor(cgColor: Color.blue)
    outerRingColor = UIColor(cgColor: Color.green)
  }
}

//MARK: public
public extension ThreeRingView {
  var innerRingValue: CGFloat {
    get {
      return ringLayers[.inner]!.value
    }
    set {
      ringLayers[.inner]!.value = newValue
    }
  }
  
  var middleRingValue: CGFloat {
    get {
      return ringLayers[.middle]!.value
    }
    set {
      ringLayers[.middle]!.value = newValue
    }
  }
  
  var outerRingValue: CGFloat {
    get {
      return ringLayers[.outer]!.value
    }
    set {
      ringLayers[.outer]!.value = newValue
    }
  }
  
  var innerRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.inner]!.ringColor)
    }
    set {
      ringLayers[.inner]!.ringColor = newValue.cgColor
    }
  }
  
  var middleRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.middle]!.ringColor)
    }
    set {
      ringLayers[.middle]!.ringColor = newValue.cgColor
    }
  }
  
  var outerRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.outer]!.ringColor)
    }
    set {
      ringLayers[.outer]!.ringColor = newValue.cgColor
    }
  }
}

//MARK: private
private extension ThreeRingView {
  func drawLayers() {
    // the largest a ring can be,
    // and still fit withing the bounds of the current view
    let maxSize = min(bounds.width, bounds.height)
    
    // measured between adjacent rings
    let sizeDifference = (ringWidth + ringPadding) * 2
    
    for (index, ringLayer) in ringLayers {
      let size = maxSize - sizeDifference * CGFloat(2 - index.rawValue)
      ringLayer.bounds = CGRect(
        x: 0,
        y: 0,
        width: size,
        height: size
      )
      
      ringLayer.position = layer.position
    }
  }
}

//MARK: UIView
public extension ThreeRingView {
  override func layoutSubviews() {
    super.layoutSubviews()
    drawLayers()
  }
}


let threeRingView = ThreeRingView(
  frame: CGRect(
    x: 0,
    y: 0,
    width: 300,
    height: 300
  )
)

threeRingView.innerRingValue = 0.9
threeRingView.middleRingValue = 0.3
threeRingView.outerRingValue = 0.6

threeRingView.ringWidth = 30
threeRingView.ringPadding = 5

threeRingView.ringBackgroundColor = #colorLiteral(red: 0.6838072036, green: 0.9764705896, blue: 0.8549920235, alpha: 1)

threeRingView.innerRingColor = #colorLiteral(red: 0.5825195312, green: 0.2972659687, blue: 0.237532236, alpha: 1)
threeRingView.middleRingColor = #colorLiteral(red: 0.9768045545, green: 0.6637557132, blue: 0.9500255733, alpha: 1)
threeRingView.outerRingColor = #colorLiteral(red: 0.695, green: 0.6370560817, blue: 0.1889320388, alpha: 1)

PlaygroundPage.current.liveView = threeRingView
