package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CTradeLimitService;
import com.mine.common.response.Response;
import com.mine.common.vo.C2CPriceVo;
import com.mine.common.vo.C2CTradeLimitVo;
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

import java.util.List;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/5/31 下午7:03
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cLimit")
public class C2CTradeLimitController extends BaseController {

    @Autowired
    private C2CTradeLimitService c2cTradeLimitService;

    @RequestMapping("/index")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("c2cLimit/index");
        return mv;
    }

    @RequestMapping("/list")
    @ResponseBody
    public Response list() {
        List<C2CTradeLimitVo> vos = c2cTradeLimitService.list();
        return Response.listSuccess(vos.size(), vos, "查询成功");
    }

    /**
     * 进入修改页面
     */
    @RequestMapping("/updateInput")
    public ModelAndView modifyPrice(Integer id) {
        ModelAndView mv = new ModelAndView("c2cLimit/edit");
        C2CTradeLimitVo vo = c2cTradeLimitService.get(id);
        mv.addObject("limit", vo);
        return mv;
    }

    @RequestMapping("/update")
    @ResponseBody
    public Response update(Integer id, String value) {
        Staff currentLogin = SecurityUtil.currentLogin();
        c2cTradeLimitService.update(id,value,currentLogin.getId());
        return Response.simpleSuccess();
    }
}
