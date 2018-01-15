import UIKit

class LogCell: UITableViewCell {
    static let defaultIdentifier = "LogCell"
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

    var log: Log! {
        didSet {
            update()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        dateLabel.text = dateFormatter.string(from: log.date)
        log.labels.forEach {
            let labelView = LogLabelView(labelText: $0)
            labelsView.addArrangedSubview(labelView)
        }
        labelsView.addArrangedSubview(labelsSpacerView)
        bodyLabel.text = log.body
    }
}
