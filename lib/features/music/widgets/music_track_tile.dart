// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/music_track.dart';

class MusicTrackTile extends StatelessWidget {
  const MusicTrackTile({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.primary,
    required this.cardColor,
    required this.textColor,
    required this.hintColor,
    required this.onTap,
  });

  final MusicTrack track;
  final bool       isPlaying;
  final Color      primary;
  final Color      cardColor;
  final Color      textColor;
  final Color      hintColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isPlaying ? primary.withOpacity(0.10) : cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isPlaying ? primary.withOpacity(0.40) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: track.artworkUrl.isEmpty
                  ? Container(
                      width: 50.w,
                      height: 50.w,
                      color: primary.withOpacity(0.2),
                      child:
                          Icon(Icons.music_note, color: primary, size: 24),
                    )
                  : Image.network(
                      track.artworkUrl,
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 50.w,
                        height: 50.w,
                        color: primary.withOpacity(0.2),
                        child: Icon(Icons.music_note, color: primary),
                      ),
                    ),
            ),
            SizedBox(width: 12.w),

            // Title + artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? primary : textColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.sp, color: hintColor),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Duration + play icon
            Column(
              children: [
                Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying ? primary : hintColor,
                  size: 26.sp,
                ),
                SizedBox(height: 3.h),
                Text(
                  track.duration,
                  style: TextStyle(
                      fontSize: 9.sp, color: hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
