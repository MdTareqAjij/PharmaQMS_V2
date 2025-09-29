Pharma QMS - Final workspace ready for release build
===================================================

This archive contains two Flutter apps:
- pharma_qms_user
- pharma_qms_admin

What I prepared for you:
- Firebase configuration files included (google-services.json and firebase_options.dart) as you uploaded.
- Admin app integrates with Drive upload server (see extras/drive_upload_server).
- key.properties placeholders added under android/app for both apps.
- GitHub Actions workflow (.github/workflows/build_aab.yml) to build AAB in CI using secrets.

IMPORTANT: I cannot build the AAB files in this environment. You must either build locally or use the provided GitHub Action.

How to create a release AAB locally (recommended):
1. Install Flutter and Android SDK.
2. Create a release keystore:
   keytool -genkey -v -keystore key.jks -alias your-key-alias -keyalg RSA -keysize 2048 -validity 10000
   Move the generated key.jks into the android/app/ folder of the app (pharma_qms_user/android/app/ or pharma_qms_admin/android/app/).
3. Edit android/app/key.properties and set storePassword, keyPassword, keyAlias, storeFile accordingly.
4. Run:
   cd pharma_qms_user
   flutter pub get
   flutter build appbundle --release
   The AAB will be at build/app/outputs/bundle/release/app-release.aab
5. Repeat for pharma_qms_admin if needed.

How to use GitHub Actions to build the AAB:
1. In your GitHub repo, add the following secrets:
   - KEYSTORE_BASE64 : base64 encoded content of your key.jks
   - KEYSTORE_PASSWORD
   - KEY_PASSWORD
   - KEY_ALIAS
2. Push this repo and run the workflow (Actions -> Build Flutter AAB -> Run workflow, choose app path input).
3. The AAB artifact will be available for download from the workflow run artifacts.

Drive upload server:
- Located in extras/drive_upload_server. You must set .env with GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GOOGLE_REFRESH_TOKEN.
- Run `npm install` and `npm start` to host the service. Then update the Admin app upload URL in code (CreateContentScreen) from http://YOUR_SERVER_IP:3000/upload to your server's address.

Security notes:
- Do NOT commit your keystore passwords or client secrets publicly.
- Use Firebase custom claims for admin role in production; do not rely on email checks.
