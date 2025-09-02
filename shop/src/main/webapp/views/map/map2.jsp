<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map{
    width:auto;
    height:400px;
    border: 2px solid blue;
  }
  #content{
    margin-top: 83px;
    width:auto;
    height:400px;
    border: 2px solid red;
    overflow: auto;
  }
</style>
<script>
  let map2={
    init:function(){
      this.makeMap(37.538453, 127.053110, '남산', 's1.jpg', 100);

      // 37.538453, 127.053110
      $('#sbtn').click(()=>{
        this.makeMap(37.538453, 127.053110, '남산', 's1.jpg', 100);
      });
      // 35.170594, 129.175159
      $('#bbtn').click(()=>{
        this.makeMap(35.170594, 129.175159, '해운대', 's2.jpg', 200);
      });
      // 33.250645, 126.414800
      $('#jbtn').click(()=>{
        this.makeMap(33.250645, 126.414800, '중문', 's3.jpg', 300);
      });
    },
    makeMap:function(lat, lng, title, imgName, target){
      let mapContainer = document.getElementById('map');
      let mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOption);
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      // Marker 생성
      let markerPosition  = new kakao.maps.LatLng(lat, lng);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map:map
      });

      // Infowindow
      let iwContent = '<p>'+title+'</p>';
      iwContent += '<img src="<c:url value="/img/'+imgName+'"/> " style="width:80px;">';
      let infowindow = new kakao.maps.InfoWindow({
        content : iwContent
      });

      // Event
      kakao.maps.event.addListener(marker, 'mouseover', function(){
        infowindow.open(map, marker);
      });
      kakao.maps.event.addListener(marker, 'mouseout', function(){
        infowindow.close();
      });
      kakao.maps.event.addListener(marker, 'click', function(){
        location.href='<c:url value="/cust/get"/> '
      });

      this.makeMarkers(map, target);

    },
    makeMarkers:function(map, target){
      let datas = [];
      if(target == 100){
        datas = [
          {lat:37.564472, lng:126.990841, title:'순대국1', img:'ss1.jpg', target:101},
          {lat:37.544472, lng:126.970841, title:'순대국2', img:'ss2.jpg', target:102},
          {lat:37.564472, lng:126.970841, title:'순대국3', img:'ss3.jpg', target:103},
          {lat:37.565472, lng:126.980841, title:'순대국4', img:'ss4.jpg', target:104},
          {lat:37.563472, lng:126.974841, title:'순대국5', img:'ss5.jpg', target:105},
          {lat:37.565472, lng:126.972841, title:'순대국6', img:'ss6.jpg', target:106},
          {lat:37.566472, lng:126.971841, title:'순대국7', img:'ss7.jpg', target:107}
        ];
      }else if(target == 200){
        datas = [
          {lat:35.176109, lng:129.165474, title:'순대국1', img:'ss1.jpg', target:201},
          {lat:35.171109, lng:129.174474, title:'순대국2', img:'ss2.jpg', target:202},
          {lat:35.179109, lng:129.172474, title:'순대국3', img:'ss3.jpg', target:203},
          {lat:35.173109, lng:129.166474, title:'순대국4', img:'ss4.jpg', target:204}
        ];
      }else if(target == 300){
        datas = [
          {lat:33.251645, lng:126.415800, title:'순대국1', img:'ss1.jpg', target:301},
          {lat:33.260645, lng:126.411800, title:'순대국2', img:'ss2.jpg', target:302},
          {lat:33.258645, lng:126.420800, title:'순대국3', img:'ss3.jpg', target:303},
          {lat:33.261645, lng:126.415000, title:'순대국4', img:'ss4.jpg', target:304}
        ];
      }
      let imgSrc1 = 'https://t1.daumcdn.net/localimg/localimages/07/2012/img/marker_p.png';
      let imgSrc2 = '<c:url value="/img/down.png"/> ';

      let result = '';

      $(datas).each((index,item)=>{
        let imgSize = new kakao.maps.Size(30,30);
        let markerImg = new kakao.maps.MarkerImage(imgSrc1, imgSize);
        let markerPosition = new kakao.maps.LatLng(item.lat, item.lng);
        let marker = new kakao.maps.Marker({
          image: markerImg,
          map:map,
          position: markerPosition
        });
        let iwContent = '<p>'+item.title+'</p>';
        iwContent += '<img style="width:80px;" src="<c:url value="/img/'+item.img+'"/> ">';
        let infowindow = new kakao.maps.InfoWindow({
          content : iwContent,
        });
        kakao.maps.event.addListener(marker, 'mouseover', function() {
          infowindow.open(map, marker);
        });
        kakao.maps.event.addListener(marker, 'mouseout', function() {
          infowindow.close();
        });
        kakao.maps.event.addListener(marker, 'click', function() {
          location.href = '<c:url value="/map/go?target='+item.target+'"/>';
        });
        // Make Content List
        result += '<p>';
        result += '<a href="<c:url value="/map/go?target='+item.target+'"/>">';
        result += '<img width="20px" src="<c:url value="/img/'+item.img+'"/> ">';
        result += item.target+' '+item.title;
        result += '</a>';
        result += '</p>';


      });  // end for

      $('#content').html(result);

    } // end makeMarkers
  }

  $(function(){
    map2.init();
  })
</script>
<div class="col-sm-10">
  <div class="row">
    <div class="col-sm-8">
      <h2>Map2</h2>
      <button id="sbtn" class="btn btn-primary">Seoul</button>
      <button id="bbtn" class="btn btn-primary">Busan</button>
      <button id="jbtn" class="btn btn-primary">Jeju</button>
      <div id="map"></div>
    </div>
    <div class="col-sm-4">
      <div id="content"></div>
    </div>
  </div>


</div>