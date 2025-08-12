import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/achivements/AchivementsWidget.dart';
import 'dart:async';
import 'dart:collection';

import 'package:jci_app/features/auth/AuthWidgetGlobal.dart'; // Import for Queue

class TopSnackbar {
  static final Queue<
      UserObjectifInfos> _infosQueue = Queue(); // Queue to hold items
  static OverlayEntry? _overlayEntry; // Current overlay entry
  static Timer? _timer; // Timer for auto-dismiss
  static ScrollController? _scrollController; // ScrollController to detect scroll events

  static void show(List<UserObjectifInfos> infos,
      BuildContext context, {
        Duration duration = const Duration(
            seconds: 2), // Default duration is 5 seconds
        ScrollController? scrollController, // Optional ScrollController
      }) {
    // Add all infos to the queue
    _infosQueue.addAll(infos);

    // Set the scroll controller
    _scrollController = scrollController;

    // Listen to scroll events if a ScrollController is provided
    if (_scrollController != null) {
      _scrollController!.addListener(_onScroll);
    }

    // Start showing the first item
    _showNext(context, duration);
  }

  static void _showNext(BuildContext context, Duration duration) {
    if (_infosQueue.isEmpty) {
      dismiss(); // Stop if the queue is empty
    }

    // Get the next info from the queue
    final info = _infosQueue.removeFirst();

    // Create an OverlayEntry for the current info
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            top: MediaQuery
                .of(context)
                .viewPadding
                .top + 10, // Position at the top with padding
            left: 10,
            right: 10,
            child: Material(
              color: Colors.transparent, // Transparent background
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    AchievementWidget(
                      userObjectif: info.userObjectif,
                      objectif: info.objectif,
                      isExpanded: ValueNotifier(false),
                      memberid: "",
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.textColorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the value for more or less roundness
                        ),
                      ),
                      onPressed: dismiss, // Dismiss on button press
                      child: Text(
                          'Dismiss', style: PoppinsRegular(14, PrimaryColor)),
                    )
                  ],
                ),
              ),
            ),
          ),
    );

    // Insert the overlay into the Overlay
    Overlay.of(context).insert(_overlayEntry!);

    // Set a timer to remove the overlay after the specified duration
    _timer = Timer(duration, () {
      dismiss(); // Dismiss the overlay when the timer completes
    });
  }

  static void _onScroll() {
    if (_scrollController != null) {
      // Check if the user is scrolling up
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        dismiss(); // Dismiss the snackbar
      }
    }
  }

  static void dismiss() {
    // Avoid duplicate dismiss logic
    if (_overlayEntry == null && _timer == null) return;

    // Cancel any active timer
    _timer?.cancel();
    _timer = null;

    // Remove overlay from UI
    try {
      _overlayEntry?.remove();
    } catch (_) {
      // In case it's already removed or throws
    } finally {
      _overlayEntry = null;
    }

    // Clear any remaining queued snackbars
    _infosQueue.clear();

    // Remove scroll listener safely
    if (_scrollController != null) {
      try {
        _scrollController!.removeListener(_onScroll);
      } catch (_) {
        // Do nothing, maybe it was already removed
      } finally {
        _scrollController = null;
      }
    }
  }
}