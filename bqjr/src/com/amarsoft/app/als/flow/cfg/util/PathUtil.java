package com.amarsoft.app.als.flow.cfg.util;

public class PathUtil {

    public static String getNameWithoutExtension(String fileName) {
        return fileName.substring(0, fileName
                .lastIndexOf(PathUtil.SEPARATOR_FORMAT));
    }

    public static String getExtension(String fileName) {
        return fileName.substring(fileName
                .lastIndexOf(PathUtil.SEPARATOR_FORMAT) + 1);
    }

    public final static String SEPARATOR_URL = "/";

    public final static String SEPARATOR_FORMAT = ".";
}
