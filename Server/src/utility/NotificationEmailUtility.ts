import lodash from 'lodash';
import moment from 'moment';
import nodemailer from 'nodemailer';
import { transporter, transporterContact } from '../config/mailer';
import { convertAgendaItemsStringsToObjects } from './objectifcheck';
export const footer=` <footer style="display: flex; justify-content: center;">
<img src="cid:jci-logo" alt="JCI Logo" style="display:block; margin-top:20px; width: 100px; height: auto;">
<div style="display: flex; justify-content: center;">
    <a href="https://www.facebook.com/JCIHammamSousse"><img src="cid:facebook-icon" alt="Facebook" style="width: 25px; height: 25px; margin:5px"></a>
    <a href="https://www.instagram.com/jci_hammam_sousse/"><img src="cid:instagram-icon" alt="Instagram" style="width: 25px; height: 25px; margin:5px"></a>
</div>
</footer>`;

export const GenerateOtp = () => {
    const otp = Math.floor(10000 + Math.random() * 900000);
    const expiry = new Date();
    const startDateUtc = moment.utc(expiry).toDate();

    startDateUtc.setTime(new Date().getTime() + (5 * 60 * 1000)); // Set expiry to 5 minutes
    return { otp, startDateUtc };
}

export const emailConfig=async (language:string, englishhtml:string,Frenshhtml:string,englishheader:string, frenshHeader:string, participants:string,isNews:boolean) =>{
    try {
        const imagePath = '.\\uploads\\Events\\jci.png';    

        // Determine HTML content based on language
        const htmlContent = language == 'en' ? englishhtml : Frenshhtml;

        // Send mail with defined transport object
        if (!isNews) {
        await transporterContact.sendMail({
            from: process.env.EMAILCONTACT, // Sender address
            to: participants, // List of recipients
            subject: language === 'en' ? englishheader : frenshHeader, // Subject line
            html: htmlContent, // HTML content based on language
            attachments: [
                {
                    filename: 'jci.png',
                    path: imagePath,
                    cid: 'jci-logo' // Content ID for the image
                },
                {
                    filename: 'facebook.png',
                    path: '.\\uploads\\Events\\facebook.png',
                    cid: 'facebook-icon' // Content ID for the image
                },
                {
                    filename: 'instagram.png',
                    path: '.\\uploads\\Events\\insta.png',
                    cid: 'instagram-icon' // Content ID for the image
                }
            ]
        });} else {
            await transporter.sendMail({
                from: process.env.EMAIL, // Sender address
                to: participants, // List of recipients
                subject: language === 'en' ? englishheader : frenshHeader, // Subject line
                html: htmlContent, // HTML content based on language
                attachments: [
                    {
                        filename: 'jci.png',
                        path: imagePath,
                        cid: 'jci-logo' // Content ID for the image
                    },
                    {
                        filename: 'facebook.png',
                        path: '.\\uploads\\Events\\facebook.png',
                        cid: 'facebook-icon' // Content ID for the image
                    },
                    {
                        filename: 'instagram.png',
                        path: '.\\uploads\\Events\\insta.png',
                        cid: 'instagram-icon' // Content ID for the image
                    }
                ]
            });
        }

        console.log("Emails sent successfully");
        return true;
    } catch (error) {
        console.log("Error sending emails", error);
        return false;
    }
}

// Function to send OTP via email
export const onRequestOTP = async (otp: number, toEmail: string): Promise<boolean> => {
    try {
        // Create a transporter object using SMTP transport
        const imagePath = '.\\uploads\\Events\\jci.png';    
      
        // Email content
        let mailOptions: nodemailer.SendMailOptions = {
            from: process.env.EMAILCONTACT, // Sender address
            to: toEmail, // Recipient email address
            subject: 'Your OTP for Verification', // Subject line
            text: `Your OTP is: ${otp}`, // Plain text body
            html: ` <div style="text-align: center;">
            <p>Your OTP is: <strong>${otp}</strong></p>
            <p style="color: red;">OTP is valid for 5 minutes.</p>
        </div> ${footer}
            `, attachments: [
                {
                    filename: 'jci.png',
                    path: imagePath,
                    cid: 'jci-logo' // Content ID for the image
                },
                {
                    filename: 'facebook.png',
                    path: '.\\uploads\\Events\\facebook.png',
                    cid: 'facebook-icon' // Content ID for the image
                },
                {
                    filename: 'instagram.png',
                    path: '.\\uploads\\Events\\insta.png',
                    cid: 'instagram-icon' // Content ID for the image
                }
            ] // HTML body
        };

        // Send email
        let info = await transporterContact.sendMail(mailOptions);
        console.log('Email sent:', info.response);
        
        return true; // Email sent successfully
    } catch (error) {
        console.error('Error occurred:', error);
        return false; // Error occurred while sending email
    }
}
export const onRequestResetPasswordOTP = async (otp: number, toEmail: string): Promise<boolean> => {

        // Create a transporter object using SMTP transport
        const imagePath = '.\\uploads\\Events\\jci.png';    
      const fresnh=`<div style="text-align: center;">
      <p>Votre code OTP est : <strong>${otp}</strong></p>
      <p style="color: red;">Le code OTP est valide pendant 5 minutes.</p>
  </div>${footer}`
  const english=` <div style="text-align: center;">
  <p>Your OTP is: <strong>${otp}</strong></p>
  <p style="color: red;">OTP is valid for 5 minutes.</p>
</div>${footer}
  ` 
  emailConfig('en',english,fresnh,"Your OTP for Verification","Votre code OTP pour la vérification",toEmail,false)
   return true     // Email content
      
}





export const sendNewMemberEmail=async(language:string,participants:string,email:string)=> {
    // Create a transporter
  
    // English HTML content
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <h1>Welcome to Our Community!</h1>
        <p>Dear ${participants},</p>
        <p>We are thrilled to officially welcome you as a new member of our community. Your membership is important to us, and we are excited to have you on board!</p>
        <p>As a member, you will have access to a wide range of resources, events, and opportunities to connect with like-minded individuals.</p>
        <p>Thank you for joining us, and we look forward to your active participation and contributions.</p>
        <p>Best regards,</p>

    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <h1>Bienvenue dans Notre Communauté !</h1>
        <p>Cher(e) ${participants},</p>
        <p>Nous sommes ravis de vous accueillir officiellement en tant que nouveau membre de notre communauté. Votre adhésion est importante pour nous, et nous sommes heureux de vous compter parmi nous !</p>
        <p>En tant que membre, vous aurez accès à une large gamme de ressources, d'événements et d'opportunités pour vous connecter avec des personnes partageant les mêmes idées.</p>
        <p>Merci de nous rejoindre, et nous sommes impatients de votre participation active et de vos contributions.</p>
        <p>Cordialement,</p>
      
    </div>
       ${footer}
    </body>
    </html>`;
   emailConfig(language,englishHTMLContent,frenchHTMLContent,"Welcome to our community","Bienvenue dans notre communauté",email,false)
}

export const sendNewEventEmail=async(eventname:string, eventTime: Date, location: string,language:string,participants:string,type:string,agenda:string[],professeurName:string)=> {
    // Create a transporter
    const formattedDateFrensh = eventTime.toLocaleDateString('fr-FR', { 
        day: 'numeric', 
        month: 'long', 
        year: 'numeric' 
    });
    const Franshdic: { [key: string]: string }={ "event":"événement","meeting":" réunion","training":"formation",}
    const translatedType = Franshdic[type] || ''; 
    const ul=convertAgendaItemsStringsToObjects(agenda)
   // Format eventTime to display month, day, and year
   const formattedDate = eventTime.toLocaleDateString('en-US', { 
    month: 'long', 
    day: 'numeric', 
    year: 'numeric' 
});const formattedtime= eventTime.toLocaleDateString('en-US', { 
    hour: 'numeric',
        minute: '2-digit',
});
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
      
        <p>Good evening dear members,</p>
        <p>We are pleased to invite you to our <strong>${eventname}</strong> ${type}, which will take place on <strong>${formattedDate}</strong>, at <strong><span style="color:red">${eventTime.getHours()-1}:${eventTime.getMinutes()}</span></strong> in <strong>${location}</strong>.</p>
        
        ${type === 'meeting' ? 
        
        "The points to be discussed are as follows:\n"+
        ul : (type === 'training' ? `The training will be directed by ${professeurName}.` : '')}
        <p>Your presence would be greatly appreciated.</p>
        <p>See you soon,</p>
     ${footer}
    </body>
    </html>`;

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
        <p> chers membres,</p>
        <p>Nous avons le plaisir de vous inviter à notre     ${translatedType} <strong><span style="color:red"><u>${eventname}</u></span></strong> qui se déroulera le <strong><u>à ${formattedDateFrensh}</u></strong> à partir de <strong><span style="color:red">${eventTime.getHours()-1}:${eventTime.getMinutes()}</span></strong> à <strong><span style="color:blue"> ${location}.</span></strong> </p>
        ${type === 'meeting' ?
        
        "Les points qui seront abordés sont les suivants:\n"+
        ul : (type === 'training' ? `La formation sera dirigée par ${professeurName}.` : '')}

       
        <p>Votre présence nous fera énormément plaisir.</p>
        <p>À très bientôt,</p>
       ${footer}
    </body>
    </html>`;
   emailConfig(language,englishHTMLContent,frenchHTMLContent,`Invitation to ${eventname} ${type}`,`Invitation à ${eventname} ${type}`,participants,true)

}



export const participationEmail=async(eventname:string, eventTime: Date, location: string,language:string,participants:string,nomPartipant:string)=> {
    
   
   // Format eventTime to display month, day, and year
   const formattedDate = eventTime.toLocaleDateString('en-US', { 
    month: 'long', 
    day: 'numeric', 
    year: 'numeric' 
});
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
    <h1 style="color: #0056b3;">Thank You for Participating!</h1>
    <p>Dear ${nomPartipant},</p>
    
    <p>We wanted to express our sincere gratitude for your participation in the event "<strong>${eventname}</strong" that took place on <strong>${formattedDate}</strong> at <strong>${location}</strong>.</p>
    
    <p>Your active involvement and contributions made the event a great success. We truly appreciate your enthusiasm and dedication.</p>
    
    <p>Thank you once again for being a part of this memorable occasion. We look forward to seeing you at future events!</p>

    <p>Best regards,</p>
       
     ${footer}
    </body>
    </html>`;

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
    <h1 style="color: #0056b3;">Merci d'avoir participé !</h1>
    <p>Cher(e) ${nomPartipant},</p>
    
    <p>Nous tenons à vous exprimer notre sincère gratitude pour votre participation à l'événement "<strong>${eventname}</strong> " qui a eu lieu le <strong>${formattedDate}</strong> à <strong>${location}</strong>.</p>
    
    <p>Votre implication active et vos contributions ont contribué au succès de l'événement. Nous apprécions sincèrement votre enthousiasme et votre dévouement.</p>
    
    <p>Merci encore une fois d'avoir été partie prenante de cette occasion mémorable. Nous avons hâte de vous voir lors de futurs événements !</p>

    <p>Meilleures salutations,</p>
        
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,`About your participation to ${eventname}`,`A Propos votre participation: ${eventname}`,participants,false)

}


export const sendVerifiedMemberEmail=async(language:string,participants:string,email:string)=> {
    // Create a transporter
  
    // English HTML content
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <h1>Welcome to Our Community!</h1>
        <p>Dear ${participants},</p>
        <p>Congratulations! We are delighted to inform you that you have been officially verified as a new member of our community. Your membership status has been successfully confirmed.</p>
        <p>As a verified member, you now have access to exclusive benefits,  and resources tailored to meet your needs.</p>
        <p>Thank you for choosing to be a part of our community, and we look forward to your active participation and engagement.</p>
        <p>Best regards,</p>

    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <h1>Bienvenue dans Notre Communauté !</h1>
        <p>Cher(e) ${participants},</p>
        <p>Nous sommes ravis de vous accueillir officiellement en tant que nouveau membre de notre communauté. Votre adhésion est importante pour nous, et nous sommes heureux de vous compter parmi nous !</p>
        <p>En tant que membre, vous aurez accès à une large gamme de ressources et d'opportunités pour vous connecter avec des personnes partageant les mêmes idées.</p>
        <p>Merci de nous rejoindre, et nous sommes impatients de votre participation active et de vos contributions.</p>
     
      
    </div>
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,"Welcome to our community","Bienvenue dans notre communauté",email,false)

}
export const sendUpdatedPointsEmail=async(language:string,participants:string,points:number,email:string)=> {
    // Create a transporter
  
    // English HTML content
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
    <h1>Points Updated</h1>
    <p>Dear ${participants},</p>
    <p>We are writing to inform you that your points have been updated to <strong>${points}</strong>. Your updated points balance is now available for your review.</p>
    <p>If you have any questions or concerns regarding your points balance, please feel free to contact us.</p>
    <p>Thank you for your continued participation and engagement.</p>
    <p>Best regards,</p>
    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
    <h1>Points Mis à Jour</h1>
    <p>Cher(e) ${participants},</p>
    <p>Nous vous informons que vos points ont été mis à jour à <strong>${points}</strong>. Votre solde de points mis à jour est maintenant disponible pour votre examen.</p>
    <p>Si vous avez des questions ou des préoccupations concernant votre solde de points, n'hésitez pas à nous contacter.</p>
    <p>Nous vous remercions de votre participation et de votre engagement continu.</p>
    <p>Cordialement,</p>
    </div>
       ${footer}
    </body>
    </html>`;
   emailConfig(language,englishHTMLContent,frenchHTMLContent,"Points Updated","Points Mis à Jour",email,false)
}

export const sendMembershipEmail=async(language:string,participants:string, email:string)=> {
    // Create a transporter
  
    // English HTML content
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
    <h1>Points Updated</h1>
    <p>Dear ${participants},</p>
    <p>We are writing to inform you that your membership status has been updated</p>
    <p>Thank you for your continued support and participation.</p>
    <p>Best regards,</p>
    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
    <h1>Points Mis à Jour</h1>
    <p>Cher(e) ${participants},</p>
    <p>Nous vous informons que votre statut d'adhésion a été mis à jour. </p>
   
    <p>Nous vous remercions pour votre soutien et votre participation continue.</p>
    <p>Cordialement,</p>
    </div>
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,"Membership Updated","Cotisation Mis à Jour",email,false)

}

export const sendPromotionEmail=async(language:string,participants:string,type:string,email:string)=> {
    // Create a transporter
    const Franshdic: { [key: string]: string }={ "admin":"administrateur","super admin":" super administrateur",}
    const translatedType = Franshdic[type] || ''; 
    // English HTML content
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
    <h1>Congratulations! You are Now ${type}</h1>
    <p>Dear ${participants},</p>
    <p>We are pleased to inform you that you have been promoted to the role of a ${type}. This new role grants you additional privileges and responsibilities within our organization.</p>
    <p>As a ${type}, you will have access to advanced features and functionalities, and you will play a key role in managing and overseeing our platform.</p>
    <p>Thank you for your dedication and commitment. We trust that you will continue to contribute positively to our community.</p>
    <p>Congratulations once again on your well-deserved promotion!</p>
    <p>Best regards,</p>
    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
    <h1>Félicitations ! Vous êtes Maintenant un Super Administrateur</h1>
    <p>Cher(e) ${participants},</p>
    <p>Nous avons le plaisir de vous informer que vous avez été promu(e) au poste de Super Administrateur. Ce nouveau rôle vous accorde des privilèges et des responsabilités supplémentaires au sein de notre organisation.</p>
    <p>En tant que Super Administrateur, vous aurez accès à des fonctionnalités avancées, et vous jouerez un rôle clé dans la gestion et la supervision de notre plateforme.</p>
    <p>Merci pour votre dévouement et votre engagement. Nous avons confiance en votre capacité à continuer à contribuer positivement à notre communauté.</p>
    <p>Félicitations encore une fois pour votre promotion bien méritée !</p>
    <p>Cordialement,</p>
    </div>
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,`${lodash.capitalize(type)} Promotion`,`Promotion en ${lodash.capitalize(translatedType)}`,email,false)

}
export const sendReportIncativity=async(language:string,participants:string,email:string)=> {

    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
  
    <p>Dear ${participants},</p>
    <p>We hope this email finds you well.</p>
    <p>We've noticed that there has been a lack of activity from your account recently. Here are some details:</p>
    <ul>
        <li>No logins recorded in the past month.</li>
        <li>No participation in community events or discussions.</li>
        <li>No contributions or interactions with other members.</li>
    </ul>
    <p>We value your participation in our community and would like to encourage you to engage more actively.</p>
    <p>If you have any questions or need assistance, please feel free to reach out to us.</p>
    <p>Thank you.</p>
    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
    <p>Cher(e) ${participants},</p>

    <p>Nous espérons que vous allez bien.</p>
    <p>Nous avons remarqué qu'il y a eu peu d'activité sur votre compte récemment. Voici quelques détails :</p>
    <ul>
        <li>Aucune connexion enregistrée au cours du dernier mois.</li>
        <li>Aucune participation aux événements ou discussions de la communauté.</li>
        <li>Aucune contribution ou interaction avec d'autres membres.</li>
    </ul>
    <p>Nous apprécions votre participation dans notre communauté et vous encourageons à vous engager plus activement.</p>
    <p>Si vous avez des questions ou avez besoin d'assistance, n'hésitez pas à nous contacter.</p>
    <p>Merci.</p>
    </div>
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,'Inactivity report ',`Rapport d'inactivité `,email,false)

}
export const sendReportmembership=async(language:string,participants:string,email:string)=> {
    // Create a transporter
 
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">

    <p>Dear ${participants},</p>
    <p>We hope this email finds you well.</p>
    <p>This is a reminder that your membership fee payment for the current period is still outstanding.</p>
    <p>Please arrange for the payment at your earliest convenience to avoid any disruption to your membership benefits.</p>
    <p>If you have already made the payment, please disregard this message.</p>
    <p>Thank you.</p>
    </div>
${footer}
 

</body>
</html>
    `
    

    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
    <p>Cher(e) ${participants},</p>
    <p>Nous espérons que vous allez bien.</p>
    <p>Nous vous rappelons que le paiement de votre cotisation pour la période actuelle est toujours en attente.</p>
    <p>Veuillez effectuer le paiement dès que possible afin d'éviter toute interruption dans vos avantages en tant que membre.</p>
    <p>Si vous avez déjà effectué le paiement, veuillez ignorer ce message.</p>
    <p>Nous vous remercions.</p>
    </div>
       ${footer}
    </body>
    </html>`;
    emailConfig(language,englishHTMLContent,frenchHTMLContent,'Membership report ',`Rapport de cotisation `,email,false)

}
export const CreationOfTeamEmail=async (language:string,emai:string,teamName:string,eventname:string)=>{
    const englishHTMLContent =`
    <html >

<body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">

    <p>Dear Members,</p>
    <p>We are excited to announce the creation of a new team within our organization: <strong>${teamName}</strong>. for event ${eventname}</p>
    <p> We believe that it will provide an excellent opportunity for members  to come together, collaborate, and make a meaningful impact.</p>
    <p>If you are interested in joining this team or learning more about its activities</p>
    <p>Let's work together to make this new team a great success!</p>
    <p>Best regards,</p>
    </div>
${footer}
 

</body>
</html>
    `
      // French HTML content
      const frenchHTMLContent = `
      <html>
      <body style="font-family: Arial, sans-serif;">
          
      <!-- French Version -->
      <div>
      <p>Chers membres,</p>
    <p>Nous sommes ravis de vous annoncer la création d'une nouvelle équipe au sein de notre organisation : <strong>${teamName}</strong>. de notre nouvelle événement ${eventname}</p>
    <p> Nous sommes convaincus qu'elle offrira une excellente opportunité aux membres intéressés  de se rassembler, de collaborer et de faire une différence significative.</p>
    <p>Si vous êtes intéressé(e) à rejoindre cette équipe ou à en savoir plus sur ses activités,</p>
    <p>Travaillons ensemble pour faire de cette nouvelle équipe un grand succès !</p>
    <p>Cordialement,</p>
      </div>
         ${footer}
      </body>
      </html>`;
      emailConfig(language,englishHTMLContent,frenchHTMLContent,`New Team Created:${teamName}`,`Nouvelle Équipe Créée : ${teamName}`,emai,true)
}



export const sendInvitationEmail = async (language: string, email: string, teamName: string, eventName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>You have been invited to join the team <strong>${teamName}</strong> for the event <strong>${eventName}</strong>.</p>
        <p>We believe that your participation will greatly contribute to the success of the team.</p>
        <p>If you are interested in joining this team or learning more about its activities, please let us know.</p>
        <p>Looking forward to working with you!</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>Vous êtes invité(e) à rejoindre l'équipe <strong>${teamName}</strong> pour l'événement <strong>${eventName}</strong>.</p>
        <p>Nous sommes convaincus que votre participation contribuera grandement au succès de l'équipe.</p>
        <p>Si vous êtes intéressé(e) à rejoindre cette équipe ou à en savoir plus sur ses activités, veuillez nous le faire savoir.</p>
        <p>En attendant de travailler avec vous !</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Invitation to Join Team: ${teamName}`, `Invitation à Rejoindre l'Équipe : ${teamName}`, email, false);
}
export const sendKickMemberEmail = async (language: string, email: string, teamName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>We regret to inform you that you have been removed from the team <strong>${teamName}</strong>.</p>
        <p>If you have any questions or concerns, please feel free to contact us.</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>Nous avons le regret de vous informer que vous avez été retiré(e) de l'équipe <strong>${teamName}</strong>.</p>
        <p>Si vous avez des questions ou des préoccupations, n'hésitez pas à nous contacter.</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Removal from Team: ${teamName}`, `Retrait de l'Équipe : ${teamName}`, email, false);
}

export const sendMemberJoinEmail = async (language: string, email: string, teamName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>We are pleased to inform you that you have successfully joined the team <strong>${teamName}</strong>.</p>
        <p>We look forward to your contributions and collaboration within the team.</p>
        <p>If you have any questions or need assistance, please feel free to contact us.</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>Nous avons le plaisir de vous informer que vous avez rejoint avec succès l'équipe <strong>${teamName}</strong>.</p>
        <p>Nous attendons avec impatience vos contributions et votre collaboration au sein de l'équipe.</p>
        <p>Si vous avez des questions ou avez besoin d'aide, n'hésitez pas à nous contacter.</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Welcome to Team: ${teamName}`, `Bienvenue dans l'Équipe : ${teamName}`, email, false);
}
export const sendTaskAssignmentEmail = async (language: string, email: string, taskName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>You have been assigned to the task <strong>${taskName}</strong>.</p>
        <p>Please review the details of the task and let us know if you have any questions.</p>
        <p>Thank you for your cooperation!</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>Vous avez été affecté(e) à la tâche <strong>${taskName}</strong>.</p>
        <p>Veuillez consulter les détails de la tâche et n'hésitez pas à nous contacter si vous avez des questions.</p>
        <p>Merci pour votre coopération !</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Task Assignment: ${taskName}`, `Affectation de Tâche : ${taskName}`, email, false);
}

export const sendSubtaskCreatedEmail = async (language: string, email: string, taskName: string, subtaskName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>A new subtask named <strong>${subtaskName}</strong> has been created within the task <strong>${taskName}</strong>.</p>
        <p>Please review the details of the subtask and let us know if you have any questions.</p>
        <p>Thank you for your cooperation!</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>Une nouvelle sous-tâche nommée <strong>${subtaskName}</strong> a été créée dans la tâche <strong>${taskName}</strong>.</p>
        <p>Veuillez consulter les détails de la sous-tâche et n'hésitez pas à nous contacter si vous avez des questions.</p>
        <p>Merci pour votre coopération !</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `New Subtask in Task: ${taskName}`, `Nouvelle Sous-tâche dans la Tâche : ${taskName}`, email, false);
}
export const sendTaskDeadlineOverdueEmail = async (language: string, email: string, taskName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>The deadline for the task <strong>${taskName}</strong> has passed.</p>
        <p>Please take immediate action to complete or update the status of the task as necessary.</p>
        <p>If you have any questions or need assistance, please feel free to contact us.</p>
        <p>Thank you for your attention to this matter.</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>La date limite pour la tâche <strong>${taskName}</strong> est dépassée.</p>
        <p>Veuillez prendre des mesures immédiates pour terminer ou mettre à jour le statut de la tâche si nécessaire.</p>
        <p>Si vous avez des questions ou avez besoin d'aide, n'hésitez pas à nous contacter.</p>
        <p>Merci de votre attention à cette question.</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Task Deadline Overdue: ${taskName}`, `Date Limite de la Tâche Dépassée : ${taskName}`, email, false);
}
export const sendTaskCompletedEmail = async (language: string, email: string, taskName: string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="margin-bottom: 20px;">
        <p>Dear Member,</p>
        <p>The task <strong>${taskName}</strong> has been completed successfully.</p>
        <p>Thank you for your efforts and contributions towards the completion of this task.</p>
        <p>If you have any questions or need assistance, please feel free to contact us.</p>
        <p>Best regards,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div>
        <p>Cher(e) Membre,</p>
        <p>La tâche <strong>${taskName}</strong> a été terminée avec succès.</p>
        <p>Merci pour vos efforts et contributions à l'achèvement de cette tâche.</p>
        <p>Si vous avez des questions ou avez besoin d'aide, n'hésitez pas à nous contacter.</p>
        <p>Cordialement,</p>
    </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Task Completed: ${taskName}`, `Tâche Terminée : ${taskName}`, email, false);
}
export const sendPresenceEmail = async (language: string, email: string, activityname:string,points:number) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
   <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">
    <h1 style="color: #007bff; margin-bottom: 20px;">Attendance Confirmation</h1>
    <p>Dear Member,</p>
    <p>We're delighted to inform you that your attendance has been successfully recorded, and you've earned ${points} points</p>
    <p>Thank you for joining us in <Strong>${activityname}</strong>,. Your active participation is greatly appreciated.</p>
    <p>If you have any inquiries or require further assistance, don't hesitate to contact us.</p>
    <p>Best regards,<br>
    
  </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">
    <h1 style="color: #007bff; margin-bottom: 20px;">Confirmation de présence</h1>
    <p>Cher(e) membre,</p>
    <p>Nous sommes ravis de vous informer que votre présence a été enregistrée avec succès et que vous avez gagné des ${points}  points supplémentaires !</p>
    <p>Merci de nous avoir rejoints ${activityname}. Votre participation active est grandement appréciée.</p>
    <p>Si vous avez des questions ou avez besoin d'aide supplémentaire, n'hésitez pas à nous contacter.</p>
    <p>Cordialement,<br>
   
  </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Attendance Confirmation`, `Confirmation de présence`, email, false);
}

export const sendAbsenceEmail = async (language: string, email: string, activityname:string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
    <h1 style="color: #dc3545;">Absence Notification</h1>
    <p>Dear Member,</p>
    <p>We regret to inform you that you have been marked as absent for ${activityname}.</p>
    <p>Due to your absence, a certain number of points have been deducted from your account.</p>
    <p>If you believe this absence has been marked in error or if you have any concerns, please don't hesitate to reach out to us.</p>
    <p>Best regards,<br>
    
  </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">
    <h1 style="color: #007bff; margin-bottom: 20px;">Confirmation de présence</h1>
    <p>Cher(e) member</p>
    <p>Nous avons le regret de vous informer que vous avez été marqué comme absent pour ${activityname}.</p>
    <p>En raison de votre absence, un certain nombre de points ont été déduits de votre compte.</p>
    <p>Si vous pensez que cette absence a été marquée par erreur ou si vous avez des préoccupations, n'hésitez pas à nous contacter.</p>
    <p>Cordialement,<br>
    </div>
  </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Absence Notification`, `Notification d'absence`, email, false);
}
export const ReminderActivity = async (language: string, email: string, activityname:string,date:Date,location:string) => {
    // English HTML content
    const englishHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">

    <!-- English Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Dear members</p>
   
 
    <p>This is a reminder for your participation in <strong>${activityname}</strong>.</p>
    <p>The event will take place at ${location} on ${date.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })} at ${date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}.</p>
    <p>We hope to see you at the event!</p>
    <p>If you have any questions or cannot attend, please contact us as soon as possible.</p>
    <p>Best regards,<br>

  </div>
    ${footer}
    </body>
    </html>`;
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Cher(e) members</p>
    <p>Ceci est un rappel pour votre participation à <strong>${activityname}</strong>.</p>
    <p>L'événement se déroulera à ${location} le ${date.toLocaleDateString('fr-FR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })} à ${date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}.</p>
    <p>Nous espérons vous voir à l'événement !</p>
    <p>Si vous avez des questions ou si vous ne pouvez pas participer, veuillez nous contacter dès que possible.</p>
    <p>Cordialement,<br>
    </div>
  </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig(language, englishHTMLContent, frenchHTMLContent, `Reminder: ${activityname}`, `Rappel:${activityname}`, email, false);
}
export const sendAddGuestEmail = async ( email: string, activityname:string,guestname:string,lieu:string,date:Date) => {
    // English HTML content
    
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Cher(e) ${guestname }</p>
   
 
    <p>Nous avons le plaisir de vous inviter à participer à <strong>${activityname}</strong>.</p>
    <p>L'événement se déroulera à ${lieu} le ${date.toLocaleDateString('fr-FR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })} à ${date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}.</p>
    <p>Nous serions honorés de votre présence à cet événement et nous espérons que vous pourrez vous joindre à nous.</p>
    <p>Veuillez confirmer votre présence dès que possible.</p>
    <p>Si vous avez des questions ou besoin d'informations supplémentaires, n'hésitez pas à nous contacter.</p>
    <p>Cordialement,<br>
  
  </div>


    </div>
  </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig('fr', '', frenchHTMLContent, `Absence Notification`, `A propos votre participation à ${activityname}`, email, false);
}
export const ConfirmGuestPartGuestEmail = async ( email: string, activityname:string,guestname:string,lieu:string,date:Date) => {
    // English HTML content
    
  
    // French HTML content
    const frenchHTMLContent = `
    <html>
    <body style="font-family: Arial, sans-serif;">
        
    <!-- French Version -->
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);">

    <p>Cher(e) ${guestname }</p>
   
 
    <p>Nous sommes ravis de vous informer que vous avez participé à ${activityname}.</p>
    <p>Votre présence a été enregistrée et nous vous remercions d'avoir pris part à ${activityname}.</p>
    <p>N'hésitez pas à nous contacter si vous avez des questions ou besoin d'assistance supplémentaire.</p>
    <p>Cordialement,<br>
  </div>


    </div>
  </div>
    ${footer}
    </body>
    </html>`;
  
    // Call the emailConfig function with the appropriate parameters
    emailConfig('fr', '', frenchHTMLContent, `Confirmation de participation `, `Confirmation de participation  à ${activityname}`, email, false);
}
