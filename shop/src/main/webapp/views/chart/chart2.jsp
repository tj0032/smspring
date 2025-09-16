<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #container1{
    width: 300px;
    border: 1px solid black;
  }
  #container2{
    width: 300px;
    border: 1px solid yellow;
  }
  #container1{
    width: 300px;
    border: 1px solid blue;
  }
</style>
<script>
  chart2={
    init:function(){
      this.chart1();
      this.chart2();
      this.chart3();
      this.chart4();
    },
    chart1:function (){
      Highcharts.chart('container1', {
        chart: {
          type: 'pie',
          options3d: {
            enabled: true,
            alpha: 45
          }
        },
        title: {
          text: 'Beijing 2022 gold medals by country'
        },
        subtitle: {
          text: '3D donut in Highcharts'
        },
        plotOptions: {
          pie: {
            innerSize: 100,
            depth: 45
          }
        },
        series: [{
          name: 'Medals',
          data: [
            ['Norway', 16],
            ['Germany', 12],
            ['USA', 8],
            ['Sweden', 8],
            ['Netherlands', 8],
            ['ROC', 6],
            ['Austria', 7],
            ['Canada', 4],
            ['Japan', 3]

          ]
        }]
      });
    },
    chart2:function (){
      Highcharts.chart('container2', {
        chart: {
          type: 'cylinder',
          options3d: {
            enabled: true,
            alpha: 15,
            beta: 15,
            depth: 50,
            viewDistance: 25
          }
        },
        title: {
          text: 'Number of confirmed COVID-19'
        },
        subtitle: {
          text: 'Source: ' +
                  '<a href="https://www.fhi.no/en/id/infectious-diseases/coronavirus/daily-reports/daily-reports-COVID19/"' +
                  'target="_blank">FHI</a>'
        },
        xAxis: {
          categories: [
            '0-9', '10-19', '20-29', '30-39', '40-49', '50-59', '60-69',
            '70-79', '80-89', '90+'
          ],
          title: {
            text: 'Age groups'
          },
          labels: {
            skew3d: true
          }
        },
        yAxis: {
          title: {
            margin: 20,
            text: 'Reported cases'
          },
          labels: {
            skew3d: true
          }
        },
        tooltip: {
          headerFormat: '<b>Age: {category}</b><br>'
        },
        plotOptions: {
          series: {
            depth: 25,
            colorByPoint: true
          }
        },
        series: [{
          data: [
            95321, 169339, 121105, 136046, 106800, 58041, 26766, 14291,
            7065, 3283
          ],
          name: 'Cases',
          showInLegend: false
        }]
      });
    },
    chart3:function (){
      const text =
              '(경남=뉴스1) 강정태 기자 = 지난 2002년 2월 8일 오전 7시50분쯤 경남의 한 도심 초등학교 교실. 친구들보다 먼저 등교해 혼자 수업 준비를 하고 있던 A 양(당시 10세)에게 마스크를 쓴 남성이 다가왔다'
              '잠기지 않은 문을 통해 교실에 침입한 이 남성은 다짜고짜 A 양의 목을 졸랐다. A 양이 정신을 잃고 반항하지 못하자 그는 곧장 몹쓸 짓을 저지르고 달아났다. 이후 A 양은 정신을 잃고 하반신에 피를 흘린 채 등교한 친구들에게 발견됐다'
              '사건 직후 곧바로 수사에 착수한 경찰은 사건 전날 회사원 복장으로 학교 주변을 서성거린 20대 남성이 있었다는 학생들의 목격담에 따라 현장 노동자와 동종 전과자를 상대로 수사를 벌였으나 범인을 특정할 실마리를 찾지 못했다'
              '그사이 큰 충격을 받았던 A 양은 가족과 함께 수백 킬로미터 떨어진 다른 지역으로 떠났고, 사건 발생 지역 학부모들은 불안에 떨어야 했다'
              '경찰은 학부모들의 커지는 불안에 사건을 공개수사로 전환해 몽타주까지 만들어 배포했으나 당시 수사 기술로는 범인을 특정하기 쉽지 않았고'
              '결국 사건은 시간이 흘러 장기 미제로 남게 됐다',
              lines = text.replace(/[():'?0-9]+/g, '').split(/[,\. ]+/g),
              data = lines.reduce((arr, word) => {
                let obj = Highcharts.find(arr, obj => obj.name === word);
                if (obj) {
                  obj.weight += 1;
                } else {
                  obj = {
                    name: word,
                    weight: 1
                  };
                  arr.push(obj);
                }
                return arr;
              }, []);

      Highcharts.chart('container3', {
        accessibility: {
          screenReaderSection: {
            beforeChartFormat: '<h5>{chartTitle}</h5>' +
                    '<div>{chartSubtitle}</div>' +
                    '<div>{chartLongdesc}</div>' +
                    '<div>{viewTableButton}</div>'
          }
        },
        chart: {
          zooming: {
            type: 'xy'
          },
          panning: {
            enabled: true,
            type: 'xy'
          },
          panKey: 'shift'
        },
        series: [{
          type: 'wordcloud',
          data,
          name: 'Occurrences'
        }],
        title: {
          text: 'Wordcloud of Alice\'s Adventures in Wonderland',
          align: 'left'
        },
        subtitle: {
          text: 'An excerpt from chapter 1: Down the Rabbit-Hole',
          align: 'left'
        },
        tooltip: {
          headerFormat: '<span style="font-size: 16px"><b>{point.name}</b>' +
                  '</span><br>'
        }
      });
    },
    chart4:function () {
      const startYear = 1965, endYear = 2020, nbr = 6;
      let dataset, chart;

      function getData(year) {
        const output = Object.entries(dataset).map(([countryName, countryData]) => [countryName, Number(countryData[year])]);
        return [output[0], output.slice(1, nbr)];
      }

      function getSubtitle(year, total) {
        return `<span style="font-size: 80px">${year}</span><br>
            <span style="font-size: 22px">Total: <b>${total.toFixed(2)}</b> TWh</span>`;
      }

      (async () => {
        dataset = await fetch('https://www.highcharts.com/samples/data/nuclear-energy-production.json')
                .then(r => r.json());

        const year = startYear;
        const totalNumber = getData(year)[0][1];

        chart = Highcharts.chart('container4', {
          title: {
            text: 'Nuclear energy production from 1965 to 2021 in US, UK, France, Germany, and Japan',
            align: 'center'
          },
          subtitle: {
            text: getSubtitle(year, totalNumber),
            floating: true,
            useHTML: true,
            verticalAlign: 'middle',
            y: 30
          },
          legend: { enabled: false },
          tooltip: { valueDecimals: 2, valueSuffix: ' TWh' },
          plotOptions: {
            series: {
              borderWidth: 0,
              colorByPoint: true,
              type: 'pie',
              size: '100%',
              innerSize: '80%',
              dataLabels: { enabled: true, crop: false, distance: '-10%', style: { fontWeight: 'bold', fontSize: '16px' }, connectorWidth: 0 }
            }
          },
          series: [{ type: 'pie', name: String(year), data: getData(year)[1] }]
        });
      })();
    }
  }
  $(()=>{
    chart2.init();
  });
</script>
<div class="col-sm-10">
  <h2>Chart2</h2>
  <div class="row">
    <div class="col-sm-6" id="container1"></div>
    <div class="col-sm-6" id="container2"></div>
  </div>
  <div class="row">
    <div class="col-sm-6" id="container3"></div>
    <div class="col-sm-6" id="container4"></div>
  </div>
</div>