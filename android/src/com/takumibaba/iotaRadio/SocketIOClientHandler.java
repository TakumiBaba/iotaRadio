package com.takumibaba.iotaRadio;

import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.util.Log;

import com.codebutler.android_websockets.SocketIOClient.Handler;

public class SocketIOClientHandler implements Handler, TextToSpeech.OnInitListener{

	private Context context;
	private TextToSpeech tts;
	//コンストラクタの部分でttsを宣言。contextを引数にすればいけそう？
	SocketIOClientHandler(Context context){
		this.context = context;
		tts = new TextToSpeech(this.context,this);
	}

	@Override
	public void onConnect() {
		// TODO Auto-generated method stub
		
		Log.d("websocket","connection start");
		
		
	}

	@Override
	public void on(String event, JSONArray arguments) {
		
		if(event.equals("weather")){
			JSONObject contents = null;
			try {
				contents = arguments.getJSONObject(0);
				tts.speak(contents.getString("contents"), TextToSpeech.QUEUE_FLUSH,null);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else{
			
		}
		Log.d("websocket",event);
		Log.d("websocket",arguments.toString());
		JSONObject hoge = null;
		try{
			hoge = arguments.getJSONObject(0);
			Log.d("hoge",hoge.getString("hoge"));
			tts.speak(hoge.getString("hoge"),TextToSpeech.QUEUE_FLUSH,null);
		}catch(JSONException e){
			e.printStackTrace();
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
	 
	public void onInit(int status){
		if(TextToSpeech.SUCCESS == status){
			Locale locale = Locale.JAPAN;
			if(tts.isLanguageAvailable(locale) >= TextToSpeech.LANG_AVAILABLE){
				tts.setLanguage(locale);
				Log.d("test","language set");
			}else{
				
				Log.d("", "Error setlocal");
			}
		}else{
			Log.d("","error init");
		}
	}
}
