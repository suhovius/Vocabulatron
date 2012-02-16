$('.destroy').live('click', function(e) {
  e.preventDefault();
  if (confirm('Are you sure you want to delete that item?')) {    
     jQuery.ajax({
      url: this.href,
      type: 'delete',
      dataType: "json",
      beforeSend: function(x) {
        if (x && x.overrideMimeType) {
          x.overrideMimeType("application/json;charset=UTF-8");
        }
      },
      success: function(result) {
        $('#content').html(result);
      },
      error: function (xhr, ajaxOptions, thrownError){
        $('#content').html(xhr.responseText);
      }

    });
  }
});
