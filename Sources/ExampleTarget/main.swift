/// use following command to generate MySecrets
///
/// swift run generateSecret rxByteArraySecret \
///    -j Sources/ExampleTarget/ExampleSecrets.json \
///    -o Sources/ExampleTarget/ExampleSecrets.swift

print(ExampleSecret.myAPIKey())
print(ExampleSecret.myInternalEndpoint()) // Will raise error on release
print(ExampleSecret.myEncryptionKey())
