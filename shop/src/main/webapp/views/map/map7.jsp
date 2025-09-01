<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map1{
    width:auto;
    height:400px;
    border:2px solid red;
  }
  /* 선택 사항: 클릭 지점/오버레이 보이기 쉽게 */
  .dot { display:block; width:8px; height:8px; margin-top:-4px; margin-left:-4px; border-radius:50%; background:#db4040; border:2px solid #fff; }
  .dotOverlay { position:relative; bottom:10px; border:1px solid #ccc; border-radius:4px; background:#fff; padding:6px 10px; font-size:12px; white-space:nowrap; }
  .dotOverlay .number { font-weight:700; }
  .distanceInfo { list-style:none; margin:0; padding:0; }
</style>

<!-- Kakao SDK가 페이지 어딘가에 반드시 로드되어 있어야 합니다 -->
<!-- <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KEY"></script> -->

<script>
  let map1 ={
    init:function(){
      let mapContainer = document.getElementById('map1');
      let mapOption = {
        center: new kakao.maps.LatLng(36.799131, 127.075013),
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOption);
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      let markerPosition  = new kakao.maps.LatLng(36.799131, 127.075013);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map:map
      });

      let drawingFlag = false; // 선이 그려지고 있는 상태
      let moveLine;            // 마우스 따라가는 보조선
      let clickLine;           // 클릭 좌표 누적선
      let distanceOverlay;     // 총거리/시간 오버레이
      let dots = [];           // ★ 배열로 변경 (기존 {}였음)

      // 지도 클릭: 선 시작/연장
      kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        let clickPosition = mouseEvent.latLng;

        if (!drawingFlag) {
          drawingFlag = true;
          deleteClickLine();
          deleteDistnce();   // 원래 함수명 유지 (오타지만 호출부와 일치)
          deleteCircleDot();

          clickLine = new kakao.maps.Polyline({
            map: map,
            path: [clickPosition],
            strokeWeight: 3,
            strokeColor: '#db4040',
            strokeOpacity: 1,
            strokeStyle: 'solid'
          });

          moveLine = new kakao.maps.Polyline({
            strokeWeight: 3,
            strokeColor: '#db4040',
            strokeOpacity: 0.5,
            strokeStyle: 'solid'
          });

          displayCircleDot(clickPosition, 0);

        } else {
          let path = clickLine.getPath();
          path.push(clickPosition);
          clickLine.setPath(path);

          let distance = Math.round(clickLine.getLength());
          displayCircleDot(clickPosition, distance);
        }
      });

      // 마우스 무브: 보조선 및 현재 총거리 표시
      kakao.maps.event.addListener(map, 'mousemove', function (mouseEvent) {
        if (!drawingFlag) return;

        let mousePosition = mouseEvent.latLng;
        let path = clickLine.getPath();
        let movepath = [path[path.length-1], mousePosition];
        moveLine.setPath(movepath);
        moveLine.setMap(map);

        let distance = Math.round(clickLine.getLength() + moveLine.getLength());
        let content = '<div class="dotOverlay distanceInfo">총거리 <span class="number">' + distance + '</span>m</div>';
        showDistance(content, mousePosition);
      });

      // 우클릭: 선 그리기 종료
      kakao.maps.event.addListener(map, 'rightclick', function () {
        if (!drawingFlag) return;

        moveLine.setMap(null);
        moveLine = null;

        let path = clickLine.getPath();

        if (path.length > 1) {
          if (dots.length > 0 && dots[dots.length-1].distance) {
            dots[dots.length-1].distance.setMap(null);
            dots[dots.length-1].distance = null;
          }
          let distance = Math.round(clickLine.getLength());
          let content = getTimeHTML(distance);
          showDistance(content, path[path.length-1]);
        } else {
          deleteClickLine();
          deleteCircleDot();
          deleteDistnce();
        }

        drawingFlag = false;
      });

      // ===== 내부 함수들 =====
      function deleteClickLine() {
        if (clickLine) {
          clickLine.setMap(null);
          clickLine = null;
        }
      }

      function showDistance(content, position) {
        if (distanceOverlay) {
          distanceOverlay.setPosition(position);
          distanceOverlay.setContent(content);
        } else {
          distanceOverlay = new kakao.maps.CustomOverlay({
            map: map,
            content: content,
            position: position,
            xAnchor: 0,
            yAnchor: 0,
            zIndex: 3
          });
        }
      }

      function deleteDistnce () {
        if (distanceOverlay) {
          distanceOverlay.setMap(null);
          distanceOverlay = null;
        }
      }

      function displayCircleDot(position, distance) {
        let circleOverlay = new kakao.maps.CustomOverlay({
          content: '<span class="dot"></span>',
          position: position,
          zIndex: 1
        });
        circleOverlay.setMap(map);

        let distOv = null;
        if (distance > 0) {
          distOv = new kakao.maps.CustomOverlay({
            content: '<div class="dotOverlay">거리 <span class="number">' + distance + '</span>m</div>',
            position: position,
            yAnchor: 1,
            zIndex: 2
          });
          distOv.setMap(map);
        }

        dots.push({circle: circleOverlay, distance: distOv});
      }

      function deleteCircleDot() {
        for (let i = 0; i < dots.length; i++ ){
          if (dots[i].circle) dots[i].circle.setMap(null);
          if (dots[i].distance) dots[i].distance.setMap(null);
        }
        dots = [];
      }

      function getTimeHTML(distance) {
        // 도보 4km/h → 67 m/min
        let walkkTime = distance / 67 | 0;
        let walkHour = '', walkMin = '';
        if (walkkTime > 60) walkHour = '<span class="number">' + Math.floor(walkkTime / 60) + '</span>시간 ';
        walkMin = '<span class="number">' + (walkkTime % 60) + '</span>분';

        // 자전거 16km/h → 267 m/min (원문은 227로 오타, 원 코드 유지하면 227)
        let bycicleTime = distance / 227 | 0; // 원본 유지
        let bycicleHour = '', bycicleMin = '';
        if (bycicleTime > 60) bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>시간 ';
        bycicleMin = '<span class="number">' + (bycicleTime % 60) + '</span>분';

        let content = '<ul class="dotOverlay distanceInfo">';
        content += '  <li><span class="label">총거리</span><span class="number">' + distance + '</span>m</li>';
        content += '  <li><span class="label">도보</span>' + walkHour + walkMin + '</li>';
        content += '  <li><span class="label">자전거</span>' + bycicleHour + bycicleMin + '</li>';
        content += '</ul>';
        return content;
      }
    }
  }

  // ★ init 호출이 없어서 아무 것도 안 뜨던 것 → 호출 추가
  document.addEventListener('DOMContentLoaded', () => map1.init());
</script>

<div class="col-sm-10">
  <h2>Map7</h2>
  <div id="map1"></div>
</div>
