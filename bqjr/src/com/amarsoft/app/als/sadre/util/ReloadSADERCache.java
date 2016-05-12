package com.amarsoft.app.als.sadre.util;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.services.SADREService;

public class ReloadSADERCache {
	public String reloadSADRECache(Transaction Sqlca){
		SADREService.setDatabase(Sqlca.getDatabase());
		SADREService.init();
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}
}
