<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #map1{ width:auto; height:400px; border:2px solid red; }
    #addrPanel{
        margin:10px 0 8px; padding:8px 12px; border:1px solid #ddd; background:#fff;
        font-size:14px; min-height:22px; border-radius:6px;
    }
</style>

<!-- (레이아웃에 jQuery가 없으면 유지, 있으면 이 줄 제거) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Kakao SDK: services, geometry + autoload=false (이 한 줄만!) -->
<script id="kakao-sdk"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f37b6c5eb063be1a82888e664e204d6d&libraries=services,geometry&autoload=false">
</script>

<script>
    let map1 = {
        map:null,
        myMarker:null,           // 움직이는 내 마커
        myMarkerImage:null,
        circle:null,             // 반경 3km 원
        shopMarkers:[],          // 햄버거 가게 마커들
        shopsCache:[],           // 서버에서 받은 매장 캐시
        photoInfoWindow:null,    // 마커 클릭 시 사진 보여줄 InfoWindow(재사용)

        // ★ 이미지 경로: DB img(hb*.jpg) 우선, 없으면 브랜드 기본값
        resolveImg(shop){
            let img = (shop.img || '').trim();
            if (!img) {
                const n = (shop.name || '').trim();
                if (n.includes('롯데리아')) img = 'l.jpg';
                else if (n.includes('맥도날드') || n.includes('맥도널드')) img = 'm.jpg';
                else if (n.includes('버거킹'))     img = 'k.jpg';
                else if (n.includes('맘스터치'))   img = 't.jpg';
                else if (n.includes('버거앤그릴') || n.includes('버거 앤 그릴')) img = 'g.jpg';
            }
            if (img) {
                if (!/^\/?img\//.test(img)) img = `/img/${img}`;
                else if (!img.startsWith('/')) img = `/${img}`;
            }
            return img; // 없으면 ''
        },

        init(){
            this.makeMap();
            setInterval(this.getData, 3000); // 내 마커 이동
            this.loadShops();                // DB에서 매장 로드
            const panel = document.getElementById('addrPanel');
            if (panel) panel.textContent = '마커를 클릭하면 사진과 주소가 표시됩니다.';
        },

        // 내 위치(샘플) 가져와 마커 이동
        getData(){
            $.ajax({
                url:'/getlatlng',
                dataType:'json',
                success:(pos)=> map1.showMyMarker(pos),
                error:(xhr)=> console.error('/getlatlng error', xhr.status, xhr.responseText)
            });
        },

        showMyMarker({lat, lng}){
            if (this.myMarker) this.myMarker.setMap(null);
            const p = new kakao.maps.LatLng(lat, lng);
            this.myMarker = new kakao.maps.Marker({
                position: p,
                image: this.myMarkerImage
            });
            this.myMarker.setMap(this.map);

            // 원 중심 갱신 + 반경 필터 재적용
            if (this.circle){
                this.circle.setPosition(p);
                if (this.shopsCache.length) this.showShops(this.shopsCache);
            }
        },

        makeMap(){
            const mapContainer = document.getElementById('map1');
            const mapOption = { center: new kakao.maps.LatLng(36.800209, 127.074968), level: 7 };
            this.map = new kakao.maps.Map(mapContainer, mapOption);

            // 컨트롤
            this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
            this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

            // 내 마커 이미지
            const imageSrc  = '/img/c1.jpg';
            const imageSize = new kakao.maps.Size(48, 48);
            const imageOpt  = { offset: new kakao.maps.Point(24, 48) };
            this.myMarkerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOpt);

            // 기본 마커 하나(중심 표시용)
            new kakao.maps.Marker({ position: mapOption.center, map: this.map });

            // 반경 3km 원
            this.circle = new kakao.maps.Circle({
                center : mapOption.center, radius: 3000,
                strokeWeight: 2, strokeColor: '#FF0000', strokeOpacity: 0.8, strokeStyle: 'solid',
                fillColor: '#FF0000', fillOpacity: 0.1
            });
            this.circle.setMap(this.map);

            // 사진용 인포윈도우(재사용)
            this.photoInfoWindow = new kakao.maps.InfoWindow({ removable: false, zIndex: 99999 });
        },

        // DB에서 버거 매장 가져오기
        loadShops(){
            $.ajax({
                url:'/getBurger',
                dataType:'json',
                success:(shops)=>{
                    this.shopsCache = shops || [];
                    this.showShops(this.shopsCache);
                },
                error:(xhr)=> console.error('/getBurger error', xhr.status, xhr.responseText)
            });
        },

        // 반경 3km 안의 매장만 마커 표시 + 클릭 시 사진 인포윈도우
        showShops(shops){
            // 기존 마커 제거
            this.shopMarkers.forEach(m=>m.setMap(null));
            this.shopMarkers = [];
            if (!this.circle) return;

            const center = this.circle.getPosition();
            const compute = kakao.maps?.geometry?.spherical?.computeDistanceBetween;
            const panel = document.getElementById('addrPanel');

            shops.forEach(shop=>{
                const lat = Number(shop.lat ?? shop.latitude ?? shop.y);
                const lng = Number(shop.lng ?? shop.longitude ?? shop.x);
                if (!Number.isFinite(lat) || !Number.isFinite(lng)) return;

                const pos = new kakao.maps.LatLng(lat, lng);
                const inRange = !compute || compute(center, pos) <= 3000;
                if (!inRange) return;

                const marker = new kakao.maps.Marker({ position: pos, map: this.map, title: shop.name || '' });
                this.shopMarkers.push(marker);

                // ★ 클릭 → 사진 + 주소 표시
                kakao.maps.event.addListener(marker, 'click', ()=>{
                    const src = this.resolveImg(shop);  // /img/hbX.jpg
                    if (panel) panel.textContent = shop.loc ? shop.loc : (shop.name || '');

                    // 바로 띄우되, 실패 시 안내문
                    const html = `
            <div style="padding:2px 2px 0 2px">
              <img src="${src}"
                   style="width:180px;height:120px;object-fit:cover;border-radius:4px"
                   onerror="this.parentElement.innerHTML='이미지 없음: ${src}'"/>
            </div>`;
                    this.photoInfoWindow.setContent(html);
                    this.photoInfoWindow.open(this.map, marker);
                });
            });
        }
    };

    // SDK 로드 후 init
    window.addEventListener('DOMContentLoaded', function () {
        const start = () => kakao.maps.load(() => map1.init());
        if (window.kakao?.maps?.load) start();
        else document.getElementById('kakao-sdk')?.addEventListener('load', start);
    });
</script>

<div class="col-sm-10">
    <h2>Map1</h2>
    <div id="addrPanel"></div>
    <div id="map1"></div>
</div>
