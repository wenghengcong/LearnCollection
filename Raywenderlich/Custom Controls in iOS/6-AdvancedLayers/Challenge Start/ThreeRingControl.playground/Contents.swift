import PlaygroundSupport
import UIKit

public final class ThreeRingView: UIView {
//MARK: public
  public var ringWidth: CGFloat = 20
  public var ringPadding: CGFloat = 1
  public var ringBackgroundColor = UIColor.darkGray
  
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
      return 0
    }
    set {
      
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
      return .clear
    }
    set {
      
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

threeRingView.ringBackgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)

threeRingView.innerRingColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
threeRingView.middleRingColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
threeRingView.outerRingColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)

PlaygroundPage.current.liveView = threeRingView
