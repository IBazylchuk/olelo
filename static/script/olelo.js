// Olelo bootstrap
// Written by Daniel Mendler
(function() {
    $('#themes').styleswitcher();
    function pageLoaded(parent) {
        $('#upload-path', parent).each(function() {
            var elem = this;
            var old = elem.value;
            var base = elem.value;
            if (base.length == 0 || base.match(/\/$/)) {
                $('#upload-file').change(function() {
                    if (elem.value == old) {
                        elem.value = base + this.value;
                        old = elem.value;
                    }
                });
            }
        });
        $('label, #menu, .tabs > ul, .pagination', parent).disableSelection();
        $('#history-table', parent).historyTable();
        $('.zebra, #history-table, #tree-table', parent).zebra();
	$('.date', parent).dateToggler();
        $('.tabs', parent).tabs();
        $('input.placeholder', parent).placeholder();
        $('*[accesskey]', parent).underlineAccessKey();
    }

    $('.pagination a:not(.current)').pagination('#content');
    $('#content').bind('pageLoaded', function() { pageLoaded(this); });
    pageLoaded();
})();
