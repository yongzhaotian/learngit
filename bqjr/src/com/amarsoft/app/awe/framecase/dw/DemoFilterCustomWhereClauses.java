package com.amarsoft.app.awe.framecase.dw;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASFilterCustomWhereClauses;

public class DemoFilterCustomWhereClauses extends ASFilterCustomWhereClauses {

	public String getWhereClauses(ASDataObject dataObject,
			HttpServletRequest request) throws Exception{ 
		//����ʹ��getDecodedParamValue��ȡֵ������������������
		return " serialno like '%"+ getDecodedParamValue("f_serialno", request) +"%'";
	}

}
