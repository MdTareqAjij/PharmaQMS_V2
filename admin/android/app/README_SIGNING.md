Signing setup (placeholder)
---------------------------
This folder includes a key.properties file with placeholders.
To create a release keystore and build an AAB, follow these steps:

1. Create a keystore (run on your machine):
   keytool -genkey -v -keystore key.jks -alias your-key-alias -keyalg RSA -keysize 2048 -validity 10000
   (you will be prompted to enter passwords and details)

2. Replace values in key.properties with your keystore passwords and alias.
   - storeFile should point to the keystore filename (key.jks) in this folder.

3. Update your android/app/build.gradle signingConfigs release block if necessary.
   The provided project is already set to read key.properties if present.

4. Build the AAB locally:
   flutter build appbundle --release

OR use the provided GitHub Actions workflow by storing your keystore as a base64 secret and the passwords as secrets.
