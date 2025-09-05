package edu.sm.app.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @ToString
public class Burger {
    private int shopId;       // map.target
    private String name;      // map.title
    private String img;       // map.img
    private double lat;       // map.lat
    private double lng;       // map.lng
    private String loc;       // map.loc  (주소)
    private String info;      // map.info
    private double distance;  // map.distance
}
