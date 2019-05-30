import PlaygroundSupport
import UIKit

let frame = CGRect(
  x: 0,
  y: 0,
  width: 300,
  height: 300
)

let threeRingViews = [
  ThreeRingView(frame: frame),
  ThreeRingView(frame: frame)
]
for threeRingView in threeRingViews {
  threeRingView.innerRingValue = 0.9
  threeRingView.middleRingValue = 0.3
  threeRingView.outerRingValue = 0.6
}

extension ThreeRingView {
  func setNewValues() {
    CATransaction.begin()
    defer {
      CATransaction.commit()
    }

    innerRingValue = randomValue
    middleRingValue = randomValue
    outerRingValue = randomValue
  }
  
  func animateNewValues() {
    CATransaction.begin()
    defer {
      CATransaction.commit()
    }
    
    for ring in rings {
      animate(
        ring: ring,
        value: randomValue
      )
    }
  }
  
  private var randomValue: CGFloat {
    return CGFloat( arc4random_uniform(20) ) / 10
  }
}

let view = UIView(
  frame: CGRect(
    x: 0,
    y: 0,
    width: frame.width,
    height: frame.height * 2
  )
)
let controls = (
  set: UIControl(frame: frame),
  animate: UIControl(
    frame: frame.offsetBy(
      dx: 0,
      dy: frame.height
    )
  )
)
for (
  index,
  (control, selector)
) in [
  ( controls.set,
    #selector(ThreeRingView.setNewValues)
  ),
  ( controls.animate,
    #selector(ThreeRingView.animateNewValues)
  )
].enumerated() {
  view.addSubview(control)
  
  let threeRingView = threeRingViews[index]
  threeRingView.isUserInteractionEnabled = false
  control.addSubview(threeRingView)
  control.addTarget(
    threeRingView,
    action: selector,
    for: .touchUpInside
  )
}
PlaygroundPage.current.liveView = view
