//
//  ActivityStoryView.swift
//  CustomStory
//
//  Created by MD SAZID HASAN DIP on 11/6/21.
//

import UIKit

protocol ActivityStoryViewDelegate {
    func tappedOnStoryAt(indexPath: IndexPath, fullScreenViewController: StoryFullScreenViewer)
}


@IBDesignable
class ActivityStoryView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    struct StoryProperty {
        let title: String
        let avatar: String
        let story: [Story]
    }

    struct Story {
        let image: String
    }
    
    
    private let storyViewNibName = "ActivityStoryView"
    private let storyCollectionnViewCellID = "StoryCollectionnViewCell"
    
    
    public var storyProperties = [StoryProperty]()
    public var delegate: ActivityStoryViewDelegate?
    
    let storyFullScreenViewer = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(identifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed(storyViewNibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        //contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: storyCollectionnViewCellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: storyCollectionnViewCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
     }
    
    private func proceedToFullView(indexPath: IndexPath) {
        let destinationVC = storyFullScreenViewer
//        destinationVC.topTitleText = storyProperties[indexPath.item].title
//        destinationVC.avatarImageSrc = storyProperties[indexPath.item].avatar
//        destinationVC.storyImageSrc = storyProperties[indexPath.item].story
        destinationVC.storyProperties = storyProperties
        destinationVC.currentViewingStoryIndex = indexPath.item
        
        let currentController = getCurrentViewController()
        currentController?.present(destinationVC, animated: true, completion: nil)

    }



}


extension ActivityStoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyProperties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCollectionnViewCellID, for: indexPath) as? StoryCollectionnViewCell else {
            fatalError("can't dequeue StoryCollectionnViewCell")
        }
        cell.avatarImageView.image = UIImage(named: storyProperties[indexPath.item].avatar)
        cell.storyImageView.image = UIImage(named: storyProperties[indexPath.item].story[0].image)
        
        return cell
    }
}

extension ActivityStoryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.tappedOnStoryAt(indexPath: indexPath, fullScreenViewController: storyFullScreenViewer)
        //print("tapped on: \(indexPath.item)")
        
        self.proceedToFullView(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoryCollectionnViewCell {
                cell.transform = .init(scaleX: 0.80, y: 0.80)
                //cell.contentView.backgroundColor = UIColor.systemBlue
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? StoryCollectionnViewCell {
                cell.transform = .identity
                //cell.contentView.backgroundColor = .clear
            }
        }
    }
}

extension ActivityStoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellHeight = self.contentView.frame.size.height
        return CGSize(width: cellHeight*(2.0/3.4), height: cellHeight)
    }

    
}


