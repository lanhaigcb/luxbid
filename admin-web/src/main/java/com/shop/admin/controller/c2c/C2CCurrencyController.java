package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CCurrencyService;
import com.mine.common.response.Response;
import com.mine.common.vo.C2CCurrencyVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/6/4 下午11:24
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cCurrency")
public class C2CCurrencyController extends BaseController {

    @Autowired
    private C2CCurrencyService c2cCurrencyService;

    @RequestMapping("/index")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("c2cCurrency/index");
        return mv;
    }

    @RequestMapping("/list")
    @ResponseBody
    public Response list() {
        List<C2CCurrencyVo> vos = c2cCurrencyService.list();
        return Response.listSuccess(vos.size(), vos, "查询成功");
    }

    /**
     * 进入添加Currency页面
     */
    @RequestMapping("/addInput")
    public ModelAndView addCurrencyIndex() {
        ModelAndView mv = new ModelAndView("c2cCurrency/add");
        return mv;
    }

    /**
     * 添加Currency
     *
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加C2CCurrency")
    @ResponseBody
    public Response add(String symbol, String chName, Integer precise, BigDecimal tradeMinLimit, BigDecimal tradeMaxLimit) {
        c2cCurrencyService.add(symbol, chName, precise,tradeMinLimit, tradeMaxLimit);
        return Response.simpleSuccess();
    }

    /**
     * 进入修改c2cCurrency页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改C2CCurrency页面")
    public ModelAndView modifyCurrency(Integer id) {
        ModelAndView mv = new ModelAndView("c2cCurrency/edit");
        C2CCurrencyVo currencyVo = c2cCurrencyService.get(id);
        mv.addObject("currency", currencyVo);
        return mv;
    }

    /**
     * 添加Currency
     *
     * @return
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "更新C2CCurrency")
    @ResponseBody
    public Response update(Integer id, String symbol, String chName, Integer precise, BigDecimal tradeMinLimit, BigDecimal tradeMaxLimit, Boolean enable, Boolean needUpdatePrice) {
        c2cCurrencyService.update(id, symbol, chName, precise, tradeMinLimit, tradeMaxLimit,enable,needUpdatePrice);
        return Response.simpleSuccess();
    }
}
