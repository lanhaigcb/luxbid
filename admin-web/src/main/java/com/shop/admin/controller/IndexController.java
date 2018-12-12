package com.shop.admin.controller;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class IndexController extends BaseController {

    @RequestMapping("/index")
    public String index() {
        Staff staff = SecurityUtil.currentLogin();
        if (null == staff) {
            return "redirect:/auth/toLoginView";
        }
        return "index/index";
    }

    @RequestMapping("/index1")
    public String index1() {
        Staff staff = SecurityUtil.currentLogin();
        if (null == staff) {
            return "redirect:/auth/toLoginView";
        }
        return "index/index1";
    }

    @RequestMapping("/welcome")
    public ModelAndView welcome() {
        ModelAndView mv = new ModelAndView("welcome/index");
        return mv;
    }
}
