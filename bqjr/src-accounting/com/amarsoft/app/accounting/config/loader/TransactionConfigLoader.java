package com.amarsoft.app.accounting.config.loader;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class TransactionConfigLoader extends AbstractLoader {

	
	public AbstractCache getCacheInstance() {
		
		return new TransactionConfig();
	}

}
