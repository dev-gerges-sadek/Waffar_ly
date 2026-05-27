// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/core.dart';
import '../../../core/services/music_service.dart';
import '../../music/models/music_track.dart';
import '../../music/screens/music_screen.dart';

class MusicSwitchers extends StatefulWidget {
  const MusicSwitchers({required this.room, super.key});
  final SmartRoom room;

  @override
  State<MusicSwitchers> createState() => _MusicSwitchersState();
}

class _MusicSwitchersState extends State<MusicSwitchers> {
  late final MusicService _musicService;

  @override
  void initState() {
    super.initState();
    _musicService = GetIt.I<MusicService>();
  }

  void _openMusicScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MusicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = SHColors.text(context);
    final primary = SHColors.primary(context);
    final hintColor = SHColors.hint(context);

    return StreamBuilder<PlayerState>(
      stream: _musicService.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final currentTrack = _musicService.currentTrack;
        final currentTitle =
            currentTrack?.title ?? widget.room.musicInfo.currentSong.title;
        final currentArtist =
            currentTrack?.artist ?? widget.room.musicInfo.currentSong.artist;
        final previewUrl = currentTrack is MusicTrack
            ? currentTrack.previewUrl
            : '';
        final isEnabled = previewUrl.isNotEmpty;

        return SHCard(
          childrenPadding: EdgeInsets.all(12.w),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.music,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _openMusicScreen,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: primary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                SHSwitcher(
                  value: playing,
                  icon: const Icon(SHIcons.music),
                  onChanged: (val) => _musicService.togglePlayPause(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _openMusicScreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: playing ? textColor : hintColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        currentArtist,
                        style: GoogleFonts.montserrat(
                          color: playing ? primary : hintColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MusicBtn(
                      icon: Icons.skip_previous_rounded,
                      enabled: isEnabled,
                      primary: primary,
                      hint: hintColor,
                      onTap: _musicService.previous,
                    ),
                    SizedBox(width: 8.w),
                    _MusicBtn(
                      icon: playing
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      enabled: isEnabled,
                      primary: primary,
                      hint: hintColor,
                      size: 30.sp,
                      onTap: _musicService.togglePlayPause,
                    ),
                    SizedBox(width: 8.w),
                    _MusicBtn(
                      icon: Icons.skip_next_rounded,
                      enabled: isEnabled,
                      primary: primary,
                      hint: hintColor,
                      onTap: _musicService.next,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MusicBtn extends StatelessWidget {
  const _MusicBtn({
    required this.icon,
    required this.enabled,
    required this.primary,
    required this.hint,
    required this.onTap,
    this.size = 22,
  });
  final IconData icon;
  final bool enabled;
  final Color primary;
  final Color hint;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(icon, color: enabled ? primary : hint, size: size),
    );
  }
}
