package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import java.io.BufferedReader;
import com.facebook.react.bridge.Promise;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import android.os.AsyncTask;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;
import java.net.InetAddress;
import java.net.InetSocketAddress;


public class RNReactNativePingTcpModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNReactNativePingTcpModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNReactNativePingTcp";
  }


 @ReactMethod
    public void Connect(final String command, final String Serv, int port,  Callback callback) {

     Socket s = null;
     String resultResponse = null;
     String answer = null;
     try {
         InetAddress serverAddress = InetAddress.getByName(Serv);
         s = new Socket();
         s.connect(new InetSocketAddress(serverAddress, port), 5000);
         s.setSoTimeout(20000);
         s.setSoLinger(true,1000);

         BufferedReader in = null;
         PrintWriter out = null;
         if (s.isConnected()) {
             try {
                 in = new BufferedReader(new InputStreamReader(s.getInputStream()));
                 out = new PrintWriter(new OutputStreamWriter(s.getOutputStream()));
                 out.println(command);
                 out.flush();
                 resultResponse = in.readLine();


             } catch (IOException ioe) {
                 resultResponse = ioe.toString();
             } finally {
                 if (s != null) {
                     try {
                         out.close();
                         in.close();
                         s.close();
                     } catch (IOException e) {
                         // TODO Auto-generated catch block
                         resultResponse = e.toString();
                     }
                 }
             }
         }else{
             resultResponse = "No connection";
         }
        }
      catch (Exception e)
      {
          resultResponse = e.toString();
      }

     callback.invoke(null, ((String) resultResponse));

    }
    
}