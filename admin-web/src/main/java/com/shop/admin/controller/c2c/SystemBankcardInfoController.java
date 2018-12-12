package com.shop.admin.controller.c2c;

import com.mine.bizservice.BankService;
import com.mine.bizservice.C2CCurrencyService;
import com.mine.bizservice.SystemBankcardInfoService;
import com.mine.common.response.Response;
import com.mine.common.vo.BankVo;
import com.mine.common.vo.C2CCurrencyVo;
import com.mine.common.vo.SystemBankcardInfoVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/5/23 下午6:15
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cBankcard")
public class SystemBankcardInfoController extends BaseController {

    @Autowired
    private SystemBankcardInfoService systemBankcardInfoService;
    @Autowired
    private BankService bankService;
    @Autowired
    private C2CCurrencyService c2cCurrencyService;

    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入SystemBankcardInfo管理")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("c2cBankcard/index");
        return mv;
    }

    @RequestMapping("/list")
    @OperatorLogger(operatorName = "获取所有SystemBankcardInfo")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = systemBankcardInfoService.count(null);
        List<SystemBankcardInfoVo> list = null;
        if(total>0){
            list = systemBankcardInfoService.list(null,getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total,list,"成功");
    }


    @RequestMapping(value = "addInput")
    @OperatorLogger(operatorName = "进入添加SystemBankcardInfo页面")
    public ModelAndView addInput() {
        BankVo vo = new BankVo();
        vo.setEnable(true);
        List<BankVo> banks = bankService.listAll(vo);
        ModelAndView mv = new ModelAndView("c2cBankcard/add");
        mv.addObject("banks",banks);

        C2CCurrencyVo currencyVo = new C2CCurrencyVo();
        vo.setEnable(true);
        List<C2CCurrencyVo> vos = c2cCurrencyService.list(currencyVo);
        mv.addObject("currencys",vos);

        return mv;
    }

    @RequestMapping("/add")
    @OperatorLogger(operatorName = "新增SystemBankcardInfo")
    @ResponseBody
    public Response add(String bankName, String subBankName, String cardNumber, String cardOwner, String symbol){
        Staff currentLogin = SecurityUtil.currentLogin();
        SystemBankcardInfoVo vo = new SystemBankcardInfoVo();
        vo.setBankName(bankName);
        vo.setCardNumber(cardNumber);
        vo.setCardOwner(cardOwner);
        vo.setCreateTime(new Date());
        vo.setEnable(true);
        vo.setStaffId(currentLogin.getId());
        vo.setSubBankName(subBankName);
        vo.setSymbol(symbol);
        systemBankcardInfoService.add(vo);

        return Response.simpleSuccess();
    }

    @RequestMapping(value = "updateInput")
    @OperatorLogger(operatorName = "进入修改SystemBankcardInfo页面")
    public ModelAndView updateInput(Integer id) {
        BankVo vo = new BankVo();
        vo.setEnable(true);
        List<BankVo> banks = bankService.listAll(vo);
        ModelAndView mv = new ModelAndView("c2cBankcard/edit");
        SystemBankcardInfoVo bankcardInfoVo = systemBankcardInfoService.get(id);
        mv.addObject("bankcard", bankcardInfoVo);
        mv.addObject("banks",banks);

        C2CCurrencyVo currencyVo = new C2CCurrencyVo();
        vo.setEnable(true);
        List<C2CCurrencyVo> vos = c2cCurrencyService.list(currencyVo);
        mv.addObject("currencys",vos);
        return mv;
    }

    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改SystemBankcardInfo")
    @ResponseBody
    public Response update(Integer id, String bankName, String subBankName, String cardNumber, String cardOwner, String symbol){
        SystemBankcardInfoVo vo = systemBankcardInfoService.get(id);
        vo.setBankName(bankName);
        vo.setCardNumber(cardNumber);
        vo.setCardOwner(cardOwner);
        vo.setUpdateTime(new Date());
        vo.setSubBankName(subBankName);
        vo.setSymbol(symbol);
        systemBankcardInfoService.update(vo);
        return Response.simpleSuccess();
    }

    @RequestMapping("/enable")
    @OperatorLogger(operatorName = "修改SystemBankcardInfo的启用禁用")
    @ResponseBody
    public Response enable(Integer id, Boolean enable){
        SystemBankcardInfoVo vo = systemBankcardInfoService.get(id);
        vo.setEnable(enable);
        vo.setUpdateTime(new Date());
        systemBankcardInfoService.update(vo);
        return Response.simpleSuccess();
    }

}
