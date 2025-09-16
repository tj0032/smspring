<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>월별 매출 통계 (chart3)</title>

  <!-- Highcharts & 필요한 모듈 -->
  <script src="https://code.highcharts.com/highcharts.js"></script>
  <script src="https://code.highcharts.com/modules/exporting.js"></script>
  <script src="https://code.highcharts.com/modules/accessibility.js"></script>

  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,'Apple SD Gothic Neo','Noto Sans KR',sans-serif}
    .wrap {max-width: 1100px; margin: 24px auto; padding: 0 12px;}
    #container {height: 460px; margin-bottom: 24px;}
    table {border-collapse: collapse; width: 100%;}
    th, td {border: 1px solid #e5e7eb; padding: 8px 10px; text-align: right;}
    th {background: #f8fafc; text-align: center;}
    td:first-child, th:first-child {text-align: center;}
  </style>
</head>
<body>
<div class="wrap">
  <h2>월별 매출 통계</h2>
  <div id="container"></div>

  <h3>월별 데이터</h3>
  <table id="data-table">
    <thead>
    <tr>
      <th>월</th>
      <th>합계(원)</th>
      <th>평균(원)</th>
    </tr>
    </thead>
    <tbody></tbody>
  </table>
</div>

<script>
  // 쿼리 파라미터 (연도, cateId 필요시 추가)
  const query = new URLSearchParams({ year: '2025' });

  // JSON 데이터 요청 (컨텍스트패스 안전하게 c:url 사용 가능)
  fetch('<c:url value="/api/chart3"/>' + '?' + query.toString(), {
    headers: { 'Accept': 'application/json' }
  })
          .then(r => {
            if (!r.ok) throw new Error('데이터 로드 실패');
            return r.json();
          })
          .then(({ cate, sum, avg }) => {
            // 1) Highcharts 렌더링
            Highcharts.chart('container', {
              chart: { zoomType: 'xy' },
              title: { text: '월별 매출 합계 vs 평균' },
              xAxis: [{ categories: cate, crosshair: true }],
              yAxis: [{
                title: { text: '합계(원)' }
              }, {
                title: { text: '평균(원)' },
                opposite: true
              }],
              tooltip: { shared: true },
              legend: { align: 'center', verticalAlign: 'bottom' },
              series: [{
                type: 'column',
                name: '합계',
                data: sum,
                yAxis: 0
              }, {
                type: 'spline',
                name: '평균',
                data: avg,
                yAxis: 1,
                marker: { enabled: true }
              }]
            });

            // 2) 표 데이터 렌더링
            const tbody = document.querySelector('#data-table tbody');
            tbody.innerHTML = cate.map((m, i) => `
        <tr>
          <td>\${m}</td>
          <td>\${Number(sum[i] || 0).toLocaleString()}</td>
          <td>\${Number(avg[i] || 0).toLocaleString()}</td>
        </tr>
      `).join('');
          })
          .catch(err => {
            console.error(err);
            document.getElementById('container').innerHTML =
                    '<p style="color:#ef4444">데이터를 불러오지 못했습니다.</p>';
          });
</script>
</body>
</html>
