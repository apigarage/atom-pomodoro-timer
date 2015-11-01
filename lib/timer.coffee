module.exports = PomodoroApp =
class Timer
  DEBUG: true
  # Keeps track of the timer's current state
  timerStateEnum:
    default : 'default'
    running : 'running'
    paused : 'paused'
  startTime: null     # Initial time
  tick: null          # The interval inbetween times to calculate the change in time
  minutes: null       # The total amount of miniutes left
  container: null     # The container to be used for the timer display
  milliseconds: null  # Time remaining in milliseconds
  timerState: null    # Current state of the timer

  constructor: (minutes, container) ->
    @timerState = @timerStateEnum.default
    @minutes = minutes
    @milliseconds = minutes * 60 * 1000         # Remaining time in milliseconds
    @container = container

  # Starts the timer
  activate: =>
    @startTime = new Date().getTime()           # Set the initial time
    @container.textContent = @minutes + ":00"
    @tick = setInterval(@increment, 500)        # Start the timer

  # Pauses the timer
  pause: =>
    @milliseconds = @increment()                # Save the remaining time
    clearInterval(@tick)                        # Stops the timer from ticking

  # Resumes the timer
  resume: =>
    @startTime = new Date().getTime()           # Reset the initial time
    @tick = setInterval(@increment, 500)        # Start ticking again

  # Increases
  increment: =>
    # Calculate new time remaining
    now = Math.max(0, @milliseconds-(new Date().getTime()-@startTime))
    minute = Math.floor(now/60000)
    second = Math.floor(now/1000)%60
    # 5 seconds will be 05 seconds
    second = (if second < 10 then "0" else "") + second
    @container.textContent = minute + ":" + second
    if ( now == 0 ) # Stop if no time remains, recursive
      clearInterval(@tick)
      @timerState = @timerStateEnum.default
    return now

  # Used to restore the timer to the default state
  reset: =>
    clearInterval(@tick)
    @container.textContent = @minutes + ":00"
    @milliseconds = @minutes * 60 * 1000
    @timerState = @timerStateEnum.default
    if @DEBUG then console.log "Timer "+ @timerState

  toggle: =>
    if @timerState is @timerStateEnum.default
        @timerState = @timerStateEnum.running
        @activate()
    else if @timerState is @timerStateEnum.paused
        @timerState = @timerStateEnum.running
        @resume()
    else
        @timerState = @timerStateEnum.paused
        @pause()
    if @DEBUG then console.log "Timer "+ @timerState

  getState: =>
    return @timerState
