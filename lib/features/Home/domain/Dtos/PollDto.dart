

import '../entities/poll/PollOption.dart';

class PollDto{
final String ActivityId;
final String Pollid;
final int? index;
final PollOptions? pollOption;
final List<PollOptions>? options;
final bool isTemplate;

  PollDto(this.pollOption, this.options, {required this.ActivityId, required this.Pollid, required this.index,  this.isTemplate=false});
}