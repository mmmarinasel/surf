import UIKit

class MainView: UIView {
    
    private weak var parent: UIView? = nil
    private var heightConstraint: NSLayoutConstraint? = nil
    private var height: CGFloat = 200
    
    private enum Direction {
        case up
        case down
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
    
    @objc private func didSwipeUp(_ sender: UISwipeGestureRecognizer) {
        self.resize(.up)
    }
    
    @objc private func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.resize(.down)
    }
    
    private func resize(_ direction: Direction) {
        guard var heightConstraint = self.heightConstraint else { return }
        self.removeConstraint(heightConstraint)
        if direction == .up {
            self.height += 200
        } else {
            self.height -= 200
        }
        heightConstraint = self.heightAnchor.constraint(equalToConstant: self.height)
        NSLayoutConstraint.deactivate([heightConstraint])
        heightConstraint.constant = self.height
        self.heightConstraint = heightConstraint
        NSLayoutConstraint.activate([heightConstraint])

        UIView.animate(withDuration: 0.5) {
            self.parent?.layoutIfNeeded()
        }
    }
    
    public func build(_ parent: UIView) {
        self.parent = parent
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
        self.backgroundColor = .green
    }
}
