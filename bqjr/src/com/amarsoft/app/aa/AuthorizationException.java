package com.amarsoft.app.aa;

import com.amarsoft.are.util.ASValuePool;

public class AuthorizationException {
	private ASValuePool attributes = new ASValuePool();
	private String[][] constants = null;
	
	public void setAttribute(String sKey,Object oValue) throws Exception{
		this.attributes.setAttribute(sKey,oValue);
	}
	public Object getAttribute(String sKey)throws Exception{
		return this.attributes.getAttribute(sKey);
	}
	public String[][] getConstants()throws Exception{
		if(constants!=null) return this.constants;
		
		Object[] sKeys = this.attributes.getKeys();
		this.constants = new String[sKeys.length][2];
		for(int i=0;i<constants.length;i++){
			if(sKeys[i]==null) continue;
			constants[i][0] = "#"+(String)sKeys[i];
			constants[i][1] = (String)this.getAttribute((String)sKeys[i]);
		}
		return this.constants; 
	}
}
