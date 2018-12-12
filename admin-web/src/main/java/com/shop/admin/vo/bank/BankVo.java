package com.shop.admin.vo.bank;

/**
 * bankVO
 */
public class BankVo {

    private Integer id;

    private String bankName;// 银行名

    private String bankPicPath;// 银行图片路径



    private String bankHDPicPath;// 银行HD图片路径

    private Double bankTimeLimit;// 银行单次扣款限额

    private Double bankDayLimit;// 银行单日扣款限额

    private Boolean enable;// 是否可用

    private String bankCode;// 银行代码 购买的时候传的数据

    private String baseBankCode;//银行基础代码

    private String productChannelString;



    private String payChannelString;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getBankPicPath() {
        return bankPicPath;
    }

    public void setBankPicPath(String bankPicPath) {
        this.bankPicPath = bankPicPath;
    }
    public String getBankHDPicPath() {
        return bankHDPicPath;
    }

    public void setBankHDPicPath(String bankHDPicPath) {
        this.bankHDPicPath = bankHDPicPath;
    }
    public Double getBankTimeLimit() {
        return bankTimeLimit;
    }

    public void setBankTimeLimit(Double bankTimeLimit) {
        this.bankTimeLimit = bankTimeLimit;
    }

    public Double getBankDayLimit() {
        return bankDayLimit;
    }

    public void setBankDayLimit(Double bankDayLimit) {
        this.bankDayLimit = bankDayLimit;
    }

    public Boolean getEnable() {
        return enable;
    }

    public void setEnable(Boolean enable) {
        this.enable = enable;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
    }

    public String getProductChannelString() {
        return productChannelString;
    }

    public void setProductChannelString(String productChannelString) {
        this.productChannelString = productChannelString;
    }

    public String getPayChannelString() {
        return payChannelString;
    }

    public void setPayChannelString(String payChannelString) {
        this.payChannelString = payChannelString;
    }

    public String getBaseBankCode() {
        return baseBankCode;
    }

    public void setBaseBankCode(String baseBankCode) {
        this.baseBankCode = baseBankCode;
    }
}
