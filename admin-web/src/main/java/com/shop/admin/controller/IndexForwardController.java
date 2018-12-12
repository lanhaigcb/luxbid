package com.shop.admin.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 */
@Controller
public class IndexForwardController {

    private static Logger logger = LoggerFactory.getLogger(IndexForwardController.class);

    /**
     * 首页跳转页面 Controller
     */
    @RequestMapping(value = "/forward", method = RequestMethod.GET)
    public ModelAndView loginPage(@RequestParam String param1, @RequestParam String param2) {
        return new ModelAndView(param1 + "/" + param2);
    }

}
