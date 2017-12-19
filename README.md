
# react-native-ping-tcp

It's simple react-native module for working with TCP. 
The module have only one method - Connect :)

After calling Connect:
- Open TCP connect with server and port
- Send message in open channel
- Waiting answed and close connect


## Getting started

`$ npm install https://github.com/AntonSeagull/react-native-ping-tcp --save`

### Mostly automatic installation

`$ react-native link react-native-ping-tcp`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-ping-tcp` and add `RNReactNativePingTcp.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativePingTcp.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNReactNativePingTcpPackage;` to the imports at the top of the file
  - Add `new RNReactNativePingTcpPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-ping-tcp'
  	project(':react-native-ping-tcp').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-ping-tcp/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-ping-tcp')
  	```

## Usage
```javascript

import RNReactNativePingTcp from 'react-native-ping-tcp';


RNReactNativePingTcp.Connect(message, server, port, (error, request) => {
	...
});

PORT - for Android it's number, for iOS it's string
