# Current-iOS-Challenge
## Fast Foodz

The goal of the assignment is to build a simple app that finds fast food places nearby in 4 popular categories: Burgers, Pizza, Mexican and Chinese. The app is using the user’s location and searches Yelp API to display them in two different views: on the map and in the list. When user selects a place, the app will display driving directions in another screen using Apple’s MapKit API.

<img src="https://github.com/r06921039/Current-iOS-Challenge/blob/main/demo.gif" alt="Demo" width="30%" height="30%"/>

### HomeScreen:
 Once fast food places are fetched, you should show a Home screen which consists of two subscreens: Map and List. Segment control is used to switch between view modes. Last selected mode should be persisted between app launches (map is default).
 
 
<img src="https://github.com/r06921039/Current-iOS-Challenge/blob/main/HomeScreen.png" alt="HomeScreen" width="30%" height="30%"/>
<!-- ![HomeScreen](https://github.com/r06921039/Current-iOS-Challenge/blob/main/HomeScreen.png = 585x1266) -->

### List:
Color icons in places list view based on provided gradient
colors (in Colors.swift file, colors are in top to bottom order).
Imagine a static vertical line colored with evenly distributed gradient colors having the same height as the list view screen. Based on icon’s center Y-axis position in the list, it will take a color on the gradient line, which should be dynamically applied during scrolling.


<img src="https://github.com/r06921039/Current-iOS-Challenge/blob/main/List.png" alt="List" width="30%" height="30%"/>

### Detail:
<img src="https://github.com/r06921039/Current-iOS-Challenge/blob/main/Detail.png" alt="Detail" width="30%" height="30%"/>
