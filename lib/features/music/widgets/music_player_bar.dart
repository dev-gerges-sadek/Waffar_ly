// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/music_cubit.dart';
import '../cubit/music_states.dart';
import '../models/music_track.dart';

/// Persistent mini-player bar — shown at screen bottom when a track is loaded.
class MusicPlayerBar extends StatelessWidget {
  const MusicPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCubit, MusicState>(
      buildWhen: (p, c) => c is MusicLoaded || p is MusicLoaded,
      builder: (context, state) {
        final cubit   = context.read<MusicCubit>();
        final track   = cubit.nowPlaying;
        final playing = cubit.isPlaying;

        if (track == null) return const SizedBox.shrink();

        final primary   = SHColors.primary(context);
        final card      = SHColors.card(context);
        final text      = SHColors.text(context);
        final hint      = SHColors.hint(context);
        final onPrimary = Theme.of(context).colorScheme.onPrimary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsetsDirectional.fromSTEB(12.w, 0, 12.w, 8.h),
          padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: primary.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: SHColors.shadow(context),
                blurRadius: 16,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              _TrackArt(track: track, primary: primary, size: 44.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: text),
                    ),
                    Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.sp, color: hint),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => cubit.playTrack(track),
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                      color: primary, shape: BoxShape.circle),
                  child: Icon(
                    playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: onPrimary,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => cubit.stopPlayback(),
                child: Icon(Icons.stop_rounded, color: hint, size: 22.sp),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackArt extends StatelessWidget {
  const _TrackArt({
    required this.track,
    required this.primary,
    required this.size,
  });

  final MusicTrack track;
  final Color      primary;
  final double     size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: track.artworkUrl.isEmpty
          ? Container(
              width: size,
              height: size,
              color: primary.withOpacity(0.2),
              child: Icon(Icons.music_note, color: primary, size: size * 0.5),
            )
          : Image.network(
              track.artworkUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: size,
                height: size,
                color: primary.withOpacity(0.2),
                child: Icon(Icons.music_note, color: primary),
              ),
            ),
    );
  }
}
