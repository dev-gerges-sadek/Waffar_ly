// ignore_for_file: deprecated_member_use
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/features/home/presentation/widgets/background_room_lights.dart';
import '../../../../features/devices/screens/room_devices_screen.dart';
import '../../../../features/smart_room/screens/room_details_screen.dart';
import '../../../core.dart';
import 'shimmer_arrows.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.percent,
    required this.room,
    required this.expand,
    required this.onSwipeUp,
    required this.onSwipeDown,
    required this.onTap,
    super.key,
  });

  final double percent;
  final SmartRoom room;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      tween: Tween(begin: 0, end: expand ? 1 : 0),
      builder: (_, value, _) => Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: lerpDouble(.85, 1.2, value),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 180),
              child: BackgroundRoomCard(room: room, translation: value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: Transform(
              transform: Matrix4.translationValues(0, -90 * value, 0),
              child: GestureDetector(
                onTap: onTap,
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -10) onSwipeUp();
                  if (details.primaryDelta! > 10) onSwipeDown();
                },
                child: Hero(
                  tag: room.id,
                  flightShuttleBuilder: (_, animation, _, _, _) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) => Material(
                        type: MaterialType.transparency,
                        child: RoomDetailItems(
                          animation: animation,
                          topPadding: MediaQuery.of(context).padding.top,
                          room: room,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      ParallaxImageCard(imageUrl: room.imageUrl, parallaxValue: percent),
                      VerticalRoomTitle(room: room),
                      CameraIconButton(room: room),
                      const AnimatedUpwardArrows(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedUpwardArrows extends StatelessWidget {
  const AnimatedUpwardArrows({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const ShimmerArrows(),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 4,
            width: 120,
            decoration: BoxDecoration(
              color: textColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraIconButton extends StatelessWidget {
  const CameraIconButton({super.key, required this.room});
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RoomDevicesScreen(room: room)),
          ),
          icon: Icon(Icons.devices_outlined, color: textColor),
          tooltip: 'View Devices',
        ),
      ),
    );
  }
}

class VerticalRoomTitle extends StatelessWidget {
  const VerticalRoomTitle({required this.room, super.key});
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: RotatedBox(
        quarterTurns: -1,
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 40.h, right: 20.h, top: 12.w),
            child: Text(
              room.name.replaceAll(' ', ''),
              maxLines: 1,
              style: TextStyle(
                fontSize: 42.sp,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
