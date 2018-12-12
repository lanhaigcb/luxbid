package com.shop.admin.vo.sms;

import java.util.Date;

/**
 * 短信VO
 */
public class SMSVo {

  public Integer id;

  public String mobile;

  public String code;

  public String type;

  public Date sendDate;

  public Date loseDate;

  public boolean effective;


  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getMobile() {
    return mobile;
  }

  public void setMobile(String mobile) {
    this.mobile = mobile;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public Date getLoseDate() {
    return loseDate;
  }

  public void setLoseDate(Date loseDate) {
    this.loseDate = loseDate;
  }

  public Date getSendDate() {
    return sendDate;
  }

  public void setSendDate(Date sendDate) {
    this.sendDate = sendDate;
  }

  public boolean isEffective() {
    return effective;
  }

  public void setEffective(boolean effective) {
    this.effective = effective;
  }
}
