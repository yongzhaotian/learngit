package com.amarsoft.app.als.flow.cfg.flowrule;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DefaultRule extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		return "true";
	}

}
