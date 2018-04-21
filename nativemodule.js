import { NativeModules, NativeEventEmitter } from "react-native";
const react_native-swift-registry_native = NativeModules.react_native-swift-registry;

const react_native-swift-registry = {
  nativeObj: react_native-swift-registry_native,
  a: react_native-swift-registry_native.a,
  b: react_native-swift-registry_native.b,
  startTime: react_native-swift-registry_native.startTime,
  addListener: cb => {
    const e = new NativeEventEmitter(react_native-swift-registry_native);
    const s = e.addListener("react_native-swift-registry", cb);
    return s;
  },
  addListenerDemo: () => {
    react_native-swift-registry.addListener(arr => {
      console.log("Received a react_native-swift-registry event", arr.message);
    });
  },
  emitMessage: async (message, delayms) => {
    if (!delayms) delayms = 0;
    return await react_native-swift-registry_native.delayedSend(message, delayms);
  },
  demoWithPromise: async message => {
    //Returns a promise!
    const output = await react_native-swift-registry_native.demo(message);
    return output;
  }
};

export default react_native-swift-registry;
