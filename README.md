# Swift Secret Vault Plugin

A Swift plugin for managing secrets securely and efficiently. This plugin provides compile-time code generation that hides your secrets as byte arrays and only exposes them during runtime.

## Features

**Secure Secret Generation**:
Secure Secret Generation: Generate secrets by transforming byte arrays and applying XOR encryption for enhanced security.

**Compile-Time Code Generation**:
Utilize compile-time code generation techniques to access secrets, ensuring efficient and optimized integration into your Swift projects.

**Customizable Secret Specialization**:
Specialize secrets based on different compiler flags that already exist in your project, allowing you to manage and utilize secrets tailored to specific environments, enhancing flexibility and security.

## Installation
Using `Swift Secret Vault Plugin` requires Swift 5.9+ toolchain with the Swift Package Manager.

### Xcode Project
1. Open your Xcode project.
2. Go to File > Add Package Dependency.
3. Enter the URL of the package repository: `https://github.com/Commencis/swift-secrets-vault-plugin`.
4. Follow the prompts to complete the installation.

### Swift Package Manager (SPM)

Add the following dependency to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/Commencis/swift-secrets-vault-plugin", from: "1.0.0")
]
````

## Usage

### Setting Up Secrets

**Folder Structure:**
- Create a hidden folder named .rxByteArraySecrets at the root of your Xcode project or target root directory, such as `Sources/{{Target}}/.rxByteArraySecrets/..`.
- Inside this folder, create a JSON file to contain your secrets.

**JSON Format:**
   - The JSON file should have the following structure:

```json
{
    "declarationName": "ExampleSecret",
    "secretDeclarations": [
        {
            "secretName": "mySecret",
            "xorValue": 42,
            "strict": false,
            "secrets": [
                {
                    "value": "DEFAULT_SECRET"
                },
                {
                    "value": "RELEASE_SECRET",
                    "flags": ["RELEASE"]
                }
            ]
        },
        ...
    ]
}
```
- Declare as many secrets as required under the `secretDeclarations` array.
- Each secret should have a unique `secretName`.
- You can specify a fixed `xorValue` between 0-255 for encryption. If not provided, a random value will be used.
- Use the `secrets` array to specify different variations of the secret, specialized for different compiler flags
- When no flags are provided, the secret is considered the default.
- Set `strict` to `false` if you don't need a certain secret in some configurations.

### Xcode Project

**Enable the Plugin:**
1. In your Xcode Project settings, select your Target.
2. Go to `Build Phases`.
3. Open `Run Build Tool Plug-in`.
4. Select `Swift Secret Vault Plugin` and then `RXByteArraySecretPlugin` to enable your plugin.

**Secret Files:**
- Ensure your secrets are located in the hidden folder `.rxByteArraySecrets` at the root of your project
- Each secret file in `.rxByteArraySecrets` will be generated into a secret source file at compile time.

**Multiple Targets:**
- Repeat the plugin-enabling process for each target you desire.

**Specializing Secret Files for Each Target:**
- If you want to specialize secret files for each target, add a `config.json` file to `.rxByteArraySecrets`.
- Use the unique name of the target and secret file names as follows:
```json
{
    "targetSecretMap": [
        {
            "targetName": "ExampleApp",
            "secretFileNameList": ["ExampleSecrets"]
        },
        {
            "targetName": "ExampleAppWidget",
            "secretFileNameList": ["ExampleSecretsWidget"]
        },
        ...
    ]
}
```

### Swift Package Manager (SPM)

**Add the Plugin to Your Target:**
In your `Package.swift` file, add the plugin to your target.
```swift
.target(
    name: "ExampleTarget",
    plugins: [.plugin(name: "RXByteArraySecretPlugin")]
)
```

**Secret Files Generation**:
- Ensure your secrets are located in the hidden folder `Sources/{{Target}}/.rxByteArraySecrets`.
- You can start accessing your secrets declared in the secret files located in this directory.

### Get your secret key in your app

You can access your secret key using the following syntax:

```swift
ExampleSecret.mySecret()
```

### License

This project is licensed under the MIT License. You are free to modify, distribute, and use the code in your projects. Please refer to the [LICENSE](https://github.com/Commencis/swift-secrets-vault-plugin/blob/main/LICENSE) file for more details.
