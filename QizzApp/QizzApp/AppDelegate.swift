//
//  AppDelegate.swift
//  QizzApp
//
//  Created by zip520123 on 13/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var quiz: Quiz?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let question1 = Question.singleAnswer("What's Mike's nationality?")
        let question2 = Question.multibleAnswer("What are Caio's nationality?")
        let questions = [question1, question2]
        
        let option1 = "Canadian"
        let option2 = "American"
        let option3 = "Greek"
        let options1 = [option1, option2, option3]
        
        let option4 = "Portuguese"
        let option5 = "American"
        let option6 = "Brazilian"
        let options2 = [option4, option5, option6]
        let options =  [question1: options1, question2: options2]
        let correctAnswers = [(question1,[option3]),(question2, [option4, option6]) ]
        let navigationController = UINavigationController()
        let factory = iOSViewControllerFactory(options:options, correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        quiz = Quiz.start(questions: questions, delegate: router, dataSource: router)
        return true
    }


}

