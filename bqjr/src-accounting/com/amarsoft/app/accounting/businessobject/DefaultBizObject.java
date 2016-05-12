package com.amarsoft.app.accounting.businessobject;

import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.impl.StateBizObject;

public class DefaultBizObject extends StateBizObject {

	public DefaultBizObject(BizObjectClass clazz) {
		super(clazz);
	}
	
	
	 public DefaultBizObject(String clazz)
	     throws JBOException
	 {
	     super(clazz);
	 }
	 
	 public void setState(byte a)
	 {
		 super.setState(a);
	 }
	

}
