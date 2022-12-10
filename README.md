# Canadian Swiss Army Knife

This is the solution to a final project.

We want to show you how we collaborate on GitHub, using pull requests.

## Team Members

- [Jay (Huajie) Jin](https://github.com/huajiejin)
- [Ravali krishna velpuri](https://github.com/ravalikrishna5121)
- [Tim Jo](https://github.com/tim00vj)
- [Mengcheng Liu](https://github.com/Liuguo320)

## Demo
![Final Project Demo](./Screenshots/Final%20Project%20Demo.gif)

## Requirements

> This group project is the pinnacle of your work in the course. Based on your experience in using mobile phones you must invent your own solution for the any problem that can be solved using iPhone. You will not be limited with the topic of your solution.
>
> In this solution you must have at least three views (screens), connected using navigation controller stack. You must make use of Table, Stack and Collection views in your application. Use of different segues to connect the views is encouraged
>
> Your views must be properly localized and internationalized. No word in code or on the screen can remain in base language (English)
>
> In your application you must use database. Use of CoreData/Sqlite is preferred. You can use Sqlite with any other access mechanism. It is not discouraged.
>
> You must use menus in the application. You can use menus described in Week 9 or Context Menus described in Week 5. Both solutions are equally accepted.
>
> You must use Key Gesture Recognizers to dismiss your keyboards. The use of TextFieldDelegate is also encouraged. Do not be afraid to use both methods
>
> Your screens must also use 6 or more different objects. The container objects (Stack, Table, Collection, Scroll) are not counted towards this.
>
> The use of services as well as the use of maps represent bonus scores. Your assignment score is counted out of 100 and the rubric can give 110 points if fully fulfilled. Therefore, you can score maximum of 22% on 20% project
>
> Dates to remember:
>
> • By midnight of 13/11/2020 you must submit the proposal of your topic fully described. You do not need to delve into technical details of the topics but you must describe your solution and present approximate screens you will have
>
> • By 6 AM on 12/12/2020 you must present the full project for the review

## Proposal

Our proposal for the final project is an iOS application which offers a bunch of small tools, just like what a swiss army knife does.

The following tools are what we have and are connected by Tab Bar Controller:

1. Searching general / specific field questions (powered by google and web view)
2. Unit Converter (using Measurement)
3. Camera
4. Map

The first tool (searching) consists of a searching screen and a results screen. Users can navigate screens back and forth.

In the second tool (unit converter), users can convert units of length. 

The third tool (camera) allows users to preview content from the camera. 

The fourth tool (Map) will show users the map of Waterloo Park.

## How to test the Core Data and Menus related features

- In the search screen
  - Input something in the text field, then click the “Search” button.
  - Switch the APP to background, doing so will save the history by CoreData.
  - Kill the APP.
  - Open the search screen in the APP again, and long press the items in the history table.
  - Click the delete popup, the record should disappear.
- In the unit converter screen
  - Click the “Length” item in the collection view.
  - Input something in any text field, then click the background of the view.
  - Switch the APP to background, doing so will save the history by CoreData.
  - Kill the APP.
  - Open the length unit converter screen in the APP again, and long press the items in the history table.
  - Click the delete popup, the record should disappear.

## How we accomplished the requirements in the rubric

- Use of GUI: Provided 9 controllers in the main storyboard.
  - Tab Bar Controller
    - Navigation Controller
      - SearchViewController
        - SearchResultViewController
      - UnitConverterViewController
        - LengthUnitConverterDetailViewController
        - ViewController (for “Coming soon…” page)
    - CameraViewController
    - MapViewController
- Internationalization: Translated all content that is displayed on screens in French.
- Use of Container views: Used 3+ container views, including TableView, CollectionView, StackView
- Use of Menus: Added the deleting search history and unit conversion history features by using Menus.
- Keyboard and Gesture Recognizers: Disappearing the keyboard has been done in both the search screen and unit converter screen.
- Navigation controller: Implemented in the search screen.
- Use of Core Data: Introduced in both search history and unit conversion history.
- Use of maps and cameras: Done in the CameraViewController and MapViewController.

## Screenshots

![Search Screen](./Screenshots/Final%20Project%201.png)
![Delete Search Record](./Screenshots/Final%20Project%202.png)
![Search Result](./Screenshots/Final%20Project%203.png)
![Search Suggestions Loading From Server](./Screenshots/Final%20Project%204.png)
![Search Suggestions](./Screenshots/Final%20Project%205.png)
![Unit Converter Menu](./Screenshots/Final%20Project%206.png)
![Unit Converter for Length](./Screenshots/Final%20Project%207.png)
![Map for Waterloo Park](./Screenshots/Final%20Project%208.png)
