# SplitSpent


![DevChallenge](https://media.licdn.com/dms/image/C4D22AQEeOrY4A_sakQ/feedshare-shrink_800/0/1679494936821?e=1682553600&v=beta&t=H_b5ba4Z7oYGE53Nl0xJVckVJuPGJ47ktHeTZpKH9Fs)


### Task description

The task is to create a user-friendly application that facilitates expense sharing among a group of users. The application should allow users to enter their expenses and sync with other users in the group. The application will then calculate the total expenses incurred by each user and generate a report to show how much money each person owes or is owed.
To achieve this, the application will need to have a user-friendly interface that allows users to easily enter their expenses. The application should also have a feature that allows users to add or remove members from the group, and the ability to create different groups for different trips.

Additionally, at the end of group expenses, the application should be able to generate an expense report that shows each user's total expenses and the amount of money they owe or are owed by other members of the group.
It should be easy to use, and the user interface should be intuitive and simple to navigate. 



### Relesed features:
- Creation and editing of local data (Users, Groups, Transactions) 
- Synchronization between different devices, usability.
- Group report screen, the correctness of expense-sharing algorithm.
- Code quality (kinda).
- Statistic graph.
- Attaching images to transactions .
- Edit existing groups and re-share information about them.
- Currency select for the group on creation.
- Unit test (one).


![Report screen](https://lh3.googleusercontent.com/tPQ0NpaMSwbuY5WOxcC8K_xR0yRuFY_ZR3y82zIl7QApMslnkmLT8KlgnwliyOam2nQ=w240)


Mutual owes have already been calculated and not being displayed

### Limitations:
- Currently, only one user can pay for all in one transaction. There is no validation
- Application responsiveness for big amounts of data (Not tested but it works for a couple of records).

### External frameworks:
- Firebase (FirebaseAuth, FirebaseCore, FirebaseFirestore) (https://github.com/firebase/firebase-ios-sdk)
- Alamofire (https://github.com/Alamofire/Alamofire)
- FormValidator (https://github.com/ShabanKamell/SwiftUIFormValidator)
- FilePicker (https://github.com/markrenaud/FilePicker)


### JSON import:

You can import JSON file in Group List Screen by tapping Import icon

![JSON Import](https://lh5.googleusercontent.com/ujBTlHX6YTe3X2Ry1E1V9zEswAhPfzP8ntwDENytmayLykZAgQNEwoPVHIlftnUKFps=w240)


### Thanks

I want to thank the judges and organizers of the competition for the work done. I was very accept this challenge and get a lot of invaluable experience while completing the assignment!
