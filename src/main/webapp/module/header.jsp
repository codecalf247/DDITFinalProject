<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.container, .container-lg, .container-md, .container-sm, .container-xl, .container-xxl{ max-width: 1450px !important;}
.body-wrapper{ padding-top:50px !important;}
html[data-boxed-layout=boxed] .container-fluid, html[data-boxed-layout=boxed] .container-lg, html[data-boxed-layout=boxed] 
.container-md, html[data-boxed-layout=boxed] .container-sm, html[data-boxed-layout=boxed] .container-xl, html[data-boxed-layout=boxed] .container-xxl
{max-width: 1450px !important;}


.noti-item.is-unread { background: var(--bs-primary-bg-subtle); }
/* 숫자 배지: 위치/겹침 고정 */
#chatTotalBadge{
  position: absolute !important;
  top: -6px !important;
  right: -6px !important;
  z-index: 20 !important;

  font-size: .70rem;
  line-height: 1;
  padding: .25rem .40rem;
  min-width: 1.25rem;
  text-align: center;
}

/* 부트스트랩이 .badge:empty를 숨기는 걸 막는다 (혹시 비어도 보이게) */
.badge:empty { display: inline-block !important; }
</style>