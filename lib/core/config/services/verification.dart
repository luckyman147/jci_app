import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';

import '../../../features/Home/domain/entities/Activitys/Activity.dart';
import '../../../features/auth/AuthWidgetGlobal.dart';
import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../error/Exception.dart';

class Verification {
  final Store store;
  final MemberStore memberStore;

  Verification(this.memberStore, {required this.store});




  Future<List<bool>> areMembersInParticipants(List<Activity> activities) async {
    final member = await memberStore.getModel();
    final memberId = member!.id;
    return activities
        .map((activity) => activity.participation.participants.contains(memberId))
        .toList();
  }

  Future<List<String?>> getTokens() async {
    final tokens = await store.GetTokens();
    if (tokens[1] == null || tokens[1].toString().isEmpty) {
      throw EmptyCacheException();
    }
    return tokens;
  }
}

bool hasCommonElement(List<dynamic> list1, List<dynamic> list2) {
  // Convert one list to a set for efficient lookup
  Set<dynamic> set = list1.toSet();

  // Track the count of common elements found
  int commonCount = 0;

  // Check if any element from the second list exists in the set
  for (var element in list2) {
    if (set.contains(element)) {
      commonCount++;
      // If at least two common elements are found, return true
      if (commonCount >= 2) {
        return true;
      }
    }
  }

  // Return false if less than two common elements are found
  return false;
}

Exception handleErrors(FirebaseException e) {
  if (e.code == 'permission-denied') {
    Logger().e(
        "User does not have permission to create documents in this collection.");
    return UnauthorizedException();
  } else if (e.code == 'unavailable') {
    Logger().e("The server is unavailable. Please try again later.");
    return NotVerifiedException();
  } else {
    Logger().e("An error occurred while adding the meeting: $e");
    return ExpiredException();
  }
}
