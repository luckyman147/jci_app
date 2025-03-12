exports.getReplyNotifi=(userLang, activityName,
    FirstName, LastName, content)=> {
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
exports.getNotificationContent=(userLang,
    activityName, FirstName, LastName, content) =>{
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
