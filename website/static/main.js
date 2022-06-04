$(document).on("click", ".project", function() {
    var path   = window.location.href;
    id_num = $(this)[0].children[1].innerText //gets issuing-authority
    url = path + "/update?project_id=" + id_num;
    window.location = url;
});