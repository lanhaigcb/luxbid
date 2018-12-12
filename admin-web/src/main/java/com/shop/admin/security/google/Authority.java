/**
 * Copyright(c) 2011-2014 by XiangShang Inc.
 * All Rights Reserved
 */
package com.shop.admin.security.google;

import org.springframework.web.bind.annotation.Mapping;

import java.lang.annotation.*;

/**
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Mapping
public @interface Authority {

    /**
     * 权限类型
     *
     * @return
     */
    AuthorityType type();

}
