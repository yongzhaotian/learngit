package com.amarsoft.app.creditline.cache.loader;

import com.amarsoft.app.creditline.cache.LimitationTypeCache;
import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class LimitationTypeDefinitionLoader extends AbstractLoader {

	/**
	 * 获取Cache实例
	 * @return AbstractCache对象
	 */
	@Override
	public AbstractCache getCacheInstance() {
		return LimitationTypeCache.getInstance();
	}
}
