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
