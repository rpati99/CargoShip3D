//
//  ViewController.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 12/04/21.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    
    // MARK: - Properties
    
    private var scnView: SCNView!
    private var baseNode: SCNNode!
    private var startValue = 0
    private let endValue = 3
    private let transition = CircularTransition()
    
    
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 70)
        label.text = "Welcome"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 50)
        label.text = "1000 ships found"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Go!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setDimensions(width: 60, height: 60)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        return button
    }()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureScene()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(count))
        displayLink.preferredFramesPerSecond = 2
        displayLink.add(to: .current, forMode: .default)
        view.addSubview(nextButton)
        nextButton.alpha = 0
        nextButton.centerX(inView: view)
        nextButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
    }

    // MARK: - Selectors
    
    @objc private func handleNextButton() {
        let vc = ShipDetailsViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc private func count(displayLink: CADisplayLink) {
        detailsLabel.text = "\(startValue) ships found"
        startValue += 1
        if startValue > endValue {
            detailsLabel.text = "\(endValue) ships found"
        }
    }
    
    
    
    // MARK: - Helpers
    
    private func configureScene() {
        let scene = SCNScene(named: "cargo1.dae")
        
        scnView = SCNView()
                view.addSubview(scnView)
        

        scnView.frame = view.frame
        scnView.backgroundColor = .clear
        
        
        baseNode = scene?.rootNode.childNode(withName: "Group001", recursively: false)!
        baseNode.scale = SCNVector3(1.5, 1.5, 1.5)
        scnView.scene?.rootNode.addChildNode(baseNode)
        scnView.scene = scene
        
        let rotation1 = SCNAction.rotateBy(x: -0.14, y: 3.35, z: 0, duration: 10)
        let rotation2 = SCNAction.rotateBy(x: 0.5, y: 0, z: 0.5, duration: 5)
        let rotation3 = SCNAction.rotateBy(x: -0.5, y: 0, z: -0.5, duration: 5)
        let transform = SCNAction.scale(to: 0.9, duration: 10)
        let move = SCNAction.move(by: SCNVector3(-1000, 0, 0), duration: 10)
        
        baseNode.runAction(move)
        baseNode.runAction(rotation1)
        baseNode.runAction(rotation2)
        baseNode.runAction(transform)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.baseNode.runAction(rotation3)
            UIView.animate(withDuration: 5) {
                self.nextButton.alpha = 1
            }
        }
        
        
    }
    
    
    private func setupUI() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Ocean")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.frame

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.1, 1.0]
        view.layer.addSublayer(gradient)
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 50)
        welcomeLabel.centerX(inView: view)

        view.addSubview(detailsLabel)
        detailsLabel.centerX(inView: view)
        detailsLabel.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 20)
        


    }
    


}


// MARK: - UIViewControllerTransitioningDelegate methods


extension ViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.currentMode = .present
        transition.startingPoint = nextButton.center
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.currentMode = .dismiss
        transition.startingPoint = nextButton.center
        return transition
    }
}
