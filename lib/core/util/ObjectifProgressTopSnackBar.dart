import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/achivements/AchivementsWidget.dart';
import 'dart:async';
import 'dart:collection';

import 'package:jci_app/features/auth/AuthWidgetGlobal.dart'; // Import for Queue

class TopSnackbar {
  static final Queue<UserObjectifInfos> _infosQueue = Queue(); // Queue to hold items
  static OverlayEntry? _overlayEntry; // Current overlay entry
  static Timer? _timer; // Timer for auto-dismiss
  static ScrollController? _scrollController; // ScrollController to detect scroll events

  static void show(
      List<UserObjectifInfos> infos,
      BuildContext context, {
        Duration duration = const Duration(seconds: 5), // Default duration is 5 seconds
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
      return; // Stop if the queue is empty
    }

    // Get the next info from the queue
    final info = _infosQueue.removeFirst();

    // Create an OverlayEntry for the current info
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10, // Position at the top with padding
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
                  borderRadius: BorderRadius.circular(10), // Adjust the value for more or less roundness
                ),
              ),
              onPressed: () => dismiss(), // Dismiss on button press
              child: Text('Dismiss', style: PoppinsRegular(14, PrimaryColor)),
            )],
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
      if (_scrollController!.position.userScrollDirection == ScrollDirection.reverse) {
        dismiss(); // Dismiss the snackbar
      }
    }
  }

  static void dismiss() {
    // Cancel the current timer
    _timer?.cancel();
    _timer = null;

    // Remove the current overlay
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Clear the queue if it's not empty
    if (_infosQueue.isNotEmpty) {
      _infosQueue.clear();
    }

    // Remove the scroll listener
    if (_scrollController != null) {
      _scrollController!.removeListener(_onScroll);
      _scrollController = null;
    }
  }
}