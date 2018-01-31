package com.x.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Date : 2016-06-08
 */
public class CF {

    public static String getStringDateYMD(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.DATE_FOMMAT_YMD);
        return sdf.format(date);
    }
}
