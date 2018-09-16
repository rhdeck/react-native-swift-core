import { NativeModules, NativeEventEmitter } from "react-native";
//#region Code for object RNSRegistry
const NativeRNSRegistry = NativeModules.RNSRegistry;
const setData = async (key, data) => {
  return await NativeRNSRegistry.setData(key, data);
};
const saveData = async (key, data) => {
  return await NativeRNSRegistry.saveData(key, data);
};
const removeData = async key => {
  return await NativeRNSRegistry.removeData(key);
};
const getData = async key => {
  return await NativeRNSRegistry.getData(key);
};
const addEvent = async (type, key) => {
  return await NativeRNSRegistry.addEvent(type, key);
};
const removeEvent = async key => {
  return await NativeRNSRegistry.removeEvent(key);
};
//#endregion
//#region Exports
export { setData, saveData, removeData, getData, addEvent, removeEvent };
//#endregion
