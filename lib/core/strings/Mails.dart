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
}