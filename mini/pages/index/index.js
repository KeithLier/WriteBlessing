// index.js
// 获取应用实例
const app = getApp()

Page({
  data: {
    canvas: null,
    context: null,
    canvasPoints: []
  },
  onLoad() {

  },
  onReady() {
    let canvasName = '#myCanvas';
    let query = wx.createSelectorQuery().in(this);//获取自定义组件的SelectQuery对象
    query.select(canvasName)
    .fields({ node: true, size: true})
    .exec((res) => {
      const canvas = res[0].node;
      const context = canvas.getContext('2d');
      //获取设备像素比
      const dpr = wx.getSystemInfoSync().pixelRatio;
      //缩放设置canvas画布大小，防止笔迹错位
      canvas.width = res[0].width * dpr;
      canvas.height = res[0].height * dpr;
      context.scale(dpr, dpr);
      context.lineJoin="round";
      context.lineWidth = 15;
      context.strokeStyle = '#000000'
      this.setData({
        context: context,
        canvas: canvas
      });
    });
  },

  // 切换颜色
  changeColor: function(e) {
    var value = e.detail.value
    var context = this.data.context
    if(value) {
      context.strokeStyle = '#ffe0b2'
    } else {
      context.strokeStyle = '#000000'
    }
    this.draw(false)
  },

  // 开始
  writeStart: function(e) {
    var context = this.data.context
    context.beginPath()
    context.moveTo(e.touches[0].x, e.touches[0].y)
    this.setData({context})
    // 轨迹点保存到数组中
    this.data.canvasPoints.push({
      pointX: e.touches[0].x,
      pointY: e.touches[0].y,
      list:[]
    })
  },
  // 移动
  writeMove: function(e) {
    let [touch] = e.touches
    let {x, y} = touch
    let point = {x , y}
    let context = this.data.context
    context.lineTo(point.x, point.y)
    context.stroke()
    let index = this.data.canvasPoints.length - 1
    this.data.canvasPoints[index].list.push({
      x: e.touches[0].x,
      y: e.touches[0].y,
    })
  },
  // 结束
  writeEnd: function(event) {
  },

  // 撤销
  back: function () {
    var points = this.data.canvasPoints
    if(points.length < 1) {
      return
    }
    var ctx = this.data.context
    ctx.clearRect(0,0, this.data.canvas.width, this.data.canvas.height)
    points.splice(points.length - 1, 1)
    for(var i = 0; i < points.length; i++) {
      ctx.beginPath()
      ctx.moveTo(points[i].pointX, points[i].pointY)
      var list = points[i].list
      for(var j = 0; j < list.length; j++) {
        ctx.lineTo(list[j].x, list[j].y)
        ctx.stroke()
      }
    }
  },

  // 重写
  rewrite: function () {
    let context = this.data.context
    context.clearRect(0,0, this.data.canvas.width, this.data.canvas.height)
    this.setData({
      context: context,
      canvasPoints: []
    })
  },

  // 回放
  playback: function() {
    this.draw(true)
  },

  // 绘制字体
  draw: function(timeout) {
    var points = this.data.canvasPoints
    if(points.length < 1) {
      return
    }
    var ctx = this.data.context
    ctx.clearRect(0,0, this.data.canvas.width, this.data.canvas.height)
    var i = 0, j = 0
    ctx.beginPath()
    ctx.moveTo(points[i].pointX, points[i].pointY)
    this.drawLine(i, j, timeout)
  },

  // 绘制线条
  drawLine(i, j, timeout) {
    var that = this
    var ctx = this.data.context
    var points = this.data.canvasPoints
    if(j < points[i].list.length) {
      if (timeout) {
        setTimeout(() => {
          ctx.lineTo(points[i].list[j].x, points[i].list[j].y)
          ctx.stroke()
          j++
          that.drawLine(i, j, timeout)
        }, 20);
      } else {
        ctx.lineTo(points[i].list[j].x, points[i].list[j].y)
        ctx.stroke()
        j++
        that.drawLine(i, j, timeout)
      }
    } else {
      i++
      j = 0
      if(i < points.length) {
        ctx.beginPath()
        ctx.moveTo(points[i].pointX, points[i].pointY)
        that.drawLine(i, j, timeout)
      }
    }
  },

  // 保存
  save: function () {
    let that = this
    wx.canvasToTempFilePath({
      canvas: that.data.canvas,
      success(res) {
        wx.saveImageToPhotosAlbum({
          filePath: res.tempFilePath,
          success(res) {
            wx.showModal({
              title: '提示',
              content: '保存成功，是否需要回看',
              success (res) {
                if (res.confirm) {
                  that.playback()
                } else if (res.cancel) {
                }
              }
            })            
          },
          fail(res) {
            if (err.errMsg === "saveImageToPhotosAlbum:fail auth deny") {
              wx.showToast({
                title: '当初用户拒绝，再次发起授权',
                icon: 'success',
                duration: 2000
              })
            } else {
              wx.showToast({
                title: '请截屏保存分享',
                icon: 'success',
                duration: 2000
              })
            }
          }
        })
      },
      fail(res) {
      }
    })
  }
})
