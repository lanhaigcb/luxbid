package com.shop.admin.controller.loan;

import com.mine.bizservice.LoanCurrencyProductService;
import com.mine.bizservice.LoanOrderService;
import com.mine.common.enums.LoanOrderStatus;
import com.mine.common.vo.LoanCurrencyProductVo;
import com.mine.common.vo.ResultVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Date;
import java.util.List;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/loan")
public class LoanOrderController extends BaseController {

    private static Log logger = LogFactory.getLog(LoanOrderController.class);

    @Autowired
    private LoanOrderService loanOrderService;

    @Autowired
    private LoanCurrencyProductService loanCurrencyProductService;

    @RequestMapping("apply")
    public ModelAndView index() {
        List<LoanCurrencyProductVo> list = loanCurrencyProductService.listAll();
        ModelAndView mv = new ModelAndView("loan/apply_index");
        mv.addObject("products",list);
        return mv;
    }

    /**
     * 列表
     *
     * @param customerId
     * @param status
     * @param symbol
     * @param offset
     * @param limit
     * @return
     */
    @ResponseBody
    @RequestMapping("list")
    public Object list(Integer customerId, String mobile, String email,
                       LoanOrderStatus status, String symbol,
                       Date start, Date end,
                       Integer offset, Integer limit) {

       try {
           total = loanOrderService.loanOrderAuditCount(symbol, customerId, mobile, email, status, start, end);
           if (total > 0) {
               list = loanOrderService.loanOrderAuditList(symbol, customerId, mobile, email, status, getOffset(offset), getLimit(limit), start, end);
           }
           result = true;
           message = "查询成功";
           return getResultMap();
       }catch (Exception e){
           e.printStackTrace();
           result = false;
           message = "查询失败";
           return getResultMap();
       }
    }

    /**
     * 申请中的订单
     * @param customerId
     * @param mobile
     * @param email
     * @param symbol
     * @param start
     * @param end
     * @param offset
     * @param limit
     * @return
     */
    @ResponseBody
    @RequestMapping("list/apply")
    public Object list(Integer customerId, String mobile, String email,
                       String symbol,
                       Date start, Date end,
                       Integer offset, Integer limit) {
        try {
            total = loanOrderService.loanOrderAuditCount(symbol, customerId, mobile, email, LoanOrderStatus.APPLY_ING, start, end);
            if (total > 0) {
                list = loanOrderService.loanOrderAuditList(symbol, customerId, mobile, email, LoanOrderStatus.APPLY_ING, getOffset(offset), getLimit(limit), start, end);
            }
            result = true;
            message = "查询成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message = "查询失败";
            return getResultMap();
        }
    }


    @RequestMapping("unwind")
    public ModelAndView unwind() {
        List<LoanCurrencyProductVo> list = loanCurrencyProductService.listAll();
        ModelAndView mv = new ModelAndView("loan/unwind_index");
        mv.addObject("products",list);
        return mv;
    }

    /**
     * 已平仓的订单
     * @param customerId
     * @param mobile
     * @param email
     * @param symbol
     * @param start
     * @param end
     * @param offset
     * @param limit
     * @return
     */
    @ResponseBody
    @RequestMapping("list/unwind")
    public Object listUnwind(Integer customerId, String mobile, String email,
                       String symbol,
                       Date start, Date end,
                       Integer offset, Integer limit) {
        try {
            total = loanOrderService.loanOrderUnwindCount(symbol, customerId, mobile, email, start, end);
            if (total > 0) {
                list = loanOrderService.loanOrderUnwindList(symbol, customerId, mobile, email, getOffset(offset), getLimit(limit), start, end);
            }
            result = true;
            message = "查询成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message = "查询失败";
            return getResultMap();
        }
    }

    @ResponseBody
    @RequestMapping("unwind/repay")
    public Object unwindRepay(Integer id) {
        try {
            loanOrderService.repayUnwindOrder(id);
            result = true;
            message = "操作成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message = "操作失败";
            return getResultMap();
        }
    }


    @RequestMapping("op")
    public String op(ModelMap modelMap, Integer id, String type) {
        modelMap.addAttribute("id",id);
        modelMap.addAttribute("type",type);
        return "loan/code";
    }


    @ResponseBody
    @RequestMapping("pass")
    public Object pass(Integer id) {
        Staff staff = SecurityUtil.currentLogin();

        try {
            ResultVo resultVo = loanOrderService.loanOrderPass(id,staff.getId());
            if(resultVo.isSuccess()){
                result = true;
                message= resultVo.getMessage();
                return getResultMap();
            }else{
                result = false;
                message= resultVo.getMessage();
                return getResultMap();
            }
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message="确认失败";
            return getResultMap();
        }
    }

    @ResponseBody
    @RequestMapping("cancel")
    public Object cancel(Integer id) {

        Staff staff = SecurityUtil.currentLogin();

        try {
            ResultVo resultVo = loanOrderService.loanOrderCancel(id,staff.getId());
            if(resultVo.isSuccess()){
                result = true;
                message= resultVo.getMessage();
                return getResultMap();
            }else{
                result = false;
                message= resultVo.getMessage();
                return getResultMap();
            }
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message="取消失败";
            return getResultMap();
        }

    }


    @RequestMapping("leading")
    public ModelAndView leadingView() {
        List<LoanCurrencyProductVo> list = loanCurrencyProductService.listAll();
        ModelAndView mv = new ModelAndView("loan/leading_index");
        mv.addObject("products",list);
        return mv;
    }

    @ResponseBody
    @RequestMapping("list/leading")
    public Object leadingList(Integer customerId, String mobile, String email,
                       String symbol,
                       Date start, Date end,
                       Integer offset, Integer limit) {
        try {
            total = loanOrderService.loanOrderAuditCount(symbol, customerId, mobile, email, LoanOrderStatus.REPAY_ING, start, end);
            if (total > 0) {
                list = loanOrderService.loanOrderAuditList(symbol, customerId, mobile, email, LoanOrderStatus.REPAY_ING, getOffset(offset), getLimit(limit), start, end);
            }
            result = true;
            message = "查询成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message = "查询失败";
            return getResultMap();
        }
    }


}
