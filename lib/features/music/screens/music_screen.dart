// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/music_cubit.dart';
import '../cubit/music_states.dart';
import '../widgets/music_track_tile.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MusicCubit(),
      child: const _MusicView(),
    );
  }
}

class _MusicView extends StatefulWidget {
  const _MusicView();

  @override
  State<_MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<_MusicView> {
  final _searchCtrl = TextEditingController();
  int? _playingId;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    if (q.trim().isEmpty) return;
    context.read<MusicCubit>().search(q);
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = SHColors.background(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);
    final cardColor = SHColors.card(context);
    final surface   = isDark
        ? SHColors.darkSurfaceColor
        : SHColors.lightSurfaceColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor:
            isDark ? SHColors.darkBackgroundColor : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Music',
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textColor),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────
          Padding(
            padding:
                EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: _onSearch,
              style: TextStyle(color: textColor, fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: 'Search songs, artists…',
                hintStyle:
                    TextStyle(color: hintColor, fontSize: 12.sp),
                prefixIcon:
                    Icon(Icons.search_rounded, color: hintColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send_rounded,
                      color: primary, size: 18),
                  onPressed: () => _onSearch(_searchCtrl.text),
                ),
                filled: true,
                fillColor: surface,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide:
                      BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Results ─────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<MusicCubit, MusicState>(
              builder: (context, state) {
                if (state is MusicLoading) {
                  return Center(
                      child: CircularProgressIndicator(color: primary));
                }

                if (state is MusicError) {
                  return _ErrorView(
                      message: state.message, hintColor: hintColor);
                }

                if (state is MusicInitial) {
                  return _EmptyView(hintColor: hintColor);
                }

                if (state is MusicLoaded) {
                  if (state.tracks.isEmpty) {
                    return _EmptyView(hintColor: hintColor);
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        16.w, 4.h, 16.w, 24.h),
                    itemCount: state.tracks.length,
                    itemBuilder: (_, i) {
                      final track = state.tracks[i];
                      return MusicTrackTile(
                        track:      track,
                        isPlaying:  _playingId == track.id,
                        primary:    primary,
                        cardColor:  cardColor,
                        textColor:  textColor,
                        hintColor:  hintColor,
                        onTap: () =>
                            setState(() => _playingId = track.id),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hintColor});
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note_rounded, size: 52, color: hintColor),
          SizedBox(height: 12.h),
          Text('Search for songs above',
              style: TextStyle(color: hintColor, fontSize: 13.sp)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.hintColor});
  final String message;
  final Color  hintColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 44, color: hintColor),
            SizedBox(height: 12.h),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: hintColor, fontSize: 13.sp)),
          ],
        ),
      ),
    );
  }
}
