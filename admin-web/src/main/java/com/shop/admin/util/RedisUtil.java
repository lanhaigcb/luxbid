package com.shop.admin.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.data.redis.core.BoundHashOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.io.Serializable;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 */
public class RedisUtil {

    private static final Log logger = LogFactory.getLog(RedisUtil.class);

    private RedisTemplate<Serializable, Object> redisTemplate;

    /**
     * 批量删除对应的value
     *
     * @param keys
     */
    public void remove(final String... keys) {
        for (String key : keys) {
            remove(key);
        }
    }

    /**
     * 批量删除key
     *
     * @param pattern
     */
    public void removePattern(final String pattern) {
        Set<Serializable> keys = redisTemplate.keys(pattern);
        if (keys.size() > 0)
            redisTemplate.delete(keys);
    }

    /**
     * 删除对应的value
     *
     * @param key
     */
    public void remove(final String key) {
        if (exists(key)) {
            redisTemplate.delete(key);
        }
    }

    /**
     * 获取一个hash
     *
     * @param cacheKey
     * @return
     */
    public Map<String, Object> getCacheMap(String cacheKey) {
        BoundHashOperations<Serializable, String, Object> bound = redisTemplate.boundHashOps(cacheKey);
        return bound.entries();
    }

    /**
     * 从hash里获取一个值
     *
     * @param cacheKey
     * @param key
     * @return
     */
    public Object getDataFromCacheMap(String cacheKey, Object key) {
        BoundHashOperations<Serializable, Object, Object> bound = redisTemplate.boundHashOps(cacheKey);
        return bound.get(key);
    }

    /**
     * 向hash放进一个键值
     *
     * @param cacheKey
     * @param key
     * @param value
     */
    public void setDataFromCacheMap(String cacheKey, Object key, Object value) {
        BoundHashOperations<Serializable, Object, Object> bound = redisTemplate.boundHashOps(cacheKey);
        bound.put(key, value);
    }

    /**
     * 删除hash一个键值
     *
     * @param cacheKey
     * @param key
     */
    public void removeDataFromCacheMap(String cacheKey, Object key) {
        BoundHashOperations<Serializable, Object, Object> bound = redisTemplate.boundHashOps(cacheKey);
        bound.delete(key);
    }

    /**
     * 判断缓存中是否有对应的value
     *
     * @param key
     * @return
     */
    public Boolean exists(final String key) {
        return redisTemplate.hasKey(key);
    }

    /**
     * 延长有效期
     * @param key
     * @param minutes
     */
    public boolean makeMoreTime(final String key, int minutes) {
        return redisTemplate.boundValueOps(key).expire(minutes, TimeUnit.SECONDS);
    }

    /**
     * 读取缓存
     *
     * @param key
     * @return
     */
    public Object get(final String key) {
        Object result = null;
        ValueOperations<Serializable, Object> operations = redisTemplate.opsForValue();
        result = operations.get(key);
        return result;
    }


    /**
     * 写入缓存
     *
     * @param key
     * @param value
     * @return
     */
    public boolean set(final String key, Object value) {
        boolean result = false;
        try {
            ValueOperations<Serializable, Object> operations = redisTemplate.opsForValue();
            operations.set(key, value);
            result = true;
        } catch (Exception e) {
            logger.error("set cache error", e);
        }
        return result;
    }

    /**
     * 写入缓存
     *
     * @param key
     * @param value
     * @return
     */
    public boolean set(final String key, Object value, Integer expireTime) {
        boolean result = false;
        try {
            ValueOperations<Serializable, Object> operations = redisTemplate.opsForValue();
            operations.set(key, value);
            redisTemplate.expire(key, expireTime, TimeUnit.SECONDS);
            result = true;
        } catch (Exception e) {
            logger.error("set cache error", e);
        }
        return result;
    }

    public long increment(final String key, long delta) {
        return redisTemplate.opsForValue().increment(key, delta);
    }

    public void setRedisTemplate(RedisTemplate<Serializable, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }
}
