//
//  ShipDetailsViewController.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 23/04/21.
//

import UIKit
import SceneKit


extension URL {
      func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
}

class ShipDetailsViewController: UIViewController  {
    
    
    private var scnView: SCNView!
    private var baseNode: SCNNode!
    private var details: [Detail]!
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "InsaniburgerwithCheese", size: 60)
        label.text = "Discover \nmore Vessels"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = .black

        return label
    }()
    
    
    private lazy var collectionView: UICollectionView = {
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



// MARK: -  UICollectionViewDelegate & UICollectionViewDataSource methods

extension ShipDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ContainerCell
        cell.containerInfo = details[indexPath.row]
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells {
                UIView.animate(withDuration: 0.2) {
                    cell.layer.position.y += 100
                } completion: { (true) in
                        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.5, initialSpringVelocity: 1.0, options: [.curveEaseOut]) {
                            cell.layer.position.y -= 100
                    }
                }
            }
        }
    }
}

