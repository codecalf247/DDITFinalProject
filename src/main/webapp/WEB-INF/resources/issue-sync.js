
// ===== 상태/컬럼 매핑 =====
const STATUS = { WAITING:'WAITING', DOING:'DOING', REVIEW:'REVIEW', DONE:'DONE' };

// kanban.jsp의 data-item 값과 매칭 (검토중은 item-pending 사용)
const COLUMN_MAP = {
  'item-todo':       STATUS.WAITING,   // 대기
  'item-inprogress': STATUS.DOING,     // 진행중
  'item-pending':    STATUS.REVIEW,    // 검토중
  'item-review':     STATUS.REVIEW,    // (혹시 다른 페이지에서 review 키를 쓰면 대비)
  'item-done':       STATUS.DONE       // 완료
};
const COLUMN_BY_STATUS = {
  [STATUS.WAITING]: 'item-todo',
  [STATUS.DOING]:   'item-inprogress',
  [STATUS.REVIEW]:  'item-pending',
  [STATUS.DONE]:    'item-done'
};

// 칸반 이동 시 기본 진행률
const DEFAULT_PROGRESS_BY_STATUS = {
  [STATUS.WAITING]: 0,
  [STATUS.DOING]:   50,
  [STATUS.REVIEW]:  90,
  [STATUS.DONE]:    100
};

// 진행률 → 상태
function statusFromProgress(p) {
  const v = Math.max(0, Math.min(100, p|0));
  if (v >= 100) return STATUS.DONE;
  if (v >= 90)  return STATUS.REVIEW; // 90~99
  if (v >= 10)  return STATUS.DOING;  // 10~80
  return STATUS.WAITING;              // 0~9
}

// 입력 보정(스냅)
function normalizeProgressInput(p) {
  let v = Math.max(0, Math.min(100, p|0));
  if (v === 0) return 0;
  if (v > 0 && v < 10) return 10;
  if (v > 80 && v < 90) return 90;
  return v;
}

// ===== 서버 PATCH (경로만 프로젝트에 맞게 바꾸세요) =====
async function updateIssue(id, payload) {
  const res = await fetch(`/api/issues/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  if (!res.ok) throw new Error('업데이트 실패');
  return await res.json(); // 갱신된 이슈 JSON 반환 가정
}

// ===== 탭/페이지 간 동기화 =====
const bc = ('BroadcastChannel' in window) ? new BroadcastChannel('issue-sync') : null;
function broadcastIssueUpdate(issue) { if (bc) bc.postMessage({ type:'issue-updated', issue }); }

