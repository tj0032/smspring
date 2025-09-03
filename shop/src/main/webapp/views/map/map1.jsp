<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map1{
    width:auto;
    height:400px;
    border:2px solid red;
  }
</style>
<script>
  let map1 = {
    addr:null,
    map:null,
    markers:[],  // 현재 지도에 찍힌 마커들 보관

    // 임시 데이터(프론트 전용) — 나중에 서버 데이터로 교체 예정
    CONVENIENCE_DATA: [
      {title:'편의점1', img:'cv1.jpg', lat:36.810354, lng:127.076886},
      {title:'편의점2', img:'cv2.jpg', lat:36.809544, lng:127.076494},
      {title:'편의점3', img:'cv3.jpg', lat:36.809089, lng:127.076449},
      {title:'편의점4', img:'cv4.jpg', lat:36.803889, lng:127.071342},
      {title:'편의점5', img:'cv5.jpg', lat:36.804287, lng:127.068841},
      {title:'편의점6', img:'cv6.jpg', lat:36.802142, lng:127.067310},
      {title:'편의점7', img:'cv7.jpg', lat:36.800446, lng:127.069313},
      {title:'편의점8', img:'cv8.jpg', lat:36.799118, lng:127.075042},
    ],
    HOSPITAL_DATA: [
      {title:'병원1', img:'hos1.jpg', lat:36.809154, lng:127.075938},
      {title:'병원2', img:'hos2.jpg', lat:36.798488, lng:127.063438},
      {title:'병원3', img:'hos3.jpg', lat:36.799651, lng:127.060157},
      {title:'병원4', img:'hos4.jpg', lat:36.799189, lng:127.059778},
      {title:'병원5', img:'hos5.jpg', lat:36.798703, lng:127.059338},
      {title:'병원6', img:'hos6.jpg', lat:36.815246, lng:127.065039},
      {title:'병원7', img:'hos7.jpg', lat:36.817840, lng:127.057919},
      {title:'병원8', img:'hos8.jpg', lat:36.787861, lng:127.085983},
    ],

    init:function(){
      this.makeMap();
      $('#btn1').click(()=>{ // 병원
        this.renderMarkers(this.HOSPITAL_DATA);
      });
      $('#btn2').click(()=>{ // 편의점
        this.addr ? this.renderMarkers(this.CONVENIENCE_DATA)
                : alert('주소를 찾을수 없어요');
      });
    },

    makeMap: function(){
      let mapContainer = document.getElementById('map1');
      let mapOption = {
        center: new kakao.maps.LatLng(37.538453, 127.053110),
        level: 7
      }
      this.map = new kakao.maps.Map(mapContainer, mapOption);
      let mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position)=>{
          let lat = position.coords.latitude;
          let lng = position.coords.longitude;
          let locPosition = new kakao.maps.LatLng(lat, lng);
          this.goMap(locPosition);
        });
      }else{
        alert('지원하지 않습니다.');
      }
    },

    goMap: function(locPosition){
      let marker = new kakao.maps.Marker({
        map: this.map,
        position: locPosition
      });
      this.map.panTo(locPosition);

      let geocoder = new kakao.maps.services.Geocoder();
      geocoder.coord2RegionCode(locPosition.getLng(), locPosition.getLat(), this.addDisplay1.bind(this));
      geocoder.coord2Address(locPosition.getLng(), locPosition.getLat(), this.addDisplay2.bind(this));
    },

    addDisplay1:function(result, status){
      if (status === kakao.maps.services.Status.OK) {
        $('#addr1').html(result[0].address_name);
        this.addr = result[0].address_name;
      }
    },
    addDisplay2:function(result, status){
      if (status === kakao.maps.services.Status.OK) {
        var detailAddr = result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
        detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
        $('#addr2').html(detailAddr);
      }
    },

    // 기존 마커 제거
    clearMarkers:function(){
      this.markers.forEach(m => m.setMap(null));
      this.markers = [];
    },

    // 리스트로 마커 찍기 + 인포윈도우 + 화면 범위 맞추기
    renderMarkers:function(list){
      this.clearMarkers();
      if(!list || list.length === 0) return;

      const bounds = new kakao.maps.LatLngBounds();

      list.forEach(item=>{
        const pos = new kakao.maps.LatLng(item.lat, item.lng);
        const marker = new kakao.maps.Marker({ position: pos, map: this.map });

        const iwContent =
                '<div style="padding:6px 8px;">'
                + '<div style="font-weight:bold;">'+ item.title +'</div>'
                + '<img src="/img/'+ item.img +'" style="width:80px;margin-top:4px;">'
                + '</div>';
        const iw = new kakao.maps.InfoWindow({ content: iwContent });

        kakao.maps.event.addListener(marker, 'mouseover', () => iw.open(this.map, marker));
        kakao.maps.event.addListener(marker, 'mouseout',  () => iw.close());

        this.markers.push(marker);
        bounds.extend(pos);
      });

      this.map.setBounds(bounds);
    },
  }

  $(function(){
    map1.init()
  })
</script>



<div class="col-sm-10">
  <h2>Map1</h2>
  <h3 id="addr1"></h3>
  <h3 id="addr2"></h3>
  <button id="btn1" class="btn btn-primary">병원</button>
  <button id="btn2" class="btn btn-primary">편의점</button>
  <div id="map1"></div>
</div>