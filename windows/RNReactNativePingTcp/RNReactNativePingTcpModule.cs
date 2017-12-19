using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace React.Native.Ping.Tcp.RNReactNativePingTcp
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNReactNativePingTcpModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNReactNativePingTcpModule"/>.
        /// </summary>
        internal RNReactNativePingTcpModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNReactNativePingTcp";
            }
        }
    }
}
