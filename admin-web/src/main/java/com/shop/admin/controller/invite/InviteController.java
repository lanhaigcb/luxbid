package com.shop.admin.controller.invite;

import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.vo.admin.invite.CustomerInviteVo;
import com.mine.common.vo.invite.InviteRuleVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import com.mine.userservice.CustomerInviteService;
import com.mine.userservice.InviteRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class InviteController extends BaseController {

    @Autowired
    private CustomerInviteService customerInviteService;

    @Autowired
    private InviteRuleService inviteRuleService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @RequestMapping("inviteRecord/index")
    @OperatorLogger(operatorName = "邀请列表页面")
    public ModelAndView modifyAffiche(){
        ModelAndView mv = new ModelAndView("inviteRecord/index");
        List<Map<String, Object>> currencyVos = customerInviteService.getInviteSymbolList();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    @RequestMapping(value = "inviteRecord/list")
    @ResponseBody
    @OperatorLogger(operatorName = "邀请列表")
    public Map<String, Object> list(Date inviteStartDate, Date inviteEndDate,Date authStartDate, Date authEndDate,
                                    String customerName, String customerId, String symbol,String certification,
                                    Integer offset, Integer limit) {
        total = (int) customerInviteService.countInvite(inviteStartDate, inviteEndDate, authStartDate,
                authEndDate, customerName, customerId, symbol, certification);
        if (total > 0) {
            List<CustomerInviteVo> invites = customerInviteService.listInvite(inviteStartDate, inviteEndDate, authStartDate, authEndDate,
                    customerName, customerId, symbol, certification, getOffset(offset), getLimit(limit));
            list = invites;
        } else {
            list = new ArrayList();
        }
        result = true;
        return getResultMap();
    }

    /**
     * 邀请规则管理页面
     */
    @RequestMapping(value = "invite/index")
    @OperatorLogger(operatorName = "进入邀请规则管理")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("invite/invite_index");
        return mv;
    }

    /***
     * 邀请规则列表
     *
     * @return
     */
    @RequestMapping(value = "invite/list")
    @OperatorLogger(operatorName = "查看邀请规则列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = (int) inviteRuleService.getCount();
        List<InviteRuleVo> inviteRuleVo = new ArrayList<InviteRuleVo>();
        if (total > 0) {
            inviteRuleVo = inviteRuleService.listAll(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, inviteRuleVo, "成功");
    }

    /**
     * 新增邀请规则页面
     *
     * @return
     */
    @RequestMapping(value = "invite/addInput")
    @OperatorLogger(operatorName = "进入添加邀请规则页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("invite/invite_add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /**
     * 新增邀请规则
     *
     * @return
     */
    @RequestMapping(value = "invite/add")
    @OperatorLogger(operatorName = "添加邀请规则")
    @ResponseBody
    public Map<String, Object> add(InviteRuleVo inviteRuleVo) {
        //参数验证
        int i = (int)inviteRuleService.getAllTrueStatus();
        if(inviteRuleVo.getRegAmount().compareTo(inviteRuleVo.getInviteMax()) > 0){
            result = false;
            message = messageSource.getMessage("注册奖励数量不能大于平台奖励总额");
        }else if(inviteRuleVo.getInviteeAmount().compareTo(inviteRuleVo.getInviteMax()) > 0){
            result = false;
            message = messageSource.getMessage("邀请奖励数量不能大于平台奖励总额");
        }else if(i>0&&inviteRuleVo.getEnable()){
            result = false;
            message = messageSource.getMessage("只能启用一条邀请规则");
        }else{
            try {
                inviteRuleVo.setRegCurrency(currencyService.getCurrencyBySymbol(inviteRuleVo.getRegSymbol()).getId());
                inviteRuleVo.setInviteeCurrency(currencyService.getCurrencyBySymbol(inviteRuleVo.getInviteeSymbol()).getId());
                inviteRuleService.add(inviteRuleVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("新增邀请规则",staff.getRealname()+"-新增邀请规则："+inviteRuleVo.getRule(),staff.getId(),staff.getRealname());
                result = true;
                message = messageSource.getMessage("add.success");
            } catch (StaffException e) {
                result = false;
                message = e.getMessage();
            } catch (Exception e) {
                result = false;
                message = messageSource.getMessage("add.failed");
            }
        }
        return getResultMap();
    }

    /**
     * 前往修改邀请规则页面
     *
     * @param request
     * @param response
     * @param
     * @return
     */
    @RequestMapping(value = "invite/updateInput")
    @OperatorLogger(operatorName = "进入修改邀请规则页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {
        InviteRuleVo inviteRuleVo = inviteRuleService.getById(id);
        ModelAndView mv = new ModelAndView("invite/invite_edit");
        List<CurrencyVo> currencyVo = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVo);
        mv.addObject("invite", inviteRuleVo);
        return mv;
    }

    @ResponseBody
    @RequestMapping("invite/update")
    @OperatorLogger(operatorName = "修改邀请规则")
    public Map<String, Object> update(InviteRuleVo inviteRuleVo) {
        //参数验证
        int i = (int)inviteRuleService.getAllTrueStatus();
        if(inviteRuleVo.getRegAmount().compareTo(inviteRuleVo.getInviteMax()) > 0){
            result = false;
            message = messageSource.getMessage("注册奖励数量不能大于平台奖励总额");
        }else if(inviteRuleVo.getInviteeAmount().compareTo(inviteRuleVo.getInviteMax()) > 0){
            result = false;
            message = messageSource.getMessage("邀请奖励数量不能大于平台奖励总额");
        }else if(i>0&&inviteRuleVo.getEnable()){
            result = false;
            message = messageSource.getMessage("只能启用一条邀请规则");
        }else {
            try {
                inviteRuleVo.setRegCurrency(currencyService.getCurrencyBySymbol(inviteRuleVo.getRegSymbol()).getId());
                inviteRuleVo.setInviteeCurrency(currencyService.getCurrencyBySymbol(inviteRuleVo.getInviteeSymbol()).getId());
                inviteRuleService.update(inviteRuleVo);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("修改邀请规则", staff.getRealname() + "-修改邀请规则：" + inviteRuleVo.getRule(), staff.getId(), staff.getRealname());
                result = true;
            } catch (Exception e) {
                result = false;
            }
        }
        message = result ? "修改成功" : "修改失败";
        return getResultMap();
    }

    @ResponseBody
    @RequestMapping("invite/total")
    @OperatorLogger(operatorName = "获取统计信息")
    public Map<String, Object> total(Date inviteStartDate, Date inviteEndDate,Date authStartDate, Date authEndDate,
                                     String customerName, String customerId, String symbol,String certification) {
        try {
            List<Map<String, Object>> inviteTotalInof = customerInviteService.getInviteTotalInfo(inviteStartDate, inviteEndDate, authStartDate, authEndDate,
                    customerName, customerId, symbol, certification);

            list = inviteTotalInof;
            result = true;
        } catch (Exception e) {
            result = false;
        }
        return getResultMap();
    }

    /***
     * 邀请记录导出
     *
     * @return
     */
    @RequestMapping(value = "invite/record/export")
    @OperatorLogger(operatorName = "邀请记录导出")
    @ResponseBody
    public Map<String, Object> exportExcel(HttpServletResponse response,Date inviteStartDate, Date inviteEndDate,Date authStartDate, Date authEndDate,
                                           String customerName, String customerId, String symbol,String certification) {
        list = customerInviteService.listInvite(inviteStartDate, inviteEndDate, authStartDate, authEndDate,
                customerName, customerId, symbol, certification, null, null);
        if(list.size()>0){
            String excelTable = PropertyUtil.getProperty("inviteRecord");
            String dist = ExcelUtil.export(excelTable,list,"inviteRecord_ColumnName","inviteRecord_Keys");
            try{
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("邀请记录导出",staff.getRealname()
                        +"-邀请记录导出"+list.size()+"条数据",staff.getId(),staff.getRealname());
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }

    //设置规则是否启用
    @ResponseBody
    @RequestMapping("invite/updateStatus")
    @OperatorLogger(operatorName = "修改兑换规则状态")
    public Map<String, Object> updateStatus(Integer id, String status) {
        int i = (int)inviteRuleService.getAllTrueStatus();
        if("enable".equals(status)&&i>0){
            result = false;
            message = messageSource.getMessage("只能启用一条邀请规则");
            return getResultMap();
        }else{
            try {
                boolean flag = false;
                if ("enable".equals(status)&&i==0) {
                    flag = true;
                }
                inviteRuleService.updateStatus(id, flag);
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
}
