import UIKit

protocol MainViewDelegate: AnyObject {
    func handleSend()
}

final class MainView: DraggableView {
    
    public weak var delegate: MainViewDelegate?
    
    private lazy var emptyLabel: UILabel = {
        return self.createLabel(text: "Хочешь к нам?",
                                color: UIColor(named: "lightGray") ?? UIColor.gray,
                                font: UIFont.systemFont(ofSize: 14))
    }()
    
    private let sendRequestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить заявку", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "lightBlack")
        button.addTarget(self, action: #selector(buildAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var greetingLabel: UILabel = {
        return self.createLabel(text: "Стажировка в Surf",
                                color: UIColor(named: "lightBlack") ?? UIColor.black,
                                font: UIFont.systemFont(ofSize: 24, weight: .bold))
    }()
    
    private var itemsCollectionView: UICollectionView?
    private let viewModel = ViewModel()
    private var subviewConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buildAlert(sender: UIButton!) {
        self.delegate?.handleSend()
    }
    
    // MARK: - Setup
    
    public func setupConstraints() {
        NSLayoutConstraint.deactivate(self.subviewConstraints)
        self.emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        self.greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.itemsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        let size: CGFloat = 0.18 * self.smallSize
        guard let itemsCollectionView = self.itemsCollectionView else { return }
        
            self.subviewConstraints = [
                self.emptyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                        constant: -size),
                self.emptyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                         constant: 20),
                self.sendRequestButton.centerYAnchor.constraint(equalTo: self.emptyLabel.centerYAnchor),
                self.sendRequestButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                                 constant: -20),
                self.sendRequestButton.widthAnchor.constraint(equalToConstant: 219),
                self.sendRequestButton.heightAnchor.constraint(equalToConstant: size),
                self.greetingLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                        constant: size / 3),
                self.greetingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: 20),
                itemsCollectionView.topAnchor.constraint(equalTo: self.greetingLabel.bottomAnchor,
                                                         constant: 12),
                itemsCollectionView.bottomAnchor.constraint(equalTo: self.sendRequestButton.topAnchor,
                                                            constant: -size / 2),
                itemsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                itemsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ]
        self.sendRequestButton.layer.cornerRadius = size / 2
        NSLayoutConstraint.activate(self.subviewConstraints)
    }
    
    private func setup() {
        self.addSubview(self.emptyLabel)
        self.addSubview(self.sendRequestButton)
        self.addSubview(self.greetingLabel)
    }
    
    public override func postbuild() {
        super.postbuild()
        self.setupCollectionView()
    }
    
    public override func onSizeChange() {
        super.onSizeChange()
        self.itemsCollectionView?.reloadData()
    }
    
    private func setupCollectionView() {
        self.itemsCollectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: self.createLayout())
        guard let itemsCollectionView = self.itemsCollectionView else { return }
        itemsCollectionView.isScrollEnabled = false
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(ItemCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        itemsCollectionView.register(CollectionReusableView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: CollectionReusableView.identifier)
        self.addSubview(itemsCollectionView)
    }
    
    private func createLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text = text
        label.textColor = color
        return label
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self?.createHorizontalSection()
            case 1:
                return self?.createPagingSection()
            default:
                return self?.createHorizontalSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    // MARK: - NSCollectionLayoutSection
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(120),
                                              heightDimension: .absolute(0.13 * self.smallSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(120),
                                               heightDimension: .absolute(0.18 * self.smallSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 0.036 * self.smallSize,
                                      leading: 20,
                                      bottom: 0,
                                      trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    private func createPagingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(120),
                                              heightDimension: .absolute(0.13 * self.smallSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(120),
                                               heightDimension: .absolute(0.3 * self.smallSize))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 0.036 * self.smallSize,
                                      leading: 20,
                                      bottom: 0,
                                      trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(60)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
}

    // MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch self.expandState {
        case .small:
            return 1
        case .medium, .large:
            return 2
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.items.count
        } else {
            return self.viewModel.itemsPaging.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier,
                                                            for: indexPath) as? ItemCollectionViewCell
        else { return UICollectionViewCell() }
        let cellVM: CellViewModel?
        if indexPath.section == 0 {
            cellVM = self.viewModel.getCellViewModel(indexPath)
        } else {
            cellVM = self.viewModel.getCellPagingViewModel(indexPath)
        }
        cellVM?.initPressState(indexPath: indexPath)
        cell.viewModel = cellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as? CollectionReusableView
            else { return UICollectionReusableView() }
            let headerVM = self.viewModel.getHeaderViewModel(indexPath)
            header.viewModel = headerVM
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
