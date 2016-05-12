package com.amarsoft.app.accounting.config.loader;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class ErrorCodeConfigLoader extends AbstractLoader {

	@Override
	public AbstractCache getCacheInstance() {
		return new ErrorCodeConfig();
	}

}
