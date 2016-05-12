package com.amarsoft.app.awe.framecase.dw;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASFilterCustomWhereClauses;

public class DemoFilterCustomWhereClauses extends ASFilterCustomWhereClauses {

	public String getWhereClauses(ASDataObject dataObject,
			HttpServletRequest request) throws Exception{ 
		//必须使用getDecodedParamValue获取值，否则会出现中文乱码
		return " serialno like '%"+ getDecodedParamValue("f_serialno", request) +"%'";
	}

}
