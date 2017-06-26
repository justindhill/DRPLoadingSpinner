### 1.3.0
* Added ability to set the rotation direction of the spinner
* Fixed background rail does not hide when animation is stopped

### 1.2.1
* Changed a use of CGFLOAT_MAX to HUGE_VALF in to fix an undefined behavior warning in Xcode 9
* Thanks to @hankinsoft for this fix!

### 1.1.1
* Updated the summary and description

### 1.1.0
* Added the ability to set the timing function of the draw cycle. This allows you to have more control over the subtlety or loudness of the animation.
* Added a background rail and the ability to set its color. This defaults to clear, so your existing animations won't be affected.

### 1.0.2
* Silenced a noisy log message

### 1.0.1
* No code changes, just updated some inaccurate documentation

### 1.0.0
* Added DRPRefreshControl
* A few more rendering fixes

### 0.2.0
* Added ability to independently set the minimum arc length and the maximum arc length
* Fixed buggy rendering

### 0.1.0
* Re-wrote rendering to use Core Animation instead of CADisplayLink to get some performance wins
* Known bug: Buggy rendering will occur if drawCycleDuration is set to less than half of rotationCycleDuration
