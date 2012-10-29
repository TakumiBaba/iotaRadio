package com.takumibaba.iotaRadio;

import java.net.URI;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.codebutler.android_websockets.SocketIOClient;

@SuppressLint("ShowToast")
public class MainActivity extends Activity {
	private Context context;
	private SocketIOClient client;
	private AsyncTask<String, Void, Void> task;
	public TtsController tts;
	private String[] prefectures;
	private String[] cities;
	private final static int PREFERENCE_INIT = 0;
	private final static int PREFERENCE_BOOTED = 1;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.context = this;
        prefectures = getResources().getStringArray(R.array.prefectures);
        
    }
    
    @Override
    public void onStart(){
    	super.onStart();
    	tts = new TtsController(this.context);
    	SocketIOClientHandler handler = new SocketIOClientHandler(this.tts);
        client = new SocketIOClient(URI.create("http://192.168.111.7:3001"),handler);
    	client.connect();
   
        Button button = (Button)findViewById(R.id.connection_button);
        Button button2 = (Button)findViewById(R.id.area_select);
        button.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
				String prefecture = sp.getString("prefecture", "ìåãûìs");
				String area = sp.getString("city", "ìåãû");
				new AsyncTask<String, Void, Void>(){

					@Override
					protected Void doInBackground(String... params) {
						JSONArray arguments = new JSONArray();
						JSONObject object   = new JSONObject();
						String event = new String("prefecture");
						String event2 = new String("area");
						
						try {
							object.put(event, params[0]);
							object.put(event2, params[1]);
							arguments.put(object);
							client.emit("weather", arguments);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
						return null;
					}
		        	
		        }.execute(prefecture, area);
		        

			}
		});
        
    }
    public void onResume(){
    	super.onResume();
    	AlertDialog.Builder prefectureDialog = new AlertDialog.Builder(this);
    	prefectureDialog.setTitle("ìsìπï{åßÇëIëÇµÇƒÇ≠ÇæÇ≥Ç¢ÅB");
    	prefectureDialog.setItems(prefectures, new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				selectArea(which);
			}
		});
    	if(PREFERENCE_INIT == getState()){
    		prefectureDialog.create();
    		prefectureDialog.show();
    	}
    }
    private void selectArea(int which){
    	Log.d("prefecture", "prefecturenum is"+which);
    	int prefectureName = getResources().getIdentifier("prefecture_"+(which+1), "array", getPackageName());
    	cities = getResources().getStringArray(prefectureName);
    	SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
    	sp.edit().putString("prefecture", prefectures[which]).commit();
    	new AlertDialog.Builder(context).setTitle("ínàÊÇëIëÇµÇƒÇ≠ÇæÇ≥Ç¢").setItems(cities, new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int i) {
				// TODO Auto-generated method stub
				SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
				sp.edit().putString("city", cities[i]).commit();
				//Toast.makeText(context, cities[which]+"Ç…ê›íËÇµÇ‹ÇµÇΩ", 10000).show();
				setState(PREFERENCE_BOOTED);
			}
		}).show();	
    }
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        menu.add(0, 0, 0, "clear");
        return true;
    }
    public boolean onOptionsItemSelected(MenuItem item){
    	switch(item.getItemId()){
    	case 0:
    		setState(PREFERENCE_INIT);
    		return true;
    	}
    	return false;
    }
    
    private int getState(){
    	int state;
    	SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
    	state = sp.getInt("InitState", PREFERENCE_INIT);
    	Toast.makeText(this.context, "state:"+state, 100);
    	return state; 
    }
    private void setState(int state){
    	SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
    	sp.edit().putInt("InitState", state).commit();
    	Toast.makeText(this.context, "set"+state, 10000);
    }
}
