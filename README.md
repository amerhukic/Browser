<p align="center">
<img src="https://raw.githubusercontent.com/amerhukic/Browser/main/Logo.png" width="420" max-width="80%" alt="Logo" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5-orange.svg" />
    <a href="">
        <img src="https://img.shields.io/badge/Licence-MIT-green.svg" alt="License">
    </a>
    <a href="https://twitter.com/hukicamer">
        <img src="https://img.shields.io/badge/contact-%40hukicamer-blue.svg?style=flat" alt="Twitter: @hukicamer" />
    </a>
</p>

This project showcases the implementation of the redesigned Safari app UI on iOS 15. It features keyboard animations, collapsing and expanding toolbar animations and animation for creating new tabs. 

<p align="center">
<img src="https://raw.githubusercontent.com/amerhukic/Browser/main/Demo.gif" width="380" max-width="80%"/>
</p>

## Project structure

The UI of the project is composed of 2 main parts:
1. `BrowserContainerViewController` which is a container view controller that contains all the UI elements - address bars, toolbar and tabs.
2. `BrowserTabViewController` which contains the web view and handles logic related to it.

The `BrowserContainerViewController` class is the main class that acts like a container for tabs, toolbar and address bars and handles all the animation logic.
When the app starts, a new tab is created and address bar are created and set into the default mode where both show its empty state.

## Animations
### Keyboard

When the keyboard appears the currently active address bar will be shifted up together with a hidden background view that blends into the keyboard. The hidden background view gives the effect of a keyboard that is taller and the address bar being part of the keyboard. When the keyboard appears the address bars on each side are also hidden by animating their center and pushing them off of the visible screen.
The animation is implemented by listening to the `keyboardWillHideNotification` and `keyboardWillShowNotification` notifications and animating the constraints change.

### New tab

A new tab can be created when all the tabs have loaded a website. In that case the user can swipe to the last tab on the right side and then swipe one more time
to trigger the animation and create a new tab.

The animation works the following way:

1. Whenever a tab loads a website we check if the tab is the last tab and if it is we create a new hidden tab and address bar on the right side.
2. When the user starts swiping from left to right the scrolling of the underlying scroll view begins and the animation starts.
3. Based on the content offset and address bar page width we calculate the percentage of the completed animation and using that we set the content offset of the scroll view that holds the tabs with web views. Since the page width of the address bar scroll view is lower than the page width of the tabs scroll view setting the content offset of the tabs scroll view will give the effect that the tabs are scrolling faster than the address bars and thus creating the required animation.
4. Based on the address bar scroll view content offset we also animate the hidden address bar that is appearing from the right side. The address bar's alpha is animated based on the percentage of the completed animation. The address bar width is set to a fixed width until the content offset reaches a treshold, after which the width constraint of the address bar is updated and thus creating the animation of the address bar stretching.
5. When the user stops scrolling/dragging we use the final content offset to calculate at what tab index the scrolling will end. If it ends at the last tab (in our case it is the hidden tab that we are animating) then we finish the animation by hiding the overlay with + sign and showing the new address bar. We also animate the appearance of the new tab view controller that holds the web view.

The new tab animation was implemented by tracking the address bar scroll view state using `UIScrollViewDelegate`. Animations were implemented by updating constraints and the final animation was implemented using regular `UIView.animate()` API. 

### Hiding toolbar

The toolbar with address bar at the bottom can be collapsed when the user swipes down on the web view. The toolbar can also be expanded when the user swipes up. 

The animation works the following way:

1. We track the pan gesture of the web view's scroll view to determine the distance that the finger was traveling while dragging the web view.
2. Based on the distance we determine whether the user is swiping up or down. 
3. If the user is swiping down we start the first part of toolbar collapsing animation where we start hiding the toolbar and lowering the alpha of the address bars. The first part of the collapsing animation will finish when the swiping offset reaches a treshold. After the treshold is reached the animation completes and the toolbar fully collapses, the alpha of the address bars reaches 0, the address bars are flattened using a transformation animation and the label that shows the domain is scaled down using a transformation.
4. If the user is swiping down and releases the finger before the collapsing animation reaches the treshold for full completion then the animation is reversed and the toolbar gets back into the original expanded state.
5. If the user is swiping up and the toolbar was in the collapsed state then the animation for expansion starts. It works the same way as the collapsing animation. In the first part of the animation the address bar and toolbar are moving up until a treshold is reached. After the treshold is reached the animation completes and the toolbar fully expands, the alpha of the address bars reaches 1, the address bars and domain label are restored to their previous state by reverting the transformation animation.
6. If the user is swiping up and releases the finger before the expanding animation reaches the treshold for full completion, then the animation is reversed and the toolbar gets back into the original collapsed state.

These animations were implemented using `UIViewPropertyAnimator`s. There are 4 animators:
1. Collapsing state animator - this animator starts the first part of the collapsing animation and in the completion block it completes the second part of the collapsing animation.
2. Revert collapsing animator - this animator is used when the user starts the collapsing animation but doesn't complete it and lifts his finger.
3. Expanding state animator - this animator starts the first part of the expanding animation and in the completion block it completes the second part of the expanding animation.
4. Revert expanding animator - this animator is used when the user starts the expanding animation but doesn't complete it and lifts his finger.

The `UIViewPropertyAnimator`'s `fractionComplete` property is used for managing the completion of each animator.
For animations we used constraints for moving the toolbar and address bars up and down, alpha for fading in and out and transforms for scaling the address bars and domain label.
The implementation of this feature is described in more detail [on my blog](https://www.amerhukic.com/implementing-the-safari-toolbar-collapsing-and-expanding-animation-on-ios-15).

## Author

[Amer Hukić](https://amerhukic.com)

## License

Browser is licensed under the MIT license. Check the [LICENSE](LICENSE) file for details.
