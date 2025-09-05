<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map1{
    width:auto;
    height:400px;
    border:2px solid red;
  }
</style>
<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f37b6c5eb063be1a82888e664e204d6d"></script>
<script>
  let map1 = {
    map:null,
    marker:null,
    markerImage:null,

    init:function(){
      this.makeMap();
      setInterval(this.getData, 3000);
    },

    getData:function(){
      $.ajax({
        url:'/getlatlng',
        success:(result)=>{ map1.showMarker(result); }
      });
    },

    showMarker:function(result){
      if (this.marker) this.marker.setMap(null);


      let position = new kakao.maps.LatLng(result.lat, result.lng);
      this.marker = new kakao.maps.Marker({
        position: position,
        image: this.markerImage
      });
      this.marker.setMap(this.map);
    },

    makeMap:function(){
      let mapContainer = document.getElementById('map1');
      let mapOption = {
        center: new kakao.maps.LatLng(36.800209, 127.074968),
        level: 7
      }
      this.map = new kakao.maps.Map(mapContainer, mapOption);

      let mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);


      let imageSrc  = '/img/c1.jpg';
      let imageSize = new kakao.maps.Size(48, 48);
      let imageOpt  = { offset: new kakao.maps.Point(24, 48) };
      this.markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOpt);


      let markerPosition  = new kakao.maps.LatLng(36.800209, 127.074968);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map:this.map
      });
    }
  }
  $(function(){ map1.init() })
</script>



<div class="col-sm-10">
  <h2>Map4</h2>
  <div id="map1"></div>
</div>