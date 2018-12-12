package com.shop.admin.controller.withdraw;

import com.mine.bizservice.BizService;
import com.mine.common.enums.RegisterType;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.ResultVo;
import com.mine.common.vo.back.WithdrawRecordVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.google.Authority;
import com.shop.admin.security.google.AuthorityType;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.userservice.UserService;
import com.mine.wallet.service.WalletService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 提币记录
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class WithdrawController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(WithdrawController.class);

    @Autowired
    private BizService bizService;

    @Autowired
    private WalletService walletService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @Autowired
    private UserService userService;

    /**
     * 页面
     *
     * @return
     */
    @RequestMapping("withdraw/index")
    @Authority(type = AuthorityType.GOOGLE)
    public ModelAndView renderIndex() {
        ModelAndView modelAndView = new ModelAndView("withdraw/index");
        return modelAndView;
    }

    /**
     * 审核列表
     *
     * @param offset
     * @param limit
     * @return
     */
    @RequestMapping("withdraw/waiting/list")
    @ResponseBody
    public Map<String, Object> waitingList(Integer offset, Integer limit) {

        total = bizService.countBackWaitingWithdrawRecord();
        if (total > 0) {
            list = bizService.listBackWaitingWithdrawRecord(getOffset(offset), getLimit(limit));
        }
        result = true;
        return getResultMap();
    }

    /**
     * 初审页面
     *
     * @param id
     * @return
     */
    @RequestMapping("withdraw/auditOne/view")
    public ModelAndView aduitOneView(Integer id) {
        ModelAndView modelAndView = new ModelAndView("withdraw/auditOne");
        WithdrawRecordVo detail = bizService.auditDetail(id);
        modelAndView.addObject("detail", detail);
        double balance = walletService.getBalance(detail.getSymbol());
        modelAndView.addObject("balance", balance);
        boolean status = false;
        if (balance >= detail.getAmount().doubleValue()) {
            status = true;
        }
        modelAndView.addObject("status",status);
        return modelAndView;
    }

    /**
     * 初审页面
     *
     * @param id
     * @return
     */
    @RequestMapping("withdraw/auditOne")
    @ResponseBody
    public Map<String, Object> aduitOne(Integer id, boolean pass, String note) {
        Staff staff = SecurityUtil.currentLogin();
        ResultVo resultVo = bizService.withdrawAuditOne(id, staff.getId(), staff.getName(), pass, note);
        //记录用户操作日志
        String auditResult;
        if(pass){
            auditResult="审核通过";
        }else{
            auditResult="审核不通过";
        }
        WithdrawRecordVo detail = bizService.auditDetail(id);
        CustomerVo customerVo = userService.getCustomerById(detail.getCustomerId());
        String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
        staffOperationLogService.addStaffOperationLog("提币一级审核",staff.getRealname()+"-提币一级审核："+account+"("+customerVo.getRealName()+")"+auditResult,staff.getId(),staff.getRealname());
        result = resultVo.isSuccess();
        message = resultVo.getMessage();
        return getResultMap();
    }

    @RequestMapping("withdraw/auditOne/list")
    @ResponseBody
    public Map<String, Object> auditOneList(Integer offset, Integer limit) {

        total = bizService.countBackWaitingWithdrawRecord();
        if (total > 0) {
            list = bizService.listBackWaitingWithdrawRecord(getOffset(offset), getLimit(limit));
        }
        result = true;
        return getResultMap();
    }


    //**********************************二级审核***************************************

    /**
     * 页面
     *
     * @return
     */
    @RequestMapping("withdraw/auditTwo/index")
    @Authority(type = AuthorityType.GOOGLE)
    public ModelAndView autidTwoIndex() {
        ModelAndView modelAndView = new ModelAndView("withdraw/auditTwoIndex");
        return modelAndView;
    }

    /**
     * 审核列表
     *
     * @param offset
     * @param limit
     * @return
     */
    @RequestMapping("withdraw/auditTwo/list")
    @ResponseBody
    public Map<String, Object> auditTwoList(Integer offset, Integer limit) {

        total = bizService.countInAuditTwoWithdrawRecord();
        if (total > 0) {
            list = bizService.listBackInAuditTwoWithdrawRecord(getOffset(offset), getLimit(limit));
        }
        result = true;
        return getResultMap();
    }


    @RequestMapping("withdraw/auditTwo/view")
    public ModelAndView aduitTwoView(Integer id) {
        ModelAndView modelAndView = new ModelAndView("withdraw/auditTwo");
        WithdrawRecordVo detail = bizService.auditDetail(id);
        modelAndView.addObject("detail", detail);
        return modelAndView;
    }

    /**
     * 二次页面
     *
     * @param id
     * @return
     */
    @RequestMapping("withdraw/auditTwo")
    @ResponseBody
    public Map<String, Object> aduitTwo(Integer id, boolean pass, String note) {
        Staff staff = SecurityUtil.currentLogin();
        ResultVo resultVo = bizService.withdrawAuditTwo(id, staff.getId(), staff.getName(), pass, note);
        //记录用户操作日志
        String auditResult;
        if(pass){
            auditResult="审核通过";
        }else{
            auditResult="审核不通过";
        }
        WithdrawRecordVo detail = bizService.auditDetail(id);
        CustomerVo customerVo = userService.getCustomerById(detail.getCustomerId());
        String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
        staffOperationLogService.addStaffOperationLog("提币二级审核",staff.getRealname()+"-提币二级审核："+account+"("+customerVo.getRealName()+")"+auditResult,staff.getId(),staff.getRealname());
        result = resultVo.isSuccess();
        message = resultVo.getMessage();
        return getResultMap();
    }


}
