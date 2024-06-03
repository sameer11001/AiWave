// from enum import Enum

// class ProcessState(Enum):
//     pending     = 'pending'
//     in_progress = 'in_progress'
//     completed   = 'completed'
//     failed      = 'failed'
//     partial     = 'partial'
//     skipped     = 'skipped'

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ProcessState {
  pending,
  in_progress,
  completed,
  failed,
  partial,
  skipped;

  String toKey() => name;

  static ProcessState fromKey(String key) {
    return ProcessState.values.firstWhere(
      (element) => element.toKey() == key,
      orElse: () => ProcessState.pending,
    );
  }

  Color get color {
    switch (this) {
      case ProcessState.completed:
        return Colors.green;
      case ProcessState.in_progress:
        return Colors.amber;
      case ProcessState.failed:
        return Colors.red;
      case ProcessState.partial:
        return Colors.purple;
      case ProcessState.skipped:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
