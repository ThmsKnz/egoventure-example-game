# Boombox - a singleton audio player framework
extends Node


# The volume to fade to if the channel should be off
const VOLUME_MIN = -80

# The volume to fade to if hte channel should be on
const VOLUME_MAX = 0


# Emited when a sound effect completed playing
signal effect_finished


# Let Boombox ignore game pausing. So all sound will continue
# playing when a game is paused
var ignore_pause: bool: set = _set_ignore_pause


# The fader used for fading music
var _music_fader: Tween

# The fader used for fading background sounds
var _background_fader: Tween

# The queue of music to fade
var _music_queue: Array = []

# The queue of backgrounds to fade
var _background_queue: Array = []

# A flag that tells the music is stopping. Cancel events that are waiting
# for the tween to finish
var _music_is_stopping: bool = false

# enum for Music or Background fader 
enum {FADER_MUSIC, FADER_BACKGROUND}


# The active music player
@onready var active_music: AudioStreamPlayer = $Music1

# The active background player
@onready var active_background: AudioStreamPlayer = $Background1


# Create the tweens
func _ready():
	_music_fader = create_tween()
	_music_fader.stop()
	_background_fader = create_tween()
	_background_fader.stop()


# Check the queues and start the fades
func _process(_delta):
	if _music_queue.size() > 0 and not _music_fader.is_running():
		if not active_music.playing:
			var target = _music_queue.pop_front()
			active_music.stream = target.music
			active_music.play(target.from_position)
		else:
			var fade_to = $Music2
			if active_music == $Music2:
				fade_to = $Music1
			var target = _music_queue.pop_front()
			_music_fader = _fade(
				active_music, 
				fade_to, 
				target.music,
				target.from_position,
				EgoVenture.configuration.tools_music_fader_seconds,
				FADER_MUSIC
			)
	
	if _background_queue.size() > 0 and not _background_fader.is_running():
		if not active_background.playing:
			var target = _background_queue.pop_front()
			active_background.stream = target.background
			active_background.play(target.from_position)
		else:
			var fade_to = $Background2
			if active_background == $Background2:
				fade_to = $Background1
			var target = _background_queue.pop_front()
			_background_fader = _fade(
				active_background,
				fade_to,
				target.background,
				target.from_position,
				EgoVenture.configuration.tools_background_fader_seconds,
				FADER_BACKGROUND
			)


# Reset the settings. Stop all music, sounds and backgrounds
# Used when starting a new game
func reset():
	$Music1.stop()
	$Music2.stop()
	if active_music != $Music1:
		active_music = $Music1
	$Background1.stop()
	$Background2.stop()
	if active_background != $Background1:
		active_background = $Background1
	#_music_fader.reset_all()
	#_background_fader.reset_all()
	$Effects.stop()
	_reset_background_volume()
	_reset_music_volume()


# Play a new music file, if it isn't the current one.
#
# ** Parameters**
#
# - music: An audiostream of the music to play
func play_music(music: AudioStream, from_position: float = 0.0):
	if not active_music.playing or \
			(
				not _music_queue.has(music) and \
				not active_music.stream == music
			):
		_music_queue.append({
			"music": music,
			"from_position": from_position
		})


# Pause playing music
func pause_music():
	active_music.stream_paused = true


# Resume playing music
func resume_music():
	active_music.stream_paused = false
	

# Stop the currently playing music
func stop_music():
	_music_is_stopping = true
	if _music_fader:
		_music_fader.stop()
	_music_queue = []
	$Music1.stop()
	$Music2.stop()
	active_music = $Music1
	_reset_music_volume()
	

# Get the current music
func get_music() -> AudioStream:
	if _music_fader.is_running():
		if active_music == $Music1:
			return $Music2.stream
		else:
			return $Music1.stream
	return active_music.stream
	
	
# Get wether boombox is currently playing music
func is_music_playing() -> bool:
	return active_music.playing
	

# Play a background effect
#
# ** Parameters **
#
# - background: An audiostream of the background noise to play
func play_background(background: AudioStream, from_position: float = 0.0):
	if not active_background.playing or \
			(
				not _background_queue.has(background) and \
				not active_background.stream == background
			):
		_background_queue.append({
			"background": background,
			"from_position": from_position
		})


# Pause playing background effect
func pause_background():
	active_background.stream_paused = true
	
	
# Resume playing background effect
func resume_background():
	active_background.stream_paused = false


# Stop playing a background effect
func stop_background():
	if _background_fader:
		_background_fader.stop()
	_background_queue = []
	$Background1.stop()
	$Background2.stop()
	active_background = $Background1
	_reset_background_volume()
	


# Get the current background
func get_background() -> AudioStream:
	if _background_fader.is_running():
		if active_background == $Background1:
			return $Background2.stream
		else:
			return $Background1.stream
	return active_background.stream


# Get wether boombox is currently playing background
func is_background_playing() -> bool:
	return active_background.playing


# Play a sound effect
#
# ** Parameters **
#
# - effect: An audiostream of the sound effect to play
#   make sure it's set to "loop = false" in the import settings
func play_effect(effect: AudioStream, from_position: float = 0.0):
	if $Effects.playing:
		$Effects.stop()
	
	$Effects.stream = effect
	$Effects.play(from_position)


# Pause playing the sound effect
func pause_effect():
	$Effects.stream_paused = true


# Resume playing the sound effect
func resume_effect():
	$Effects.stream_paused = false


# Stop playing a sound a effect
func stop_effect():
	$Effects.stop()


# React to ignore_pause
func _set_ignore_pause(value: bool):
	ignore_pause = value
	if ignore_pause:
		process_mode = Node.PROCESS_MODE_ALWAYS
		$Music1.process_mode = Node.PROCESS_MODE_ALWAYS
		$Music2.process_mode = Node.PROCESS_MODE_ALWAYS
		$Background1.process_mode = Node.PROCESS_MODE_ALWAYS
		$Background2.process_mode = Node.PROCESS_MODE_ALWAYS
		$Effects.process_mode = Node.PROCESS_MODE_ALWAYS
		if _background_fader:
			_background_fader.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		if _music_fader:
			_music_fader.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	else:
		process_mode = Node.PROCESS_MODE_PAUSABLE
		$Music1.process_mode = Node.PROCESS_MODE_PAUSABLE
		$Music2.process_mode = Node.PROCESS_MODE_PAUSABLE
		$Background1.process_mode = Node.PROCESS_MODE_PAUSABLE
		$Background2.process_mode = Node.PROCESS_MODE_PAUSABLE
		$Effects.process_mode = Node.PROCESS_MODE_PAUSABLE
		if _background_fader:
			_background_fader.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
		if _music_fader:
			_music_fader.set_pause_mode(Tween.TWEEN_PAUSE_STOP)


# Emit effect_finished signal
func _on_Effects_finished():
	emit_signal("effect_finished")


# Fade a channel
#
# #### Parameters
#
# - fade_from: Fade from this channel
# - fade_to: Fade to this channel
# - stream: Stream to play on the fade_to channel
# - time: Time to take to fade
# - type: music or background fader
#
# #### Returns
#
# - Tween
func _fade(
	fade_from: Node, 
	fade_to: Node, 
	stream: AudioStream, 
	from_position: float,
	time: float, 
	type: int
) -> Tween:
	
	fade_to.stream = stream
	fade_to.play(from_position)
	
	var fader = create_tween()
	if type == FADER_MUSIC:
		fader.connect(
			"finished", self._handle_music_tween_completed
		)
	elif type == FADER_BACKGROUND:
		fader.connect(
			"finished", self._handle_background_tween_completed
		)
	
	fader.tween_property(
		fade_from,
		"volume_db",
		VOLUME_MIN,
		time
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	fader.tween_property(
		fade_to,
		"volume_db",
		VOLUME_MAX,
		time
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	fader.play()
	
	return fader


# Reset the music volume
func _reset_music_volume():	
	$Music1.volume_db = VOLUME_MAX
	$Music2.volume_db = VOLUME_MIN


# Reset the background volume
func _reset_background_volume():
	$Background1.volume_db = VOLUME_MAX
	$Background2.volume_db = VOLUME_MIN


# Handle a completed music tween
func _handle_music_tween_completed():
	var fade_to = $Music2
	if active_music == $Music2:
		fade_to = $Music1
	
	active_music.stop()
	active_music = fade_to


# Handle a completed background tween
func _handle_background_tween_completed():
	var fade_to = $Background2
	if active_background == $Background2:
		fade_to = $Background1
	
	active_background.stop()
	active_background = fade_to
