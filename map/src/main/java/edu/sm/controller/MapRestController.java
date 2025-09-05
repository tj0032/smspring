package edu.sm.controller;   // ← 메인 클래스 패키지 스캔 범위와 맞추세요 (예: 메인이 edu.sm.app면 edu.sm.app.controller 권장)

import edu.sm.app.dto.Burger;
import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Search;

import edu.sm.app.service.MarkerService;
import edu.sm.app.service.BurgerService;   // ★ BurgerService 로 통일

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MapRestController {

    private final MarkerService markerService;
    private final BurgerService burgerService;   // ★ 여기만 주입

    @RequestMapping("/getaddrshop")
    public Object getaddrshop(@RequestParam("addr") String addr, @RequestParam("type") int type) throws Exception {
        log.info(addr + " : " + type);
        String strs[] = addr.split(" ");
        Search search = Search.builder().addr(strs[strs.length - 1]).type(type).build();
        // 해당 주소로 데이터 베이스에서 정보를 조회 한다.
        // List 담아서 리턴 한다.
        return "ok";
    }

    @RequestMapping("/iot")
    public Object iot(@RequestParam("lat") double lat, @RequestParam("lng") double lng) throws Exception {
        log.info(lat + " " + lng);
        return "ok";
    }

    @RequestMapping("/getlatlng")
    public Object getlatlng() throws Exception {
        JSONObject jsonObject = new JSONObject();
        //36.800209, 127.074968
        Random r = new Random();
        double lat = 36.800209 + r.nextDouble(0.005);
        double lng = 127.074968 + r.nextDouble(0.001);
        jsonObject.put("lat", lat);
        jsonObject.put("lng", lng);
        // {lat:xxxxx, lng:xxxxxx}
        return jsonObject;
    }

    @RequestMapping("/getmarkers")
    public Object getMarkers(@RequestParam("target") int target) throws Exception {
        List<Marker> list = markerService.findByLoc(target);
        return list;
    }

    @RequestMapping("/getcontents")
    public Object getcontents(@RequestParam("target") int target, @RequestParam("type") int type) {
        log.info(target + " " + type);
        List<Content> contents = new ArrayList<>();
        if (target == 100) {
            if (type == 10) {
                contents.add(new Content(37.564472, 126.990841, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(37.544472, 126.970841, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(37.564472, 126.970841, "순대국3", "ss3.jpg", 103));
            } else if (type == 20) {
                contents.add(new Content(37.554472, 126.910841, "순1", "ss1.jpg", 101));
                contents.add(new Content(37.514472, 126.920841, "순2", "ss2.jpg", 102));
                contents.add(new Content(37.534472, 126.990841, "순3", "ss3.jpg", 103));
            } else if (type == 30) {
                contents.add(new Content(37.574472, 126.920841, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(37.584472, 126.970841, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(37.514472, 126.930841, "순대국3", "ss3.jpg", 103));
            }
        } else if (target == 200) {
            if (type == 10) {
                contents.add(new Content(35.175109, 129.171474, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(35.176109, 129.176474, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(35.172109, 129.179474, "순대국3", "ss3.jpg", 103));
            } else if (type == 20) {
                contents.add(new Content(35.171109, 129.174474, "순1", "ss1.jpg", 101));
                contents.add(new Content(35.175109, 129.170474, "순2", "ss2.jpg", 102));
                contents.add(new Content(35.179109, 129.171474, "순3", "ss3.jpg", 103));
            } else if (type == 30) {
                contents.add(new Content(35.165109, 129.170474, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(35.171109, 129.171474, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(35.169109, 129.168474, "순대국3", "ss3.jpg", 103));
            }
        } else if (target == 300) {
            if (type == 10) {
                contents.add(new Content(33.254564, 126.569944, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(33.251564, 126.566944, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(33.259564, 126.561944, "순대국3", "ss3.jpg", 103));
            } else if (type == 20) {
                contents.add(new Content(33.259564, 126.561944, "순1", "ss1.jpg", 101));
                contents.add(new Content(33.252564, 126.565944, "순2", "ss2.jpg", 102));
                contents.add(new Content(33.256564, 126.568944, "순3", "ss3.jpg", 103));
            } else if (type == 30) {
                contents.add(new Content(33.251564, 126.568944, "순대국1", "ss1.jpg", 101));
                contents.add(new Content(33.256564, 126.561944, "순대국2", "ss2.jpg", 102));
                contents.add(new Content(33.259564, 126.565944, "순대국3", "ss3.jpg", 103));
            }
        }
        return contents;
    }

    // 햄버거만 반환
    @RequestMapping("/getBurger")
    public Object getBurger() {
        List<Burger> shops = burgerService.getAll();   // repo.selectAll() 호출
        return shops;
    }
}
