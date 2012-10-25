package com.takumibaba.iotaRadio;

import java.net.URI;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.R.id;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.Button;

import com.codebutler.android_websockets.SocketIOClient;

@SuppressLint("ShowToast")
public class MainActivity extends Activity {
	private Context context;
	private SocketIOClient client;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.context = this;
        SocketIOClientHandler handler = new SocketIOClientHandler(this.context);
        client = new SocketIOClient(URI.create("http://192.168.111.7:3001"),handler);
        client.connect();
        
        Button button = (Button)findViewById(id.button1);
        button.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				JSONArray arguments = new JSONArray();
		        JSONObject area = new JSONObject();
		        try {
					area.put("area","“Œ‹ž");
					arguments.put(area);
					//client.emit("weather",arguments);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
        
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }
}
