//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    private(set) var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    private(set) var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    private static let tasksKey = "tasks_storage_key"

    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        do {
                    let data = try JSONEncoder().encode(tasks)
                    UserDefaults.standard.set(data, forKey: tasksKey)
                } catch {
                    print("Failed to encode tasks: \(error)")
                }
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else {

        return [] // 👈 replace with returned saved tasks
    }
        
        do {
                   let tasks = try JSONDecoder().decode([Task].self, from: data)
                   return tasks
               } catch {
                   print("Failed to decode tasks: \(error)")
                   return []
               }
    }

    // Add a new task or update an existing task with the current task.
    func save() {

        var allTasks = Task.getTasks()

                if let index = allTasks.firstIndex(where: { $0.id == self.id }) {
                    // Update existing task
                    allTasks[index] = self
                } else {
                    // Append new task
                    allTasks.append(self)
                }

                Task.save(allTasks)
    }
}
