<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GroupWare · 차트 대시보드</title>
    <%@ include file="/module/headPart.jsp" %>
    <style>
      .card-title { font-weight: 600; }
      .apexcharts-canvas { max-width: 100%; }
      /* 헤더 높이만큼 실제 spacer로 확보 */
      #header-spacer { height: var(--header-h, 72px); }
    </style>
  </head>
  <body>
    <%@ include file="/module/header.jsp" %>
    <%@ include file="/module/aside.jsp" %>

    <div id="header-spacer"></div>
    <div class="body-wrapper">
      <div class="container-fluid">

        <!-- 헤더 영역 -->
        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
          <div class="card-body px-4 py-3">
            <div class="row align-items-center">
              <div class="col-9">
                <h4 class="fw-semibold mb-0">통계</h4>
              </div>
              <!-- <div class="col-3 text-end">
                <button id="btnReload" class="btn btn-sm btn-primary"><i class="ti ti-refresh"></i> 데이터 새로고침</button>
              </div> -->
            </div>
          </div>
        </div>

        <!-- 1행: 기본/그룹형 -->
        <div class="row g-4">
          <div class="col-12 col-xl-6">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">2024년도 매출</h5>
                <div id="barBasic"></div>
              </div>
            </div>
          </div>
          <div class="col-12 col-xl-6">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">2024년도 팀별 분기 매출</h5>
                <div id="barGrouped"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- 2행: 누적/수평 -->
        <div class="row g-4 mt-1">
          <div class="col-12 col-xl-6">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">출결통계</h5>
                <div id="barStacked"></div>
              </div>
            </div>
          </div>
          <div class="col-12 col-xl-6">
            <div class="card h-100">
              <div class="card-body">
                <h5 class="card-title mb-3">프로젝트 이슈</h5>
                <div id="barHorizontal"></div>
              </div>
            </div>
          </div>
        </div>

      </div><!-- /.container-fluid -->
    </div><!-- /.body-wrapper -->

    <%@ include file="/module/footerPart.jsp" %>

    <!-- ApexCharts (Modernize local path) -->
    <script src="${pageContext.request.contextPath }/resources/assets/libs/apexcharts/dist/apexcharts.min.js"></script>

    <script>
      // ===== 고정 헤더 겹침 자동 보정 =====
      (function headerOffset(){
        function apply(){
          const header = document.querySelector('.app-header, .topbar, header.topbar, header.navbar, .navbar');
          const spacer = document.getElementById('header-spacer');
          if (!spacer) return;
          const h = header ? header.getBoundingClientRect().height : 64; // fallback
          spacer.style.height = (h + 12) + 'px';
          document.documentElement.style.setProperty('--header-h', (h + 12) + 'px');
        }
        document.addEventListener('DOMContentLoaded', apply);
        window.addEventListener('resize', apply);
      })();

      // ===== CSS 변수에서 색상 읽기 =====
      function readCssVar(name, fallback){
        const v = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
        return v || fallback || '#5D87FF';
      }
      function palette(){
        return {
          primary:  readCssVar('--bs-primary',  '#5D87FF'),
          secondary:readCssVar('--bs-secondary','#49BEFF'),
          success:  readCssVar('--bs-success',  '#13DEB9'),
          info:     readCssVar('--bs-info',     '#49BEFF'),
          warning:  readCssVar('--bs-warning',  '#FFAE1F'),
          danger:   readCssVar('--bs-danger',   '#FA896B'),
          text:     readCssVar('--bs-body-color','#2A3547'),
          grid:     readCssVar('--bs-border-color','#EBF1F6'),
          bg:       readCssVar('--bs-body-bg', '#fff')
        }
      }
      function currentMode(){
        const mode = document.documentElement.getAttribute('data-bs-theme') || 'light';
        return mode === 'dark' ? 'dark' : 'light';
      }

      // ===== 공통 옵션 빌더 =====
      function baseBarOptions(){
        const c = palette();
        return {
          chart: { type: 'bar', height: 320, toolbar: { show: false } },
          theme: { mode: currentMode() },
          grid: { borderColor: c.grid },
          dataLabels: { enabled: false },
          xaxis: { labels: { style: { colors: c.text } }, axisBorder: { color: c.grid }, axisTicks: { color: c.grid } },
          yaxis: { labels: { style: { colors: c.text } } },
          legend: { labels: { colors: c.text } },
          tooltip: { theme: currentMode() }
        };
      }

      // ===== 차트 인스턴스 보관 =====
      const CHARTS = {};

      // ===== 샘플 렌더러 =====
      async function renderCharts(){
        const c = palette();

        // 1) 기본 막대
        {
          const el = document.querySelector('#barBasic');
          if (CHARTS.basic) CHARTS.basic.destroy();
          const opt = Object.assign({}, baseBarOptions(), {
            series: [{ name: '매출', data: [12, 19, 13, 22, 18, 25, 21, 26, 24, 28, 30, 33] }],
            colors: [c.primary],
            xaxis: Object.assign({}, baseBarOptions().xaxis, { categories: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] }),
          });
          CHARTS.basic = new ApexCharts(el, opt); CHARTS.basic.render();
        }

        // 2) 그룹형 막대
        {
          const el = document.querySelector('#barGrouped');
          if (CHARTS.grouped) CHARTS.grouped.destroy();
          const opt = Object.assign({}, baseBarOptions(), {
            series: [
              { name: '현장',  data: [44, 55, 57, 56] },
              { name: '디자이너',  data: [76, 85, 101, 98] },
              { name: '인사',  data: [35, 41, 36, 26] },
            ],
            colors: [c.primary, c.info, c.success],
            xaxis: Object.assign({}, baseBarOptions().xaxis, { categories: ['Q1','Q2','Q3','Q4'] }),
            plotOptions: { bar: { columnWidth: '45%' } }
          });
          CHARTS.grouped = new ApexCharts(el, opt); CHARTS.grouped.render();
        }

        // 3) 누적 막대
        {
          const el = document.querySelector('#barStacked');
          if (CHARTS.stacked) CHARTS.stacked.destroy();
          const opt = Object.assign({}, baseBarOptions(), {
            chart: Object.assign({}, baseBarOptions().chart, { stacked: true }),
            series: [
              { name: '정상', data: [30, 40, 45, 50, 49, 60] },
              { name: '지각', data: [5, 6, 7, 8, 6, 7] },
              { name: '결근', data: [1, 2, 1, 3, 2, 1] },
            ],
            colors: [c.success, c.warning, c.danger],
            xaxis: Object.assign({}, baseBarOptions().xaxis, { categories: ['4월','5월','6월','7월','8월','9월'] }),
          });
          CHARTS.stacked = new ApexCharts(el, opt); CHARTS.stacked.render();
        }

        // 4) 수평 막대
        {
          const el = document.querySelector('#barHorizontal');
          if (CHARTS.horizontal) CHARTS.horizontal.destroy();
          const opt = Object.assign({}, baseBarOptions(), {
            chart: Object.assign({}, baseBarOptions().chart, { height: 360 }),
            plotOptions: { bar: { horizontal: true, barHeight: '60%' } },
            series: [{ name: '이슈', data: [23, 18, 15, 12, 9] }],
            colors: [c.info],
            xaxis: Object.assign({}, baseBarOptions().xaxis, { categories: ['경남아너스빌 1단지','테크노 10단지','엑스포아파트 5단지','롯데아파트 5단지','경남아너스빌 2단지'] }),
          });
          CHARTS.horizontal = new ApexCharts(el, opt); CHARTS.horizontal.render();
        }
      }

      // ===== 테마 변경/리사이즈 대응 =====
      const mo = new MutationObserver(() => { renderCharts(); });
      mo.observe(document.documentElement, { attributes: true, attributeFilter: ['data-bs-theme','data-color-theme'] });
      window.addEventListener('resize', () => {
        clearTimeout(window.__chartResizeTimer);
        window.__chartResizeTimer = setTimeout(renderCharts, 200);
      });

      // 새로고침 버튼 동작(가데이터 그대로 렌더)
      document.getElementById('btnReload')?.addEventListener('click', renderCharts);

      // 초기 렌더
      document.addEventListener('DOMContentLoaded', renderCharts);
    </script>
  </body>
</html>
