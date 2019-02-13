//
//  CPEnterSurveyViewController.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/20/19.
//  Copyright © 2019 Hasitha. All rights reserved.
//

import UIKit

class CPEnterSurveyViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    var viewmodel : CPEnterSurveyViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CPHelper.roundCorners(_view: btnNext)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        
        CPHelper.showHud()
        viewmodel?.loadQuestions(completion: { (status) in
            CPHelper.hideHud()
            if status{
                CPSurveyManager.shared.surveyViewControllers.removeAll()
                for obj in self.viewmodel!.questionsArray{
                    
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CPQuestionsViewController") as! CPQuestionsViewController
                    controller.viewModel = CPQuestionsViewModel.instance
                    controller.viewModel!.questionObj = obj as! [String : Any]
                    CPSurveyManager.shared.surveyViewControllers.append(controller)
                }
                if CPSurveyManager.shared.surveyViewControllers.count > 0{
                    let navController = UINavigationController.init(rootViewController: CPSurveyManager.shared.surveyViewControllers[0])
                    navController.navigationBar.barTintColor = UIColor(named: "navBlue")
                    navController.navigationBar.isTranslucent = false
                    CPSurveyManager.shared.currentQuestionIndex = 0
                    self.present(navController, animated: true, completion: nil)
                }
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
