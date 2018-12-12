package com.shop.admin.controller.user;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.bizservice.MessageService;
import com.mine.common.api.CustomerApiVo;
import com.mine.common.constants.Constants;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.RegisterType;
import com.mine.common.enums.WhiteListApplyStatus;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.admin.AdminCustomerAccountInfoVo;
import com.mine.common.vo.admin.AdminCustomerVo;
import com.mine.common.vo.admin.AdminWhiteListApplyVo;
import com.mine.common.vo.mobile.SubAccountVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import com.shop.admin.util.RedisUtil;
import com.mine.userservice.UserService;
import com.mine.util.match.FormatUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class CustomerController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(CustomerController.class);

    @Autowired
    private UserService userService;
    @Autowired
    private AdminService adminService;
    @Autowired
    private ExchangeService exchangeService;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private StaffOperationLogService staffOperationLogService;
    @Autowired
    private MessageService messageService;
    @Autowired
    private RedisUtil redisUtil;
    @Autowired
    private CurrencyService currencyService;



    @OperatorLogger(operatorName = "进入用户列表")
    @RequestMapping(value = "customer/index")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("customer/index");
        return mv;
    }

    @RequestMapping(value = "customer/list")
    @ResponseBody
    @OperatorLogger(operatorName = "查看用户信息列表")
    public Map<String, Object> list(AdminCustomerVo vo, Integer offset, Integer limit) {
        total = (int) userService.countCustomer(vo);
        if (total > 0) {
            List<AdminCustomerVo> clist = userService.listCustomer(vo, getOffset(offset), getLimit(limit));
            list = clist;
        }
        result = true;
        return getResultMap();
    }

    @RequestMapping(value = "customer/export")
    @ResponseBody
    @OperatorLogger(operatorName = "用户信息导出")
    public Map<String, Object> export(AdminCustomerVo vo, HttpServletResponse response) {
        List<AdminCustomerVo> clist = userService.listCustomer(vo, null, null);
        if (clist.size() > 0) {
            String excelTable = PropertyUtil.getProperty("customerRecord");
            String dist = ExcelUtil.export(excelTable, clist, "customerRecord_ColumnName", "customerRecord_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("用户信息导出", staff.getRealname()
                        + "-用户信息导出" + clist.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    /**
     * 用户详情
     *
     * @param customerId
     * @return
     */
    @OperatorLogger(operatorName = "进入用户详情页面")
    @RequestMapping("customer/detail")
    public String detail(Integer customerId, ModelMap modelMap) {
        CustomerVo customerVo = userService.getCustomerById(customerId);
        AdminCustomerVo vo = new AdminCustomerVo();//adminService.getCustomerAssetById(customerId);
        vo.setId(customerId);
        vo.setMobile(customerVo.getMobile());
        vo.setEmail(customerVo.getEmail());
        vo.setIdInfoStatus(customerVo.getIdInfoStatus().name());
        modelMap.addAttribute("adminCustomerVo", vo);
        return "customer/detail";
    }

    /**
     * 查询用户详情
     *
     * @param customerId
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/queryCustomerSubAccount")
    @OperatorLogger(operatorName = "查看用户详情")
    public Object queryCustomerSubAccount(Integer customerId, Integer offset, Integer limit) {
        try {
            total = adminService.countSubAccountByCustomerId(customerId);
            if (total > 0) {
                list = adminService.getSubAccountByCustomerId(customerId, getOffset(offset), getLimit(limit));
            }
            result = true;
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            return getResultMap();
        }

    }

    /**
     * 查看资金流水
     *
     * @param customerId
     * @param subAccountId
     * @param modelMap
     * @return
     */
    @RequestMapping("customer/showAccountLog")
    @OperatorLogger(operatorName = "查看用户资金流水")
    public String showAccountLog(Integer customerId, Integer subAccountId, ModelMap modelMap) {
        modelMap.addAttribute("customerId", customerId);
        modelMap.addAttribute("subAccountId", subAccountId);
        modelMap.addAttribute("currencyId");
        return "customer/showAccountLog";
    }

    /**
     * 查看用户资金流水
     *
     * @param customerId
     * @param subAccountId
     * @param offset
     * @param limit
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/queryCustomerAccountLog")
    public Object queryCustomerAccountLog(Integer customerId, Integer subAccountId, Integer offset, Integer limit) {
        total = adminService.countSubAccountLog(customerId, subAccountId);
        if (total > 0) {
            list = adminService.getSubAccountLog(customerId, subAccountId, getOffset(offset), getLimit(limit));
        }
        result = true;
        return getResultMap();
    }




    @RequestMapping("customer/addWhiteInput")
    public Object addWhiteInput(Integer customerId, ModelMap modelMap) {
        CustomerVo customerVo = userService.getCustomerById(customerId);
        modelMap.addAttribute("customerId", customerId);
        modelMap.addAttribute("customer", customerVo);
        List<ExchangeVo> voList = exchangeService.listAllExchange();
        modelMap.addAttribute("voList", voList);
        return "customer/addWhite";
    }
    @ResponseBody
    @RequestMapping("customer/makeAPIKEY")
    public Object makeAPIKEY(CustomerApiVo customerApiVo) {
        result = userService.addApiKey(customerApiVo);
        if(result){
            message = messageSource.getMessage("生成成功");
        }else{
            message = messageSource.getMessage("生成失败");
        }
        return getResultMap();
    }

    @RequestMapping("customer/findApiKey")
    public Object findApiKey(Integer customerId,ModelMap modelMap) {
        CustomerApiVo customerApiVo = new CustomerApiVo();
        customerApiVo.setCustomerId(customerId);
        modelMap.put("customerApiVo",customerApiVo);
        return "customer/findApiKey";
    }

    /**
     * 查询apikey
     *
     * @param customerId
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/findApiKeyList")
    @OperatorLogger(operatorName = "查看apikey")
    public Object findApiKeyList(Integer customerId) {
        try {
            total = userService.countApiKey(customerId);
            if (total > 0) {
                list = userService.findApiKey(customerId);
            }
            result = true;
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            return getResultMap();
        }
    }

    /**
     * 初始化APIKEY
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/initRedisApiKey")
    @OperatorLogger(operatorName = "禁用apiKey")
    public Map<String, Object> initRedisApiKey() {
        try {
            userService.initRedisApiKey();
            result = true;
            message = messageSource.getMessage("初始化成功");
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("初始化失败");
        }
        return getResultMap();
    }

    /**
     * 禁用apiKey
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/updateApiKeyStatus")
    @OperatorLogger(operatorName = "禁用apiKey")
    public Map<String, Object> updateApiKeyStatus(CustomerApiVo customerApiVo) {
        try {
            userService.updateApiKeyStatus(customerApiVo);
            result = true;
            message = messageSource.getMessage("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("修改失败");
        }
        return getResultMap();
    }

    /**
     * @param applyVo
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/addWhiteList")
    public Object addWhiteList(AdminWhiteListApplyVo applyVo) {
        if (applyVo.getCustomerId() == null
                || applyVo.getExchangeId() == null
                || applyVo.getNote() == null) {
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        Staff staff = SecurityUtil.currentLogin();
        applyVo.setApplyStaffId(staff.getId());
        applyVo.setApplyStaffName(staff.getName());
        applyVo.setApplyStatus(WhiteListApplyStatus.WAITING);
        adminService.addWhiteListApply(applyVo);
        return Response.simpleSuccess();
    }


    /**
     * 设置项目方
     *
     * @param customerId
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/isProject")
    @OperatorLogger(operatorName = "设置项目方")
    public Map<String, Object> isProject(Integer customerId) {
        Staff currentLogin = SecurityUtil.currentLogin();
        String realname = currentLogin.getRealname();
        CustomerVo customerVo = userService.getCustomerById(customerId);
        if (null == customerVo.getProject() || customerVo.getProject()) {
            result = false;
            message = messageSource.getMessage("该用户已设置为项目方,不可重复设置");
        } else {
            try {
                boolean flag = true;
                userService.updateIsProject(customerId, flag);
                //记录用户操作日志
                String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
                staffOperationLogService.addStaffOperationLog("设为项目方", realname + "-设置项目方：" + account + "(" + customerVo.getRealName() + ")" + "为项目方", currentLogin.getId(), realname);
                result = true;
                message = messageSource.getMessage("修改成功");
            } catch (Exception e) {
                e.printStackTrace();
                result = false;
                message = messageSource.getMessage("修改失败");
            }
        }
        return getResultMap();
    }

    @RequestMapping("customer/statisticalInfo")
    @OperatorLogger(operatorName = "进入用户统计页面")
    public String statisticalInfo(ModelMap modelMap) {
        return "customer/statisticalInfo";
    }

    @ResponseBody
    @RequestMapping("customer/listCustomerStatistics")
    @OperatorLogger(operatorName = "用户统计列表")
    public Object listCustomerStatistics(Date startDate, Date endDate, String channelId, Integer offset, Integer limit) {
        total = adminService.countCustomerStatistics(startDate, endDate, channelId);
        if (total > 0) {
            list = adminService.listCustomerStatistics(startDate, endDate, channelId, getOffset(offset), getLimit(limit));
        }
        result = true;
        return getResultMap();
    }

    /**
     * 用户启用禁用
     *
     * @param
     * @param enable
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/updateStatus")
    @OperatorLogger(operatorName = "修改用户启用/禁用状态")
    public Map<String, Object> updateStatus(Integer customerId, Boolean enable) {
        CustomerVo customerVo = userService.getCustomerById(customerId);
        Boolean baseEnable = customerVo.getEnable();
        String msg = enable == true ? "启用" : "禁用";
        if (baseEnable == enable) {
            result = false;
            message = messageSource.getMessage("该用户已经" + msg);
            return getResultMap();
        }
        try {
            userService.updateUserStatus(customerVo.getId(), enable);

            if(!enable){
                String pcTokenKey = FormatUtil.formatPpwTokenKey(Constants.PC_TOKEN_KEY,customerId);
                String mobileTokenKey = FormatUtil.formatPpwTokenKey(Constants.MOBILE_TOKEN_KEY,customerId);

                String pcToken = (String) redisUtil.get(pcTokenKey);
                String mobileToken = (String) redisUtil.get(mobileTokenKey);
                if(!StringUtils.isEmpty(pcToken)){
                    redisUtil.remove(pcToken,pcTokenKey);
                }
                if(!StringUtils.isEmpty(mobileToken)){
                    redisUtil.remove(mobileToken,mobileToken);
                }
            }

            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
            staffOperationLogService.addStaffOperationLog("用户启用禁用", staff.getRealname()
                    + "-" + msg + account, staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("修改失败");
        }

        return getResultMap();
    }

    @OperatorLogger(operatorName = "进入发送信息页面")
    @RequestMapping(value = "customer/sendMessage")
    public String sendMessage(String customerId, ModelMap modelMap) {
        modelMap.addAttribute("customerId",customerId);
        return "customer/sendMessage";
    }

    @ResponseBody
    @RequestMapping("customer/saveMessage")
    @OperatorLogger(operatorName = "保存站内信信息")
    public Map<String, Object> saveMessage(String customerId,String content) {
        try {
            if(StringUtils.isNotEmpty(customerId) && StringUtils.isNotEmpty(content)){
                messageService.batchAdd(customerId,content);
            }
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = "保存信息失败";
        }
        return getResultMap();
    }

}
