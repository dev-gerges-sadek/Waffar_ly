// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../features/smart_room/cubit/smart_room_cubit.dart';
import '../../../../features/smart_room/cubit/smart_room_states.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/entities/smart_room.dart';
import '../../../theme/sh_colors.dart';
import '../../../../features/devices/screens/room_devices_screen.dart';

/// Draggable bottom sheet that filters rooms by name and navigates on tap.
class RoomSearchSheet extends StatelessWidget {
  const RoomSearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SmartRoomCubit>()..loadRooms(),
      child: const _RoomSearchSheetBody(),
    );
  }
}

class _RoomSearchSheetBody extends StatefulWidget {
  const _RoomSearchSheetBody();

  @override
  State<_RoomSearchSheetBody> createState() => _RoomSearchSheetBodyState();
}

class _RoomSearchSheetBodyState extends State<_RoomSearchSheetBody> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? SHColors.darkCardColor : SHColors.lightCardColor;
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scroll) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 0),
        child: Column(
          children: [
            _Handle(hintColor: hintColor),
            SizedBox(height: 16.h),
            Text(
              l10n.searchRooms,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            _SearchField(
              ctrl: _ctrl,
              hintText: l10n.searchRoomHint,
              hintColor: hintColor,
              textColor: textColor,
              isDark: isDark,
              primary: primary,
              onChanged: (q) => setState(() => _query = q.toLowerCase().trim()),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SmartRoomCubit, SmartRoomState>(
                builder: (_, state) => switch (state) {
                  SmartRoomLoading() || SmartRoomInitial() => Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                  SmartRoomError() => Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: hintColor),
                    ),
                  ),
                  SmartRoomLoaded() => _RoomList(
                    rooms: state.rooms,
                    query: _query,
                    scroll: scroll,
                    textColor: textColor,
                    hintColor: hintColor,
                    primary: primary,
                    l10n: l10n,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Room list with inline filter ──────────────────────────────────────────────

class _RoomList extends StatelessWidget {
  const _RoomList({
    required this.rooms,
    required this.query,
    required this.scroll,
    required this.textColor,
    required this.hintColor,
    required this.primary,
    required this.l10n,
  });

  final List<SmartRoom> rooms;
  final String query;
  final ScrollController scroll;
  final Color textColor;
  final Color hintColor;
  final Color primary;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty
        ? rooms
        : rooms.where((r) => r.name.toLowerCase().contains(query)).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(l10n.noRoomsFound, style: TextStyle(color: hintColor)),
      );
    }

    return ListView.separated(
      controller: scroll,
      itemCount: filtered.length,
      separatorBuilder: (_, _) =>
          Divider(color: hintColor.withOpacity(0.15), height: 1),
      itemBuilder: (_, i) => _RoomTile(
        room: filtered[i],
        textColor: textColor,
        hintColor: hintColor,
        primary: primary,
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Handle extends StatelessWidget {
  const _Handle({required this.hintColor});
  final Color hintColor;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: hintColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    ),
  );
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.ctrl,
    required this.hintText,
    required this.hintColor,
    required this.textColor,
    required this.isDark,
    required this.primary,
    required this.onChanged,
  });

  final TextEditingController ctrl;
  final String hintText;
  final Color hintColor;
  final Color textColor;
  final Color primary;
  final bool isDark;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    onChanged: onChanged,
    autofocus: true,
    textDirection: TextDirection.ltr,
    style: TextStyle(color: textColor),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor),
      prefixIcon: Icon(Icons.search, color: hintColor),
      filled: true,
      fillColor: isDark
          ? SHColors.darkSurfaceColor
          : SHColors.lightSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    ),
  );
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({
    required this.room,
    required this.textColor,
    required this.hintColor,
    required this.primary,
  });

  final SmartRoom room;
  final Color textColor;
  final Color hintColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context);

    return ListTile(
      contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 4.w, vertical: 4.h),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.asset(
          room.imageUrl,
          width: 52.w,
          height: 52.w,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: 52.w,
            height: 52.w,
            color: primary.withOpacity(0.2),
            child: Icon(Icons.home, color: primary),
          ),
        ),
      ),
      title: Text(
        l10n.roomLabel(room.name),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 14.sp,
        ),
      ),
      subtitle: Text(
        '${room.temperature.toInt()}° · ${l10n.humidity} ${room.airHumidity.toInt()}%',
        style: TextStyle(color: hintColor, fontSize: 11.sp),
      ),
      trailing: Icon(
        isRtl ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
        size: 14,
        color: hintColor,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomDevicesScreen(room: room)),
        );
      },
    );
  }
}
