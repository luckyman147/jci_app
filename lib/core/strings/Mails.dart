class mails{
  static String otpMail(String otp)=>"""
   
  <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
      <div style="width: 100%; max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #007bff; color: white; padding: 20px; text-align: center;">
            
              <h1 style="margin: 0;">Jeune Chamber International Hammam Sousse</h1>
          </div>
          
          <div style="padding: 20px;">
              <h2 style="font-size: 24px; color: #333333;">One-Time Password (OTP)</h2>
              <p style="font-size: 16px;">Dear User,</p>
              <p style="font-size: 16px;">Your OTP for verification is:</p>
              <div style="font-size: 24px; font-weight: bold; color: #333333;">$otp</div>
              <p style="font-size: 16px;">This OTP is valid for 5 minutes. Please do not share it with anyone.</p>
          </div>

          <div style="text-align: center; padding: 10px; background-color: #f4f4f4;">
              <p style="margin: 0;">&copy; 2024 JCI Hammam Souuse. All rights reserved.</p>
          </div>
      </div>
  </body>
  """;
  static String otpFrenshMail(String otp) => """
   
  <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
      <div style="width: 100%; max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #007bff; color: white; padding: 20px; text-align: center;">
            
              <h1 style="margin: 0;">Jeune Chambre Internationale Hammam Sousse</h1>
          </div>
          
          <div style="padding: 20px;">
              <h2 style="font-size: 24px; color: #333333;">Mot de passe à usage unique (OTP)</h2>
              <p style="font-size: 16px;">Cher utilisateur,</p>
              <p style="font-size: 16px;">Votre mot de passe à usage unique (OTP) pour la vérification est :</p>
              <div style="font-size: 24px; font-weight: bold; color: #333333;">$otp</div>
              <p style="font-size: 16px;">Cet OTP est valable pendant 5 minutes. Veuillez ne pas le partager avec quiconque.</p>
          </div>

          <div style="text-align: center; padding: 10px; background-color: #f4f4f4;">
              <p style="margin: 0;">&copy; 2024 JCI Hammam Sousse. Tous droits réservés.</p>
          </div>
      </div>
  </body>
  """;
  static String passwordResetOtpFrenshMail(String otp) => """
   
  <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
      <div style="width: 100%; max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #007bff; color: white; padding: 20px; text-align: center;">
            
              <h1 style="margin: 0;">Jeune Chambre Internationale Hammam Sousse</h1>
          </div>
          
          <div style="padding: 20px;">
              <h2 style="font-size: 24px; color: #333333;">Réinitialisation du mot de passe - Code OTP</h2>
              <p style="font-size: 16px;">Cher utilisateur,</p>
              <p style="font-size: 16px;">Votre code OTP pour la réinitialisation de votre mot de passe est :</p>
              <div style="font-size: 24px; font-weight: bold; color: #333333;">$otp</div>
              <p style="font-size: 16px;">Cet OTP est valable pendant 5 minutes. Veuillez ne pas le partager avec quiconque.</p>
          </div>

          <div style="text-align: center; padding: 10px; background-color: #f4f4f4;">
              <p style="margin: 0;">&copy; 2024 JCI Hammam Sousse. Tous droits réservés.</p>
          </div>
      </div>
  </body>
  """;

  static String passwordReseteNGLISHOtpMail(String otp) => """
   
  <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
      <div style="width: 100%; max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #007bff; color: white; padding: 20px; text-align: center;">
            
              <h1 style="margin: 0;">Jeune Chamber International Hammam Sousse</h1>
          </div>
          
          <div style="padding: 20px;">
              <h2 style="font-size: 24px; color: #333333;">Password Reset - OTP</h2>
              <p style="font-size: 16px;">Dear User,</p>
              <p style="font-size: 16px;">Your OTP for resetting your password is:</p>
              <div style="font-size: 24px; font-weight: bold; color: #333333;">$otp</div>
              <p style="font-size: 16px;">This OTP is valid for 5 minutes. Please do not share it with anyone.</p>
          </div>

          <div style="text-align: center; padding: 10px; background-color: #f4f4f4;">
              <p style="margin: 0;">&copy; 2024 JCI Hammam Sousse. All rights reserved.</p>
          </div>
      </div>
  </body>
  """;
  static String welcomeGuestInFrench(String name, String eventName, DateTime time, String lieu) => """
<div style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
    <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);">
        <div style="background-color: #0047ab; color: white; padding: 40px 30px; text-align: center;">
            <h1 style="font-size: 32px; margin: 0; font-weight: bold;">JCI Hammam Sousse</h1>
            <p style="font-size: 18px; margin: 10px 0;">Nous sommes ravis de vous accueillir</p>
        </div>

        <div style="padding: 40px; color: #333333;">
            <h2 style="font-size: 26px; font-weight: bold; color: #0047ab; margin-bottom: 20px;">Bienvenue à $eventName</h2>
            <p style="font-size: 16px; line-height: 1.6; color: #555555;">Bonjour <strong>$name</strong>,</p>
            <p style="font-size: 16px; line-height: 1.6; color: #555555;">Nous sommes heureux de vous inviter à notre événement organisé par <strong>JCI Hammam Sousse</strong>. C'est une occasion idéale pour se connecter, apprendre et échanger avec d'autres membres de notre communauté dynamique.</p>

            <div style="text-align: center; margin: 30px 0; background-color: #ff6f00; padding: 12px 30px; border-radius: 5px; display: inline-block; font-weight: bold;">
                <a href="https://jcihammamsousse.org/" style="font-size: 18px; color: white; text-decoration: none;">Rejoignez-nous dès maintenant</a>
            </div>
            
            <p style="font-size: 16px; line-height: 1.6; color: #555555; text-align: center; margin-top: 40px;">
                <strong>Date:</strong> ${time.day} ${_getMonthInFrench(time.month)} ${time.year}<br>
                <strong>Heure:</strong> ${time.hour}:${time.minute.toString().padLeft(2, '0')}<br>
                <strong>Lieu:</strong> $lieu
            </p>
        </div>

        <div style="background-color: #f4f4f4; padding: 20px; text-align: center;">
            <p style="font-size: 14px; color: #777777; margin: 0;">&copy; 2024 JCI Hammam Sousse. Tous droits réservés.</p>
        </div>
    </div>
</div>
""";


// Helper function to convert month numbers to French month names
  static String _getMonthInFrench(int month) {
    const months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
      "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[month - 1];
  }

}