# DRPLoadingSpinner

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

Done! See? That was easy.

<p align="center">
  <img src="http://zippy.gfycat.com/RealExcitableBoubou.gif" width="320" />
</p>
