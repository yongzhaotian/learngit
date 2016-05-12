package com.amarsoft.app.creditline.cache.loader;

import com.amarsoft.app.creditline.cache.CLErrorTypeCache;
import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class ErrorTypeDefinitionLoader extends AbstractLoader {

	/**
	 * ��ȡCacheʵ��
	 * @return AbstractCache����
	 */
	@Override
	public AbstractCache getCacheInstance() {
		return CLErrorTypeCache.getInstance();
	}
}
