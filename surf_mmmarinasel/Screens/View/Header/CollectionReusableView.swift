import UIKit

final class CollectionReusableView: UICollectionReusableView {
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(named: "lightGray")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    public static let identifier: String = "reusableView"
    
    public var viewModel: HeaderViewModel? {
        didSet {
            self.descriptionLabel.text = self.viewModel?.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionReusableView {
    private func setup() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                           constant: 0),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                            constant: 0),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
