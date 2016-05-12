package com.amarsoft.app.aa;

import java.util.Vector;

import com.amarsoft.are.util.ASValuePool;

public class AuthorizationPoint {
	private ASValuePool attributes = new ASValuePool();
	private Vector exceptions = new Vector();
	public void setAttribute(String sKey,Object oValue) throws Exception{
		this.attributes.setAttribute(sKey,oValue);
	}
	public Object getAttribute(String sKey)throws Exception{
		return this.attributes.getAttribute(sKey);
	}
	public void setException(AuthorizationException oValue){
		this.exceptions.add(oValue);
	}
	public AuthorizationException getException(int i){
		return (AuthorizationException)this.exceptions.get(i);
	}
	public int countExceptions(){
		return this.exceptions.size();
	}
	public String[][] getConstants() throws Exception{
		String[][] constants;
		Object[] sKeys = this.attributes.getKeys();
		constants = new String[sKeys.length][2];
		for(int i=0;i<constants.length;i++){
			if(sKeys[i]==null) continue;
			constants[i][0] = "#"+(String)sKeys[i];
			constants[i][1] = (String)this.getAttribute((String)sKeys[i]);
		}
		return constants; 
	}
}
