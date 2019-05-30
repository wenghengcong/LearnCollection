import PlaygroundSupport
import UIKit


final class DeluxeButton: UIView {
  //MARK: fileprivate
  fileprivate let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  fileprivate let label: UILabel = {
    let label = UILabel()
    
    label.font = UIFont.systemFont(
      ofSize: 40.0,
      weight: UIFontWeightHeavy
    )
    label.textAlignment = .center
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }()
  
  fileprivate lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.imageView, self.label])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    return stackView
  }()
  
  //MARK: init
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initPhase2()
  }
  
  private func initPhase2() {
    label.backgroundColor = tintColor
    layer.borderColor = tintColor.cgColor
    layer.cornerRadius = 20
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
      stackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
      label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
      ])
  }
}

extension DeluxeButton {
  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
    }
  }
  
  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }
  
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  override func tintColorDidChange() {
    label.backgroundColor = tintColor
    layer.borderColor = tintColor.cgColor
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
deluxeButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
deluxeButton.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
deluxeButton.borderWidth = 10
deluxeButton.image = #imageLiteral(resourceName: "drink.png")
deluxeButton.text = "Lemonade"


let view = UIView(
  frame: deluxeButton.frame.insetBy(dx: -100, dy: -100)
)
view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
view.addSubview(deluxeButton)


PlaygroundPage.current.liveView = view
