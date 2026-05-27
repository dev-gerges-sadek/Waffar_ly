import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../cubit/music_cubit.dart';
import '../cubit/music_states.dart';
import '../models/music_track.dart';
import '../widgets/music_player_bar.dart';
import '../widgets/music_track_tile.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => MusicCubit(),
        child: const _MusicView(),
      );
}

class _MusicView extends StatefulWidget {
  const _MusicView();
  @override
  State<_MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<_MusicView> {
  final _searchCtrl = TextEditingController();
  final _focusNode  = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    _focusNode.unfocus();
    context.read<MusicCubit>().search(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n      = AppLocalizations.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary   = SHColors.primary(context);
    final surface   = isDark ? SHColors.darkSurfaceColor : SHColors.lightSurfaceColor;

    return Scaffold(
      backgroundColor: SHColors.background(context),
      appBar: ShBackAppBar(title: l10n.music),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 8.h),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _focusNode,
              onSubmitted: _onSearch,
              style: TextStyle(color: textColor, fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: l10n.isArabic
                    ? 'ابحث عن أغاني أو فنانين…'
                    : 'Search songs, artists…',
                hintStyle: TextStyle(color: hintColor, fontSize: 12.sp),
                prefixIcon:
                    Icon(Icons.search_rounded, color: hintColor),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.send_rounded,
                          color: primary, size: 18),
                      onPressed: () => _onSearch(_searchCtrl.text),
                    ),
                    BlocBuilder<MusicCubit, MusicState>(
                      builder: (_, s) =>
                          s is MusicLoaded && !s.isTopCharts
                              ? IconButton(
                                  icon: Icon(Icons.close_rounded,
                                      color: hintColor, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    context.read<MusicCubit>().loadTopCharts();
                                  },
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
                filled: true,
                fillColor: surface,
                contentPadding:
                    EdgeInsetsDirectional.symmetric(horizontal: 14.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Section label ─────────────────────────────────────
          BlocBuilder<MusicCubit, MusicState>(
            builder: (_, s) {
              if (s is! MusicLoaded) return const SizedBox.shrink();
              final label = s.isTopCharts
                  ? (l10n.isArabic ? 'الأكثر استماعاً' : 'TOP CHARTS')
                  : '${l10n.isArabic ? 'نتائج' : 'RESULTS FOR'} "${s.query.toUpperCase()}"';
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    16.w, 0, 16.w, 6.h),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: hintColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Track list ────────────────────────────────────────
          Expanded(
            child: BlocBuilder<MusicCubit, MusicState>(
              builder: (ctx, state) {
                if (state is MusicLoading) return const LoadingView();
                if (state is MusicError) {
                  return ErrorView(
                      icon: Icons.wifi_off_rounded,
                      message: state.message);
                }
                if (state is MusicInitial) {
                  return EmptyStateView(
                    icon: Icons.music_note_rounded,
                    label: l10n.isArabic
                        ? 'جارٍ تحميل الأغاني…'
                        : 'Loading top charts…',
                  );
                }
                if (state is MusicLoaded) {
                  if (state.tracks.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.search_off_rounded,
                      label: l10n.isArabic
                          ? 'لا توجد نتائج لـ "${state.query}"'
                          : 'No tracks found for "${state.query}"',
                    );
                  }
                  return _TrackList(
                    tracks: state.tracks,
                    nowPlayingId: state.nowPlayingId,
                    primary: primary,
                    textColor: textColor,
                    hintColor: hintColor,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // ── Mini player ───────────────────────────────────────
          const MusicPlayerBar(),
        ],
      ),
    );
  }
}

class _TrackList extends StatelessWidget {
  const _TrackList({
    required this.tracks,
    required this.nowPlayingId,
    required this.primary,
    required this.textColor,
    required this.hintColor,
  });

  final List<MusicTrack> tracks;
  final int?   nowPlayingId;
  final Color  primary;
  final Color  textColor;
  final Color  hintColor;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MusicCubit>();
    return ListView.builder(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 16.h),
      itemCount: tracks.length,
      itemBuilder: (_, i) {
        final track = tracks[i];
        return MusicTrackTile(
          track: track,
          isPlaying: nowPlayingId == track.id,
          primary: primary,
          cardColor: SHColors.card(context),
          textColor: textColor,
          hintColor: hintColor,
          onTap: () => cubit.playTrack(track),
        );
      },
    );
  }
}
