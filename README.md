# DRPLoadingSpinner ![Preview image](http://imgur.com/0cLpUM3.gif)

DRPLoadingSpinner is a neat little loading spinner. It's pretty
configurable, so you can achieve a variety of effects. Check out
`src/DRPLoadingSpinner.h` for all the configurable properties.
Even though it's quite configurable, DRPLoadingSpinner is easy
to get started with. Here's a snippet of creating one with default
settings:

```objc
DRPLoadingSpinner *spinner = [[DRPLoadingSpinner alloc] init];
[self.view addSubview:spinner];
[spinner startAnimating];
```

<br/>

Done! See? That was easy. You can even use DRPLoadingSpinner as a drop-in replacement for UIRefreshControl. Check out its sibling, DRPRefreshControl.

```objc
DRPRefreshControl *refreshControl = [[DRPRefreshControl alloc] init];
[refreshControl addToScrollView:self.scrollView target:self action:@selector(refreshTriggered:)];
```
Bam! Now you've got a snazzy refresh control in just a couple lines of code. Refresh controls can be added to UITableViewControllers and, in iOS 10, any UIScrollView or UIScrollView subclass. You can use either a callback block or a target-action to get notified that a refresh has been triggered.

<br/>

<p align="center">
  <img src="http://imgur.com/WQcgqdf.gif" width="320" />
</p>

### Installing
Installing couldn't be easier. Just install the Pod and away you go! If you're not the CocoaPods type, you can always just add the contents of the `src` directory to your project and get building!
```ruby
pod install 'DRPLoadingSpinner'
```

### Customizing
There are a handful of things you can customize on your loading spinner:
* *Color sequence*: DRPLoadingSpinner has the opportunity to change color every time it goes around. You can define what colors appear and in which order. When the end of the sequence is reached, it loops back to the beginning.
  * To define a single color, just set colorSequence to an array with just one color, like: `loadingSpinner.colorSequence = @[ UIColor.grayColor ];`
```objc
loadingSpinner.colorSequence = @[ UIColor.cyanColor, UIColor.magentaColor, UIColor.yellowColor, UIColor.blackColor ];
```

* *Line width:* You can change the thickness of the line drawn when the spinner is spinning:
```objc
loadingSpinner.lineWidth = 3; // a pretty thick line.
```

* *Minimum and maximum arc length:* As the spinner is spinning, it expands and contracts. You can define how long it gets as its longest and how short it gets at its shortest. This is measured in radians - don't forget the handy `M_PI` family of constants!
```objc
loadingSpinner.maximumArcLength = (2 * M_PI) - M_PI_4; // line will get as long as 7/8 the circumference of the circle
loadingSpinner.minimumArcLength = 0; // line will completely disappear at its shortest.
```

* *Rotation cycle duration:* As the spinner is expanding and contracting, it also spins about its center. The rotation cycle duration is how long it would take to make a complete revolution if left interrupted. It's a CFTimeInterval, so it's measured in seconds!
```objc
loadingSpinner.rotationCycleDuration = 2; // a short and pretty noticeable rotation
```

* *Draw cycle duration:* Draw cycle duration is the length of time taken up by any period of expansion or contraction of the line. Time taken by expansion and contraction are always equal. I find that it's quite pleasant to look at if rotationCycleDuration and drawCycleDuration are multiples of one another.
```objc
loadingSpinner.drawCycleDuration = 1;
```

### Handy APIs
* `-startAnimating` and `-stopAnimating` do exactly what their names suggest.
* `-isAnimating` will tell you whether or not the spinner is currently animating. Nifty!

### Contributing
Have something to add? Fork this repo and then submit a pull request. I'm always happy to check them out.
