

import UIKit

class StoryFullScreenViewer: UIViewController {
    
    @IBOutlet var closeButton: UIButton! {
        didSet {
            self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet var topTitleLabel: UILabel!
    @IBOutlet var storyImageView: UIImageView! 
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var leftIconImageView: UIImageView!
    @IBOutlet var rightIconImageView: UIImageView!
    @IBOutlet var progressViewHolder: UIView!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        }
    }
    @IBOutlet var prevButton: UIButton! {
        didSet {
            prevButton.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        }

    }
    
    public var storyProperties = [ActivityStoryView.StoryProperty]()
    public var currentViewingStoryIndex = 0
    private var storyImageIndex = 0
//    var storyImageSrc = ""
//    var avatarImageSrc = ""
//    var topTitleText = ""
    var progressTimer = Timer()

    var automaticDissappearAfterSeconds = 5.0
    var timerProgressStartAt = 0.0
    var progressRate = 0.0
    
    var topProgressViews = [UIProgressView]()
    
    private let pangestureVelocity:CGFloat = 1000

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupViewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.progressTimer.invalidate()
        self.currentViewingStoryIndex = 0
        self.storyImageIndex = 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    private func setupViewDidLoad() {
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        self.progressRate = automaticDissappearAfterSeconds/1000
    }

    
    private func setupViewWillAppear() {
        self.avatarImageView.transform = .init(scaleX: 0.70, y: 0.70)
        self.topTitleLabel.transform = .init(scaleX: 0.70, y: 0.70)
        

        self.topTitleLabel.text = self.storyProperties[currentViewingStoryIndex].title
        
        let storiyImages = self.storyProperties[currentViewingStoryIndex].story
        self.storyImageView.image = UIImage(named: storiyImages[0].image)
        self.avatarImageView.image = UIImage(named: self.storyProperties[currentViewingStoryIndex].avatar)
        
        
        
        if currentViewingStoryIndex == 0 {
            self.leftIconImageView.isHidden = true
            self.rightIconImageView.isHidden = false
        }
        else if currentViewingStoryIndex == storyProperties.count - 1 {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = true
        }
        else {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = false
        }
        
        self.timerProgressStartAt = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.transform = .identity
            self.topTitleLabel.transform = .identity

        }
        
        self.initProgressViews()
        self.initTimerProgress()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func initProgressViews() {
        
        for subViews in self.progressViewHolder.subviews {
            subViews.removeFromSuperview()
        }
        self.topProgressViews.removeAll()
        
        let stackView   = UIStackView()
        stackView.axis  = .horizontal
        stackView.contentMode = .scaleAspectFill
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing   = 8.0
        stackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-40, height: 6)
        
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        let storiyImages = self.storyProperties[currentViewingStoryIndex].story
        
        for _ in 0..<storiyImages.count {
            let progressView = UIProgressView()
            progressView.tintColor = .white
            progressView.progress = 0.0
            progressView.contentMode = .scaleAspectFill

            stackView.addArrangedSubview(progressView)
            self.topProgressViews.append(progressView)
        }
        self.progressViewHolder.addSubview(stackView)
    }
    
    
    
    private func updateStoryImages(index: Int) {
        let storiyImages = self.storyProperties[currentViewingStoryIndex].story
        self.storyImageView.image = UIImage(named: storiyImages[index].image)
    }
    
    
    
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextAction() {
        
        let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
        
        if self.currentViewingStoryIndex < storyProperties.count-1 {

            
            if self.storyImageIndex < imagesInCurrentStory.count-1 {
                
                self.topProgressViews[storyImageIndex].progress = 1.0
                
                self.storyImageIndex += 1
                self.timerProgressStartAt = 0.0
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.storyImageIndex = 0
                self.timerProgressStartAt = 0.0
                currentViewingStoryIndex += 1
                UIView.animate(withDuration: 0.2) {
                    self.setupViewWillAppear()
                }
            }

        }
        else {
            if self.storyImageIndex < imagesInCurrentStory.count-1 {
                
            }
            else {
                self.closeButtonAction()
            }
            
        }

    }

    
    @objc func prevAction() {
        
        if self.currentViewingStoryIndex > 0 {
//            self.storyImageIndex = 0
//            currentViewingStoryIndex -= 1
//            UIView.animate(withDuration: 0.2) {
//                self.setupViewWillAppear()
//            }
            
            
//            let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
            if self.storyImageIndex > 0 {
                
                
                self.topProgressViews[storyImageIndex].progress = 0.0
                self.storyImageIndex -= 1
                self.topProgressViews[storyImageIndex].progress = 0.0
                self.timerProgressStartAt = 0.0
                
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.storyImageIndex = 0
                self.timerProgressStartAt = 0.0
                currentViewingStoryIndex -= 1
                UIView.animate(withDuration: 0.2) {
                    self.setupViewWillAppear()
                }
            }

            
        }
    }

    private func initTimerProgress() {
        
        self.progressTimer.invalidate()
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(timerProgressAction), userInfo: nil, repeats: true)
        self.progressTimer.fire()
    }

    
    
    @objc func timerProgressAction() {
        self.countLabel.text = "\(currentViewingStoryIndex+1)\n\(storyImageIndex+1)"
        if timerProgressStartAt > 1.0 {
            //self.closeButtonAction()
            let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
            
            if self.storyImageIndex < imagesInCurrentStory.count-1 {

                self.storyImageIndex += 1
                self.timerProgressStartAt = 0.0
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
                }

                self.timerProgressStartAt += self.progressRate
            }
            else {
//                self.timerProgressStartAt = 0.0
//                self.storyImageIndex = 0
                //self.closeButtonAction()
                
                for progressView in topProgressViews {
                    progressView.progress = 0.0
                }
                                
                self.initProgressViews()
                self.nextAction()
                
            }

        }
        else {
            if storyImageIndex < topProgressViews.count {
                self.topProgressViews[storyImageIndex].progress = Float(timerProgressStartAt)
                self.timerProgressStartAt += self.progressRate
            }


        }

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Finger touched!")
            self.progressTimer.invalidate()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("finger is not touching.")
            self.initTimerProgress()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Touch Move")
            self.progressTimer.invalidate()
        }
    }

}

