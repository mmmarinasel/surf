import UIKit

class DraggableView: UIView {
    
    private enum Direction {
        case up
        case down
    }
    
    public enum State {
        case small
        case medium
        case large
    }
    
    private weak var parent: UIView? = nil
    private var heightConstraint: NSLayoutConstraint? = nil
    private var height: CGFloat = 200
    private var state: State = .small
    
    public var mediumSize: CGFloat = 0
    public var largeSize: CGFloat = 0
    public var smallSize: CGFloat = 0
    public var expandState: State {
        get {
            return self.state
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp(_:)))
        swipeGestureRecognizerUp.direction = .up
        self.addGestureRecognizer(swipeGestureRecognizerUp)
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
        swipeGestureRecognizerDown.direction = .down
        self.addGestureRecognizer(swipeGestureRecognizerDown)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: - Build Custom Sheet View
    
    @objc private func didSwipeUp(_ sender: UISwipeGestureRecognizer) {
        self.resize(.up)
    }
    
    @objc private func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.resize(.down)
    }
    
    private func resize(_ direction: Direction) {
        guard var heightConstraint = self.heightConstraint else { return }
        self.removeConstraint(heightConstraint)
        
        switch self.state {
        case .small:
            if direction == .up {
                self.state = .medium
                self.height = self.mediumSize
            }
        case .medium:
            if direction == .up {
                self.state = .large
                self.height = self.largeSize
            }
            else {
                self.state = .small
                self.height = self.smallSize
            }
        case .large:
            if direction == .down {
                self.state = .medium
                self.height = self.mediumSize
            }
        }
        
        heightConstraint = self.heightAnchor.constraint(equalToConstant: self.height)
        NSLayoutConstraint.deactivate([heightConstraint])
        heightConstraint.constant = self.height
        self.heightConstraint = heightConstraint
        NSLayoutConstraint.activate([heightConstraint])

        UIView.animate(withDuration: 0.4) {
            self.parent?.layoutIfNeeded()
        }
        self.onSizeChange()
    }
    
    public func build(_ parent: UIView) {
        self.parent = parent
        let safeArea = self.parent?.safeAreaInsets
        self.smallSize = (self.parent?.frame.height ?? 0) / 3 + (safeArea?.bottom ?? 0) + (safeArea?.top ?? 0)
        self.mediumSize = (self.parent?.frame.height ?? 0) / 2 + (safeArea?.bottom ?? 0) + (safeArea?.top ?? 0)
        self.largeSize = (self.parent?.frame.height ?? 0) - (safeArea?.top ?? 0)
        self.height = smallSize
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: self.height)
        
        guard let heightConstraint = self.heightConstraint else { return }
        NSLayoutConstraint.activate([heightConstraint])
        self.layer.cornerRadius = 32
        self.backgroundColor = .systemBackground
        self.postbuild()
    }
    
    public func postbuild() {
        
    }
    
    public func onSizeChange() {
        
    }
}
