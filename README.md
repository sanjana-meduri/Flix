# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **6** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] User can view the large movie poster by tapping on a cell. (They can see the movie trailer.)
- [x] Customize the selection effect of the cell. (set to no selection effect)
- [x] Customize the navigation bar. (dark mode and changed icons)
- [x] Customize the UI. (dark mode)
- [x] Run your app on a real device.
- [ ] All images fade in as they are loading.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] User can view the app on various device sizes and orientations.


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would have liked to implement a settings option that can change the app from Dark Mode to Light Mode and change the language of the app.
2. I want to change how I implemented the CollectionView to include some sort of tag on each cell, so that I can search in the Grid View as well.

## Video Walkthrough

The first GIF simulates good user connection, while the second GIF starts out with no Internet connection and then refreshes with the Internet connection restored.

<img src='./flix1comp.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' width=200 height=500 />
<img src='./flix2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' width=200 height=500 />


GIF created with [Kap](https://getkap.co/).

## Notes

I can use this project as a reference for:

- setting up a Table View
    
    - put TableView in storyboard
    - create outlet
    - put necessary "roles" in <> next to ViewController title
    - implement 2 necessary methods
    - reloadData on didLoad
    
- creating a Network Request
- using CocoaPods 

    - in repository, `pod init`
    - `open Podfile` and add what you need
    - `pod install`
    - use the .xcworkspace file from now on to open project

- good ImageView settings

    - Content Mode: Aspect Fill
    - Clip to Bounds should be checked
    
- pull to refresh featuer

    - using UIRefreshControl
    
- create segue (used show segue to create movie detail screen)

- navigation segue method to pass information between two view controllers (remember that what you want to pass between them has to go in the header file)

- create a basic loading screen (`UIActivityIndicator`)

- create an alert using `UIAlertController`

- create a CollectionView (very similar process to TableView) and configuring layout

- creating a WebView
    
## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
