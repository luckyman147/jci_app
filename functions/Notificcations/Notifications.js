const admin = require("firebase-admin");
exports.getReplyNotifi = (
    userLang,
    activityName,
    FirstName,
    LastName,
    content,
) => {
  const translations = {
    en: {
      title: `New reply to your comment on ${activityName}`,
      body: `${FirstName} ${LastName}: ${content}`,
    },
    fr: {
      title: `Nouvelle réponse à votre commentaire sur ${activityName}`,
      body: `${FirstName} ${LastName}: ${content}`,
    },
  };

  return translations[userLang] || translations["en"];
};
exports.getNotificationContent = (
    userLang,
    activityName,
    FirstName,
    LastName,
    content,
) => {
  const translations = {
    en: {
      title: `New Comment on ${activityName}`,
      body: `${FirstName} ${LastName}: ${content}`,
    },
    fr: {
      title: `Nouveau commentaire sur ${activityName}`,
      body: `${FirstName} ${LastName}: ${content}`,
    },
  };

  // Return the appropriate translation or default to English
  return translations[userLang] || translations["en"];
};

/**
 * Sends a notification to a user using their FCM token.
 * @param {string} userId - The ID of the user to send the notification to.
 * @param {string} title - The title of the notification.
 * @param {string} body - The body of the notification.
 * @param {Object} data - Additional data to include
 *  in the notification payload.
 * @return {Promise<void>}
 */
async function sendNotificationToUser(userId, title, body, data = {}) {
  try {
    // Fetch the user's FCM token from Firestore
    const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
    const fcmToken = userDoc.data().fcmTokens[-1];

    if (!fcmToken) {
      console.log("No FCM token found for user:", userId);
      return;
    }

    // Prepare the notification payload
    const payload = {
      notification: {
        title: title,
        body: body,
      },
      data: data,
      token: fcmToken,
    };

    // Send the notification using Firebase Cloud Messaging (FCM)
    await admin.messaging().send(payload);
    console.log(`Notification sent to user ${userId}`);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}
/**
 * Adds a notification to the user's notifications collection in Firestore.
 *
 * @param {string} userId - The ID of the user.
 * @param {string} type - The type of notification (e.g., "Objectif").
 * @param {string} textBody - The body text of the notification.
 * @param {string} title - The title text of the notification.
 * @param {Firestore} db - The Firestore database instance.
 * @param {WriteBatch} batch - The Firestore batch instance.
 */
function addNotificationToUserToBatch(
    userId,
    type,
    textBody,
    title,
    db,
    batch,
) {
  const notificationRef = db
      .collection("users")
      .doc(userId)
      .collection("notifications")
      .doc();

  const notificationId = notificationRef.id;
  const isSeen = false;

  // 1. Add the main notification
  batch.set(notificationRef, {
    notificationId: notificationId,
    title: title,
    body: textBody,
    type: type,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    seen: isSeen,
  });

  // 2. Update the checks array in the user document
  const userRef = db.collection("users").doc(userId);

  // Method 1: Add to array (if using array)
  batch.update(userRef, {
    notificationCount: admin.firestore.FieldValue.increment(1),
    unreadNotificationCount:
     admin.firestore.FieldValue.increment(isSeen ? 0 : 1),
  });
}
module.exports = {
  addNotificationToUserToBatch,
  sendNotificationToUser,
};
