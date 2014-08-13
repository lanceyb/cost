#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery.form
#= require jquery.appendGrid
#= require select2

$ ->
  getResult = (rs) ->
    $.ajax
      url: "/result"
      dataType: "JSON"
      data: { rs: rs }
      success: (data) ->
        $(".result strong").html(data["result"])
        failure: ->
          alert("系统出错，请先手动计算！")
  $("#append").click ->
    $("#computer").appendGrid("appendRow", 1)
  $("#compute-result").click ->
    rs = []
    totalRate = 0
    for result in $("#computer").appendGrid("getAllValue")
      if result["material_id"] isnt "" and result["rate"] isnt ""
        rs.push(result)
        totalRate = totalRate + parseFloat(result["rate"])
    if rs.length > 0
      if totalRate > 1
        getResult(rs) if confirm("材料比例总和大于1，您确定要计算结果么？")
      else if totalRate < 1
        getResult(rs) if confirm("材料比例总和不足1，您确定要计算结果么？")
      else
        getResult(rs)
    else
      alert("请填写内容")
  initComputer = (data) ->
    $("#computer").appendGrid
      resizable: false
      columns: [
        { name: 'material', type: "select", display: "原材料" , ctrlOptions: data},
        { name: 'rate', type: 'text', display: "比率" }
      ]
      initRows: 5
      hideButtons:
        moveUp: true
        moveDown: true
        removeLast: true
        append: true
      customGridButtons:
        insert: $('<a>').text("插入").get(0)
        append: $('<a>').text("新增").get(0)
        remove: $('<a>').text("删除").get(0)
      beforeRowRemove: (caller, rowIndex) ->
        $(caller).find("tbody tr:eq(" + rowIndex + ") select").select2("destroy")
        true
      afterRowInserted: (caller, parentRowIndex, addedRowIndex) ->
        $(caller).find("tbody tr:eq(" + addedRowIndex + ") select").select2({width: "140px"})
      afterRowAppended: (caller, parentRowIndex, addedRowIndexs) ->
        for index in addedRowIndexs
          $(caller).find("tbody tr:eq(" + index + ") select").select2({width: "140px"})
  $.ajax
    url: "/materials"
    dataType: "JSON"
    success: (data) ->
      initComputer(data)
