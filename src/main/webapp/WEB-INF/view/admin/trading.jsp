<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:directive.include file="../common/head.jsp"/>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
        <script src="js/index.js"></script>
        <script src="js/menu.js"></script>
        <script src="js/trading.js"></script>
        <script>
            const sideMenuGenerator = new SideMenuGenerator('layoutSidenav_nav');
            sideMenuGenerator.init();

            const topMenu = new TopMenuGenerator('topNavbar');
            topMenu.init();
        </script>
        <style>
            .tui-grid {
                border-right: 1px solid #ddd !important;
            }
            /* 마지막 컬럼 셀에 오른쪽 테두리 추가 */
            .tui-grid-cell-header:last-child,
            .tui-grid-cell:last-child {
                border-right: 1px solid #ddd !important;
            }

            /* 또는 */
            .tui-grid-border-line {
                border-right: 1px solid #ddd !important;
            }

            /* 헤더 테두리 */
            .tui-grid-header-cell {
                border-right: 1px solid #ddd !important;
                border-bottom: 1px solid #ddd !important;
            }

            /* 바디 셀 테두리 */
            .tui-grid-cell {
                border-right: 1px solid #ddd !important;
                border-bottom: 1px solid #ddd !important;
            }

            /* 전체 그리드 테두리 */
            .tui-grid {
                border-top: 1px solid #ddd !important;
                border-left: 1px solid #ddd !important;
            }

            /* 체크박스 컬럼 테두리 */
            .tui-grid-row-header-cell {
                border-right: 1px solid #ddd !important;
                border-bottom: 1px solid #ddd !important;
            }
        </style>
    </head>
    <body class="">
        <div id="contents" style="display: flex; flex-direction: column; height: 100vh;">
            <div id="topArea">
                <div id="topNavbar"></div>
            </div>
            <div id="mainArea" style="flex: 1;">
                <div id="layoutSidenav">
                    <div id="layoutSidenav_nav">
                    </div>
                </div>
                <div class="page_content" style='height:100%; overflow:auto; display:flex;flex-direction: column;'>
                    <div style="display:none;">
                        <div class="search_title">
                            <i></i><span> 검색조건</span>
                        </div>
                        <div class="search_param">
                        </div>
                        <div class="search_button">
                            <div class="button basic" onclick="clickSearch();">
                                <span>조 회</span>
                            </div>
                            <div id="create" class="button basic">
                                <span>생성</span>
                            </div>
                            <div id="sync" class="button basic">
                                <span>저장</span>
                            </div>
                            <div id="delete" class="button basic">
                                <span>삭제</span>
                            </div>
                        </div>
                    </div>

                    <style>
                        .grid_info {
                            display: flex;
                            flex-direction: row;
                            gap: 20px;
                            padding: 5px;
                            background-color: #f8f9fa;
                            border-radius: 8px;
                            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                        }

                        .grid_info_row {
                            display: flex;
                            align-items: center;
                        }

                        .grid_info_title {
                            font-weight: 600;
                            margin-right: 8px;
                            color: #495057;
                        }

                        .grid_info_value {
                            padding: 2px 4px;
                            border: 1px solid #dee2e6;
                            border-radius: 4px;
                            background-color: #fff;
                            text-align: right;
                            max-width: 100px;
                        }

                        .win-lose-input {
                            max-width: 40px;
                        }

                        .win-lose-input {
                            max-width: 70px;
                        }

                        /* readonly 상태의 input 스타일 */
                        .grid_info_value[readonly] {
                            background-color: #fff;
                            cursor: default;
                        }
                    </style>

                    <div class="grid_info">
                        <div class="grid_info_row">
                            <div class="grid_info_title">실현수익 : </div>
                            <input type="text" class="grid_info_value total_profit" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">실현수익률 : </div>
                            <input type="text" class="grid_info_value total_profit_rate win-lose-input" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">수수료 : </div>
                            <input type="text" class="grid_info_value total_fee" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">승률 : </div>
                            <input type="text" class="grid_info_value win_rate win-lose-input" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">매매횟수 : </div>
                            <input type="text" class="grid_info_value total_count win-lose-input" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">승 : </div>
                            <input type="text" class="grid_info_value win_count win-lose-input" readonly>
                        </div>
                        <div class="grid_info_row">
                            <div class="grid_info_title">패 : </div>
                            <input type="text" class="grid_info_value lose_count win-lose-input" readonly>
                        </div>
                    </div>

                    <!-- 검색 결과 리스트 -->
                    <div class="search_list" style="">
                        <div>
                            <div id="grid" style=''></div>
                            <script>
                                document.getElementById('create').addEventListener('click', createRow);
                                document.getElementById('sync').addEventListener('click', syncServer);
                                document.getElementById('delete').addEventListener('click', deleteRow);

                                function createRow() {
                                    grid.prependRow();
                                    grid.request('createData');
                                }

                                function deleteRow() {
                                    //console.log('삭제할 행 : ' + grid.getCheckedRowKeys());
                                    grid.removeRows(grid.getCheckedRowKeys())
                                    grid.request('deleteData');
                                }

                                // 폼 데이터를 JSON 형식으로 변환하는 함수
                                function serializeFormToJson(formId) {
                                    var formData = $("#" + formId).serializeArray();
                                    var json = {};
                                    $.each(formData, function (index, field) {
                                        json[field.name] = field.value || "";
                                    });
                                    return json;
                                }

                                function clickSearch() {
                                    serializeFormToJson('frmParam');
                                    grid.readData(0, serializeFormToJson('frmParam'));
                                }


                                function syncServer() {
                                    const {rowKey, columnName} = grid.getFocusedCell();

                                    if (rowKey && columnName) {
                                        grid.finishEditing(rowKey, columnName);
                                    }

                                    grid.request('updateData', {
                                        checkedOnly: false
                                    });

                                }

                                var dataSource = {
                                    initialRequest: true
                                    , contentType: 'application/json'
                                    , api: {
                                        readData: {url: TRADE_URL+'/trading', method: 'GET'}
                                        <%--, createData: {url: USER_URL+'/create', method: 'POST'}
                                        , updateData: {url: USER_URL+'/user/update', method: 'PUT'}
                                        , deleteData: {url: USER_URL+'/user/delete', method: 'PUT'}
                                        , modifyData: {url: USER_URL+'/user/modify', method: 'POST'}--%>
                                    }
                                    , headers : {
                                        'Content-Type': 'application/json',
                                        'Authorization':  localStorage.getItem('token')
                                    }
                                }

                                tui.Grid.applyTheme('striped', {
                                    cell: {
                                        normal: {
                                            border: '#ddd'
                                        },
                                        header: {
                                            border: '#ddd'
                                        }
                                    }
                                });

                                var grid = new tui.Grid({
                                  el: document.getElementById('grid'),
                                  data: dataSource,
                                  columns: columns,
                                  bodyHeight: 420,
                                  pageOptions: {
                                    useClient: false,
                                    perPage: 10
                                  },
                                  scrollX: true,
                                  scrollY: true,
                                  columnOptions: {
                                    resizable: true
                                  },
                                  rowHeaders: [{
                                    type: 'rowNum',
                                    header: 'No.',
                                    align: 'center',
                                    width: 60,
                                    formatter: function(value) {
                                      // 현재 페이지번호를 가져옴
                                      const currentPage = grid.getPagination().getCurrentPage();
                                      // 페이지당 행 개수
                                      const perPage = grid.getPagination().getItemsPerPage();
                                      // 실제 번호 계산 ((현재페이지-1) * 페이지당개수 + 행번호)
                                      return ((currentPage - 1) * perPage) + value;
                                    }
                                  }]
                                });

                                // 페이지 컨텐츠 스타일링
                                const pageContent = document.querySelector('.page_content');
                                pageContent.style.cssText = 'height:100%; overflow:auto; display:flex; flex-direction:column; align-items:center; padding: 20px;';

                                // 그리드 정보 영역 스타일링
                                const gridInfo = document.querySelector('.grid_info');
                                gridInfo.style.cssText = 'width: 100%; max-width: 1200px; margin-bottom: 20px;';

                                // 검색 리스트 영역 스타일링
                                const searchList = document.querySelector('.search_list');
                                searchList.style.cssText = 'width: 100%; max-width: 1200px;';

                                // 그리드 컨테이너 스타일링
                                const gridContainer = document.getElementById('grid');
                                gridContainer.style.cssText = 'width: 100%; border: 1px solid #e0e0e0; border-radius: 4px;';

                                grid.on('response', function (ev) {
                                    console.log('ev', ev)
                                    // 성공/실패와 관계 없이 응답을 받았을 경우
                                    let response = JSON.parse(ev.xhr.response)
                                    console.log('response', response)
                                    /*let data = response.data;
                                    let total_profit = parseFloat(data.totalProfit).toFixed(2);
                                    let win_rate = parseFloat(data.winRate).toFixed(2);
                                    let win_count = data.winCount;
                                    let lose_count = data.loseCount;

                                    $('.total_profit').val(total_profit);
                                    $('.win_rate').val(win_rate);
                                    $('.win_count').val(win_count);
                                    $('.lose_count').val(lose_count);*/

                                    getTradingSummary()

                                    if(response.statusCode =='401'){
                                        localStorage.setItem('token', '');
                                        alert('로그인이 만료되었습니다');
                                    }
                                    if(JSON.stringify(response) != '{}'){

                                    }else{
                                        clickSearch();
                                    }
                                })
                            </script>
                        </div>
                    </div>
                </div>
            </div>
            <div id="footerArea">
                <footer class="py-2 bg-light">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="text-muted">Copyright &copy; Your Website 2023</div>
                            <div>
                                <a href="#">Privacy Policy</a>
                                &middot;
                                <a href="#">Terms &amp; Conditions</a>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>
