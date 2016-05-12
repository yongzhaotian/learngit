package com.amarsoft.app.als.process;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class DefaultContext implements Context {

	private Map<String, Object> cache = null;
	private String name = "DefaultContext";
	
	public Object get(String key) {
		Object object = null;
		if (hasCached(key)) {
		      object = cache.get(key);
		    } 
		return object;
	}
	
	public Object set(String key, Object value) throws Exception {
		if(key == null) throw new Exception("DefaultContext: Key is null!");
		if (cache==null) {
			cache = new HashMap<String, Object>();
		}
		return cache.put(key, value);
	}

	public String getName() {
		return name;
	}

	public boolean has(String key) {
		return hasCached(key);
	}

	public Set<String> keys() {
		Set<String> keys = new HashSet<String>();
	    if (cache!=null) keys.addAll(cache.keySet());
	    return keys;
	}

	public boolean hasCached(String objectName) {
	    return (cache!=null) && (cache.containsKey(objectName));
	  }

}
