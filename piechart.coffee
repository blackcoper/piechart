# out: ./piechart.min.js, sourcemap: true
# 😘😘😘💘💘💘
# piechart.js
# Copyright (c) 2018 Copyright MAXSOLUTION All Rights Reserved.
$ ->
  $.piechart = ( element,options )->
    DEFAULTS =
      DATA : [0,0,0] # clamp range [0 - 1]
      X : 0
      Y : 0
      RADIUS : 200
      ANGLE : -90
      BGCOLOR : null # '#fff'
      COLOR : [['#94c79a', '#7AB355'], ['#20bfe2', '#00ABE8'], ['#f7af76', '#F19446']]
      COLOR_LABEL : ['#F15C53', '#47C2E8', '#A5C93A']
      TEXT_LABEL : ['FISIK', 'SOCIAL', 'AKAL']
      FONTFAMILY_LABEL : "bold 24px Arial"
      FONTCOLOR_LABEL : "#000"
      BGCOLOR_LABEL : "#e7bb63"
      useGradient : true
      download : ->{}
    _ = @

    # HELPER
    deg2rad = (a)->
      a / 180 * Math.PI
    rad2deg = (a)->
      a * 180 / Math.PI
    cos = (a)->
      Math.cos a
    sin = (a)->
      Math.sin a
    cosBAR = (a,r,x)->
      _a = deg2rad a
      x+cos(_a)*r
    sinBAR = (a,r,y)->
      _a = deg2rad a
      y+sin(_a)*r
    limit = (value, inMin, inMax, outMin, outMax)->
      (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || (f) ->
      setTimeout f,1000/60
    window.cancelAnimationFrame = window.cancelAnimationFrame || window.mozCancelAnimationFrame || (i) ->
      clearTimeout i
    Polygon = (x, y, radius, sides, pointSize, angle) ->
      @x = x
      @y = y
      @radius = radius
      @sides = sides
      @pointSize = pointSize
      @angle = angle
      return
    Polygon::exec = (ctx) ->
      x = @x
      y = @y
      radius = @radius
      angle = @angle
      sides = @sides
      ps = 1 - (@pointSize || 0)
      a = 360 / sides
      ctx.moveTo cosBAR(angle,radius,x), sinBAR(angle,radius,y)
      i = 0
      while i < sides
        angle += a
        ctx.lineTo cosBAR(angle,radius,x), sinBAR(angle,radius,y)
        i++
      ctx.closePath()
    TextArc = (text, font, color, x, y, radius, angle, space) ->
      @text = text ? text : ''
      @font = font
      @color = color
      @x = x
      @y = y
      @radius = radius
      @angle = angle
      @space = space
      return
    TextArc::exec = (container) ->
      len = @text.length
      @space = @space || 3
      n = 0
      _t = []
      widthTextAngle = 0
      while n < len
        t = new createjs.Text()
        t.text = @text[n]
        t.font = @font
        t.color = @color
        t.textAlign = "center"
        t.textBaseline = "middle"
        charWid = t.getMeasuredWidth()
        textHeight = t.getMeasuredHeight()
        # t.rotation = @angle+(n*5)
        # t.regY = @radius
        widthTextAngle += rad2deg((charWid+@space)/@radius)
        container.addChild(t)
        _t.push t
        n++
      n = 0
      _angle = @angle-widthTextAngle/2
      while n < len
        charWid = _t[n].getMeasuredWidth()
        textHeight = _t[n].getMeasuredHeight()
        _wt = rad2deg(((charWid+@space)/2)/@radius)
        _t[n].x = cosBAR(_angle+_wt,@radius,@x)
        _t[n].y = sinBAR(_angle+_wt,@radius,@y)
        _t[n].rotation = 90+_angle+_wt
        _angle += _wt+rad2deg(((charWid+@space)/2)/@radius)
        n++
    _.init = ->
      _.data = DEFAULTS.DATA
      _.OPTIONS = $.extend({},DEFAULTS,options)
      WIDTH = 500
      HEIGHT = 500

      # INITIALIZE
      canvas = $('<canvas>')
      $(element).append canvas
      canvas.attr
        width : WIDTH
        height : HEIGHT
      stage = new createjs.Stage canvas.get 0
      background = new createjs.Shape()
      background.regX = stage.canvas.width / 2
      background.regY = stage.canvas.height / 2
      container = new createjs.Container()
      container.x = stage.canvas.width / 2
      container.y = stage.canvas.height / 2
      stage.addChild container
      background.graphics.f(_.OPTIONS.BGCOLOR).drawRect(0, 0, WIDTH, HEIGHT)
      container.addChild background
      shape = new createjs.Shape()
      shapeData = new createjs.Shape()
      _._draw = (id,v,_angle,_mid) ->
        _gap1 = 1
        _gap2 = 0.3
        # CREATE CHART DATA
        if !_.OPTIONS.useGradient
          start =
            x: cosBAR(_.OPTIONS.ANGLE + _angle/4, _.OPTIONS.RADIUS, _.OPTIONS.X)
            y: sinBAR(_.OPTIONS.ANGLE + _angle/4, _.OPTIONS.RADIUS, _.OPTIONS.Y)
          end =
            x: cosBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS/2, _.OPTIONS.X)
            y: sinBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS/2, _.OPTIONS.Y)
          shapeData.graphics
            .beginLinearGradientFill(_.OPTIONS.COLOR[id], [0, 1], start.x, start.y, end.x, end.y)
            .mt(cosBAR(_mid, _gap1, _.OPTIONS.X), sinBAR(_mid, _gap1, _.OPTIONS.Y))
            .arc(0, 0, _.OPTIONS.RADIUS * v, deg2rad(_.OPTIONS.ANGLE + _gap2), deg2rad(_.OPTIONS.ANGLE + _angle - _gap2), false)
            .cp()
        else
          if _.OPTIONS.COLOR[id]
            shapeData.graphics
              .f(_.OPTIONS.COLOR[id][0])
              .mt(cosBAR(_mid, _gap1, _.OPTIONS.X), sinBAR(_mid, _gap1, _.OPTIONS.Y))
              .arc(0, 0, _.OPTIONS.RADIUS * v, deg2rad(_.OPTIONS.ANGLE + _gap2), deg2rad(_.OPTIONS.ANGLE + _angle - _gap2), false)
              .cp()
            shapeData.graphics
              .f(_.OPTIONS.COLOR[id][1])
              .mt(cosBAR(_.OPTIONS.ANGLE + _angle/2, _gap1, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _angle/2, _gap1, _.OPTIONS.Y))
              .lt(cosBAR(_.OPTIONS.ANGLE + _angle/2, _gap1 + 2, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _angle/2, _gap1 + 2, _.OPTIONS.Y))
              .lt(cosBAR(_.OPTIONS.ANGLE + _angle - _gap2 - 1, _.OPTIONS.RADIUS * v, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _angle - _gap2 - 1, _.OPTIONS.RADIUS * v, _.OPTIONS.Y))
              .lt(cosBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS * v, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS * v, _.OPTIONS.Y))
              .cp()
        # CREATE HEADER LEGEND
        _hg = 35
        shape.graphics
          .f(_.OPTIONS.BGCOLOR_LABEL)
          .mt(cosBAR(_.OPTIONS.ANGLE + _gap2, _.OPTIONS.RADIUS + _gap1, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _gap2, _.OPTIONS.RADIUS + _gap1, _.OPTIONS.Y))
          .lt(cosBAR(_.OPTIONS.ANGLE + _gap2, _.OPTIONS.RADIUS + _hg, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _gap2, _.OPTIONS.RADIUS + _hg, _.OPTIONS.Y))
          .arc(0, 0, _.OPTIONS.RADIUS + _hg, deg2rad(_.OPTIONS.ANGLE + _gap2), deg2rad(_.OPTIONS.ANGLE + _angle - _gap2), false)
          .lt(cosBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS + _gap1, _.OPTIONS.X), sinBAR(_.OPTIONS.ANGLE + _angle - _gap2, _.OPTIONS.RADIUS + _gap1, _.OPTIONS.Y))
          .arc(0, 0, _.OPTIONS.RADIUS + _gap1, deg2rad(_.OPTIONS.ANGLE + _angle - _gap2), deg2rad(_.OPTIONS.ANGLE + _gap2), true)
          .cp()
      _.setData = (ss)->
        _angle = _.OPTIONS.ANGLE
        data = if ss then ss else _.OPTIONS.DATA
        shapeData.graphics.c()
        for id of data
          _angle = 360 / data.length
          _mid = _.OPTIONS.ANGLE + _angle / 2
          v = 0
          if typeof data[id] is 'number'
            v =  Math.max(Math.min(data[id],1),0)
          else
            n = 0
            for i in data[id]
              if i then n++
            v = n / data[id].length
          @_draw id,v,_angle,_mid
          a = new TextArc(_.OPTIONS.TEXT_LABEL[id], _.OPTIONS.FONTFAMILY_LABEL, _.OPTIONS.FONTCOLOR_LABEL, _.OPTIONS.X, _.OPTIONS.Y, _.OPTIONS.RADIUS + 17, _.OPTIONS.ANGLE + _angle / 2)
          a.exec(container)
          _.OPTIONS.ANGLE += _angle
        stage.update()
      _.download = (link,filename,format,encoder)->
        link.href = canvas.get(0).toDataURL(format,encoder)
        link.download = filename
      _.get64 = ->
        return canvas.get(0).toDataURL()
      container.addChild shape
      container.addChild shapeData
      _.setData()
    _.init()
    _
  $.fn.piechart = ( options )->
    @each ()->
      if !$(@).data('piechart')
        _ = new $.piechart(this,options)
        $(@).data('piechart',_);
