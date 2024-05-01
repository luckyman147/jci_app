
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
    try {
        // Create a transporter object using SMTP transport
        const imagePath = '.\\uploads\\Events\\jci.png';    
      
        // Email content
        let mailOptions: nodemailer.SendMailOptions = {
            from: process.env.EMAILCONTACT, // Sender address
            to: toEmail, // Recipient email address
            subject: `Reset Password Verification code ${otp}`, // Subject line
            text: `Your OTP is: ${otp}`, // Plain text body
            html: ` <div style="text-align: center;">
            <p>Your OTP is: <strong>${otp}</strong></p>
            <p style="color: red;">OTP is valid for 5 minutes.</p>
        </div>${footer}
            ` ,// HTML body
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
    try {
        const imagePath = '.\\uploads\\Events\\jci.png';    

        if (language=="en"){
            // Send mail with defined transport object
            await transporter.sendMail({
                from: process.env.EMAIL, // Sender address
                to: participants, // List of recipients
                subject: `Invitation to ${eventname} `, // Subject line
                html: englishHTMLContent, // HTML content for English version
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
        else{
            // Send mail with defined transport object for French version
            await transporter.sendMail({
                from: process.env.EMAIL, // Sender address
                to: participants, // List of recipients
                subject: `Invitation: ${eventname}`, // Subject line for French version
                html: frenchHTMLContent,
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
                ] // HTML content for French version
                 // Plain text fallback
            });
        }
            console.log("Emails sent successfully");
            return true
    } catch (error) {
        console.log("Error sending emails", error)
        return false
    }

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
    try {
        const imagePath = '.\\uploads\\Events\\jci.png';    

        if (language=="en"){
            // Send mail with defined transport object
            await transporter.sendMail({
                from: process.env.EMAIL, // Sender address
                to: participants, // List of recipients
                subject: `About your participation to ${eventname} `, // Subject line
                html: englishHTMLContent, // HTML content for English version
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
        else{
            // Send mail with defined transport object for French version
            await transporter.sendMail({
                from: process.env.EMAIL, // Sender address
                to: participants, // List of recipients
                subject: `A Propos votre participation: ${eventname}`, // Subject line for French version
                html: frenchHTMLContent,
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
                ] // HTML content for French version
                 // Plain text fallback
            });
        }
            console.log("Emails sent successfully");
            return true
    } catch (error) {
        console.log("Error sending emails", error)
        return false
    }

}




