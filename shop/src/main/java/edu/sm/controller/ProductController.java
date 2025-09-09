package edu.sm.controller;

import edu.sm.app.dto.Product;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {
    final ProductService productService;

    String dir="product/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center",dir+"add");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<Product> list = null;

        list = productService.get();
        model.addAttribute("plist", list);
        model.addAttribute("left", dir+"left");
        model.addAttribute("center", dir+"get");
        return "index";
    }
    @RequestMapping("/registerimpl")
    public String registerimpl(Model model, Product product) throws Exception {
        productService.register(product);
        return "redirect:/product/get";
    }

}