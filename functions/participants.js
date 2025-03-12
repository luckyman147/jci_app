const admin = require("firebase-admin");
const {onRequest} = require("firebase-functions/v2/https");
const moment = require("moment");
const {onSchedule} = require("firebase-functions/v2/scheduler");
/**
 * Helper function to get the event.
 * @param {string} eventId - The ID of the event.
 * @return {Promise<Object>} - The event data.
 */
async function getEvent(eventId) {
  const eventRef = admin.firestore().collection("activities").doc(eventId);
  const eventDoc = await eventRef.get();
  if (!eventDoc.exists) {
    throw new Error("Event not found");
  }
  return eventDoc.data();
}

/**
 * Helper function to get the member data.
 * @param {string} memberId - The ID of the member.
 * @return {Promise<Object>} - The member data.
 */
async function getMember(memberId) {
  const memberRef = admin.firestore().collection("users").doc(memberId);
  const memberDoc = await memberRef.get();
  if (!memberDoc.exists) {
    throw new Error("Member not found");
  }
  return memberDoc.data();
}

/**
 * Helper function to send a notification.
 * @param {Array<string>} fcmTokens - The FCM tokens of the members.
 * @param {string} eventName - The name of the event.
 */
async function sendNotification(fcmTokens, eventName) {
  if (fcmTokens && fcmTokens.length > 0) {
    const message = {
      notification: {
        title: "You have been added to an event",
        body: `You have been successfully added to the event: ${eventName}.`,
      },
      token: fcmTokens[fcmTokens.length - 1], // Send to the latest FCM token
    };
    await admin.messaging().send(message);
    console.log("Notification sent to the user");
  } else {
    console.log("FCM Token not found for member");
  }
}

/**
 * Add participant to event.
 * @param {string} eventId - The ID of the event.
 * @param {string} memberId - The ID of the member.
 */
async function addParticipantToEvent(eventId, memberId) {
  const eventData = await getEvent(eventId);
  console.log(eventData);

  const MData = await getMember(memberId);
  console.log(MData);

  const participants = eventData.Participants || [];

  // Check if the member is already a participant
  if (participants.some((participant) =>
    participant.id === memberId)) {
    throw new Error("Member already exists in activity");
  }


  participants.push(memberId);

  // Save the updated participants list
  await admin.firestore().collection("activities").doc(eventId)
      .update({Participants: participants});


  // Update the member's activities
  const activities = MData.Activities || [];
  activities.push(eventId);

  await admin.firestore().collection("users")
      .doc(memberId).update({Activities: activities});

  // Send notification to the member
  await sendNotification(MData.fcmTokens, eventData.name);
}
/**
 * Remove participant from event.
 * @param {string} eventId - The ID of the event.
 * @param {string} memberId - The ID of the member.
 */
async function removeParticipantFromEvent(eventId, memberId) {
  const eventData = await getEvent(eventId);
  const MData = await getMember(memberId);

  const participants = eventData.Participants || [];
  const updatedParticipants = participants.filter(
      (participant) => participant!== memberId);

  // Check if the participant was not found
  if (updatedParticipants.length === participants.length) {
    throw new Error("Member not found in participants list");
  }
  // Save
  await admin.firestore().collection("activities").doc(eventId)
      .update({Participants: updatedParticipants});
  const activities = MData.Activities || [];
  const updatedActivities = activities.filter(
      (activityId) => activityId !== eventId);

  // Update the member's activities
  await admin.firestore().collection("users").doc(memberId)
      .update({Activities: updatedActivities});

  console.log(`Participant with ID ${memberId} removed from event ${eventId}.`);
}

// HTTP function to add participant
exports.addParticipantToEvent = onRequest(
    {cors: [/firebase\.com$/, "flutter.com"], timeoutSeconds: 1200},
    async (req, res) =>{
      const MId = req.query.memberId;
      const EId = req.query.eventId;
      console.log(`Adding participant: ${MId} to event: ${EId}`);

      try {
        await addParticipantToEvent(EId, MId);
        return res.status(200).json({message: "Participant added "});
      } catch (error) {
        console.error("Error adding participant to event:", error);
        return res.status(500).json({message: error.message});
      }
    });

// HTTP function to remove participant
exports.removeParticipantFromEvent = onRequest(
    {cors: [/firebase\.com$/, "flutter.com"], timeoutSeconds: 1200},
    async (req, res) => {
      const MId = req.query.memberId;
      const EId = req.query.eventId;
      try {
        await removeParticipantFromEvent(EId, MId);
        return res.status(200).json({message: "Participant removed "});
      } catch (error) {
        console.error("Error removing participant from event:", error);
        return res.status(500).json({message: error.message});
      }
    });

/**
  * Send reminder to all users.
  * @param {Object} req - The request object.
  * @param {Object} res - The response object.
  * @return {Promise<void>} - The promise object.
  * @throws {Error} - If an error occurs.

 */

exports.sendReminderToAllUsers =onRequest(
    {cors: [/firebase\.com$/, "flutter.com"], timeoutSeconds: 1200},

    async (req, res) => {
      try {
        const {activityName, activityBeginDate, userId, location} = req.query;
        // Fetch all users from the users collection (independent of activities)
        const usersSnapshot = await admin.firestore().collection("users").get();

        if (usersSnapshot.empty) {
          res.status(404).send("No users found.");
          return;
        }

        const emailPromises = [];
        const fcmTokens = [];

        usersSnapshot.forEach((userDoc) => {
          if ( userDoc.id == userId) {
            // skip the user who is sending the reminder

            return;
          }
          const userData = userDoc.data();
          const email = userData.email;
          const fcmToken = userData.fcmTokens[userData.fcmTokens.length - 1];
          const language = userData.language || "fr";

          // Send email to user
          if (email) {
            emailPromises.push(sendEmail(email, activityName,
                activityBeginDate, language, location));
          }


          // Collect FCM tokens for push notifications
          if (fcmToken) {
            fcmTokens.push(fcmToken);
          }
        });
        console.log(fcmTokens);

        // Send push notifications in bulk using sendEachForMulticast
        if (fcmTokens.length > 0) {
          await sendPushNotifications(fcmTokens, activityName,
              activityBeginDate);
        }
        // Send email and push notifications
        await Promise.all(emailPromises);
        res.status(200).send("Reminder sent to all users successfully.");
      } catch (e) {
        console.error("Error sending reminder: ", e);
        res.status(500).send("Error sending reminder.");
      }
    });

/**
 * Formats the date in "ddd, MMMM, yyyy" format.
 * @param {string} date - The date to format.
 * @return {string} - The formatted date.
 */
function formatDate(date) {
  return moment(date).format("ddd, MMMM, yyyy");
}

/**
 * Returns the email content (subject, text, and body) based on the language.
 * @param {string} language - The language code (e.g., "fr" or "en").
 * @param {string} activityName - The name of the activity.
 * @param {string} activityBeginDate - The formatted start date of the activity.
 * @param {string} location - The location of the activity.
 * @return {object} - The email content.
 */
function getEmailContent(language, activityName, activityBeginDate, location) {
  const parsedActivityBeginDate = new Date(activityBeginDate);
  if (isNaN(parsedActivityBeginDate.getTime())) {
    throw new Error(`Invalid activityBeginDate: ${activityBeginDate}`);
  }
  if (language === "fr") {
    return {
      subject: `Rappel: ${activityName}`,
      text: `Bonjour, N'oubliez pas l'activité "${activityName}"
       qui commence le ${activityBeginDate}.`,
      body: `
        <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;
     background-color: #ffffff; 
     border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Cher(e) members</p>
    <p>Ceci est un rappel pour votre participation à
     <strong>${activityName}</strong>.</p>
    <p>L'événement se déroulera à ${location} 
    le ${parsedActivityBeginDate.toLocaleDateString("fr-FR",
      {weekday: "long", year: "numeric", month: "long", day: "numeric"})} à 
      ${parsedActivityBeginDate.toLocaleTimeString("fr-FR",
      {hour: "2-digit", minute: "2-digit"})}.</p>
    <p>Nous espérons vous voir à l'événement !</p>
    <p>Si vous avez des questions ou si vous ne pouvez pas participer, 
    
    veuillez nous contacter dès que possible.</p>
    <p>Cordialement,<br>
    </div>
  </div>
   
    </body>
      `,
    };
  } else {
    return {
      subject: `Reminder: ${activityName}`,
      text: `Hello, Don't forget about the activity "${activityName}" 
      starting on ${activityBeginDate}.`,
      body: `
       <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="max-width: 600px; margin: 0 auto; 
    padding: 20px; background-color: #ffffff;
     border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Dear members</p>
   
 
    <p>This is a reminder for your participation in
     <strong>${activityName}</strong>.</p>
    <p>The event will take place at ${location} 
    on ${parsedActivityBeginDate.toLocaleDateString("en-US",
      {weekday: "long", year: "numeric", month: "long", day: "numeric"})}
       at ${parsedActivityBeginDate.toLocaleTimeString("en-US",
      {hour: "2-digit", minute: "2-digit"})}.</p>
    <p>We hope to see you at the event!</p>
    <p>If you have any questions or cannot attend, 
    please contact us as soon as possible.</p>
    <p>Best regards,<br>

  </div>
 
    </body>
      `,
    };
  }
}

/**
 * Sends an email using the Firebase Firestore mail collection.
 * @param {string} email - The recipient's email address.
 * @param {string} activityName - The name of the activity.
 * @param {string} activityBeginDate - The start date of the activity.
 * @param {string} language - The user's language preference.
 * @param {string} location - The location of the activity.
 */
async function sendEmail(email, activityName, activityBeginDate
    , language, location) {
  const formattedDate = formatDate(activityBeginDate);
  const emailContent = getEmailContent(language, activityName,
      formattedDate, location);

  const emailRef = admin.firestore().collection("mail").doc();
  await emailRef.set({
    to: email,
    message: {
      subject: emailContent.subject,
      text: emailContent.text,
      html: emailContent.body,
    },
  });
}
/**
 * Send push notifications to users.
 * @param {Array<string>} fcmTokens - List of FCM tokens.
 * @param {string} activityName - The name of the activity.
 * @param {string} activityBeginDate - The start date of the activity.
 * @param {string} language - The language of the users.
 * @return {Promise<void>} - The promise object.
 * @throws {Error} - If an error occurs.
 */
async function sendPushNotifications(fcmTokens, activityName,
    activityBeginDate) {
  const title = `Rappel: ${activityName}`;
  const body = `L'activité "${activityName}" commence le 
  ${formatDate(activityBeginDate)}
    . Ne le manquez pas!`;
  const button1 = "Participez maintenant";
  const button2 = "Détails supplémentaires";
  console.log( "sssssss", fcmTokens);

  const message = {
    tokens: fcmTokens,
    notification: {
      title: title,
      body: body,
    },
    android: {
      notification: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
      data: {
        button1: button1,
        button2: button2,

      },
    },
  };

  try {
    await admin.messaging().sendEachForMulticast(message);
    console.log(`Push notifications sent to ${fcmTokens.length} users.`);
  } catch (error) {
    console.error("Error sending push notifications: ", error);
  }
}

// Schedule reminder to be sent every 24 hours
exports.scheduleReminder = onSchedule("every day 09:00", async (context) => {
  const now = moment();
  const todayDate = moment().startOf("day");

  const activitiesSnapshot = await admin.firestore()
      .collection("activities").get();
  let activityFound = false;

  activitiesSnapshot.forEach(async (activityDoc) => {
    const activityData = activityDoc.data();
    const activityBeginDate = moment(activityData.ActivityBeginDate);
    const userDoc = await admin.firestore().collection("users").get();

    // Check if the activity is today and 2 hours away
    if (activityBeginDate.isSame(todayDate, "day") &&
    now.isBefore(activityBeginDate)) {
      activityFound = true;
      const tokens = [];
      userDoc.forEach(async (userDoc) => {
        const userData = userDoc.data();
        const email = userData.email;
        const fcmToken = userData.fcmTokens[userData.fcmTokens.length - 1];
        const language = userData.language || "fr";

        tokens.add(fcmToken);
        // Send email to user
        if (email) {
          await sendEmail(email, activityData.name,
              activityBeginDate.format("LLL"), language);
        }

        // Send push notification to user
      },

      ); if (tokens.length > 0) {
        await sendPushNotifications(tokens, activityData.name,
            activityBeginDate.format("LLL"));
      }
    }
  });

  if (!activityFound) {
    console.log("No activities found for today.");
  }
});
