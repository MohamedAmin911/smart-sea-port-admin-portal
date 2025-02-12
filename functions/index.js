const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");

// Initialize Firebase Admin
admin.initializeApp();

// Set SendGrid API Key
const SENDGRID_API_KEY = functions.config().sendgrid.apikey;
sgMail.setApiKey(SENDGRID_API_KEY);


// Cloud Function to Send Approval Email
exports.sendApprovalEmail = functions.database
    .ref("/customers/{customerId}/accountStatus")
    .onUpdate(async (change, context) => {
      const before = change.before.val();
      const after = change.after.val();

      // Trigger only when status changes from pending to approved
      if (before === "pending" && after === "approved") {
        const customerId = context.params.customerId;
        const customerRef = admin.database().ref(`/customers/${customerId}`);
        const snapshot = await customerRef.once("value");
        const customerData = snapshot.val();

        if (!customerData) return null;

        const msg = {
          to: customerData.email,
          from: "your@example.com",
          subject: "Approval",
          text: "Your account is approved!",
          html: `<p>Your account is approved!</p>`,
        };


        return sgMail.send(msg)
            .then((response) => console.log("Email sent"))
            .catch((error) => console.error("Error sending email:", error));
      }
      return null;
    });
