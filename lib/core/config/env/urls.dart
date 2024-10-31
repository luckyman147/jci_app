
  const BaseUrl = "http://192.168.1.9"
      ":8080";
  const SuperAdminUrl = "$BaseUrl/Super";
  const BoardUrl = "$BaseUrl/Board";
  const BoardRoleUrl = "$BaseUrl/BoardRole";
  const PositionUrl = "$BaseUrl/PositionOfMember";
  const getYearsUrl= "$BoardUrl/years";
  const addBoardUrl= "$BoardUrl/AddBoard";
  const addPosiUrl= "$PositionUrl/AddPosition";
  const AddRoleBoardUrl= "$BoardRoleUrl/AddBoardRole";
   String getBoardByYearUrl(String year)=> "$BoardUrl/get/$year";
   String removeBoardUrl(String year)=> "$BoardUrl/$year";
   String AddMemberBoardUrl(String id)=> "$PositionUrl/$id/AddMember";
   String RemoveMemberBoardUrl(String id)=> "$PositionUrl/$id/RemoveMember";
   String getBoardRoleUrl(int Priority)=> "$BoardRoleUrl/$Priority";
   String RemoveBoardRoleUrl(String id)=> "$BoardRoleUrl/$id";
String RemovePostUrl(String id,String year)=> "$PositionUrl/$id/$year";
const LoginUrl = "$BaseUrl/auth/login";
const LoginGoogleUrl = "$BaseUrl/auth/google";
const SignUpUrl = "$BaseUrl/auth/signup";
const SignUpGoogleUrl = "$BaseUrl/auth/google/register";
const ForgetPasswordUrl = "$BaseUrl/auth/forgetPassword";
const RefreshTokenUrl = "$BaseUrl/auth/RefreshToken";
const LogoutUrl = "$BaseUrl/auth/logout";
const UpdatePasswordUrl = "$BaseUrl/auth/updatePassword";
const getUserProfileUrl = "$BaseUrl/member/profile";
const getallMembers = "$BaseUrl/admin/members";
const getMember = "$BaseUrl/admin/member";
const getEventByMonth = "$BaseUrl/Event/LatestofTheMonth";
const createEventUrl = "$BaseUrl/Event/add";
const createMeetingUrl = "$BaseUrl/Meeting/add";
const createTrainingUrl = "$BaseUrl/Training/add";
const TeamUrl = "$BaseUrl/Team/";
const getMeetingsUrl = "$BaseUrl/Meeting/";
const getTrainingByWeek = "$BaseUrl/Training/Latestofweekend";
const getTrainingsUrl = "$BaseUrl/Training/";
const getTrainingByMonth= "$BaseUrl/Training/LatestofTheMonth";
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
const ChangeLanguageUrl = "$BaseUrl/member/UpdateLanguage";
const getMeetingByWeek = "$BaseUrl/Meeting/Latestofweek";

const getEventByWeek = "$BaseUrl/Event/Latestofweekend";
const getEventsUrl = "$BaseUrl/Event/";



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

  static String downloadUrl(String activityId) => "$BaseUrl/Activity/download/$activityId";
}
