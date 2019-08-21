/*
  Copyright (C) 2016 Apple Inc. All Rights Reserved.
  See APPLE_LICENSE.txt for this sample’s licensing information
  
  Abstract:
  This is the container configuration that gets passed to CloudKit.configure.
        Customize this for your own environment.
 */

module.exports = {
  // Replace this with a container that you own.
  containerIdentifier:'iCloud.com.raywenderlich.TIL',

  environment: 'development',

  serverToServerKeyAuth: {
    // Generate a key ID through CloudKit Dashboard and insert it here.
    keyID: '1f404a6fbb1caf8cc0f5b9c017ba0e866726e564ea43e3aa31e75d3c9e784e91',

    // This should reference the private key file that you used to generate the above key ID.
    privateKeyFile: __dirname + '/eckey.pem'
  }
};