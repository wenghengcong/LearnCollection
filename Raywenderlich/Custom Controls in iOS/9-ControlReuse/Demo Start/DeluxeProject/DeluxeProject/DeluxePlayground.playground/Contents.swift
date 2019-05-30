import PlaygroundSupport
import UIKit


final class DeluxeView: UIView {
  func handleDeluxeButtonTap() {
    print("Deluxe View Action")
  }
}

let dimensions = (width: 200, height: 200)
let deluxeButton = DeluxeButton(
  frame: CGRect(
    x: dimensions.width / 2,
    y: dimensions.height / 2,
    width: dimensions.width,
    height: dimensions.height
  )
)
deluxeButton.unpressedBackgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
deluxeButton.pressedBackgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
deluxeButton.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
deluxeButton.borderWidth = 10
deluxeButton.image = #imageLiteral(resourceName: "drink.png")
deluxeButton.text = "Lemonade"
deluxeButton.imagePadding = 10


let view = DeluxeView(
  frame: deluxeButton.frame.insetBy(dx: -100, dy: -100)
)
view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
view.addSubview(deluxeButton)

deluxeButton.addTarget(
  view,
  action: #selector(view.handleDeluxeButtonTap),
  for: .touchUpInside
)

PlaygroundPage.current.liveView = view
