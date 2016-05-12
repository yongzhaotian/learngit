package com.amarsoft.app.als.flow.cfg.util;

import java.io.File;
import java.io.FilenameFilter;

public class SingleIOFilenameFilter implements FilenameFilter {

    public SingleIOFilenameFilter(String extend) {
        this.extend = extend;
    }

    public boolean accept(File dir, String name) {
        int index = name.lastIndexOf(PathUtil.SEPARATOR_FORMAT);
        if ((index > 0) && (index < (name.length() - 1))) {
            String extension = name.substring(index + 1).toLowerCase();
            if (extension.equalsIgnoreCase(extend)) {
                return true;
            }
        }
        return false;
    }

    private String extend;

}
