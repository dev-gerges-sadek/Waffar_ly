import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/helper_functions.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/music_cubit.dart';
import '../models/music_track.dart';

/// Reusable music player widget
/// Displays: Now playing track, play/pause/stop buttons, progress bar
class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({
    required this.track,
    this.onTrackEnd,
    this.onError,
    super.key,
  });

  final MusicTrack track;
  final VoidCallback? onTrackEnd;
  final Function(String)? onError;

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  @override
  void initState() {
    super.initState();
    // Auto-play track when widget is mounted
    _autoPlayTrack();
  }

  void _autoPlayTrack() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicCubit>().playTrack(widget.track);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MusicCubit>();
    final primary = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── Track Info ───────────────────────────────────────────────────
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.track.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: hintColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // ─── Progress Bar ─────────────────────────────────────────────────
        StreamBuilder<Duration>(
          stream: cubit.positionStream,
          builder: (context, positionSnap) {
            return StreamBuilder<Duration>(
              stream: cubit.durationStream,
              builder: (context, durationSnap) {
                final position = positionSnap.data ?? Duration.zero;
                final duration = durationSnap.data ?? Duration(milliseconds: widget.track.trackTimeMillis);

                return Column(
                  children: [
                    // Progress slider
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.r,
                          elevation: 0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12.r,
                        ),
                      ),
                      child: Slider(
                        value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                        max: duration.inSeconds.toDouble(),
                        activeColor: primary,
                        inactiveColor: primary.withOpacity(0.2),
                        onChanged: (value) {
                          cubit.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    // Time display
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: hintColor,
                            ),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        SizedBox(height: 12.h),

        // ─── Control Buttons ──────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stop button
            _ControlButton(
              icon: Icons.stop_circle_rounded,
              onTap: () => cubit.stop(),
              primary: primary,
              hintColor: hintColor,
            ),
            SizedBox(width: 16.w),

            // Play/Pause button (larger)
            StreamBuilder<void>(
              stream: cubit.onComplete,
              builder: (context, _) {
                return _ControlButton(
                  icon: cubit.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  onTap: () async {
                    if (cubit.isPlaying) {
                      await cubit.pause();
                    } else if (cubit.isPaused) {
                      await cubit.resume();
                    } else {
                      await cubit.playTrack(widget.track);
                    }
                    setState(() {}); // Trigger rebuild for button icon
                  },
                  primary: primary,
                  hintColor: hintColor,
                  size: 36.sp,
                );
              },
            ),
            SizedBox(width: 16.w),

            // Info button
            _ControlButton(
              icon: Icons.info_outline_rounded,
              onTap: () {
                _showTrackInfo(context, widget.track);
              },
              primary: primary,
              hintColor: hintColor,
            ),
          ],
        ),
      ],
    );
  }

  /// Format duration for display (MM:SS)
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Show track info dialog
  void _showTrackInfo(BuildContext context, MusicTrack track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (track.artworkUrl.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: NetworkImage(track.artworkUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 12.h),
              Text('Title', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              Text(track.title, style: TextStyle(fontSize: 11.sp)),
              SizedBox(height: 8.h),
              Text('Artist', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              Text(track.artist, style: TextStyle(fontSize: 11.sp)),
              SizedBox(height: 8.h),
              Text('Album', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              Text(track.album.isEmpty ? 'Unknown' : track.album, style: TextStyle(fontSize: 11.sp)),
              SizedBox(height: 8.h),
              Text('Duration', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
              Text(track.duration, style: TextStyle(fontSize: 11.sp)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Small reusable control button
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.primary,
    required this.hintColor,
    this.size,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color primary;
  final Color hintColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: primary,
          size: size ?? 24.sp,
        ),
      ),
    );
  }
}
