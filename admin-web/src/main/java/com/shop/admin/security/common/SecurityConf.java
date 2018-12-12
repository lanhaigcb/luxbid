package com.shop.admin.security.common;

/**
 */
public class SecurityConf {


  public static Boolean SSL_ENABLE = true;

  /**
   *
   */
  public static final String LOGIN_URL = "/auth/toLoginView";

  /**
   *
   */
  public static final String DEFAULT_ROLE = "MGMT_BASIC_STAFF_ROLE";

  public static long LOGIN_TIMEOUT_SECOND = 60*60*1000L;

}
