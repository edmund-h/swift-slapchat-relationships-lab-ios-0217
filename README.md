# SlapChat

Let's make an app where you can create messages that persist in Core Data.

## Objectives

1. Set up core data model (`.xcdatamodeld`) from scratch.
2. Configure boilerplate code for data store to interact with Core Data / SQLite database.
3. Learn basics of fetching/saving with Core Data.

## Instructions

Open up the project. We've set up a blank tableview controller and started `DataStore`. Your job is to setup Core Data, display your persistent `Message` objects, and add an interface where users can create and save new messages.

### Core Data Setup

Before we work on any views, we need to prepare our models for Core Data. This part has much more 'explaining' than 'coding', but it's important! So **soak up the knowledge.**

##### Data Model

1. First, let's create our data model (`.xcdatamodeld`). Create a new file, select the "Core Data" section on the left, then choose "Data Model". Usually we give this the same name as our project, so let's name it "SlapChat".

2. Go to your new **.xcdatamodeld** file and create an entity (*"Add Entity" button near the bottom*) and name it `Message`. Give it two attributes: `content` (String) and `createdAt` (Date, though this is stored in Core Data as an `NSDate`). A singular name is used for each entity (e.g., `Message` rather than `Messages`), even if we know we're going to have multiples of the entity later on. This is because we're really dealing with *multiple entities*, each entity being its own instance of a `NSManagedObject` subclass. Wouldn't it be weird to say we're going to set the `content` of a `Messages`?

Our `.xcdatamodeld` is set up, so now let's prepare `DataStore` so that it can fetch/save with Core Data. 

##### Data Store

1. Check out `DataStore.swift`. We've set a few things up for you: a singleton called `sharedInstance`, a private initializer, a `persistentContainer`, and the function `saveContext()`. The last two of these actually come prebuilt in your `AppDelegate` when you create a new project and specify the use of Core Data. It's common practice to move them to a Data Store, however, for better organization of your code.

2. Your task is to setup `fetchData()`.
   - This is Data*Store*, so add an `Array` property on this class to hold your fetched objects. Name it `messages`.
   - Implement `fetchData()` to create an `NSFetchRequest`, have your context `fetch` it, set the results to your `messages` array, and sort `messages` by their creation dates.

> Hint: The context is retrieved by calling `persistentContainer.viewContext`.
 
That's it! Your model and data store are now ready to fetch and save `Message`s.

### A Little More Setup

##### Making Test Messages

1. We can't display messages if we haven't created any! Let's do this in `TableViewController`.   
	- Create a `store` property to hold your Data Store's `sharedInstance`. 
	- In `viewDidLoad()`, use `Message(context:)` to create a few `Message`s.
	- Don't forget to set your test messages' `content` and `createdAt` properties!
2. Now is when you'd want to `saveContext()` so that these messages would persist in our database. BUT, since this is in `viewDidLoad()`, that means that we'd be creating and saving new messages *every time we run our app*. Let's add some logic to prevent that.
    - Make a new method called `generateTestData()`. Dump all your message creation in there, and make your dataStore `saveContext()` and `fetchData()` at the end. The reason we `fetchData()` here is to ensure the `messages` property on our `store` singleton is completely up-to-date.
    - In `viewDidLoad()`, `fetchData()`.
    - Logic time - if the messages array attached to your `store` is still empty, call `generateTestData()` to fill it up.

3. Run it a couple times and either `print()` or breakpoint/`po` your local messages array to make sure you're not saving a ton of duplicates. Assuming all went well, we can finally get some stuff on the screen!

### View Time (Finally)
*Less talk; more walk.*

##### Messages TableView
- Set your cell style to `Basic` and its reuse identifier to `messageCell`.
- Set up your data source. Make each cell display the `content` of its corresponding message.

Run it to make sure it works. Comment out your `generateTestData()` check to *prove* that the messages are actually persisting. Revel in your persistent data's glory. 

##### 'Add Message' Interface

Let's keep rollin' with our theme of "just do it":

  1. Add a plus button to the navigation bar and link it to a new view controller. Name the class `AddMessageViewController`.
  2. Add a save button and a text field. When you tap save, make it:
     -  create a new message with the contents of the text field,
     -  save the context,
     -  dismiss the view controller.
  3. Cool! Except the new message didn't show up in our tableView... In your tableView controller, override `viewWillAppear()` so that it fetches data and reloads the tableView.   
  4. Give it another shot. When the `AddMessageViewController` is dismissed, your tableView will display the new message.

#### Congratulations, you made an app with a persistent data store!

## Extra Credit

  1. Add a button that resorts the messages in the array to descending by the `createdAt` property.
  2. Take your `generateTestData()` method out of `TableViewController` and put it where it belongs (`DataStore`).

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/swift-slapchat-lab' title='SlapChat'>SlapChat</a> on Learn.co and start learning to code for free.</p>
