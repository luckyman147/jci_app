const admin = require("firebase-admin");
const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");
const {sendNotificationToUser, addNotificationToUserToBatch}=
require("../Notificcations/Notifications");
const db = admin.firestore();
const fcm = admin.messaging();
/**
 * Cloud Function triggered when a new objective is created.
 * Assigns the objective to users based on their role matching the objective's
 * @param {functions.firestore.DocumentSnapshot} event - The Firestore document
 * @param {functions.EventContext} context - The event context
 * @returns {Promise<void>} A promise that resolves when the operation completes
 */
exports.onObjectiveCreated = onDocumentCreated(
    "objectifs/{id}",
    async (event) => {
      const objectifId = event.params.id;
      const objectifData = event.data.data();
      const cibleArray = objectifData.cible || [];

      console.log(`New objective created for roles: ${cibleArray.join(", ")}`);

      try {
        if (cibleArray.length === 0) {
          await assignToAllUsers(objectifId, objectifData, db);
          return;
        }

        const rolesSnapshot = await db
            .collection("roles")
            .where("RoleCategory", "in", cibleArray)
            .get();

        if (rolesSnapshot.empty) {
          console.log("No matching roles found in database");
          return;
        }

        const targetRoleRefs = rolesSnapshot.docs.map((doc) => doc.ref);

        const usersSnapshot = await db.collection("users")
            .where("role", "in", targetRoleRefs)
            .get();

        if (usersSnapshot.empty) {
          console.log("No users found with the targeted roles");
          return;
        }

        console.log(`Found ${usersSnapshot.size} users with matching roles`);
        await processUsers(usersSnapshot, objectifId, objectifData, db);
      } catch (error) {
        console.error("Error in objective assignment:", error);
        throw error;
      }
    },
);

/**
 * Processes users and assigns objectives to them in batch.
 * @param {admin.firestore.QuerySnapshot} usersSnapshot
 * @param {string} objectifId - ID of the objective to assign
 * @param {Object} objectifData - Data of the objective
 * @param {admin.firestore.Firestore} db - Firestore database instance
 * @return {Promise<void>} A promise that resolves when processing is complete
 */
async function processUsers(usersSnapshot, objectifId, objectifData, db) {
  const batch = db.batch();
  const fcmTokens = [];

  usersSnapshot.forEach((userDoc) => {
    const userId = userDoc.id;
    const userData = userDoc.data();

    const userFcmTokens = userData.fcmTokens || [];
    const userFcmToken = userFcmTokens[userFcmTokens.length - 1];

    if (userFcmToken) {
      fcmTokens.push(userFcmToken);
    }

    console.log(`Assigning objective ${objectifId} to user ${userId}`);

    const userObjectiveRef = db.collection("users")
        .doc(userId)
        .collection("line_objectifs")
        .doc(objectifId);

    batch.set(userObjectiveRef, {
      objectifId: objectifId,
      currentProgress: 0,
      isCompleted: false,
      assignedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    addNotificationToUserToBatch(
        userId,
        "Objectifs",
        `New objective:
         ${objectifData.objectifActionType} ${objectifData.points || ""} ${objectifData.feature}!`,
        "New Objective Available",
        db,
        batch,
    );
  });

  await batch.commit();
  console.log(`Assigned objective to ${usersSnapshot.size} users`);

  if (fcmTokens.length > 0) {
    await fcm.sendEachForMulticast({
      notification: {
        title: "New Objective Available",
        body: `New:
         ${objectifData.objectifActionType} 
        ${objectifData.points || ""} ${objectifData.feature}`,
      },
      tokens: fcmTokens,
    });
    console.log("Sent FCM notifications");
  }
}

/**
 * Assigns an objective to all users (fallback when no cible is specified).
 * @param {string} objectifId - ID of the objective to assign
 * @param {Object} objectifData - Data of the objective
 * @param {admin.firestore.Firestore} db - Firestore database instance
 * @return {Promise<void>} A promise that resolves when assignment is complete
 */
async function assignToAllUsers(objectifId, objectifData, db) {
  const usersSnapshot = await db.collection("users").get();
  await processUsers(usersSnapshot, objectifId, objectifData, db);
}


exports.updateuser = onDocumentUpdated("users/{userId}",
    (event) => {
      const beforeData = event.data.before.data();
      const afterData = event.data.after.data();
      const userId = event.params.userId;

      // Check if points were added
      if (afterData.points > beforeData.points) {
        const pointsAdded = afterData.points - beforeData.points;
        addNotificationToUserToBatch(
            userId,
            "Points",
            `You have earned ${pointsAdded} 
        points for completing an objective.`, "Points Added",
            admin.firestore(),
            admin.firestore().batch(),
        );
        sendNotificationToUser(
            userId,
            "Points Added",
            `You have earned ${pointsAdded} 
        points for completing an objective.`,
            {
              type: "points_added",
              points: pointsAdded.toString(),
            },
        );
      }
      // perform more operations ...
    });
