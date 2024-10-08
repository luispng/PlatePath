//
//  SceneDelegate.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/13/24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let newWindow = UIWindow(frame: windowScene.screen.bounds)
        newWindow.windowScene = windowScene

        let browseView = CategoriesView()
        let browseViewController = UIHostingController(rootView: browseView)
        browseViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 0)

        let desertMealsGridView = MealGridListView(category: "Dessert")
        let desertMealsGridViewController = UIHostingController(rootView: desertMealsGridView)
        desertMealsGridViewController.tabBarItem = UITabBarItem(title: "Dessert", image: UIImage(systemName: "carrot.fill"), tag: 1)

        let mealSearchView = SearchView()
        let mealSearchViewController = UIHostingController(rootView: mealSearchView)
        mealSearchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [browseViewController, desertMealsGridViewController, mealSearchViewController]

        // Set the TabBarController as the root view controller
        newWindow.rootViewController = tabBarController
        newWindow.makeKeyAndVisible()
        window = newWindow
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

