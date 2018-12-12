
package com.shop.admin.controller.award;

import com.mine.bizservice.AwardConfigService;
import com.mine.bizservice.AwardService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.award.AwardConfigVo;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.AwardStatus;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.award.AwardCheck;
import com.mine.common.vo.award.AwardVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.google.Authority;
import com.shop.admin.security.google.AuthorityType;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.service.staff.StaffService;
import com.mine.userservice.UserService;
import com.mine.util.check.CheckUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class AwardController extends BaseController {

    private static Log logger = LogFactory.getLog(AwardController.class);

    private static final String CHECK_STATUS = "PASS";

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private AwardConfigService awardConfigService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private StaffService staffService;

    @Autowired
    private AwardService awardService;

    @Autowired
    private UserService userService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    /**
     * 活动奖励管理页面
     */
    @Authority(type = AuthorityType.GOOGLE)
    @RequestMapping(value = "awardConfig/index")
    @OperatorLogger(operatorName = "进入活动奖励管理")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("awardConfig/index");
        return mv;
    }

    /***
     * 活动奖励列表
     *
     * @return
     */
    @RequestMapping(value = "awardConfig/list")
    @OperatorLogger(operatorName = "查看活动奖励列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = (int) awardConfigService.getCount();
        List<AwardConfigVo> awardConfigVo = new ArrayList<AwardConfigVo>();
        if (total > 0) {
            awardConfigVo = awardConfigService.listAll(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, awardConfigVo, "成功");
    }

    /**
     * 奖励记录页面
     */
    @Authority(type = AuthorityType.GOOGLE)
    @RequestMapping(value = "awardRecord/index")
    @OperatorLogger(operatorName = "进入奖励记录页面")
    public ModelAndView awardRecordindex() {
        ModelAndView mv = new ModelAndView("awardRecord/index");
        List<Map<String, Object>> currencyVos = awardService.getAwardSymbolList();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /***
     * 奖励记录列表
     *
     * @return
     */
    @RequestMapping(value = "awardRecord/list")
    @OperatorLogger(operatorName = "查看奖励记录列表")
    @ResponseBody
    public Response awardRecordlist(Integer limit, Integer offset, String customerAccount, String senderRealName, String checkerRealName, String symbol,
                                    String awardStatus, Date startCreateTime, Date endCreateTime, Date startUpdateTime, Date endUpdateTime) {
        total = (int) awardService.getAwardRecordCount(customerAccount, senderRealName, checkerRealName, symbol, awardStatus, startCreateTime,
                endCreateTime, startUpdateTime, endUpdateTime);
        List<AwardVo> awardVo = new ArrayList<AwardVo>();
        if (total > 0) {
            awardVo = awardService.awardRecordlistAll(getOffset(offset), getLimit(limit), customerAccount, senderRealName, checkerRealName, symbol, awardStatus, startCreateTime,
                    endCreateTime, startUpdateTime, endUpdateTime);
        }
        return Response.listSuccess(total, awardVo, "成功");
    }

    /**
     * 新增活动奖励页面
     *
     * @return
     */
    @RequestMapping(value = "awardConfig/addInput")
    @OperatorLogger(operatorName = "进入添加活动奖励页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("awardConfig/add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /**
     * 新增活动奖励
     *
     * @return
     */
    @RequestMapping(value = "awardConfig/add")
    @OperatorLogger(operatorName = "添加活动奖励")
    @ResponseBody
    public Map<String, Object> add(AwardConfigVo awardConfigVo) {
        try {
            AwardConfigVo awardConfigSy = awardConfigService.getAwardConfigBySymbol(awardConfigVo.getSymbol());
            if (null != awardConfigSy.getId()) {
                result = false;
                message = messageSource.getMessage("每个币种只能存在一个活动奖励");
            } else if (awardConfigVo.getAwardNumTotal().signum() < 0) {
                result = false;
                message = messageSource.getMessage("兑换比例不能为负数");
            } else {
                awardConfigVo.setAwardCurrency(currencyService.getCurrencyBySymbol(awardConfigVo.getSymbol()).getId());
                awardConfigService.add(awardConfigVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("新增活动奖励", staff.getRealname() + "-新增活动奖励：" + awardConfigVo.getAwardConfigName(), staff.getId(), staff.getRealname());
                result = true;
                message = messageSource.getMessage("add.success");
            }
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("add.failed");
        }
        return getResultMap();
    }

    /**
     * 前往修改活动奖励页面
     *
     * @param request
     * @param response
     * @param
     * @return
     */
    @RequestMapping(value = "awardConfig/updateInput")
    @OperatorLogger(operatorName = "进入修改活动奖励页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {
        AwardConfigVo awardConfigVo = awardConfigService.getById(id);
        ModelAndView mv = new ModelAndView("awardConfig/edit");
        List<CurrencyVo> currencyVo = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVo);
        mv.addObject("awardConfigVo", awardConfigVo);
        return mv;
    }

    @ResponseBody
    @RequestMapping("awardConfig/update")
    @OperatorLogger(operatorName = "修改活动奖励")
    public Map<String, Object> updateAwardConfig(AwardConfigVo awardConfigVo) {
        try {
            AwardConfigVo awardConfigSy = awardConfigService.getAwardConfigBySymbol(awardConfigVo.getSymbol());
            if (awardConfigVo.getId() != awardConfigSy.getId() && awardConfigSy.getId() != null) {
                result = false;
                message = messageSource.getMessage("每个币种只能存在一个活动奖励");
                return getResultMap();
            } else if (awardConfigVo.getAwardNumTotal().signum() < 0) {
                result = false;
                message = messageSource.getMessage("兑换比例不能为负数");
                return getResultMap();
            } else {
                awardConfigVo.setAwardCurrency(currencyService.getCurrencyBySymbol(awardConfigVo.getSymbol()).getId());
                awardConfigService.update(awardConfigVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("修改活动奖励", staff.getRealname() + "-修改活动奖励：" + awardConfigVo.getAwardConfigName(), staff.getId(), staff.getRealname());
                result = true;
            }

        } catch (Exception e) {
            logger.error("修改awardConfig未知错误", e);
            result = false;
        }
        message = result ? "修改成功" : "修改失败";
        return getResultMap();
    }

    /**
     * 活动奖励发放页面
     */
    @Authority(type = AuthorityType.GOOGLE)
    @RequestMapping(value = "award/index")
    @OperatorLogger(operatorName = "进入发放奖励")
    public ModelAndView awardIndex() {
        ModelAndView mv = new ModelAndView("award/award_index");
        List<AwardConfigVo> awardConfigVo = awardConfigService.listAll(0, 100);
        mv.addObject("awardConfigs", awardConfigVo);
        return mv;
    }

    /**
     * 发放奖励
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("award/sengReward")
    @OperatorLogger(operatorName = "发放奖励")
    public Map<String, Object> sengReward(Integer awardConfigId, String ids) {
        try {
            BigDecimal sumAward = BigDecimal.ZERO;
            AwardConfigVo awardConfigVo = awardConfigService.getById(awardConfigId);
            String currencyName = awardConfigVo.getSymbol();
            List<AwardVo> awardVoList = awardService.getAwardListByIds(ids);
            for (AwardVo awardVo : awardVoList) {
                if (awardVo.getAwardNum().compareTo(BigDecimal.ZERO) <= 0) {
                    result = false;
                    message = "ID:" + awardVo.getId() + "的用户发放币种数量不能为零，且最大小数位为8位";
                    return getResultMap();
                }
                //判断发放数据和奖励活动配置中奖励币种不一致
                if (!awardVo.getSymbol().equals(currencyName)) {
                    result = false;
                    message = "发放数据币种" + awardVo.getSymbol() + "和奖励活动配置中奖励币种" + currencyName + "不一致";
                    return getResultMap();
                }

                CustomerVo customerVo = null;
                if (null != awardVo.getCustomerId()) {
                    customerVo = userService.getCustomerById(awardVo.getCustomerId());
                } else {
                    boolean isEmail = CheckUtil.checkEmail(awardVo.getCustomerAccount());
                    if (isEmail) {
                        customerVo = userService.getCustomerByEmail(awardVo.getCustomerAccount());
                    } else {
                        customerVo = userService.getCustomerByMobile(awardVo.getCustomerAccount());
                    }
                }

                //逻辑验证如果有一个不存在则直接返回错误信息
                if (customerVo == null) {
                    result = false;
                    if (null != awardVo.getCustomerId()) {
                        message = awardVo.getCustomerId() + "账号ID用户不存在";
                    } else {
                        message = awardVo.getCustomerAccount() + "账号用户不存在";
                    }
                    return getResultMap();
                } else {
                    sumAward = sumAward.add(awardVo.getAwardNum());
                    awardVo.setActivityName(awardConfigVo.getAwardConfigName());
                    awardVo.setAwardConfigId(awardConfigVo.getId());
                    awardVo.setCustomerId(customerVo.getId());
                    awardVo.setCustomerAccount(customerVo.getRegType().name().equals("EMAIL") ? customerVo.getEmail() : customerVo.getMobile());
                    awardVo.setCurrency(awardConfigVo.getAwardCurrency());
                    awardVo.setAwardStatus(AwardStatus.CHECK);
                }
            }
            //发放数量判断
            BigDecimal sumAwardAlready = awardService.getAwardNumSum(awardConfigVo.getId());
            if (awardConfigVo.getAwardNumTotal().compareTo(sumAward.add(sumAwardAlready)) >= 0) {
                awardService.updateAwardStatus(awardVoList);
            } else {
                message = "本次发放数量加上已发放数量不能大于活动奖励配置发放数量";
                result = false;
                return getResultMap();
            }
            result = true;
        } catch (Exception e) {
            logger.error("发放奖励未知错误", e);
            result = false;
        }
        message = result ? "发放奖励成功" : "发放奖励失败";
        return getResultMap();
    }

    /**
     * 删除奖励发放记录
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("award/deleteAwardGrant")
    @OperatorLogger(operatorName = "删除奖励发放记录")
    public Map<String, Object> deleteAwardGrant(String ids) {
        try {
            if (StringUtils.isNotEmpty(ids)) {
                awardService.deleteAwardGrant(ids);
                result = true;
            }
        } catch (Exception e) {
            logger.error("删除奖励发放记录未知错误", e);
            result = false;
        }
        message = result ? "删除成功" : "删除失败";
        return getResultMap();
    }

    /***
     * 活动奖励列表
     *
     * @return
     */
    @RequestMapping(value = "grant/list")
    @OperatorLogger(operatorName = "查看奖励发放列表")
    @ResponseBody
    public Response grantList(Integer limit, Integer offset) {
        total = (int) awardService.getCount();
        List<AwardVo> awardVo = new ArrayList<AwardVo>();
        if (total > 0) {
            awardVo = awardService.listAll(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, awardVo, "成功");
    }


    /***
     * 奖励发放导入
     *
     * @return
     */
    @RequestMapping(value = "award/import")
    @OperatorLogger(operatorName = "奖励发放导入")
    @ResponseBody
    public ModelAndView importExcel(MultipartFile uploadFile) {

        Staff currentLogin = SecurityUtil.currentLogin();
        currentLogin = staffService.getStaffById(currentLogin.getId());
        Date date = new Date();
        List<AwardVo> list = new ArrayList<>();
        result = false;
        try {
            POIFSFileSystem fs = new POIFSFileSystem(uploadFile.getInputStream());
            HSSFWorkbook hw = new HSSFWorkbook(fs);
            HSSFSheet sheet = hw.getSheetAt(0);
            for (int i = 2; i <= sheet.getLastRowNum(); i++) {
                HSSFRow row = sheet.getRow(i);
                if (row != null) {
                    AwardVo awardVo = getAwardVo(currentLogin, date);
                    String customerId = getVal(row.getCell(0));
                    String customerAccount = getVal(row.getCell(1));
                    if (StringUtils.isEmpty(customerId) && StringUtils.isEmpty(customerAccount)) {
                        continue;
                    }
                    if (StringUtils.isNotEmpty(customerId)) {
                        awardVo.setCustomerId(Integer.valueOf(customerId));
                    }
                    if (StringUtils.isNotEmpty(customerAccount)) {
                        awardVo.setCustomerAccount(customerAccount);
                    }
                    awardVo.setAwardNum(new BigDecimal(getVal(row.getCell(2))));
                    awardVo.setSymbol(getVal(row.getCell(3)));
                    awardVo.setReason(getVal(row.getCell(4)));
                    list.add(awardVo);
                }
            }
            if (null != list && 0 < list.size()) {
                awardService.addBatch(list);
                result = true;
            }
        } catch (Exception e) {
            logger.error("导入数据import未知错误", e);
        }
        message = result ? "添加成功" : "添加失败";
        ModelAndView mv = new ModelAndView("award/award_index");
        List<AwardConfigVo> awardConfigVo = awardConfigService.listAll(getOffset(null), getLimit(null));
        mv.addObject("awardConfigs", awardConfigVo);
        return mv;
        //return getResultMap();
    }

    /**
     * 创建初始化的发放奖励对象
     *
     * @param staff
     * @param date
     * @return
     */
    public AwardVo getAwardVo(Staff staff, Date date) {
        AwardVo awardVo = new AwardVo();
        awardVo.setSenderAccount(staff.getName());
        awardVo.setSenderRealName(staff.getRealname());
        awardVo.setCreateTime(date);
        awardVo.setAwardStatus(AwardStatus.WAITING);
        return awardVo;
    }

    /**
     * 处理val（暂时只处理string和number，可以自己添加自己需要的val类型）
     *
     * @param hssfCell
     * @return
     */
    public static String getVal(HSSFCell cell) {
        if (null == cell) {
            return null;
        }
        String cellValue = "";
        DecimalFormat df = new DecimalFormat("#.########");
        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_STRING:
                cellValue = cell.getRichStringCellValue().getString().trim();
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                cellValue = df.format(cell.getNumericCellValue()).toString();
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                cellValue = String.valueOf(cell.getBooleanCellValue()).trim();
                break;
            case HSSFCell.CELL_TYPE_FORMULA:
                cellValue = cell.getCellFormula();
                break;
            default:
                cellValue = "";
        }
        return cellValue;
    }

    /**
     * 奖励审核页面
     */
    @Authority(type = AuthorityType.GOOGLE)
    @RequestMapping(value = "awardCheck/index")
    @OperatorLogger(operatorName = "进入奖励审核")
    public ModelAndView awardCheckIndex() {
        ModelAndView mv = new ModelAndView("award/awardCheck_index");
        List<Map<String, Object>> currencyVos = awardService.getAwardSymbolList();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /***
     * 待审核奖励记录
     *
     * @return
     */
    @RequestMapping(value = "awardCheck/list")
    @OperatorLogger(operatorName = "待审核奖励记录")
    @ResponseBody
    public Map<String, Object> awardCheckList(AwardCheck awardCheck) {
        total = (int) awardService.getAwardCheckCount(awardCheck);
        if (total > 0) {
            list = awardService.getAwardCheckList(awardCheck);
        }
        return getResultMap();
    }

    @ResponseBody
    @RequestMapping("award/updateStatus")
    @OperatorLogger(operatorName = "活动奖励审核")
    public Map<String, Object> updateAwardStatus(Integer id, String status) {
        try {
            Staff currentLogin = SecurityUtil.currentLogin();
            currentLogin = staffService.getStaffById(currentLogin.getId());
            String realname = currentLogin.getRealname();
            String account = currentLogin.getName();
            awardService.updateAwardStatus(id, status, account, realname);
            //记录用户操作日志
            String auditResult;
            if ("PASS".equals(status)) {
                auditResult = "审核通过";
            } else {
                auditResult = "审核不通过";
            }
            AwardVo awardVo = awardService.getById(id);
            staffOperationLogService.addStaffOperationLog("活动奖励审核", realname + "-活动奖励审核：" + awardVo.getCustomerAccount() + auditResult, currentLogin.getId(), realname);
            result = true;
        } catch (Exception e) {
            logger.error("修改award未知错误", e);
            result = false;
        }
        message = result ? "审核通过" : "审核不通过";
        return getResultMap();
    }

    @ResponseBody
    @RequestMapping("award/updateStatusBatch")
    @OperatorLogger(operatorName = "活动奖励批量审核")
    public Map<String, Object> updateAwardStatusBatch(String ids) {
        try {
            Staff currentLogin = SecurityUtil.currentLogin();
            currentLogin = staffService.getStaffById(currentLogin.getId());
            String realname = currentLogin.getRealname();
            String account = currentLogin.getName();
            List<AwardVo> awardVoList = awardService.getAwardCheckList(ids);
            if (awardVoList.size() > 0) {
                for (int i = 0; i < awardVoList.size(); i++) {
                    AwardVo awardVo = awardVoList.get(i);
                    CustomerVo customerVo = null;

                    if (null != awardVo.getCustomerId()) {
                        customerVo = userService.getCustomerById(awardVo.getCustomerId());
                    } else {
                        boolean isEmail = CheckUtil.checkEmail(awardVo.getCustomerAccount());
                        if (isEmail) {
                            customerVo = userService.getCustomerByEmail(awardVo.getCustomerAccount());
                        } else {
                            customerVo = userService.getCustomerByMobile(awardVo.getCustomerAccount());
                        }
                    }
                    if (null == customerVo) {
                        result = false;
                        if (null != awardVo.getCustomerId()) {
                            message = awardVo.getCustomerId() + "账号ID用户不存在";
                        } else {
                            message = awardVo.getCustomerAccount() + "账号用户不存在";
                        }
                        return getResultMap();
                    }
                }
                awardService.updateAwardStatusBatch(awardVoList, CHECK_STATUS, account, realname);
                //记录用户操作日志
                for (int i = 0; i < awardVoList.size(); i++) {
                    AwardVo awardVo = awardService.getById(awardVoList.get(i).getId());
                    staffOperationLogService.addStaffOperationLog("活动奖励审核", realname + "-活动奖励审核：" + awardVo.getCustomerAccount() + "审核通过", currentLogin.getId(), realname);
                }
            }
            result = true;
        } catch (Exception e) {
            logger.error("修改award未知错误", e);
            result = false;
        }
        message = result ? "审核通过" : "审核不通过";
        return getResultMap();
    }
}