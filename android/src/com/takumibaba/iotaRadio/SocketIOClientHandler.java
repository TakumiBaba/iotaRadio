package com.takumibaba.iotaRadio;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;

import com.codebutler.android_websockets.SocketIOClient.Handler;

public class SocketIOClientHandler implements Handler{

	private Context context;
	private TtsController ttsController;
	//コンストラクタの部分でttsを宣言。contextを引数にすればいけそう？
	SocketIOClientHandler(TtsController tts){
		this.ttsController = tts;
	}

	@Override
	public void onConnect() {
		// TODO Auto-generated method stub
		
		Log.d("websocket","connection start");
		
	}

	@Override
	public void on(String event, JSONArray arguments) {
		
		if(event.equals("weather")){
			Log.d("websocket", event);
			JSONObject args = null;
			try {
				args = arguments.getJSONObject(0);
				String contents = args.getString("contents");
				String[] dividedContents = new String[5];
				String[] list = contents.split("!!!",0);
				for(int i=0;i<list.length;i++){
					ttsController.add(list[i].trim());
					if(i == 0){
						ttsController.next();
					}
					Log.e("weatherlist", list[i]);
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else{
			
		}
	}

	@Override
	public void onDisconnect(int code, String reason) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onError(Exception error) {
		// TODO Auto-generated method stub

	}
}
