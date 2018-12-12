package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CCurrencyService;
import com.mine.bizservice.C2CPriceService;
import com.mine.common.response.Response;
import com.mine.common.vo.C2CCurrencyVo;
import com.mine.common.vo.C2CPriceVo;
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

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/5/23 下午2:15
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cPrice")
public class C2CPriceController extends BaseController {

    @Autowired
    private C2CPriceService c2cPriceService;
    @Autowired
    private C2CCurrencyService c2cCurrencyService;
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入C2CPrice管理")
    public ModelAndView currencyManage() {
        List<C2CCurrencyVo> vos = c2cCurrencyService.list();
        ModelAndView mv = new ModelAndView("c2cPrice/index");
        mv.addObject("vos", vos);
        return mv;
    }

    @RequestMapping("/list")
    @OperatorLogger(operatorName = "获取所有C2CPrice")
    @ResponseBody
    public Response list(String symbol) {
        List<C2CPriceVo> vos = c2cPriceService.listBySymbol(symbol);
        return Response.listSuccess(vos.size(), vos, "查询成功");
    }

    /**
     * 进入修改C2CPrice页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改C2CPrice页面")
    public ModelAndView modifyPrice(Integer id) {
        ModelAndView mv = new ModelAndView("c2cPrice/edit");
        C2CPriceVo priceVo = c2cPriceService.get(id);
        mv.addObject("price", priceVo);
        return mv;
    }

    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改C2CPrice")
    @ResponseBody
    public Response update(Integer id, BigDecimal rate) {
        Staff currentLogin = SecurityUtil.currentLogin();
        c2cPriceService.update(id, rate, currentLogin.getId());
        return Response.simpleSuccess();
    }

    @RequestMapping("/enable")
    @OperatorLogger(operatorName = "修改C2CPrice的启用禁用")
    @ResponseBody
    public Response enable(Integer id, Boolean enable){
        Staff currentLogin = SecurityUtil.currentLogin();
        c2cPriceService.enable(id,enable,currentLogin.getId());
        return Response.simpleSuccess();
    }
}
