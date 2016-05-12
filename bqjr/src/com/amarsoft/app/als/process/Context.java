package com.amarsoft.app.als.process;

import java.util.Set;

public interface Context {
	  /** key of the Sqlca in the environment */
	  String CONTEXTNAME_SQLCA = "Sqlca";
	  
	  /** key of the transaction in the environment */
	  String CONTEXTNAME_TRANSACTION = "LocalTransaction";

	  String getName();

	  Object get(String key);

	  boolean has(String key);
	  Object set(String key, Object value) throws Exception ;
	  Set<String> keys();
}
