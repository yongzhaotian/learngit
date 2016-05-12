package com.amarsoft.app.awe.framecase.dw;

import java.util.Hashtable;

import com.amarsoft.awe.dw.ui.validator.CustomValidator;
import com.amarsoft.awe.dw.ui.validator.ICustomerRule;

/**
 * 
 * @author flian
 * @version 2013-5-21 обнГ5:01:06
 */
public class UserTest extends CustomValidator {

	@Override
	protected String valid(String value) throws Exception {
		if("1".equals(value))
			return "";
		else
			return "false";
	}

	
}
