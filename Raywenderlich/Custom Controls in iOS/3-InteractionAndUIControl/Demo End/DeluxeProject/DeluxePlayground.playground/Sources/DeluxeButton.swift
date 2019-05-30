import UIKit

public final class DeluxeButton: UIControl {
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
    stackView.isUserInteractionEnabled = false
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
    clipsToBounds = true
    
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

public extension DeluxeButton {
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
      layoutMargins = UIEdgeInsets(
        top: newValue,
        left: newValue,
        bottom: newValue / 2,
        right: newValue
      )
      layer.borderWidth = newValue
    }
  }
  
  var imagePadding: CGFloat {
    get {
      return image?.alignmentRectInsets.top ?? 0
    }
    set {
      image = image?.withAlignmentRectInsets(
        UIEdgeInsets(
          top: -newValue,
          left: -newValue,
          bottom: -newValue,
          right: -newValue
        )
      )
    }
  }
  
  override func tintColorDidChange() {
    label.backgroundColor = tintColor
    layer.borderColor = tintColor.cgColor
  }
}
