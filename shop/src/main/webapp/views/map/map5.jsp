<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map{
    width:auto;
    height:400px;
    border: 2px solid blue;
  }
</style>
<script>
  let map2 = {
    map: null,
    overlays: new Set(),

    init: function () {
      this.makeMap(37.538453, 127.053110, '남산', 's1.jpg', 100);

      // 교통정보 토글
      $('#sbtn').click(() => {
        this.toggleOverlay('TRAFFIC');
      });
      // 로드뷰 커버리지(보라색 길) 토글
      $('#bbtn').click(() => {
        this.toggleOverlay('ROADVIEW');
      });
      // 지형정보 토글
      $('#jbtn').click(() => {
        this.toggleOverlay('TERRAIN');
      });
    },

    toggleOverlay: function (typeName) {
      const typeId = kakao.maps.MapTypeId[typeName];
      if (this.overlays.has(typeId)) {
        this.map.removeOverlayMapTypeId(typeId);
        this.overlays.delete(typeId);
      } else {
        this.map.addOverlayMapTypeId(typeId);
        this.overlays.add(typeId);
      }
    },

    makeMap: function (lat, lng, title, imgName, target) {
      const mapContainer = document.getElementById('map');
      const mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 7
      };
      this.map = new kakao.maps.Map(mapContainer, mapOption);

      const mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

      const zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      const markerPosition = new kakao.maps.LatLng(lat, lng);
      new kakao.maps.Marker({
        position: markerPosition,
        map: this.map
      });
    }
  };

  $(function () {
    map2.init();
  });
</script>

<div class="col-sm-10">
  <h2>Map5</h2>
  <button id="sbtn" class="btn btn-primary">교통정보 지도타입</button>
  <button id="bbtn" class="btn btn-primary">로드뷰 도로정보 지도타입</button>
  <button id="jbtn" class="btn btn-primary">지형정보 지도타입</button>
  <div id="map"></div>
</div>