const admin = require("firebase-admin");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

const db = admin.firestore();
const fcm = admin.messaging();

exports.onObjectiveCreated = onDocumentCreated(
    "objectifs/{id}",
    async (event) => {
      const objectifId = event.data.data().id;
      console.log(`New objective created: ${objectifId}`);
      const objectifData = event.data.data();

      try {
        // Fetch all users
        const usersSnapshot = await db.collection("users").get();

        const batch = db.batch();
        const fcmTokens = [];

        usersSnapshot.forEach((userDoc) => {
          const userId = userDoc.id;
          const userData = userDoc.data();
          const userFcmToken =
          userData.fcmTokens[userData.fcmTokens.length - 1];

          if (userFcmToken) {
            fcmTokens.push(userFcmToken);
          }
          console.log(`Assigning objective ${objectifId} to user ${userId}`);

          // Reference to user's line_objectifs subcollection
          const userObjectiveRef = db
              .collection("users")
              .doc(userId)
              .collection("line_objectifs")
              .doc(objectifId);

          batch.set(userObjectiveRef, {
            objectifId: objectifId,
            currentProgress: 0,
            isCompleted: false,
            assignedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          // Reference to user's notifications subcollection
          const notificationRef = db
              .collection("users")
              .doc(userId)
              .collection("notifications")
              .doc();

          batch.set(notificationRef, {
            title: "New Objective Available",
            body: `You have a new objective: ${objectifData.englishname}!`,
            objectifId: objectifId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            seen: false,
          });
        });

        // Commit batch writes
        await batch.commit();
        console.log(`Objective ${objectifId} assigned to all users.`);

        // Send FCM notification
        if (fcmTokens.length > 0) {
          const message = {
            notification: {
              title: "New Objective Available",
              body: `Check out the new objective: ${objectifData.englishname}`,
            },
            tokens: fcmTokens,
          };

          await fcm.sendEachForMulticast(message);
          console.log("FCM notifications sent.");
        }
      } catch (error) {
        console.error("Error assigning objective to users:", error);
      }
    });
