//
//  Copyright © 2017 Essential Developer. All rights reserved.
//

import UIKit
import QuizEngine

class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var quiz: Quiz?
	
	private lazy var navigationController = UINavigationController()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		
		startNewQuiz()
		
		return true
	}
	
	private func startNewQuiz() {
		let factory = iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
		let router = NavigationControllerRouter(navigationController, factory: factory)
		
		quiz = Quiz.start(questions: questions, delegate: router)
	}
}
