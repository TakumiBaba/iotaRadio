package com.takumibaba.iotaRadio;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Locale;
import java.util.Queue;

import android.annotation.SuppressLint;
import android.content.Context;
import android.speech.tts.TextToSpeech;
import android.speech.tts.UtteranceProgressListener;
import android.util.Log;

@SuppressLint("NewApi")
public class TtsController extends UtteranceProgressListener implements TextToSpeech.OnInitListener {
	
	public Queue<String> que;
	public TextToSpeech tts;
	public TtsController(Context context) {
		que = new LinkedList<String>();
		tts = new TextToSpeech(context, this);
		//tts.setOnUtteranceProgressListener(this);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onInit(int status) {
		// TODO Auto-generated method stub
		this.tts.setOnUtteranceProgressListener(this);
		if(TextToSpeech.SUCCESS == status){
			Locale locale = Locale.JAPAN;
			if(this.tts.isLanguageAvailable(locale) >= TextToSpeech.LANG_AVAILABLE){
				this.tts.setLanguage(locale);
				Log.d("test","language set");
			}else{
				
				Log.d("", "Error setlocal");
			}
		}else{
			Log.d("","error init");
		}
	}
	
	public void add(String s){
		this.que.offer(s);
	}
	public void next(){
		HashMap<String, String>params = new HashMap<String, String>();
		params.put(TextToSpeech.Engine.KEY_PARAM_UTTERANCE_ID, "testtest");
		String message = this.que.poll();
		this.tts.speak(message, TextToSpeech.QUEUE_FLUSH, params);
	}

	@Override
	public void onDone(String utteranceId) {
		// TODO Auto-generated method stub
		Log.e("TTs", utteranceId);
		this.next();
	}

	@Override
	public void onError(String utteranceId) {
		// TODO Auto-generated method stub
		Log.e("utterance", utteranceId);
		
	}

	@Override
	public void onStart(String utteranceId) {
		// TODO Auto-generated method stub
	}

}
