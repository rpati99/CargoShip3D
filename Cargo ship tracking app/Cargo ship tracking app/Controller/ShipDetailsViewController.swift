//
//  ShipDetailsViewController.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 23/04/21.
//

import UIKit
import SceneKit

class ShipDetailsViewController: UIViewController  {
    
    var scnView: SCNView!
    var baseNode: SCNNode!
    var details: [Detail]!
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 60)
        label.text = "Discover \nmore Vessels"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = .black

        return label
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ContainerCell.self, forCellWithReuseIdentifier: "cellid")
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()

   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureScene()
        configureCollectionView()

    }
    


    
    // MARK: - API
    
   
    private func readLocalFile(forName name: String, completion: @escaping(Container?) -> ())  {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"), let data = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let jsonData = try JSONDecoder().decode(Container.self, from: data)
                completion(jsonData)
            }
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Helpers
    
    private func configureScene() {
        let scene = SCNScene(named: "cargo1.dae")
        scnView = SCNView()
        view.addSubview(scnView)
        scnView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 150)
        scnView.backgroundColor = .clear
        baseNode = scene?.rootNode.childNode(withName: "Group001", recursively: false)!
        baseNode.scale = SCNVector3(1.5, 1.5, 1.5)
        scnView.scene?.rootNode.addChildNode(baseNode)
        scnView.scene = scene
        
        let rotation = SCNAction.rotateBy(x: 0.15, y: 0.5, z: 0, duration: 5)
        let transform = SCNAction.scale(to: 0.75, duration: 5)
        let move = SCNAction.move(by: SCNVector3(-2500, 0, 0), duration: 5)
        baseNode.runAction(rotation)
        baseNode.runAction(transform)
        baseNode.runAction(move)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let mov = SCNAction.rotateBy(x: -0.1  , y: 0.2 , z: 0, duration: 30)
            self.baseNode.runAction(mov)
        }
    }

    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: view.frame.height * 0.55)
        
        readLocalFile(forName: "ContainerAPI") { (container) in
            guard let container = container else { return}
            let detail = container.route.details
            self.details = detail
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

        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16 )

        let cloud = UIImageView(frame: CGRect(x: 0, y: 105, width: 200, height: 200))
        cloud.contentMode = .scaleAspectFill
        cloud.image = UIImage(named: "Cloud")
        view.addSubview(cloud)
        
        let anime = CABasicAnimation(keyPath: "position.x")
        anime.duration = 20
        anime.toValue = view.frame.width + 200
        cloud.layer.add(anime, forKey: nil)
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.duration = 30
        opacity.toValue = 0
        cloud.layer.add(opacity, forKey: nil)
      
    }
}



