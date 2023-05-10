
# Todoey ✓ using Realm

### Dev Notes
- Cocoapods
  - I had to completely uninstall `Cocoapods` with Gem running `sudo gem uninstall cocoapods` and reinstall it with `homebrew` running `homebrew install cocoapods` because M1 Macs dont support the old Intel based architecture of the Gem Cocoapods library

## Our Goal


The objective of this tutorial is to understand how to save data in iOS. We'll look at various choices and learn to use UserDefaults, Core Data and Realm.

## Data Management in iOS

- ### What are the different options for Data Management in iOS?

![data-mamangement](https://raw.githubusercontent.com/kawgh1/Todoey-iOS13/master/iOS%20Data.png)

There are several options for data management in iOS, depending on the requirements and complexity of the application. Some of the most common options are:

- ### UserDefaults: 
  - UserDefaults is a simple and lightweight option for storing small amounts of data, such as user preferences or settings. It uses key-value pairs to store data, and the data is stored in a property list format.

- ### SQLite: 
  - SQLite is a popular relational database that can be used for iOS apps. It is a serverless, self-contained database that can be embedded into an app. SQLite can handle large amounts of data and supports complex queries and transactions.

- ### Core Data: 
  - Core Data is an object graph and persistence framework provided by Apple. It can be used to manage the storage of app data in a SQLite database, XML, or binary format. Core Data provides features such as versioning, undo and redo, and automatic object graph management.

- ### Realm: 
  - Realm is a mobile database designed specifically for mobile applications. It is an object-oriented database that can handle large amounts of data, and supports real-time data synchronization across devices.

- ### Firebase: 
  - Firebase is a cloud-based platform that provides a variety of services, including a real-time database, authentication, and analytics. The Firebase Realtime Database is a NoSQL cloud database that can be used to store and sync data between clients in real time.

Overall, the choice of data management option depends on the specific requirements of the application, such as the amount and complexity of the data, the need for synchronization, and the scalability requirements.

- from ChatGPT



## NSPredicate

### What is NSPredicate?

NSPredicate is a class in the Foundation framework of Apple's programming language, Objective-C, and Swift. It represents a query or search condition used to filter and search collections of objects, such as an array or a Core Data database.

![nspredicate](https://raw.githubusercontent.com/kawgh1/Todoey-iOS13/master/NSPredicate%20Cheat%20Sheet.png)

https://academy.realm.io/posts/nspredicate-cheatsheet/

- ### NSPredicate objects allow you to define rules for matching objects based on a set of conditions. 
  - These conditions can range from simple comparisons (e.g., "name == 'John'") to complex logical expressions that combine multiple conditions using logical operators (e.g., "age > 25 AND state == 'NY'").

NSPredicate can be used in a variety of contexts, including:

- Filtering an array of objects based on specific criteria.
- Searching a Core Data database for objects that match a set of criteria.
- Specifying constraints for a fetch request in Core Data.
- Defining rules for a smart playlist in iTunes.
- Specifying conditions for a notification in Apple's Notification Center framework.

Overall, NSPredicate provides a powerful and flexible way to filter and search collections of objects in Objective-C and Swift.

- from ChatGPT



A todolist app to keep track of all your tasks.
