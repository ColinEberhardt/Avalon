#Avalon - MVVM for iOS

This project is currently a work-in-progress, and something I hope will grow into a fully-fledged MVVM framework for iOS Developers.

## Why MVVM? and why Avalon?

In short, because I think it is the best pattern for *any* UI development! The pattern itself is quite simple, you place your logic within view models, then rely on a framework to wire-up the view model  and your UI controls, keeping the two synchronised. That is the purpose of Avalon, it is the layer of glue between your view models and you view.

## OK, show me some code!

As I mentioned, this is a work-in-progress and is not documented. If you want to see Avalon in action, the best place to start is the `Examples` folder:

 + **ColorPicker** - a really simple app that highlights how Avalon synchronises the view model and view state. Take a look at the various UI controls within the storyboard, the Attributes Inspector reveals how they are bound to the view.
 + **SwiftWeather** - a pretty, yet simple, app (courtesy of [Jake Lin](https://github.com/JakeLin/SwiftWeather)) modified to use Avalon. Note, this uses Cocoapods.
 + **SwiftPlaces** - a more complex app (courtesy of [Josh Smith](https://github.com/ijoshsmith/swift-places)) modified to use Avalon. Shows things like table view binding. This app also shows that view models expose more than just state (i.e. properties), sometimes you need to use events. This concept is something I only recently introduced.
  + **KitchenSink** - have a guess? ;-)