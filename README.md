
# Todoey ✓ using Realm

## What is Realm?
- `Realm` is a mobile database solution by `MongoDB` designed specifically for mobile applications. It is an object-oriented database that can handle large amounts of data and supports real-time data synchronization across devices. Here's how Realm works:

  - #### Object-oriented approach: 
    - Realm is built around an object-oriented approach, where data is stored as objects rather than rows and columns in a table. This makes it easier to work with data and reduces the need for complex mapping between objects and tables.

  - #### Client-side database: 
    - Realm is a client-side database, which means that it is stored on the device rather than on a remote server. This allows for faster access to data and reduces the dependency on a network connection.

  - #### Reactive architecture: 
    - Realm uses a reactive architecture, which means that it automatically updates data in real-time across all devices. This is achieved through an event-driven approach, where changes made on one device are immediately propagated to all other devices.

  - #### Encryption: 
    - Realm supports encryption of the database, which ensures that the data is secure and protected from unauthorized access. The encryption keys are stored securely in the device's Keychain.

  - #### Cross-platform support: 
    - Realm supports multiple platforms, including iOS, Android, Xamarin, React Native, and Unity. This allows for easy sharing of data between different applications and platforms.

  - #### Integration with popular programming languages: 
    - Realm provides APIs for popular programming languages such as Swift, Objective-C, Java, and Kotlin. This makes it easy to integrate Realm into an existing application or start a new application using Realm.

 - Overall, Realm provides a powerful and easy-to-use database solution for mobile applications, with features such as real-time synchronization, encryption, and cross-platform support.

- https://realm.io/

## Dev Notes

- ### `Cocoapods`
  - I had to completely uninstall `Cocoapods` with Gem running `sudo gem uninstall cocoapods` and reinstall it with `homebrew` running `homebrew install cocoapods` because M1 Macs dont support the old Intel based architecture of the Gem Cocoapods library
  
- ###  Install `RealmSwift` to app
  - In the root project folder, run `pod init`
  - open the podfile running `open Podfile -a Xcode`
  - keep `use_frameworks!`
  - add `pod 'RealmSwift', '>= 10.0.0'`
  - close the pod file and go back to terminal root project folder
  - run `pod install` to install Realm and its dependencies 
  - https://cocoapods.org/pods/RealmSwift

- ### Install `SwipeCellKit` to app
  - same steps as above
  - create a swipable Table View for deleting a cell row with a swip and other functionality
  - https://cocoapods.org/pods/SwipeCellKit

- ### Install `Realm Studio` to local machine
  - Realm Studio is a desktop application to manage Realm database operations
  - Needs to be at `v14.0.2` to be able to run `Realm Studio` and `iOS Simulator` at same time
  - https://studio-releases.realm.io/v14.0.2

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
