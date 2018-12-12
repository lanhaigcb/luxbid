package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CCurrencyService;
import com.mine.bizservice.C2CExchangeOrderService;
import com.mine.common.response.Response;
import com.mine.common.vo.C2CCurrencyVo;
import com.mine.common.vo.C2CStatisticVo;
import com.shop.admin.controller.BaseController;
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
 * @date 2018/5/28 下午5:10
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cStatistic")
public class C2CStatisticController extends BaseController {
    @Autowired
    private C2CExchangeOrderService c2cExchangeOrderService;
    @Autowired
    private C2CCurrencyService c2cCurrencyService;

    @RequestMapping("/index")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("c2cStatistic/index");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/list")
    public Response statistic(Date startTime, Date endTime){
        List<C2CStatisticVo> vos = new ArrayList<>();
        List<C2CCurrencyVo> c2CCurrencyVos = c2cCurrencyService.list();
        for(C2CCurrencyVo currencyVo:c2CCurrencyVos){
            C2CStatisticVo vo = c2cExchangeOrderService.getC2CStatistic(startTime, endTime, currencyVo.getSymbol());
            vos.add(vo);
        }
        return Response.listSuccess(vos.size(), vos, "查询成功");
    }
}
