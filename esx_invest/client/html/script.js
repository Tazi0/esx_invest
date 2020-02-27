$(function() {
    window.addEventListener('message', function(event) {
        if(event.data.type == "open") {
            $('#waiting').show();
            $('body').addClass("active");
        } else if(event.data.type == "close"){
            $('#waiting, #general, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
            $('body').removeClass("active");
        } else if(event.data.type == "balance") {
            $('.username').html(event.data.player);
            $('.invested').html(event.data.balance);
        }
    });
});

$('#fingerprint-content').click(function(){
    $('.fingerprint-active, .fingerprint-bar').addClass("active")
    setTimeout(function(){
        $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')
        $('.fingerprint-active, .fingerprint-bar').removeClass("active")
    }, 1400);
})

document.onkeyup = function(data){
    if (data.which == 27){
        $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
        $('body').removeClass("active");
        $.post('http://esx_invest/close', JSON.stringify({}));
    }
}