package com.shop.admin.controller.loan;

import com.mine.bizservice.LoanAmountRateService;
import com.mine.bizservice.LoanCurrencyProductService;
import com.mine.common.response.Response;
import com.mine.common.vo.LoanAmountRateVo;
import com.mine.common.vo.LoanCurrencyProductVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.mine.util.date.DateTools;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2018/6/28.
 */
@RequestMapping("loanAmountRate")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class LoanAmountRateController extends BaseController {

    @Autowired
    private LoanCurrencyProductService loanCurrencyProductService;

    @Autowired
    private LoanAmountRateService loanAmountRateService;

    @RequestMapping("index")
    public String index(HttpServletRequest request) {
        List<LoanCurrencyProductVo> listLoanCurrencyProductVo=loanCurrencyProductService.list(null);
        request.setAttribute("listLoanCurrencyProductVo",listLoanCurrencyProductVo);
        return "loanAmountRate/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "offset", defaultValue = "1") int offset,
                       @RequestParam(value = "limit", defaultValue = "10") int limit,
                       LoanAmountRateVo vo) {

        total = loanAmountRateService.countLoanAmountRate(vo);
        if (total > 0) {
            list = loanAmountRateService.listLoanAmountRate(vo, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }


    /**
     * 进入添加页面
     */
    @RequestMapping(value = "add")
    @OperatorLogger(operatorName = "进入添加页面")
    public String add(HttpServletRequest request) {
        LoanCurrencyProductVo loanCurrencyProductVo=new LoanCurrencyProductVo();
        loanCurrencyProductVo.setEnable(true);
        List<LoanCurrencyProductVo> listLoanCurrencyProductVo=loanCurrencyProductService.list(loanCurrencyProductVo);
        request.setAttribute("listLoanCurrencyProductVo",listLoanCurrencyProductVo);
        return "loanAmountRate/edit";
    }

    /**
     * 保存
     *
     * @return
     */
    @RequestMapping(value = "save")
    @OperatorLogger(operatorName = "添加产品")
    @ResponseBody
    public Map<String, Object> save(LoanAmountRateVo vo) {
        try {
            if (null != vo.getId()) {
                vo.setCreateTime(DateTools.stringToDateTime(vo.getCreateTimeStr()));
                loanAmountRateService.update(vo);
            } else {
                loanAmountRateService.add(vo);
            }
            result = true;
        } catch (Exception e) {
            result = false;
            message = e.getMessage();
        }
        return getResultMap();
    }

    /**
     * 前往修改页面
     *
     * @param request
     * @param response
     * @param
     * @return
     */
    @RequestMapping(value = "update")
    @OperatorLogger(operatorName = "进入修改页面")
    public String update(HttpServletRequest request, Integer id) {
        LoanAmountRateVo vo = loanAmountRateService.get(id);
        vo.setCreateTimeStr(DateTools.dateToStringDateTimeDefault(vo.getCreateTime()));
        request.setAttribute("loanAmountRateVo", vo);
        LoanCurrencyProductVo loanCurrencyProductVo=new LoanCurrencyProductVo();
        loanCurrencyProductVo.setEnable(true);
        List<LoanCurrencyProductVo> listLoanCurrencyProductVo=loanCurrencyProductService.list(loanCurrencyProductVo);
        request.setAttribute("listLoanCurrencyProductVo",listLoanCurrencyProductVo);
        return "loanAmountRate/edit";
    }
}
