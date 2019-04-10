import UIKit

class EventCell: UITableViewCell {
    static let defaultIdentifier = "EventCell"
    let labelMargin: CGFloat = 4
    let horizontalPadding: CGFloat = 8
    let verticalPadding: CGFloat = 4
    let fontSize: CGFloat = 10
    let itemSpacing: CGFloat = 2
    let bodyLines = 10

    let dateLabel = UILabel()
    let labelsView = UIStackView()
    let bodyLabel = UILabel()
    let labelsSpacerView = UIView()

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return formatter
    }() {
        didSet {
            update()
        }
    }

    var event: Event! {
        didSet {
            update()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpSubviews()

        selectionStyle = .none
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSubviews() {
        dateLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        dateLabel.textColor = .darkGray
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        labelsView.spacing = labelMargin
        bodyLabel.font = UIFont.systemFont(ofSize: fontSize)
        bodyLabel.textColor = .gray
        bodyLabel.numberOfLines = bodyLines

        let dateAndLabelsStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            labelsView,
        ])
        dateAndLabelsStackView.spacing = itemSpacing

        let mainStackView = UIStackView(arrangedSubviews: [
            dateAndLabelsStackView,
            bodyLabel,
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = itemSpacing

        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        labelsView.arrangedSubviews.forEach {
            labelsView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func update() {
        dateLabel.text = dateFormatter.string(from: event.date)

        var priority: Float = 1000
        event.labels.forEach {
            let labelView = EventLabelView(labelText: $0)
            labelView.setContentCompressionResistancePriority(UILayoutPriority(priority), for: .horizontal)
            labelsView.addArrangedSubview(labelView)

            if priority > 200 {
                priority -= 100
            }
        }
        labelsView.addArrangedSubview(labelsSpacerView)
        bodyLabel.text = event.body
    }
}
