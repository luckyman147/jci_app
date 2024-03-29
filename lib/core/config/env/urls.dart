import 'dart:io';

  final BaseUrl = "http://192.168.1.13:8080";
final LoginUrl = "$BaseUrl/auth/login";
final SignUpUrl = "$BaseUrl/auth/signup";
final ForgetPasswordUrl = "$BaseUrl/auth/forgetPassword";
final RefreshTokenUrl = "$BaseUrl/auth/RefreshToken";
final LogoutUrl = "$BaseUrl/auth/logout";
final UpdatePasswordUrl = "$BaseUrl/auth/updatePassword";
final getUserProfileUrl = "$BaseUrl/member/profile";
final getallMembers = "$BaseUrl/admin/members";
final getMember = "$BaseUrl/admin/member";
final getEventByMonth = "$BaseUrl/Event/LatestofTheMonth";
final createEventUrl = "$BaseUrl/Event/add";
final createMeetingUrl = "$BaseUrl/Meeting/add";
final createTrainingUrl = "$BaseUrl/Training/add";
final TeamUrl = "$BaseUrl/Team/";
final getMeetingsUrl = "$BaseUrl/Meeting/";
final getTrainingByWeek = "$BaseUrl/Training/Latestofweekend";
final getTrainingsUrl = "$BaseUrl/Training/";
final getTrainingByMonth= "$BaseUrl/Training/LatestofTheMonth";

final getMeetingByWeek = "$BaseUrl/Meeting/Latestofweek";

final getEventByWeek = "$BaseUrl/Event/Latestofweekend";
final getEventsUrl = "$BaseUrl/Event/";

bool isEmulator() {
  if (Platform.isAndroid) {
    // Check if the 'goldfish' or 'ranchu' emulators are present in the model name
    return (Platform.operatingSystem == 'android' &&
            Platform.version.contains('goldfish')) ||
        (Platform.operatingSystem == 'android' &&
            Platform.version.contains('ranchu'));
  }
  return false;
}

void main() {
  if (isEmulator()) {
    print('Running on an emulator.');
  } else {
    print('Running on a physical device.');
  }
}
