//
//  AppDelegate.swift
//  QizzApp
//
//  Created by zip520123 on 13/11/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit
import QuizEngine
import SwiftUI
class QuizAppStore {
    var quiz: Quiz?
}

@main
struct QuizApp: App {
    let appStore = QuizAppStore()
    
    @StateObject var navigationStore = QuizNavigationStore()
    var body: some Scene {
        WindowGroup {
            QuizNavigationView(store: navigationStore)
                .onAppear(perform: {
                    startANewQuiz()
                })
        }
    }
    
    private func startANewQuiz() {

        let adapter = iOSSwiftUINavigationAdapter(navigation: navigationStore, options:options, correctAnswers: correctAnswers, playAgain: startANewQuiz)
        
        appStore.quiz = Quiz.start(questions: questions, delegate: adapter, dataSource: adapter)
    }
}

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var quiz: Quiz?

    private lazy var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        startANewQuiz()
        
        return true
    }

    fileprivate func startANewQuiz() {
        
        let factory = iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(questions: questions, delegate: router, dataSource: router)
    }
}

let question1 = Question.singleAnswer("What's Mike's nationality?")
let question2 = Question.multibleAnswer("What are Caio's nationality?")
let question3 = Question.singleAnswer("What's the capital of Brazil?")

let questions = [question1, question2, question3]

let option1 = "Canadian"
let option2 = "American"
let option3 = "Greek"
let options1 = [option1, option2, option3]

let option4 = "Portuguese"
let option5 = "American"
let option6 = "Brazilian"
let options2 = [option4, option5, option6]

let option7 = "Sao Paulo"
let option8 = "Rio de Janeiro"
let option9 = "Brasilia"
let options3 = [option7, option8, option9]

let options =  [question1: options1, question2: options2, question3: options3]
let correctAnswers = [
    (question1,[option3]),
    (question2, [option4, option6]) ,
    (question3, [option9])]

struct BasicQuiz {
    let quesions: [Question<String>]
    let options: [Question<String> : [String]]
    let correctAnswers: [Question<String>: [String]]
}
