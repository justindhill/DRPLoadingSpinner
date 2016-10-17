# DRPLoadingSpinner ![Preview image](http://imgur.com/cUbeItF.gif)

DRPLoadingSpinner is a neat little loading spinner. It's pretty
configurable, so you can achieve a variety of effects. Check out
`src/DRPLoadingSpinner.h` for all the configurable properties.
Even though it's quite configurable, DRPLoadingSpinner is easy
to get started with. Here's a snippet of creating one with default
settings:

```objc
    DRPLoadingSpinner *spinner = [[DRPLoadingSpinner alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
	[self.view addSubview:spinner];
	[spinner startAnimating];
```

Done! See? That was easy. You can even use DRPLoadingSpinner as a drop-in replacement for UIRefreshControl. Check out its sibling, DRPRefreshControl.

```objc
    DRPRefreshControl *refreshControl = [[DRPRefreshControl alloc] init];
    [refreshControl addToScrollView:self.scrollView target:self action:@selector(refreshTriggered:)];
```
Bam! Now you've got a snazzy refresh control in just a couple lines of code.

<p align="center">
  <img src="http://imgur.com/WQcgqdf.gif" width="320" />
</p>

### Installing
Installing couldn't be easier. Just `pod 'DRPLoadingSpinner'` and away you go! If you're not the CocoaPods type, you can always just add the contents of the `src` directory to your project and get building!

### Contributing
Have something to add? Fork this repo and then submit a pull request. I'm always happy to check them out.
