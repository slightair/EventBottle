import UIKit

class EventLabelView: UIView {
    private let horizontalPadding: CGFloat = 4
    private let verticalPadding: CGFloat = 1
    private let cornerRadius: CGFloat = 4
    private let labelFontSize: CGFloat = 8

    private let textLabel = UILabel()
    private let labelText: String

    private static var colors: [String: UIColor] = [:]

    private func color(from text: String) -> UIColor {
        let hue = CGFloat(Double(arc4random_uniform(255)) / 255)
        return UIColor(hue: hue, saturation: 0.6, brightness: 0.8, alpha: 1.0)
    }

    var labelColor: UIColor {
        if let color = EventLabelView.colors[labelText] {
            return color
        }

        let color = self.color(from: labelText)
        EventLabelView.colors[labelText] = color

        return color
    }

    init(labelText: String) {
        self.labelText = labelText

        super.init(frame: .zero)

        setUpSubviews()
        textLabel.text = labelText

        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = textLabel.intrinsicContentSize
        return CGSize(width: labelSize.width + horizontalPadding * 2, height: labelSize.height + verticalPadding * 2)
    }

    private func setUpSubviews() {
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.boldSystemFont(ofSize: labelFontSize)

        addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(labelColor.cgColor)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        context?.addPath(path.cgPath)
        context?.fillPath()
    }
}
