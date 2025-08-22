import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerComponent extends StatefulWidget {
  final bool isFullScreen;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;

  const AudioPlayerComponent({
    Key? key,
    this.isFullScreen = false,
    this.onMinimize,
    this.onMaximize,
  }) : super(key: key);

  @override
  State<AudioPlayerComponent> createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String _currentTrack = 'Calm Piano';
  String _currentArtist = 'Sleep Music';
  String _currentImage = 'https://picsum.photos/200';
  bool _isDisposed = false;
  bool _isLoading = true;
  String? _errorMessage;

  // List of meditation tracks
  final List<Map<String, String>> _tracks = [
    {
      'title': 'Calm Piano',
      'artist': 'Sleep Music',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'https://picsum.photos/200',
    },
    {
      'title': 'Rain Sounds',
      'artist': 'Nature',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'image': 'https://picsum.photos/201',
    },
    {
      'title': 'White Noise',
      'artist': 'Ambient',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'image': 'https://picsum.photos/202',
    },
  ];

  int _currentTrackIndex = 0;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    if (_isDisposed) return;
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        if (_isDisposed) return;
        setState(() {
          _isPlaying = state.playing;
        });
      });

      // Listen to position changes
      _audioPlayer.positionStream.listen((position) {
        if (_isDisposed) return;
        setState(() {
          _position = position;
        });
      });

      // Listen to duration changes
      _audioPlayer.durationStream.listen((duration) {
        if (_isDisposed) return;
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });

      // Set initial audio source
      await _loadTrack(_currentTrackIndex);
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _errorMessage = 'Error loading audio: ${e.toString()}';
        });
      }
    } finally {
      if (!_isDisposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTrack(int index) async {
    if (_isDisposed) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final track = _tracks[index];
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(track['url']!)),
      );

      if (!_isDisposed) {
        setState(() {
          _currentTrack = track['title']!;
          _currentArtist = track['artist']!;
          _currentImage = track['image']!;
          _currentTrackIndex = index;
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _errorMessage = 'Error loading track: ${e.toString()}';
        });
      }
    } finally {
      if (!_isDisposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _playPause() async {
    if (_isDisposed) return;
    
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _errorMessage = 'Error playing/pausing: ${e.toString()}';
        });
      }
    }
  }

  void _nextTrack() async {
    if (_isDisposed) return;
    
    int nextIndex = (_currentTrackIndex + 1) % _tracks.length;
    await _loadTrack(nextIndex);
    await _audioPlayer.play();
  }

  void _previousTrack() async {
    if (_isDisposed) return;
    
    int prevIndex = (_currentTrackIndex - 1 + _tracks.length) % _tracks.length;
    await _loadTrack(prevIndex);
    await _audioPlayer.play();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _initAudioPlayer(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: widget.isFullScreen ? _buildFullScreenPlayer() : _buildMiniPlayer(),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              _currentImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentTrack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _currentArtist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: _playPause,
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade800,
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    onPressed: widget.onMinimize,
                  ),
                  const Expanded(
                    child: Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          // Album Art
          Expanded(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _currentImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Track Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Text(
                  _currentTrack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _currentArtist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                  onPressed: _previousTrack,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.blue.shade900,
                      size: 40,
                    ),
                    onPressed: _playPause,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                  onPressed: _nextTrack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
} 