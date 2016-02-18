### 0.1.0
* Re-wrote rendering to use Core Animation instead of CADisplayLink to get some performance wins
* Known bug: Buggy rendering will occur if drawCycleDuration is set to less than half of rotationCycleDuration
