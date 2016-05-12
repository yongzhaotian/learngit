package com.amarsoft.app.als.sadre.util;

import com.amarsoft.ars.utils.StringUtils;

public class StringUtil
{
  public static String getString(String s, String s1, String s2)
  {
    if ((s == null) || (s.length() == 0))
      return s2.trim();

    return s1.trim();
  }

  public static String getString(String s, String s2)
  {
    return getString(s, s, s2);
  }

  public static String getString(String s) {
    return getString(s, s, "");
  }
  
  public static String[] toStringArray(String s, String s1)
  {
    String[] as = null;
    int i = getSeparateSum(s, s1);
    if (i > 0) {
      as = new String[i];
      for (int j = 1; j <= i; ++j)
        as[(j - 1)] = getSeparate(s, s1, j);
    }

    return as;
  }
  public static String getSeparate(String s, String s1, int i) {
	    int k = 0;
	    int l = 0;
	    s = s + s1;

	    int j;
	    while ((j = s.indexOf(s1, k)) >= 0) {
	      if (++l == i)
	        return s.substring(k, j).trim();
	      k = j + 1;
	    }
	    return "";
	  }

	  public static int getSeparateSum(String s, String s1) {
		  return StringUtils.getSeparateSum(s, s1);
	  }

}