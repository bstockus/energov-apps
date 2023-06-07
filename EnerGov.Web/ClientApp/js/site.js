// Write your JavaScript code.
$(function () {

    $(document).ajaxStart(function () {
        Pace.restart();
    });

    // Load Remote Select Boxes
    $(".select2-remote").each(function (idx, elem) {
        setupSelect2Remote(idx, elem);
    });

    $(".select2-remote-multiple").each(function (idx, elem) {
        setupSelect2RemoteMultiple(idx, elem);
    });

    $(".remote-modal-btn").on("click",
        function () {
            $("#modal-container").load($(this).attr("href"),
                function () {
                    $(".select2-remote", "#modal-container").each(function (idx, elem) {
                        setupSelect2Remote(idx, elem);
                    });

                    $(".select2-remote-multiple", "#modal-container").each(function (idx, elem) {
                        setupSelect2RemoteMultiple(idx, elem);
                    });

                    $("[data-mask]").inputmask();

                    $(".select2", "#modal-container").select2();
                    $(".datetime-control", "#modal-container").datepicker();
                    $(".date-control", "#modal-container").datepicker({
                        format: "mm/dd/yyyy"
                    });
                    $('.time-control').timepicker({
                        showInputs: false
                    });

                    $(".icheck-hide", "#modal-container").each(function (idx, elem) {

                        var selector = $(elem).data("selector");
                        var elementName = $(elem).data("name");
                        var elementId = $(elem).data("id");

                        if ($(elem).is(":checked")) {
                            setCheckbox(elementId, elementName);
                            showElements(selector);
                        } else {
                            unSetCheckbox(elementId, elementName);
                            hideElements(selector);
                        }

                        $(elem).iCheck({
                            checkboxClass: "icheckbox_flat-green"
                        });

                        $(elem).on("ifChecked",
                            function (event) {
                                console.log("Checked: " + elementName);
                                setCheckbox(elementId, elementName);
                                showElements(selector);
                            });

                        $(elem).on("ifUnchecked",
                            function (event) {
                                console.log("UnChecked: " + elementName);
                                unSetCheckbox(elementId, elementName);
                                hideElements(selector);
                            });

                    });

                    $(".icheck-cbo", "#modal-container").each(function (idx, elem) {
                        var elementName = $(elem).data("name");
                        var elementId = $(elem).data("id");

                        if ($(elem).is(":checked")) {
                            setCheckbox(elementId, elementName);
                        } else {
                            unSetCheckbox(elementId, elementName);
                        }

                        $(elem).iCheck({
                            checkboxClass: "icheckbox_flat-green"
                        });

                        $(elem).on("ifChecked",
                            function (event) {
                                console.log("Checked: " + elementName);
                                setCheckbox(elementId, elementName);
                            });

                        $(elem).on("ifUnchecked",
                            function (event) {
                                console.log("UnChecked: " + elementName);
                                unSetCheckbox(elementId, elementName);
                            });
                    });

                    $("[data-yes-toggle]").on('change',
                        function (event) {

                            updateYesToggles(this);

                        });

                    $("[data-yes-toggle]").each(function (i) {
                        updateYesToggles(this);
                    });

                    $("form", "#modal-container").validator();

                    $(".modal", "#modal-container").modal({ show: true });

                    $("input,select,textarea", "#modal-container").attr('autocomplete', 'nope');


                });

            return false;
        });
});

$("[data-yes-toggle]").on('change',
    function (event) {

        updateYesToggles(this);

    });

$("[data-yes-toggle]").each(function (i) {
    updateYesToggles(this);
});

$("input,select,textarea", "#modal-container").attr('autocomplete', 'nope');

function updateYesToggles(element) {
    var selector = $(element).data('yes-toggle');
    var value = $(element).val();

    var myParent = $(element).parents(".form-group");

    var parent = $(selector).parents(".form-group");

    if (value === "0" || myParent.hasClass("hidden")) {

        $(parent).addClass("hidden");
        $("input", parent).attr("data-validate", "false");
        $("textarea", parent).attr("data-validate", "false");
        $("form", "#modal-container").validator("update").validator("validate");
    } else {
        $(parent).removeClass("hidden");
        $("input", parent).attr("data-validate", "true");
        $("textarea", parent).attr("data-validate", "true");
        $("form", "#modal-container").validator("update").validator("validate");
    }

    $(selector).filter("[data-yes-toggle]").each(function () {
        updateYesToggles($(this));
    });
}

function hideElements(selector) {
    $("." + selector).addClass("hidden");
    $("." + selector + " input").attr("data-validate", "false");
    $("form", "#modal-container").validator("update").validator("validate");
}

function showElements(selector) {
    $("." + selector).removeClass("hidden");
    $("." + selector + " input").attr("data-validate", "true");
    $("form", "#modal-container").validator("update").validator("validate");
}

function setupSelect2Remote(idx, elem) {
    var element = $(elem);

    var apiUrl = element.data("api");
    var placeholder = element.data("placeholder");
    var notRequired = element.data("not-required");

    var currentOption = $("option", elem);

    var clearSelection = (notRequired === "True") && (currentOption.length === 0);
    var itemToSelect = null;

    if (currentOption.length > 0) {
        itemToSelect = $(currentOption[0]).attr("value");
    }

    $(element).find("option")
        .remove()
        .end();

    if (notRequired === "True") {
        $(element).prepend("<option></option>");
    }

    var parents = element.parents(".modal");

    $.ajax({
        url: apiUrl
    }).done(function (data) {
        var options = {
            'data': data,
            'placeholder': placeholder,
            'allowClear': (notRequired === "True")
        };

        if (parents.length > 0) {
            var parent = parents[0];
            options["dropdownParent"] = $(parent);
        }

        $(element).select2(options);
        if (clearSelection) {
            $(element).select2().val([]).trigger("change");
        } else if (itemToSelect !== null) {
            $(element).select2().val([itemToSelect]).trigger("change");
        }
    });
}

function setupSelect2RemoteMultiple(idx, elem) {
    var element = $(elem);

    var apiUrl = element.data("api");
    var placeholder = element.data("placeholder");

    var selected = [];

    var parents = element.parents(".modal");

    $("option", elem).each(function (selIdx, selElem) {
        selected.push($(selElem).attr("value"));
    });

    $(element).find("option")
        .remove()
        .end();

    $.ajax({
        url: apiUrl
    }).done(function (data) {
        var options = {
            'data': data,
            'placeholder': placeholder,
            'multiple': true
        };

        if (parents.length > 0) {
            var parent = parents[0];
            options["dropdownParent"] = $(parent);
        }

        $(element).select2(options);

        $(element).select2().val(selected).trigger("change");
    });
}

function unSetCheckbox(elementId, elementName) {
    $("#cbo-value-" + elementId).empty();
}

function setCheckbox(elementId, elementName) {
    $("#cbo-value-" + elementId).empty();
    $("#cbo-value-" + elementId)
        .html("<input type='hidden' value='true' name='" + elementName + "' id='" + elementName + "' />");
}