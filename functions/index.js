const admin = require("firebase-admin");
// Initialize Firebase Admin
admin.initializeApp(
    {
      credential: admin.credential.applicationDefault(),
      databaseURL: "https://jci-app-e8e4c-default-rtdb.europe-west1.firebasedatabase.app/",
    },
);

const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {addParticipantToEvent} = require("./participants");
const {removeParticipantFromEvent, sendReminderToAllUsers, scheduleReminder} =
require("./participants");
const {addNotificationToUserToBatch}=require("./Notificcations/Notifications");
const {onObjectiveCreated, updateuser}=require("./objectifs/objectifs");
const {onCommentCreated, onReplyCreated}= require("./comments");
const {onRequest} = require("firebase-functions/v2/https");
exports.addParticipantToEvent = addParticipantToEvent;
exports.onCommentCreated = onCommentCreated;
exports.onReplyCreated = onReplyCreated;
exports.updateuser=updateuser;
exports.onObjectiveCreated=onObjectiveCreated;
exports.scheduleReminder = scheduleReminder;
exports.sendReminderToAllUsers = sendReminderToAllUsers;
exports.removeParticipantFromEvent = removeParticipantFromEvent;
// Function to send notification
exports.sendNotificationOnNewActivity =
onDocumentCreated("activities/{id}",
    async (event) => {
      try {
        const newActivity = event.data.data();
        const title = "New Activity Created!";
        const body = `Activity: ${newActivity.name || "Unnamed Activity"} 
    has been added!`;

        // Send notification to all users subscribed to the topic 'all_users'
        await admin.messaging().send({
          "topic": "all_users",
          "notification": {
            title: title,
            body: body,
          },
          "data": {
            "route": `/activity/${newActivity.id}/${newActivity.type}s/1`,
          },
        });
        console.log("Notification sent successfully.");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });

// Add a blank line at the end of the file
exports.sendNotificationOnNewPV =onRequest(
    {cors: [/firebase\.com$/, "flutter.com"], timeoutSeconds: 1200},

    async (req, res) => {
      try {
        // The newly created PV
        const {activityId, PVId} = req.query;

        // Fetch activity details
        const activityDoc = await admin.firestore().collection("activities")
            .doc(activityId).get();
        const activity = activityDoc.data();

        if (!activity) {
          console.error(`Activity with ID ${activityId} not found.`);
          res.status(404).send("Activity not found.");
        }
        const pvDoc = await admin.firestore().collection("activities")
            .doc(activityId).collection("pvs").doc(PVId).get();
        const newPV = pvDoc.data();

        // Notification title and body
        const title = `New PV Added to ${activity.name || "an Activity"}`;
        const body = `PV: ${newPV.title || "Unnamed PV"} has been added.`;
        const tokens = [];

        // Fetch all participants of the activity
        const participants = activity.Participants || [];
        for (const participant of participants) {
          const userDoc = await admin.firestore()
              .collection("users").doc(participant).get();
          const user = userDoc.data();
          // update notifications list of each user
          const userid = user.id;

          if (user && user.fcmTokens) {
            tokens.push(user.fcmTokens[user.fcmTokens.length - 1]);
          }
          addNotificationToUserToBatch(
              userid,
              "PV",

              body,
              title,
              admin.firestore(), admin.firestore().batch(),
          );
        }
        if (tokens.length === 0) {
          console.log("No participants to notify.");
          res.status(200).send("No participants to notify.");
        }

        console.log(`Sending notifications to
           ${tokens.length} participants...`);

        // Send push notifications
        const message = {
          tokens: tokens,
          notification: {
            title: title,
            body: body,
          },
          data: {
            route: `/activity/${activityId}`,
          },
        };

        await admin.messaging().sendEachForMulticast(message);
        console.log(`Push notifications sent to ${tokens.length} users.`);
        res.status(200).send("Notifications sent successfully.");
      } catch (error) {
        console.error("Error sending notification:", error);
        res.status(500).send("An error occurred while sending notifications.");
      }
    });

exports.notifyAgendaPoint = onRequest(
    {cors: [/firebase\.com$/, "flutter.com"], timeoutSeconds: 1200},


    async (req, res) => {
      try {
        // Extract query parameters
        const activityId = req.query.activityId;
        const pointName = req.query.pointName;
        const ExpiryDate =Date.parse( req.query.ExpiryDate);


        if (!activityId || !pointName || !ExpiryDate ) {
          return res.status(400).json({error: "Missing or invalid parameters"});
        }


        // Fetch participant tokens from Firestore
        const participants = await partcipantsPresent(activityId);
        const participantTokens = [];
        for (const participant of participants) {
          const userDoc = await admin.firestore()
              .collection("users").doc(participant).get();
          const user = userDoc.data();
          if (user && user.fcmTokens) {
            participantTokens.push(user.fcmTokens[user.fcmTokens.length - 1]);
          }
        }

        // Create the notification payload
        const message = {
          notification: {
            title: `New Agenda Point: ${pointName}`,
            body: ` Ends at ${ExpiryDate.toLocaleTimeString()}.`,
          },
          data: {
            title: pointName,
            end_time: ExpiryDate.toString(),
          },
          tokens: participantTokens,
        };

        // Send the notification to all tokens
        const response = await admin.messaging().sendEachForMulticast(message);

        console.log(`Notifications sent: ${response.successCount}, 
          Failures: ${response.failureCount}`);

        return res.status(200).json({
          message: "Notification sent successfully",
          successCount: response.successCount,
          failureCount: response.failureCount,
        });
      } catch (error) {
        console.error("Error sending notification:", error);
        return res.status(500).
            json({error: "Internal server error", details: error.message});
      }
    });


/**
     * Function to send reminder notifications to participants of an activity
     * @param {string} activityId - The ID of the activity
     * @return {Promise<Array<string>>} - An array of participant IDs


    **/
async function partcipantsPresent(activityId) {
  const participantsSnapshot = await admin
      .firestore()
      .collection("activities")
      .doc(activityId)
      .collection("participants")
      .where("attendance", "==", "Present")
      .get();

  // Check if there are any matching documents
  if (participantsSnapshot.empty) {
    return [];
  }

  // Extract participant IDs
  return participantsSnapshot.docs.map((doc) => doc.data().memberId);
}
