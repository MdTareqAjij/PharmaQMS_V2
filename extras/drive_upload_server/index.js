require('dotenv').config();
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const {google} = require('googleapis');
const upload = multer({ dest: 'uploads/' });
const app = express();
app.use(express.json());

/*
.env should contain:
GOOGLE_CLIENT_ID=... 
GOOGLE_CLIENT_SECRET=...
GOOGLE_REFRESH_TOKEN=...   // Obtain by performing OAuth2 consent once and storing refresh token here
PORT=3000
*/

const oauth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET
);
oauth2Client.setCredentials({ refresh_token: process.env.GOOGLE_REFRESH_TOKEN });

const drive = google.drive({ version: 'v3', auth: oauth2Client });

app.post('/upload', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'No file uploaded' });
    const filePath = req.file.path;
    const fileMetadata = { name: req.file.originalname };
    const media = { body: fs.createReadStream(filePath) };
    const response = await drive.files.create({
      requestBody: fileMetadata,
      media: media,
      fields: 'id, webViewLink, webContentLink'
    });
    const fileId = response.data.id;
    // make file public
    await drive.permissions.create({
      fileId: fileId,
      requestBody: { role: 'reader', type: 'anyone' }
    });
    const result = await drive.files.get({ fileId: fileId, fields: 'id, webViewLink, webContentLink' });
    // cleanup
    fs.unlinkSync(filePath);
    res.json({ link: result.data.webViewLink || result.data.webContentLink });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.toString() });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Drive upload server running on port', PORT));
