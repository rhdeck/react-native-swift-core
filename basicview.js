import { requireNativeComponent } from "react-native";
import React, { Component } from "react";

const NativeView = requireNativeComponent(
  "react_native-swift-registryBasicView",
  BasicView
);
class BasicView extends Component {
  render() {
    return <NativeView {...this.props} />;
  }
}
export default BasicView;
