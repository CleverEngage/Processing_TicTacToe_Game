/**
 ** Timer Class
 ** version 1.0
 ** by Abdullah Al-Sabbagh
 **
 ** USAGE: To control drawing and animation flow by
 **  two types of timers; 
 **    1 - on delay timer: if the timer triggered and 
 **      time in millis is met the onDely() will return true
 **    2 - off delay timer: if the timer triggered the offDely() 
 **      return true and after some time in millis the function will 
 **      return false    
 ** VERSIONS:
 **   1: 02-01-2017: First released
 */

class Timer {
  int targetInterval;
  int type;    // 0: For millis - 1: For frameCount
  boolean isTimerTriggerd;

  Timer() {
    reset();
  }

  void reset() {
    targetInterval = 0;
    type = -1;
    isTimerTriggerd = false;
  }

  void setMillisIntervalFor(int milliSecond) {
    targetInterval = millis() + milliSecond;
    isTimerTriggerd = true;
    type = 0;
  }

  void setFrameCountIntervalFor(int frames) {
    targetInterval = frameCount + frames;
    isTimerTriggerd = true;
    type = 1;
  }

  boolean doesIntervalExpired() {
    switch(type) {
      // for millis
    case 0:
      return (millis()   >= targetInterval);
      // for frameCount
    case 1:
      return (frameCount >= targetInterval);
    default:
      return false;
    }
  }

  boolean onDelay() {
    if (isTimerTriggerd && doesIntervalExpired()) {
      reset();
      return true;
    }
    return false;
  }

  boolean offDelay() {
    if (isTimerTriggerd && !doesIntervalExpired()) {
      return true;
    }
    reset();
    return false;
  }
}