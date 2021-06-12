//
//  HomeViewConntroller.swift
//  CustomStory
//
//  Created by MD SAZID HASAN DIP on 11/6/21.
//

import UIKit




class HomeViewConntroller: UIViewController {
    
    
    @IBOutlet weak var storyView: ActivityStoryView!
    
    var storyProperties = [ActivityStoryView.StoryProperty]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDidLoad()
    }
    
    
    private func setupViewDidLoad() {
        loadStoryProperties()
    }
    
    private func loadStoryProperties() {
        let avatarImages = ["a1", "a2","a3", "a4","a5", "a6","a7","a1", "a2","a3"]
        
        let names = ["MD SAZID HASAN DIP", "Farhin Islam", "Sharmin Akter", "Nahid Shishir", "Siam Hossain", "Aisha Rahman", "Iftekhar Sanjid", "MD SAZID HASAN DIP", "Farhin Islam", "Sharmin Akter"]
        
        let story1 = ActivityStoryView.Story(image: "s1")
        let story2 = ActivityStoryView.Story(image: "s2")
        let story3 = ActivityStoryView.Story(image: "s3")
        let story4 = ActivityStoryView.Story(image: "s4")
        let story5 = ActivityStoryView.Story(image: "s5")
        let story6 = ActivityStoryView.Story(image: "s6")
        let story7 = ActivityStoryView.Story(image: "s7")

        let storyImages = [[story1], [story2, story3], [story4, story5, story6], [story7], [story1, story2],[story3, story4], [story5, story6],[story7], [story1, story2],[story4]]

        
        
        for i in 0..<10 {
            let story = ActivityStoryView.StoryProperty(title: names[i], avatar: avatarImages[i], story: storyImages[i])
            self.storyProperties.append(story)
        }
        self.storyView.storyProperties = self.storyProperties
    }


}
