/**
 *
 */
package com.shop.admin.util;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 */
public class CacheUtil {

    private static Map<String, String> CACHE_MAP = new ConcurrentHashMap<String,String>();

    public static void put(String key, String value) {
        CACHE_MAP.put(key, value);
    }

    public static boolean isContain(String key) {
        return CACHE_MAP.containsKey(key);
    }

    public static void remove(String key) {
        CACHE_MAP.remove(key);
    }
}
