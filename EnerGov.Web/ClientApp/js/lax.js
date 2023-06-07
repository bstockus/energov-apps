$(function () {

    $(".datatable-search-input")
        .keyup(function (e) {
            var delegateTarget = $(e.delegateTarget);
            $(".data-table#" + delegateTarget.data("tableId")).DataTable().search(delegateTarget.val()).draw();
        });

    $(".data-table .datatable-header")
        .each(function (idx, elem) {
            var table = $(_.last($(elem).parentsUntil("table"))).parent();
            var tableType = $(table).data('type');
            var tableDom =
                "<'row table-header-row'<'col-sm-6'l><'col-sm-6 tools'f>><'row'<'col-sm-12'tr>><'row table-footer-row'<'col-sm-5'i><'col-sm-7'p>>";
            tableDom =
                "<'row'<'col-sm-12'tr>><'row table-footer-row'<'col-sm-4'i><'col-sm-3 text-center'l><'col-sm-5'p>>";
            var tablePaging = true;
            if (tableType === "basic") {
                tableDom = "<'row'<'col-sm-12'tr>>";
                tablePaging = false;
            } else if (tableType === "simple") {
                tableDom =
                    "<'row'<'col-sm-12'tr>><'row table-footer-row'<'col-sm-4'i><'col-sm-3 text-center'l><'col-sm-5'p>>";
            }
            var dataTableOptions = {
                "stateSave": true,
                "dom": tableDom,
                "paging": tablePaging,
                "columns": []
            };
            $("th", elem)
                .each(function (tdIdx, tdElem) {
                    var dataOrderable = $(tdElem).data('orderable');
                    dataTableOptions.columns.push({
                        "targets": tdIdx,
                        "orderable": dataOrderable
                    });
                });
            $(table).dataTable(dataTableOptions);

            if ($(table).DataTable().data().length === 0) {

                var tableId = $(table).attr("id");

                $('.datatable-empty[data-table-id="' + tableId + '"]').removeClass('hidden');
                $("#" + tableId + "_wrapper").addClass('hidden');
                $('.datatable-search-input[data-table-id="' + tableId + '"]').attr("disabled", "disabled");

            }

            $('.datatable-search-input[data-table-id="' + $(table).attr('id') + '"]')
                .val($(table).DataTable().search());

        });

    $("[data-mask]").inputmask();
    $(".select2").select2();
    $('.datetime-control').datepicker();
    $('.date-control').datepicker({
        format: 'mm/dd/yyyy'
    });
    $('.time-control').timepicker({
        showInputs: false
    });

    $(function () {
        $('[data-toggle="popover"]').popover();
    });

    $(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });

});