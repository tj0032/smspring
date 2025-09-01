<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>원, 선, 사각형, 다각형 표시하기</title>
  <style>
    #map1 {
      width: auto;
      height: 400px;
      border: 2px solid red;
    }
  </style>
  <!-- 카카오맵 SDK (appkey 제거된 버전: 실제 실행하려면 appkey 필요) -->
  <script src="//dapi.kakao.com/v2/maps/sdk.js"></script>
</head>
<body>
<div class="col-sm-10">
  <h2>Map6</h2>
  <div id="map1"></div>
</div>

<script>
  // 지도 컨테이너 및 옵션
  let mapContainer = document.getElementById('map1');
  let mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667),
    level: 3
  };

  // 지도 생성
  let map = new kakao.maps.Map(mapContainer, mapOption);

  // 원
  let circle = new kakao.maps.Circle({
    center: new kakao.maps.LatLng(33.450701, 126.570667),
    radius: 50,
    strokeWeight: 5,
    strokeColor: '#75B8FA',
    strokeOpacity: 1,
    strokeStyle: 'dashed',
    fillColor: '#CFE7FF',
    fillOpacity: 0.7
  });
  circle.setMap(map);

  // 선
  let linePath = [
    new kakao.maps.LatLng(33.452344169439975, 126.56878163224233),
    new kakao.maps.LatLng(33.452739313807456, 126.5709308145358),
    new kakao.maps.LatLng(33.45178067090639, 126.5726886938753)
  ];
  let polyline = new kakao.maps.Polyline({
    path: linePath,
    strokeWeight: 5,
    strokeColor: '#FFAE00',
    strokeOpacity: 0.7,
    strokeStyle: 'solid'
  });
  polyline.setMap(map);

  // 사각형
  let sw = new kakao.maps.LatLng(33.448842, 126.570379);
  let ne = new kakao.maps.LatLng(33.450026, 126.568556);
  let rectangleBounds = new kakao.maps.LatLngBounds(sw, ne);
  let rectangle = new kakao.maps.Rectangle({
    bounds: rectangleBounds,
    strokeWeight: 4,
    strokeColor: '#FF3DE5',
    strokeOpacity: 1,
    strokeStyle: 'shortdashdot',
    fillColor: '#FF8AEF',
    fillOpacity: 0.8
  });
  rectangle.setMap(map);

  // 다각형
  let polygonPath = [
    new kakao.maps.LatLng(33.45133510810506, 126.57159381623066),
    new kakao.maps.LatLng(33.44955812811862, 126.5713551811832),
    new kakao.maps.LatLng(33.449986291544086, 126.57263296172184),
    new kakao.maps.LatLng(33.450682513554554, 126.57321034054742),
    new kakao.maps.LatLng(33.451346760004206, 126.57235740081413)
  ];
  let polygon = new kakao.maps.Polygon({
    path: polygonPath,
    strokeWeight: 3,
    strokeColor: '#39DE2A',
    strokeOpacity: 0.8,
    strokeStyle: 'longdash',
    fillColor: '#A2FF99',
    fillOpacity: 0.7
  });
  polygon.setMap(map);
</script>
</body>
</html>
