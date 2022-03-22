# Notes

## generate keystore for android signing
```
$ /c/Program\ Files/Android/Android\ Studio/jre/bin/keytool.exe -genkey -v -keystore thegreatantihate.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Make sure you set the password in android/key.properties

