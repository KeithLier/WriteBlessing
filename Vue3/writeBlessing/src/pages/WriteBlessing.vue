<template>
    <div>
        <img class="bg-image" src="/src/assets/bg.png" alt="">
        <div class="text-view" @touchmove.prevent>福
            <canvas class="write-canvas" ref="myCanvas" id="canvas" width="300" height="300" @mousedown="canvasDown($event)" @mouseup="canvasUp($event)" @mousemove="canvasMove($event)" @mouseleave="canvasLeave()"></canvas>
        </div>
        <div class="opration-view">
            <span class="opration-button" style="width: 20%;" @click="revoke">撤销</span>
            <span class="opration-button" style="width: 60%;" @click="save">保存到相册</span>
            <span class="opration-button" style="width: 20%;" @click="clear">重写</span>
        </div>
    </div>
</template>

<script>

import { defineComponent, onMounted, ref, reactive, toRefs } from 'vue'

export default defineComponent({
    setup() {
        const myCanvas = ref(null)
        const data = reactive({
            ctx: null,
            canvasMoveUse: false,
            imgSrc: ''
        })
        // 重写
        const clear = () => {

        }

        // 保存
        const save = () => {

        }

        // 撤销
        const revoke = () => {

        }

        const canvasDown = (event) => {
            data.canvasMoveUse = true
            const canvasX = event.offsetX
            const canvasY = event.offsetY
            data.ctx.beginPath()
            data.ctx.moveTo(canvasX, canvasY)
        
        }
        const canvasUp = (event) => {
            data.canvasMoveUse = false
        }
        const canvasMove = (event) => {
            if(data.canvasMoveUse) {
                const canvasX = event.offsetX
                const canvasY = event.offsetY
                data.ctx.lineTo(canvasX, canvasY)
                data.ctx.stroke()
            }
        }

        const canvasLeave = () => {
            data.canvasMoveUse = false;
        }

        onMounted(() => {
            myCanvas.value = document.querySelector('#canvas')
            data.ctx = myCanvas.value.getContext("2d")
            data.ctx.lineWidth = 20
        });
        return {
            ...toRefs(data),
            myCanvas,
            clear,
            save,
            revoke,
            canvasDown,
            canvasUp,
            canvasMove,
            canvasLeave
        }
    },
})
</script>

<style scoped>
.bg-image {
  display: block;
  height: 100%;
  width: 100%;
  position: absolute;
  left: 0;
  bottom: 0;
  z-index: -999;
}

.text-view {
  margin-top: 20%;
  margin-left: 10%;
  margin-right: 10%;
  width: 80%;
  font-size: 300px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: gray;
  opacity: 0.3;
  position: relative;
  box-shadow: 0 4px 12px rgb(0, 0, 0, 0.5);
  flex: 5;
  overflow: hidden;
  box-sizing: border-box;
  border: 4px solid rgb(255, 255, 255, 0.25);
}

.write-canvas {
  display: block;
  width: 100%;
  height: 100%;
  position: absolute;
  z-index: 999;
}

.opration-view {
  display: flex;
  width: 100%;
  position: absolute; 
  flex-direction: row;
  justify-content: center;
  bottom: 50px;
}

.opration-button {
  display: flex;
  justify-content: center;
}

</style>