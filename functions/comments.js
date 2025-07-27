const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const {
  getNotificationContent,
  getReplyNotifi,
  addNotificationToUserToBatch,
} = require("./Notificcations/Notifications");
const batch = admin.firestore().batch();
/**
 * Fetch activity data from Firestore.
 * @param {string} act - The ID of the activity.
 * @return {Object} - The data of the activity.
 * @throws {Error} - If the activity is not found.
 */
async function fetchAct(act) {
  const activityDoc = await admin
      .firestore()
      .collection("activities")
      .doc(act)
      .get();
  if (!activityDoc.exists) {
    throw new Error(`Activity ${act} not found`);
  }
  return activityDoc.data();
}

/**
 * Fetch user FCM tokens for a list of users.
 * @param {Array<string>} users - List of user IDs.
 * @return {Array<string>} - List of FCM tokens.
 */
async function fetchUserTokens(users) {
  const tokens = [];
  for (const userId of users) {
    const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
    console.log("userDoc", userDoc);
    if (userDoc.exists) {
      const userData = userDoc.data();
      if (userData.fcmTokens && userData.fcmTokens.length > 0) {
        tokens.push(userData.fcmTokens[userData.fcmTokens.length - 1]);
      }
    }
  }
  return tokens; // Return list of FCM tokens
}

/**
 * Get the notification content based on user language.
 * @param {string} userLang - The language of the user (e.g., 'en', 'fr').
 * @param {string} activityName - The name of the activity.
 * @param {string} FirstName - The first name of the commenter.
 * @param {string} LastName - The last name of the commenter.
 * @param {string} content - The content of the comment.
 * @return {Object} - Object containing the title and body of the notification.
 */

/**
 * Remove a member from the participants list in an activity.
 * @param {string} activityId - The ID of the activity.
 * @param {string} memberId - The ID of the member to remove.
 * @return {Array<string>} - The updated list of participants.
 * @throws {Error} - If the activity is not found.
 */
async function removeMemberFromParticipants(activityId, memberId) {
  const activityDoc = await admin
      .firestore()
      .collection("activities")
      .doc(activityId)
      .get();
  if (!activityDoc.exists) {
    throw new Error(`Activity ${activityId} not found`);
  }

  const activityData = activityDoc.data();
  let users = activityData.Participants || [];

  // Remove the memberId from the Participants list if present
  if (users.includes(memberId)) {
    users = users.filter((user) => user !== memberId);
  }

  console.log(`Removed memberId ${memberId} 
    from activity ${activityId}`);
  return users; // Return updated participants list
}

/**
 * Send notifications
 * @param {Array<string>} tokens - List of .
 * @param {Object} payload - The notification payload to send.
 * @return {Promise} - The result of the notification sending operation.
 */
async function sendNotification(tokens, payload) {
  if (tokens.length > 0) {
    const response = await admin.messaging().sendEachForMulticast(payload);
    console.log("Notifications sent successfully:", response);
  } else {
    console.log("No tokens available for sending notifications.");
  }
}

exports.onCommentCreated = onRequest(async (req, res) => {
  try {
    const {
      activityId: actId,
      commentId,
      content,
      FirstName,
      LastName,
      memberId,
    } = req.query;

    if (
      !actId ||
      !commentId ||
      !content ||
      !FirstName ||
      !LastName ||
      !memberId
    ) {
      res.status(400).send("Missing required fields.");
      return;
    }

    // Fetch activity data
    const activityData = await fetchAct(actId);

    // Remove memberId from the participants list
    const updatedUsers = await removeMemberFromParticipants(actId, memberId);

    const tokens = await fetchUserTokens(updatedUsers);

    // Get notification content based on user language
    const notificationContent = getNotificationContent(
        "en",
        activityData.name,
        FirstName,
        LastName,
        content,
    );

    addNotificationToUserToBatch(
        memberId,
        "Comments",
        notificationContent.body,
        notificationContent.title,
        admin.firestore(),
        batch,
    );
    // Prepare notification payload
    const payload = {
      notification: {
        title: notificationContent.title,
        body: notificationContent.body,
      },
      data: {
        activityId: actId,
        commentId: commentId,
      },
      tokens: tokens,
    };

    // Send notifications
    await sendNotification(tokens, payload);

    res.status(200).send("Notifications sent.");
  } catch (error) {
    console.error("Error processing comment creation:", error);
    res.status(500).send("Error processing comment creation.");
  }
});

/**
 * Fetch comment data from Realtime Database.
 * @param {string} commentId - The ID of the comment.
 * @param {string} actId - The ID of the activity.
 * @return {Object} - The data of the comment.
 * @throws {Error} - If the comment is not found.
 */

exports.onReplyCreated = onRequest(async (req, res) => {
  try {
    const {
      actId,
      replyId,
      content,
      FirstName,
      LastName,
      commenterId,
      originalCommentId,
      image,
    } = req.query;

    if (
      !actId ||
      !replyId ||
      !content ||
      !FirstName ||
      !LastName ||
      !commenterId ||
      !originalCommentId
    ) {
      res.status(400).send("Missing required fields.");
      return;
    }

    // Fetch activity data
    const activityData = await fetchAct(actId);

    // Fetch the original comment to get the user who was replied to
    const originalComment = await fetchComment(originalCommentId, actId);
    console.log("hello", originalComment);
    // Get the user being replied to
    const repliedUserId = originalComment["user"]["id"];
    console.log("kalb", repliedUserId);
    // Check if the current comment is a reply to the original comment
    if (repliedUserId == commenterId) {
      console.log("No notification sent.");
      res.status(200).send(" No notification sent.");
      return;
    }

    // Fetch FCM tokens for the user being replied to
    const tokens = await fetchUserTokens([repliedUserId]);

    const notificationContent = getReplyNotifi(
        "fr",
        activityData.name,
        FirstName,
        LastName,
        content,
    );
    addNotificationToUserToBatch(
        repliedUserId,
        "Replies",
        notificationContent.body,
        notificationContent.title,
        admin.firestore(), batch,
    );
    // Prepare notification payload
    const payload = {
      notification: {
        title: notificationContent.title,
        body: notificationContent.body,
      },
      data: {
        image: image,
        activityId: actId,
        replyId: replyId,
        originalCommentId: originalCommentId,
      },
      tokens: tokens,
    };

    // Send notifications
    await sendNotification(tokens, payload);

    res.status(200).send("Reply notifications sent.");
  } catch (error) {
    console.error("Error processing reply creation:", error);
    res.status(500).send("Error processing reply creation.");
  }
});

/**
 * Fetch comment data from Realtime Database.
 * @param {string} commentId - The ID of the comment.
 * @param {string} actId - The ID of the activity.
 * @return {Object} - The data of the comment.
 * @throws {Error} - If the comment is not found.
 */
async function fetchComment(commentId, actId) {
  // / Fetch the comment data from Realtime Database
  console.log(commentId);
  console.log("ddddddd", actId);
  const commentRef = admin
      .database()
      .ref(`Comments/${actId}/comments/${commentId}`);
  const snapshot = await commentRef.once("value");

  if (!snapshot.exists()) {
    throw new Error(`Comment ${commentId} not found`);
  }

  return snapshot.val(); // Returns the data of the comment
}
