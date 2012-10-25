package com.takumibaba.iotaRadio;

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

public class GPSController implements LocationListener {
	private Context context;
	private LocationManager locationManager;
	
	public GPSController(Context c){
		this.context = c;
	}
	
	public void onStart(){
		locationManager = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
		
	}

	@Override
	public void onLocationChanged(Location location) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderDisabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub
		
	}
}
