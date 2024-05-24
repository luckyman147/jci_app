
  final BaseUrl = "http://192.168.1.9"
      ":8080";
  final SuperAdminUrl = "$BaseUrl/Super";
  final BoardUrl = "$BaseUrl/Board";
  final BoardRoleUrl = "$BaseUrl/BoardRole";
  final PositionUrl = "$BaseUrl/PositionOfMember";
  final getYearsUrl= "$BoardUrl/years";
  final addBoardUrl= "$BoardUrl/AddBoard";
  final addPosiUrl= "$PositionUrl/AddPosition";
  final AddRoleBoardUrl= "$BoardRoleUrl/AddBoardRole";
   String getBoardByYearUrl(String year)=> "$BoardUrl/get/$year";
   String removeBoardUrl(String year)=> "$BoardUrl/$year";
   String AddMemberBoardUrl(String id)=> "$PositionUrl/$id/AddMember";
   String RemoveMemberBoardUrl(String id)=> "$PositionUrl/$id/RemoveMember";
   String getBoardRoleUrl(int Priority)=> "$BoardRoleUrl/$Priority";
   String RemoveBoardRoleUrl(String id)=> "$BoardRoleUrl/$id";
String RemovePostUrl(String id,String year)=> "$PositionUrl/$id/$year";
final LoginUrl = "$BaseUrl/auth/login";
final LoginGoogleUrl = "$BaseUrl/auth/google";
final SignUpUrl = "$BaseUrl/auth/signup";
final SignUpGoogleUrl = "$BaseUrl/auth/google/register";
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
 String ChangeToAdminUrl(String id )=>"$SuperAdminUrl/ChangeToAdmin/$id";
 String ChangeToSuperUrl(String id )=>"$SuperAdminUrl/ChangeToSuper/$id";
 String ChangeToMemberUrl(String id )=>"$SuperAdminUrl/ChangeToMember/$id";
 String CreatePresidents( )=>"$SuperAdminUrl/CreateLastPresident";
 String UpdatePresidents(String id )=>"$SuperAdminUrl/UpdatePresident/$id";
 String getAllPresidents( String start,String limit)=>"$SuperAdminUrl/getAllPresidents?start=$start&limit=$limit";
 String DeletePresidents(String id )=>"$SuperAdminUrl/DeleteLastPresident/$id";
 String CotisationUrl(String id )=>"$getMember/$id/UpdateCotisation";
 String validationUrl(String memberid )=>"$getMember/$memberid/validate";
 String PointsUrl(String memberid )=>"$getMember/$memberid/UpdatePoints";
final ChangeLanguageUrl = "$BaseUrl/member/UpdateLanguage";
final getMeetingByWeek = "$BaseUrl/Meeting/Latestofweek";

final getEventByWeek = "$BaseUrl/Event/Latestofweekend";
final getEventsUrl = "$BaseUrl/Event/";



class Urls{
  static String AddCommentUrl(String id)=>"$TeamUrl/$id/Comment";

  static String guestUrl="$BaseUrl/Activity/guests/";
  static String ALLGuestsAllUrl="$BaseUrl/Activity/guestsALL";
  static String getMembersWithRank="$BaseUrl/member/Members";
  static String getMemberWithHightRank="$BaseUrl/member/Member";
  static String activitySearch="$BaseUrl/Activity/SearchName/get";
  static String AddNotes(String activityId)=>"$BaseUrl/Activity/notes/$activityId";
  static String SendReminderUrl(String activityId)=> "$BaseUrl/mails/SendReminder/$activityId";
  static String Addguest(String activityId)=> "$guestUrl$activityId";
  static String deleteguest(String activityId,String guestId)=> "$guestUrl$activityId/$guestId";
  static String getAllParticipants(String activityId)=>"$BaseUrl/Activity/members/$activityId";
  static String CheckAbsence="$BaseUrl/Activity/members";
  static String mailVerify= "$BaseUrl/mails/VerifyEmails";
  static String mailIcativityReporturl(String id )=>"$BaseUrl/mails/reportInactivity/$id";
  static String mailMembershipReporturl(String id )=>"$BaseUrl/mails/reportmembership/$id";
  static String ResetPassword= "$BaseUrl/mails/ResetPasswordMails";
  static String TeamMember(String teamId) => "$TeamUrl$teamId/TeamMembers";
  static String InviteMemberUrl(String teamId,String memberid) => "$TeamUrl$teamId/AddMember/$memberid";
  static String JoinTeam(String teamId,) => "$TeamUrl$teamId/JoinTeam";

  static String AddGuestToActivity(String activityId, String guestId) => "$BaseUrl/Activity/guests/$activityId/$guestId";

  static String DeleteNotes( String act,String noteId) => "$BaseUrl/Activity/notes/$act/$noteId";

  static String GetNotes(String activityId,String start,String limit) => "$BaseUrl/Activity/notes/$activityId?start=$start&limit=$limit";

  static String UpdateNotes(String id) => "$BaseUrl/Activity/notes/$id";

  static String ChangeGuestToMember(String guestId) =>"$BaseUrl/admin/guest/ChangeToMember/$guestId";

  static String deleteMemberUrl(String id) => "$SuperAdminUrl/member/$id";
}
