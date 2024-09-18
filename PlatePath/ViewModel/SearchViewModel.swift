//
//  MealSearchViewModel.swift
//  PlatePath
//
//  Created by Luis Paniagua on 9/17/24.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false
    @Published var isTyping: Bool = false
    @Published var errorMessage: String? = nil

    private let mealService: MealServiceProtocol
    private var searchTask: Task<Void, Never>? // Store the last search task
    private var searchDispatchItem: DispatchWorkItem? // Search debouncer

    init(mealService: MealServiceProtocol = MealService()) {
        self.mealService = mealService
    }

    func performSearch(debounce: Bool = false) {
        guard !searchTerm.isEmpty else {
            clearSearch()
            return
        }

        self.isTyping = true
        self.searchDispatchItem?.cancel() // cancel any ongoing debouncer tasks

        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.executeSearch(with: self.searchTerm)
            self.isTyping = false
        }
        self.searchDispatchItem = dispatchWorkItem

        if !debounce {
            dispatchWorkItem.perform() // Execute immediately
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: dispatchWorkItem) // Debounce by 0.5 seconds
        }
    }

    func performPendingSearchNow() {
        // execute pending search
        if isTyping {
            self.searchDispatchItem?.perform() // Execute pending items immediately
            self.searchDispatchItem?.cancel() // Cancel to prevent double execution
        }
    }

    private func executeSearch(with searchString: String) {
        guard !searchTerm.isEmpty else {
            clearSearch()
            return
        }

        self.searchTask?.cancel() // cancel any pending search tasks

        self.isLoading = true
        self.errorMessage = nil

        self.searchTask = Task {
            do {
                let fetchedMeals = try await mealService.getMeals(search: searchString)
                await updateUIWithResults(fetchedMeals, searchTerm: searchString)
            } catch is CancellationError {
                // Handle cancellation if needed (silent failure)
            } catch {
                await updateUIWithError(error)
            }
        }
    }

    private func clearSearch() {
        self.searchDispatchItem?.cancel()
        self.searchDispatchItem = nil // Explicitly set to nil after canceling
        self.searchTask?.cancel()
        self.meals = []
        self.errorMessage = nil
        self.isLoading = false
        self.isTyping = false
    }

    @MainActor
    private func updateUIWithResults(_ fetchedMeals: [Meal], searchTerm: String) {
        self.meals = fetchedMeals
        self.isLoading = false
        self.isTyping = false
        self.errorMessage = fetchedMeals.isEmpty ? "No results found for \"\(searchTerm)\"" : nil
    }

    @MainActor
    private func updateUIWithError(_ error: Error) {
        self.errorMessage = "Failed to fetch meals: \(error.localizedDescription)"
        self.isLoading = false
        self.isTyping = false
    }
}
